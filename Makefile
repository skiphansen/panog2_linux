###############################################################################
## Makefile
###############################################################################

TOPDIR = .
GIT_INIT := $(shell if [ ! -e $(TOPDIR)/pano/.git ]; then echo "updating submodules"> /dev/stderr;git submodule init; git submodule update; fi)

.PHONY: help flash_kernel flash_gateware flash_rootfs flash_image 
.PHONY: read_flash erase_flash build_all update_prebuilt reset enter_env


SHELL := $(shell which bash)

UART_PORT ?= hdmi
export HDMI2USB_UDEV_IGNORE=y
export PLATFORM=pano_logic_g2
export CPU_VARIANT=linux
export BUILD_BUILDROOT=1
export TARGET=net
export FIRMWARE=linux
export MAKE_LITEX_EXTRA_CMDLINE=-Op uart_connection $(UART_PORT)
export BR2_EXTERNAL=$(CURDIR)/litex-buildenv/pano/buildroot/

ENV_DOWNLOADED = litex-buildenv/build/.env_downloaded
LITEX_BUILD_DIR = build/pano_logic_g2_net_vexriscv.linux
GATEWARE_BIN_FILE = $(LITEX_BUILD_DIR)/gateware+emulator+dtb.bin
GATEWARE_BIT_FILE = litex-buildenv/$(LITEX_BUILD_DIR)/gateware/top.bit
BUILD_IMAGE_DIR = litex-buildenv/third_party/buildroot/output/images
IMAGE_FBI = $(BUILD_IMAGE_DIR)/Image.fbi
CPIO_FBI = $(BUILD_IMAGE_DIR)/rootfs.cpio.fbi
DTB_FBI = litex-buildenv/$(LITEX_BUILD_DIR)/software/linux/rv32.fbi


help:

XC3SPROG_OPTS = -c $(CABLE) -v
include $(TOPDIR)/pano/make/common.mk
include $(TOPDIR)/pano/make/ise.mk

help:
	@echo "Usage:"
	@echo "  make flash_image    - flash the full image (gateware, kernel, rootfs)"
	@echo "  make flash_gateware - flash just gateware, DTB, emulator"
	@echo "  make flash_kernel   - flash just Linux kernel"
	@echo "  make flash_rootfs   - flash just root filesystem"
	@echo "  make reset          - reset the Pano"
	@echo "  make build_all      - rebuild image from sources (optional)"
	@echo "  make enter_env      - enter litex-buildenv interactive build environment"

flash_kernel:
	@echo "Flashing kernel..."
	$(XC3SPROG) $(XC3SPROG_OPTS) -I$(BSCAN_SPI_BITFILE) $(PREBUILT_DIR)/Image.fbi:W:4456448:bin

flash_gateware:
	@echo "Flashing gateware, emulator and DTS..."
	$(XC3SPROG) $(XC3SPROG_OPTS) -I$(BSCAN_SPI_BITFILE) $(PREBUILT_DIR)/gateware-$(UART_PORT).bin:W:0:bin

flash_rootfs:
	@echo "Flashing rootfs..."
	$(XC3SPROG) $(XC3SPROG_OPTS) -I$(BSCAN_SPI_BITFILE) $(PREBUILT_DIR)/rootfs.cpio.fbi:W:10223616:bin

flash_image: gateware-flash kernel-flash rootfs-flash

read_flash:
	$(XC3SPROG) $(XC3SPROG_OPTS) -I$(BSCAN_SPI_BITFILE) readback.bin:R:0:bin:33554432

erase_flash:
	@echo "Erasing flash..."
	echo -en "\xFF" > ff.bin
	$(XC3SPROG) $(XC3SPROG_OPTS) -I$(BSCAN_SPI_BITFILE) -e ff.bin:W:0:bin
	rm ff.bin

litex-buildenv:
	git clone https://github.com/skiphansen/litex-buildenv.git --branch pano_master

$(ENV_DOWNLOADED):
	(cd litex-buildenv; ./scripts/download-env.sh)
	touch $(ENV_DOWNLOADED)

$(GATEWARE_BIT_FILE): | litex-buildenv $(ENV_DOWNLOADED)
	(cd litex-buildenv; . ./scripts/enter-env.sh; make gateware)

litex-buildenv/$(GATEWARE_BIN_FILE): | litex-buildenv $(ENV_DOWNLOADED) $(GATEWARE_BIT_FILE)
	(cd litex-buildenv; . ./scripts/enter-env.sh; make DUMMY_FLASH=y gateware-flash)

build_all: $(GATEWARE_BIT_FILE)
	(cd litex-buildenv; . ./scripts/enter-env.sh; ./scripts/build-linux.sh)

$(IMAGE_FBI) $(CPIO_FBI) $(DTB_FBI):
	(cd litex-buildenv; . ./scripts/enter-env.sh; make ../$@)

update_prebuilt: litex-buildenv/$(GATEWARE_BIN_FILE) $(IMAGE_FBI) $(CPIO_FBI)
	cp $^ prebuilt
	mv prebuilt/$(notdir $(GATEWARE_BIN_FILE)) prebuilt/gateware-$(UART_PORT).bin

reset:
	$(XC3SPROG) $(XC3SPROG_OPTS) -R

enter_env: | litex-buildenv $(ENV_DOWNLOADED)
ifeq ($(HDMI2USB_ENV),)
	cd litex-buildenv/; unset MAKELEVEL; bash --rcfile ./scripts/enter-env.sh -i
else
	@echo "You are already in the litex-buildenv build environment"
endif

cd_test:
	cd litex-buildenv;pwd



