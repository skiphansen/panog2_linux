###############################################################################
## Makefile
###############################################################################

TOPDIR = .
GIT_INIT := $(shell if [ ! -e $(TOPDIR)/pano/.git ]; then echo "updating submodules"> /dev/stderr;git submodule init; git submodule update; fi)

PLATFORM = pano-g2

.PHONY: image-flash read_flash

image-flash:

include $(TOPDIR)/pano/make/common.mk
include $(TOPDIR)/pano/make/ise.mk

image-flash:
	$(XC3SPROG) $(XC3SPROG_OPTS) -e
	$(XC3SPROG) $(XC3SPROG_OPTS) -I$(BSCAN_SPI_BITFILE) $(PREBUILT_DIR)/gateware.bin:W:0:bin
	$(XC3SPROG) $(XC3SPROG_OPTS) -I$(BSCAN_SPI_BITFILE) $(PREBUILT_DIR)/Image.fbi:W:4456448:bin
	$(XC3SPROG) $(XC3SPROG_OPTS) -I$(BSCAN_SPI_BITFILE) $(PREBUILT_DIR)/rootfs.cpio.fbi:W:10223616:bin

read_flash:
	$(XC3SPROG) $(XC3SPROG_OPTS) -I$(BSCAN_SPI_BITFILE) readback.bin:R:0:bin

