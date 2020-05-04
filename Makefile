###############################################################################
## Makefile
###############################################################################

TOPDIR = .
GIT_INIT := $(shell if [ ! -e $(TOPDIR)/pano/.git ]; then echo "updating submodules"> /dev/stderr;git submodule init; git submodule update; fi)

.PHONY: image-flash read_flash help build_all update_prebuilt

SHELL := $(shell which bash)

UART_PORT ?= hdmi
export HDMI2USB_UDEV_IGNORE=y
export PLATFORM=pano_logic_g2
export CPU_VARIANT=linux
export BUILD_BUILDROOT=1
export TARGET=net
export FIRMWARE=linux
export MAKE_LITEX_EXTRA_CMDLINE=-Op uart_connection $(UART_PORT)
export TFTP_SERVER_PORT=69

ENV_DOWNLOADED=litex-buildenv/build/.env_downloaded
GATEWARE_BIT_FILE = litex-buildenv/build/pano_logic_g2_net_vexriscv.linux/gateware/top.bit

help:

include $(TOPDIR)/pano/make/common.mk
include $(TOPDIR)/pano/make/ise.mk

help:
	@echo "Usage:"
	@echo "   REV A or B Pano (xc6slx150):"
	@echo "      image-flash     - flash image with serial on micro HDMI"
	@echo "      make build_all  - rebuild image from sources (optional)"
	@echo
	@echo "   REV C Pano (xc6slx100):"
	@echo "      Sorry, not supported yet"

image-flash:
	$(XC3SPROG) $(XC3SPROG_OPTS) -I$(BSCAN_SPI_BITFILE) $(PREBUILT_DIR)/gateware-$(UART_PORT).bin:W:0:bin
	$(XC3SPROG) $(XC3SPROG_OPTS) -I$(BSCAN_SPI_BITFILE) $(PREBUILT_DIR)/Image.fbi:W:4456448:bin
	$(XC3SPROG) $(XC3SPROG_OPTS) -I$(BSCAN_SPI_BITFILE) $(PREBUILT_DIR)/rootfs.cpio.fbi:W:10223616:bin

read_flash:
	$(XC3SPROG) $(XC3SPROG_OPTS) -I$(BSCAN_SPI_BITFILE) readback.bin:R:0:bin

litex-buildenv:
	git clone https://github.com/skiphansen/litex-buildenv.git --branch pano_master

$(ENV_DOWNLOADED):
	(cd litex-buildenv; ./scripts/download-env.sh)
	touch $(ENV_DOWNLOADED)

$(GATEWARE_BIT_FILE): | litex-buildenv $(ENV_DOWNLOADED)
	(cd litex-buildenv; . ./scripts/enter-env.sh; make gateware)

build_all: $(GATEWARE_BIT_FILE)
	(cd litex-buildenv; . ./scripts/enter-env.sh; ./scripts/build-linux.sh)

TOP_BIN = litex-buildenv/build/pano_logic_g2_net_vexriscv.linux/gateware/top.bin
IMAGE_FBI = litex-buildenv/third_party/buildroot/output/images/Image.fbi
CPIO_FBI = litex-buildenv/third_party/buildroot/output/images/rootfs.cpio.fbi

$(TOP_BIN): $(GATEWARE_BIT_FILE)

$(IMAGE_FBI) $(CPIO_FBI):
	(cd litex-buildenv; . ./scripts/enter-env.sh; make ../$@)

update_prebuilt: $(TOP_BIN) $(IMAGE_FBI) $(CPIO_FBI)
	cp $^ prebuilt
	mv prebuilt/top.bin prebuilt/gateware-$(UART_PORT).bin
