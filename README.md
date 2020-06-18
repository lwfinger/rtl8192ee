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
you must have the kernel headers installed (usually package linux-headers or linux-headers-generic). If you do not understand what this means,
consult your distro's documentation.

### Compiling

Depending on your distribution, you *might* need to run this as root.  

`make all -j$(nproc)`

### Installing

`sudo make install`

You must also blacklist the kernel driver, or it will override this one.  

`echo "blacklist rtl8192ee" | sudo tee -a /etc/modprobe.d/50-blacklist.conf`

Now, tell the system to load the module on boot.

`echo "8192ee" | sudo tee -a /etc/modules-load.d/8192ee.conf`

### Using as AP

Reference: TL-WN881ND v2
This device can broadcast on channels 1-13.
Using hostapd to manage your AP, set the proper ht-capab field for this device, which is:  

`HT_CAPAB=[RX-STBC1][SHORT-GI-40][SHORT-GI-20][DSSS_CCK-40][MAX-AMSDU-7935]`

Optionally enable wideband, if you don't have neighbours:  
Note that while this will result in a increase in network throughput it may cause clients further away to fail connecting.  

`HT_CAPAB=[HT40+][RX-STBC1][SHORT-GI-40][SHORT-GI-20][DSSS_CCK-40][MAX-AMSDU-7935]` (for channels 1-7), or  
`HT_CAPAB=[HT40-][RX-STBC1][SHORT-GI-40][SHORT-GI-20][DSSS_CCK-40][MAX-AMSDU-7935]` (for channels 5-13)

### Changing transmit power

Currently there is no way to change transmit power in the driver with iw or iwconfig tools, as you would with other wireless devices.  
However, you can still manually change the transmit power at compile time
by editing the file `hal/rl8192e/rtl8192e_phycfg.c` and changing the lines below:

```
/* Manual Transmit Power Control 
   The following options take values from 0 to 63, where:
   0 - disable
   1 - lowest transmit power the device can do
   2 - highest transmit power the device can do
   Note that these options may override your country's regulations about transmit power.
   Setting the device to work at higher transmit powers most of the time may cause premature 
   failure or damage by overheating. Make sure the device has enough airflow before you increase this.
   It is currently unknown what these values translate to in dBm.
*/


// Transmit Power Boost
// This value is added to the device's calculation of transmit power index.
// Useful if you want to keep power usage low while still boosting/decreasing transmit power.
// Can take a negative value as well to reduce power.
// Zero disables it. Default: 2, for a tiny boost.
int transmit_power_boost = 2;
// (ADVANCED) To know what transmit powers this device decides to use dynamically, see:
// https://github.com/lwfinger/rtl8192ee/blob/42ad92dcc71cb15a62f8c39e50debe3a28566b5f/hal/phydm/rtl8192e/halhwimg8192e_rf.c#L1310


// Transmit Power Override
// This value completely overrides the driver's calculations and uses only one value for all transmissions.
// Zero disables it. Default: 0
int transmit_power_override = 0;


/* Manual Transmit Power Control */
```

DKMS
---------
The module can also be installed with DKMS. Make sure to install the `dkms` package first.

    sudo dkms add ./rtl8192ee
    sudo dkms build 8192ee/1.1
    sudo dkms install 8192ee/1.1

