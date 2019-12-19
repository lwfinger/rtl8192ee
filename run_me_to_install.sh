#!/bin/bash
#
# Version number of driver.
ver="1.2"
#
echo "Description: This script automates installation of this driver, plus adding recommended options to modprobe.d"
echo "Press enter to continue, or export AUTO=\"y\" to remove all confirmation and user dialogue."
if [ "$AUTO" == "" ]; then
	read placeholder
	unset placeholder

		echo "Please select an install method."
		echo
		echo "Enter \"dkms\", no quotes, below, to install for all kernels in your system."
		echo "This will let the driver follow kernel updates automatically."
		echo
		echo "Enter \"cko\", no quotes, below, to install only for the current kernel."
		read INST
		
		if [ "$INST" != "dkms" ] && [ "$INST" != "cko" ]; then
			echo "Unknown mode $INST"
			exit 1
		fi
else
		if [ "$INST" == "" ]; then
	echo "Defaulting to current-kernel-only install"
	echo "Setting INST=\"cko\". Export INST=\"dkms\" to override this."
			INST="cko"
		fi
	# Save password via sudo
	sudo echo "OK"	
fi

echo
echo "Step 0. Cleaning up."
make clean

echo
echo "Step 1. Building driver"
thr=$(nproc)
thr=$((thr + 1))

if [ "$INST" == "cko" ]; then
echo "Detected $(nproc) cores. Using $thr threads to build"
make -j$thr all
	
	echo
	echo "Step 2. Installing driver"
	sudo make install
	echo "Done"
#exit 0
fi

if [ "$INST" == "dkms" ]; then
	echo "Using DKMS"
	sudo dkms add .
	sudo dkms build 8192ee/$ver
	sudo dkms build 8192ee/$ver
echo "Done"
#exit 0
fi

echo "Step 3. Setting up driver loading and blacklisting builtin rtl8192ee"
	echo "8192ee" | sudo tee -a /etc/modules-load.d/8192ee.conf
	echo "blacklist rtl8192ee" | sudo tee -a /etc/modprobe.d/50-blacklist.conf
	echo
if [ "$AUTO" = "y" ]; then
	echo "Done."
	exit 0
else
	echo "Installation complete. Would you like to turn off power-saving features for this driver?"
	echo "Might increase performance at the cost of power. yes/NO"
	read SEL
fi

disablePS(){
	echo "Remove /etc/modprobe.d/8192ee.conf if you wish to reenable power save for this driver."
	mkdir /etc/modprobe.d 2>/dev/null
	echo "options 8192ee rtw_iqk_fw_offload=1 rtw_en_napi=1 rtw_pci_aspm_enable=0 rtw_lps_level=0" | sudo tee /etc/modprobe.d/8192ee.conf
	echo "Done. Please reboot your computer."
	exit 0
}

case $SEL in
	y|Y|yes|YES|Yes)
		echo "Disabling Power Save."; disablePS;;
	No|N|n|no|NO)
		echo "Not disabling Power Save. Done. Please reboot your computer."; exit 0;;
	*)
		echo "Not disabling Power Save. Done. Please reboot your computer."; exit 0;;
esac
