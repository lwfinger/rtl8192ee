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

Installation
---------

The script "run_me_to_install.sh handles installation."

Run the one liner below in a terminal to install:

`git clone https://github.com/lwfinger/rtl8192ee.git; cd rtl8192ee; ./run_me_to_install.sh`

### Dependencies

To install/build the driver, you need to have make and gcc installed. In addition,
you must have the kernel headers installed. If you do not understand what this means,
consult your distro's documentation. This driver also supports DKMS, so check if you have it installed as well.

### Using as AP

Reference device: TL-WN881ND

This device can broadcast on channels 1-13.

Using hostapd to manage your AP, set the proper ht-capab field for this device, which is:  

> HT_CAPAB=[RX-STBC12][TX-STBC][SHORT-GI-40][SHORT-GI-20][DSSS-CCK-40][MAX-AMSDU-7935]

Optionally enable wideband, if you don't have neighbours:  

> HT_CAPAB=[HT40+][RX-STBC12][TX-STBC][SHORT-GI-40][SHORT-GI-20][DSSS-CCK-40][MAX-AMSDU-7935]

DKMS
---------
The module can also be installed with DKMS. Make sure to install the `dkms` package first.

    sudo dkms add ./rtl8192ee
    sudo dkms build 8192ee/1.2
    sudo dkms install 8192ee/1.2


FAQ
---------
Coming soon.
