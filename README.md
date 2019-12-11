IMPORTANT - PLEASE READ:

Beginning on November 4, 2019, I will NO LONGER support people that have downloaded the source
as a zip file. Using git has much more flexibility. In addition, there is much less liklihood
that a user will contact me with a problem that is ALREADY fixed.

If your system says that /lib/modules/...../build does not exist, you have not
installed the kernel headers, you have done it incorrectly, or you are not running
the kernel for which the headers have been installed. The necessary steps are
dependent on which distro you are using. Creating a new issue and asking at
GitHub will not be productive.

Unsolicited E-mail sent to my private address will be ignored!!

If a build fails that previously worked, perform a 'git pull' and retry before
reporting a problem. As noted, if you had downloaded the source in zip form, then you would
need to get an entirely new source file. That is why using git, which downloads only the changed
lines, is required.

rtl8192ee
=========

Repository for the stand-alone RTL8192EE driver.  
May offer much better performance than the kernel rtl8192ee driver, especially when used as Access Point.  
Still, it will, with difficulty, barely surpass 50Mbps of uplink, in the best conditions.

Compiling & Building
---------
### Dependencies
To compile the driver, you need to have make and a compiler installed. In addition,
you must have the kernel headers installed. If you do not understand what this means,
consult your distro.
### Compiling

Depending on your distribution, you *might* need to run this as root.  

> make all

### Installing

> sudo make install

You must also blacklist the kernel driver, or it will override this one.  

> sudo nano /etc/modprobe.d/50-blacklist.conf

Add a line that says "blacklist rtl8192ee", no quotes.

Now, tell the system to load the module on boot.

> sudo nano /etc/modules-load.d/8192ee.conf

Add a line that says "8192ee", no quotes.

### Using as AP

Reference: TL-WN881ND
This device can broadcast on channels 1-13 with a maximum txpower of 20dBm.
Using hostapd to manage your AP, set the proper ht-capab field for this device, which is:  

> HT_CAPAB=[RX-STBC1][SHORT-GI-40][SHORT-GI-20][DSSS-CCK-40][MAX-AMSDU-7935]

Optionally enable wideband, if you don't have neighbours:  

> HT_CAPAB=[HT40+][RX-STBC1][SHORT-GI-40][SHORT-GI-20][DSSS-CCK-40][MAX-AMSDU-7935]

Optionally optimize the driver by tweaking some features:  

> sudo nano /etc/modprobe.d/8192ee.conf

Add a line that says "options 8192ee rtw_iqk_fw_offload=1 rtw_en_napi=1 rtw_pci_aspm_enable=0 rtw_lps_level=0", no quotes.  

This will disable power-saving features and enable offloading that might or might not improve performance at the cost of power. YMMV.

DKMS
---------
The module can also be installed with DKMS. Make sure to install the `dkms` package first.

    sudo dkms add ./rtl8192ee
    sudo dkms build 8192ee/1.1
    sudo dkms install 8192ee/1.1

Known Issues
---------
This driver is prone to locking up after some time of activity. (a day or two)

To (mostly) solve this, append `swiotlb=32768` to your kernel parameters. How to do this depends on your distribution and bootloader.

On GRUB, for example, this is at `/etc/default/grub`, at the `GRUB_CMDLINE_LINUX_DEFAULT` line. After changing it, you may run `sudo update-grub` to apply the change.

Submitting Issues
---------

Frequently asked Questions
---------

