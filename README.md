## Linux on the Pano Logic G2

This repository supplements the following repositories:

* [litex-buildenv](https://github.com/timvideos/litex-buildenv)
* [litex](https://github.com/enjoy-digital/litex)
* [liteeth](https://github.com/enjoy-digital/liteeth)
* [linux-on-litex-vexriscv](https://github.com/litex-hub/linux-on-litex-vexriscv)
* [linux-on-litex-vexriscv-prebuilt](https://github.com/litex-hub/linux-on-litex-vexriscv-prebuilt)

## Why?  
* Pano logic is not yet supported by linux-on-litex-vexriscv-prebuilt.
* Pano support is in flux and some features have not been merged into the upstream repositories yet.

## HW Requirements

* A xc6slx150 based Pano Logic G2 (the one with a DVI port)
* A suitable 5 volt power supply
* A JTAG programmer to load the bitstream into the FPGA.
* A 5 volt compatible serial port
* A cable (clip leads, etc) to connect the serial port to the Pano.

Note: The [Rev C](https://github.com/tomverbeure/panologic-g2/wiki/Identifying-different-Pano-generations-and-revisions) Pano can run Linux, but the flash is too small to boot Linux directly, hence it is not supported here.

## Software Requirements

* GNU make
* xc3sprog

To program the SPI flash in the Pano only [xc3sprog](https://github.com/tomverbeure/panologic-g2/wiki/xc3sprog) is needed, you DO NOT need Xilinx's ISE.

## Serial port 

A serial port is required for a console.  Please see this [page](https://github.com/timvideos/litex-buildenv/wiki/HowTo-Linux-on-Pano-Logic-G2) for connection information.
The baudrate is 115,200. The serial port can be connected to either the DDC lines
on the DVI port or the micro HDMI port.  

The micro HDMI connector is used by default, if you want the serial port to 
be connected via the DVI then set the "UART_PORT" environment variable to "dvi".

## Programming the Pano

Install and configure xc3sprog for your JTAG programmer.  See this [xc3sprog](https://github.com/tomverbeure/panologic-g2/wiki/xc3sprog) in
the Pano Hacker's wiki for more information.

For a serial console on the micro HDMI connector just run "make".  If your
serial console is connected to the DVI connector then run "make image-dvi-flash".

This is a good time to go for a coffee break.  The bitstream plus the Linux 
kernel and filesystem uses almost all of the G2's 16mbyte flash takes 
approximately 5 minutes to program.

```
skip@dell-790:~/pano/working/panog2_linux$ make
xc3sprog -c jtaghs2 -v -e
XC3SPROG (c) 2004-2011 xc3sprog project $Rev: 774 $ OS: Linux
Free software: If you contribute nothing, expect nothing!
Feedback on success/failure/enhancement requests:
        http://sourceforge.net/mail/?group_id=170565
Check Sourceforge for updates:
        http://sourceforge.net/projects/xc3sprog/develop

Using built-in device list
Using built-in cable list
Cable jtaghs2 type ftdi VID 0x0403 PID 0x6014 Desc "Digilent USB Device" dbus data e8 enable eb cbus data 00 data 60
Using Libftdi, Using JTAG frequency   6.000 MHz from undivided clock
JTAG chainpos: 0 Device IDCODE = 0x3401d093     Desc: XC6SLX150
USB transactions: Write 6 read 3 retries 1
xc3sprog -c jtaghs2 -v -I/home/skip/pano/working/panog2_linux/pano/cores/xc3sprog/xc6slx150.bit /home/skip/pano/working/panog2_linux/prebuilt/gateware.bin:W:0:bin
XC3SPROG (c) 2004-2011 xc3sprog project $Rev: 774 $ OS: Linux
Free software: If you contribute nothing, expect nothing!
Feedback on success/failure/enhancement requests:
        http://sourceforge.net/mail/?group_id=170565
Check Sourceforge for updates:
        http://sourceforge.net/projects/xc3sprog/develop

Using built-in device list
Using built-in cable list
Cable jtaghs2 type ftdi VID 0x0403 PID 0x6014 Desc "Digilent USB Device" dbus data e8 enable eb cbus data 00 data 60
Using Libftdi, Using JTAG frequency   6.000 MHz from undivided clock
JTAG chainpos: 0 Device IDCODE = 0x3401d093     Desc: XC6SLX150
Created from NCD file: top.ncd;UserID=0xFFFFFFFF
Target device: 6slx150fgg484
Created: 2019/11/09 17:21:29
Bitstream length: 9415568 bits
DNA is 0x1927bec012fa2fff
done. Programming time 1612.6 ms
JEDEC: 20 20 0x18 0x00
Found Numonyx M25P Device, Device ID 0x2018
256 bytes/page, 65536 pages = 16777216 bytes total
Created from NCD file:
Target device:
Created:
Bitstream length: 34233792 bits
Erasing sector 17/17....Writing data page  16715/ 16716 at flash page  16715..
Maximum erase time 1919.1 ms, Max PP time 191914 us
Verifying page  16716/ 16716 at flash page  16716
Verify: Success!
USB transactions: Write 74944 read 74367 retries 77427
xc3sprog -c jtaghs2 -v -I/home/skip/pano/working/panog2_linux/pano/cores/xc3sprog/xc6slx150.bit /home/skip/pano/working/panog2_linux/prebuilt/Image.fbi:W:4456448:bin
XC3SPROG (c) 2004-2011 xc3sprog project $Rev: 774 $ OS: Linux
Free software: If you contribute nothing, expect nothing!
Feedback on success/failure/enhancement requests:
        http://sourceforge.net/mail/?group_id=170565
Check Sourceforge for updates:
        http://sourceforge.net/projects/xc3sprog/develop

Using built-in device list
Using built-in cable list
Cable jtaghs2 type ftdi VID 0x0403 PID 0x6014 Desc "Digilent USB Device" dbus data e8 enable eb cbus data 00 data 60
Using Libftdi, Using JTAG frequency   6.000 MHz from undivided clock
JTAG chainpos: 0 Device IDCODE = 0x3401d093     Desc: XC6SLX150
Created from NCD file: top.ncd;UserID=0xFFFFFFFF
Target device: 6slx150fgg484
Created: 2019/11/09 17:21:29
Bitstream length: 9415568 bits
DNA is 0x1927bec012fa2fff
done. Programming time 1614.7 ms
JEDEC: 20 20 0x18 0x00
Found Numonyx M25P Device, Device ID 0x2018
256 bytes/page, 65536 pages = 16777216 bytes total
Created from NCD file:
Target device:
Created:
Bitstream length: 42693280 bits
Erasing sector 38/38....Writing data page  20846/ 20847 at flash page  38254..
Maximum erase time 1884.7 ms, Max PP time 188475 us
Verifying page  20847/ 20847 at flash page  38255
Verify: Success!
USB transactions: Write 96793 read 96216 retries 98368
xc3sprog -c jtaghs2 -v -I/home/skip/pano/working/panog2_linux/pano/cores/xc3sprog/xc6slx150.bit /home/skip/pano/working/panog2_linux/prebuilt/rootfs.cpio.fbi:W:10223616:bin
XC3SPROG (c) 2004-2011 xc3sprog project $Rev: 774 $ OS: Linux
Free software: If you contribute nothing, expect nothing!
Feedback on success/failure/enhancement requests:
        http://sourceforge.net/mail/?group_id=170565
Check Sourceforge for updates:
        http://sourceforge.net/projects/xc3sprog/develop

Using built-in device list
Using built-in cable list
Cable jtaghs2 type ftdi VID 0x0403 PID 0x6014 Desc "Digilent USB Device" dbus data e8 enable eb cbus data 00 data 60
Using Libftdi, Using JTAG frequency   6.000 MHz from undivided clock
JTAG chainpos: 0 Device IDCODE = 0x3401d093     Desc: XC6SLX150
Created from NCD file: top.ncd;UserID=0xFFFFFFFF
Target device: 6slx150fgg484
Created: 2019/11/09 17:21:29
Bitstream length: 9415568 bits
DNA is 0x1927bec012fa2fff
done. Programming time 1610.3 ms
JEDEC: 20 20 0x18 0x00
Found Numonyx M25P Device, Device ID 0x2018
256 bytes/page, 65536 pages = 16777216 bytes total
Created from NCD file:
Target device:
Created:
Bitstream length: 32518208 bits
Erasing sector 55/55....Writing data page  15878/ 15879 at flash page  55814..
Maximum erase time 1876.5 ms, Max PP time 187650 us
Verifying page  15879/ 15879 at flash page  55815
Verify: Success!
USB transactions: Write 74255 read 73678 retries 75990
skip@dell-790:~/pano/working/panog2_linux$
```

## Running 

Once the Pano has been flashed power cycle the Pano and after about a minute
you should be greeted by a login prompt:

```
        __   _ __      _  __
       / /  (_) /____ | |/_/
      / /__/ / __/ -_)>  <
     /____/_/\__/\__/_/|_|
   Build your hardware, easily!

 (c) Copyright 2012-2020 Enjoy-Digital
 (c) Copyright 2007-2015 M-Labs

 BIOS built on Apr 25 2020 11:21:03
 BIOS CRC passed (a925dc64)

 Migen git sha1: 19d5eae
 LiteX git sha1: 2d018826

--=============== SoC ==================--
CPU:       VexRiscv @ 50MHz
ROM:       32KB
SRAM:      32KB
L2:        8KB
MAIN-RAM:  65536KB

--========== Initialization ============--
Ethernet init...
Initializing SDRAM...
SDRAM now under hardware control
Memtest OK
Memspeed Writes: 122Mbps Reads: 163Mbps

--============== Boot ==================--
Booting from serial...
Press Q or ESC to abort boot completely.
sL5DdSMmkekro
Timeout
Loading Image from flash...
Copying 5336652 bytes from 0x20440000 to 0x40000000...
Loading rootfs.cpio from flash...
Copying 4064768 bytes from 0x209c0000 to 0x40800000...
Loading rv32.dtb from flash...
Copying 2096 bytes from 0x20410000 to 0x41000000...
Loading emulator.bin from flash...
Copying 2992 bytes from 0x20414000 to 0x41100000...
Executing booted program at 0x41100000

--============= Liftoff! ===============--
*** VexRiscv BIOS ***
*** Supervisor ***
[    0.000000] No DTB passed to the kernel
[    0.000000] Linux version 5.0.13 (skip@dell-790) (gcc version 8.4.0 (Buildroot 2020.05-git-01081-ga5c711d671)) #1 Wed Apr 22 17:27:32 PDT 2020
[    0.000000] earlycon: sbi0 at I/O port 0x0 (options '')
[    0.000000] printk: bootconsole [sbi0] enabled
[    0.000000] Initial ramdisk at: 0x(ptrval) (8388608 bytes)
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x0000000040000000-0x0000000043ffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000040000000-0x0000000043ffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000040000000-0x0000000043ffffff]
[    0.000000] elf_hwcap is 0x1101
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 16256
[    0.000000] Kernel command line: mem=64M@0x40000000 rootwait console=liteuart earlycon=sbi root=/dev/ram0 init=/sbin/init swiotlb=32
[    0.000000] Dentry cache hash table entries: 8192 (order: 3, 32768 bytes)
[    0.000000] Inode-cache hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Sorting __ex_table...
[    0.000000] Memory: 51528K/65536K available (4001K kernel code, 153K rwdata, 685K rodata, 148K init, 216K bss, 14008K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] NR_IRQS: 0, nr_irqs: 0, preallocated irqs: 0
[    0.000000] irqchip: LiteX VexRiscv irqchip driver initialized. IE: 0, mask: 0x00000000, pending: 0x00000000
[    0.000000] irqchip: LiteX VexRiscv irqchip settings: mask CSR 0x9c0, pending CSR 0xdc0
[    0.000000] clocksource: riscv_clocksource: mask: 0xffffffffffffffff max_cycles: 0xb8812736b, max_idle_ns: 440795202655 ns
[    0.000423] sched_clock: 64 bits at 50MHz, resolution 20ns, wraps every 4398046511100ns
[    0.004576] Console: colour dummy device 80x25
[    0.006991] Calibrating delay loop (skipped), value calculated using timer frequency.. 100.00 BogoMIPS (lpj=200000)
[    0.008961] pid_max: default: 32768 minimum: 301
[    0.024141] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.026401] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.107469] devtmpfs: initialized
[    0.166403] random: get_random_bytes called from setup_net+0x4c/0x188 with crng_init=0
[    0.176339] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
[    0.178876] futex hash table entries: 256 (order: -1, 3072 bytes)
[    0.194323] NET: Registered protocol family 16
[    0.504980] FPGA manager framework
[    0.534599] clocksource: Switched to clocksource riscv_clocksource
[    0.993483] NET: Registered protocol family 2
[    1.019512] tcp_listen_portaddr_hash hash table entries: 512 (order: 0, 4096 bytes)
[    1.021575] TCP established hash table entries: 1024 (order: 0, 4096 bytes)
[    1.024127] TCP bind hash table entries: 1024 (order: 0, 4096 bytes)
[    1.025634] TCP: Hash tables configured (established 1024 bind 1024)
[    1.032083] UDP hash table entries: 256 (order: 0, 4096 bytes)
[    1.033789] UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
[    1.060866] Unpacking initramfs...
[    3.571957] Initramfs unpacking failed: junk in compressed archive
[    3.605447] workingset: timestamp_bits=30 max_order=14 bucket_order=0
[    4.418383] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    4.420418] io scheduler mq-deadline registered
[    4.421347] io scheduler kyber registered
[    4.440526] LiteX SoC Controller driver initialized
[    7.270383] f0002000.serial: ttyLXU0 at MMIO 0xf0002000 (irq = 0, base_baud = 0) is a liteuart
[    7.273680] printk: console [liteuart0] enabled
[    7.273680] printk: console [liteuart0] enabled
[    7.275899] printk: bootconsole [sbi0] disabled
[    7.275899] printk: bootconsole [sbi0] disabled
[    7.321040] litex-spiflash f0005000.spiflash: m25p128 (16384 Kbytes)
[    7.360856] libphy: Fixed MDIO Bus: probed
[    7.365044] liteeth f0006000.mac: Failed to get IRQ, using polling
[    7.395429] liteeth f0006000.mac eth0: irq 0, mapped at a0006000
[    7.406138] i2c /dev entries driver
[    7.519660] NET: Registered protocol family 10
[    7.559833] Segment Routing with IPv6
[    7.563964] sit: IPv6, IPv4 and MPLS over IPv4 tunneling driver
[    7.647618] Freeing unused kernel memory: 148K
[    7.648480] This architecture does not have kernel memory protection.
[    7.649562] Run /init as init process
mount: mounting tmpfs on /dev/shm failed: Invalid argument
mount: mounting tmpfs on /tmp failed: Invalid argument
mount: mounting tmpfs on /run failed: Invalid argument
Starting syslogd: OK
Starting klogd: OK
Running sysctl: OK
Saving random seed: [   12.892732] random: dd: uninitialized urandom read (512 bytes read)
OK
Starting network: OK

Welcome to Buildroot
buildroot login: root
                __   _
               / /  (_)__  __ ____ __
              / /__/ / _ \/ // /\ \ /
             /____/_/_//_/\_,_//_\_\
                   / _ \/ _ \
   __   _ __      _\___/_//_/ __         ___  _
  / /  (_) /____ | |/_/__| | / /____ __ / _ \(_)__ _____  __
 / /__/ / __/ -_)>  </___/ |/ / -_) \ // , _/ (_-</ __/ |/ /
/____/_/\__/\__/_/|_|    |___/\__/_\_\/_/|_/_/___/\__/|___/

 32-bit VexRiscv CPU with MMU integrated in a LiteX SoC

login[76]: root login on 'console'
root@buildroot:~# ifconfig eth0 up inet <IP ADDRESS FOR YOUR PANO>
root@buildroot:~# ip route add default via <IP ADDRESS OF YOUR GATEWAY> dev eth0
root@buildroot:~# echo "nameserver 8.8.8.8" > /etc/resolv.conf
root@buildroot:~# ping google.com
PING google.com (172.217.5.206): 56 data bytes
64 bytes from 172.217.5.206: seq=0 ttl=54 time=19.764 ms
64 bytes from 172.217.5.206: seq=1 ttl=54 time=20.881 ms
^C
--- google.com ping statistics ---
2 packets transmitted, 2 packets received, 0% packet loss
round-trip min/avg/max = 19.764/20.322/20.881 ms
root@buildroot:~#
```

### Building everything from sources

You will need:

* A PC running Linux natively or in a VM.
* Xilinx ISE 14.7.

The free Webpack version of Xilinx [ISE 14.7](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools/archive-ise.html) is used for development.
Download the latest Windows 10 version which supports the Spartan 6 family of 
chips used in the second generation Pano Logic device.

1. Clone the https://github.com/skiphansen/panog2_linux repository
2. cd into .../panog2_linux
3. Run "make build_all"

This would be a good time to go to breakfast/lunch/dinner.  It takes about 30
minutes for a complete build with a good Internet connection.  A large amount
of utilities and code will be downloaded from the Internet the first time 
build_all is run.

**NB:** The Ethernet interface currently includes a workaround kludge for a fatal
routing error which occurs on the Pano platform [(issue #38)](https://github.com/enjoy-digital/liteeth/issues/38) which "kind of works, most of the time".
The prebuilt binaries have been cherry picked, if your build results in poor 
or no Ethernet functionality this is probably the reason. Simply 
re-run build_all again and it might work better.

**A proper fix would be most welcome!**

## SPI memory map for Linux on Pano G2 rev A/B

The minimum flash erase size is 256k (0x40000).  

To save flash space the end of the bitstream, the device tree and the emulator 
share the same erase block.

The Linux kernel and root file system do not share any erase blocks so they
may be updated independently.


|     Byte address     |  offset  |       usage        | used     |
|----------------------|----------|--------------------|----------|
| 0x000000 -> 0x40ffff |     -    | fpga bitstream     | 4122k    |
| 0x410000 -> 0x413fff | 0x0      | device tree        | 1703     |
| 0x414000 -> 0x43ffff | 0x4000   | emulator           | 2992     |
| 0x440000 -> 0x9bffff | 0x30000  | Linux kernel       | 5211k    |
| 0x9c0000 -> 0xdbffff | 0x5b0000 | root file system   | 3970k    |
| 0xdc0000 -> 0xffffff |    -     | 2.2 mb for future  |  0       |

## Pano Links

litex-buildenv's [howto](https://github.com/timvideos/litex-buildenv/wiki/HowTo-Linux-on-Pano-Logic-G2)
Links to other Pano Logic information can be found [here](https://github.com/tomverbeure/panologic-g2/wiki/Pano Logic-links#pano-links)

## LEGAL 

My original work (Makefile and various patches) is released under the 
GNU General Public License, version 2.

