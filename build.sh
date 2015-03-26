#!/bin/bash

REVISION="git log --pretty=format:'%h' -n 1"

CURDATE=`date "+%m-%d-%Y"`
VERSION="-Negalite-S4-NG2-$REVISION"

PARENT=`readlink -f .`
INITRAMFS=$PARENT/compiled
INSTALLER=$PARENT/compiled/installer

chmod 755 $PARENT/scripts/gcc-wrapper.py

echo " "
echo "**************************************************************"
echo "**************************************************************"
echo "                Cleaning Up Old Install Files                 "
echo "**************************************************************"
echo "**************************************************************"
echo " "

if [ -e $PARENT/build.log ]; then
	echo "  CLEAN   build.log"
	rm $PARENT/build.log
fi
if [ -e $INITRAMFS/zImage ]; then
	echo "  CLEAN   zImage"
	rm $INITRAMFS/zImage
fi
if [ -e $INITRAMFS/*.zip ]; then
	echo "  CLEAN   kernel.zip"
	rm $INITRAMFS/*.zip
fi;
if [ -e $INSTALLER/kernel/boot.img ]; then
	echo "  CLEAN   boot.img"
	rm $INSTALLER/kernel/boot.img
fi;

if [ -e $INSTALLER/system/lib/modules/ansi_cprng.ko ]; then
	echo "  CLEAN   ansi_cprng.ko"
	rm $INSTALLER/system/lib/modules/ansi_cprng.ko
fi;
if [ -e $INSTALLER/system/lib/modules/cifs.ko ]; then
	echo "  CLEAN   cifs.ko"
	rm $INSTALLER/system/lib/modules/cifs.ko
fi;
if [ -e $INSTALLER/system/lib/modules/dhd.ko ]; then
	echo "  CLEAN   dhd.ko"
	rm $INSTALLER/system/lib/modules/dhd.ko
fi;
if [ -e $INSTALLER/system/lib/modules/exfat_fs.ko ]; then
	echo "  CLEAN   exfat_fs.ko"
	rm $INSTALLER/system/lib/modules/exfat_fs.ko
fi;
if [ -e $INSTALLER/system/lib/modules/exfat_core.ko ]; then
	echo "  CLEAN   exfat_core.ko"
	rm $INSTALLER/system/lib/modules/exfat_core.ko
fi;
if [ -e $INSTALLER/system/lib/modules/frandom.ko ]; then
	echo "  CLEAN   frandom.ko"
	rm $INSTALLER/system/lib/modules/frandom.ko
fi;
if [ -e $INSTALLER/system/lib/modules/gspca_main.ko ]; then
	echo "  CLEAN   gspca_main.ko"
	rm $INSTALLER/system/lib/modules/gspca_main.ko
fi;
if [ -e $INSTALLER/system/lib/modules/ntfs.ko ]; then
	echo "  CLEAN   ntfs.ko"
	rm $INSTALLER/system/lib/modules/ntfs.ko
fi;
if [ -e $INSTALLER/system/lib/modules/ppp_async.ko ]; then
	echo "  CLEAN   ppp_async.ko"
	rm $INSTALLER/system/lib/modules/ppp_async.ko
fi;
if [ -e $INSTALLER/system/lib/modules/reset_modem.ko ]; then
	echo "  CLEAN   reset_modem.ko"
	rm $INSTALLER/system/lib/modules/reset_modem.ko
fi;
if [ -e $INSTALLER/system/lib/modules/scsi_wait_scan.ko ]; then
	echo "  CLEAN   scsi_wait_scan.ko"
	rm $INSTALLER/system/lib/modules/scsi_wait_scan.ko
fi;

echo " "
echo "**************************************************************"
echo "**************************************************************"
echo "               Cleaning Up Old Compiled Files                 "
echo "**************************************************************"
echo "**************************************************************"
echo " "

make mrproper
make clean

echo " "
echo "**************************************************************"
echo "**************************************************************"
echo "               Setting Up Configuration Files                 "
echo "**************************************************************"
echo "**************************************************************"
echo " "

export CROSS_COMPILE=/usr/arm-cortex_a15-linux-gnueabihf-linaro_4.9.3/arm-cortex_a15-linux-gnueabihf-linaro_4.9.3/bin/arm-cortex_a15-linux-gnueabihf-
export ARCH=arm

make VARIANT_DEFCONFIG=jf_spr_defconfig nega_defconfig DEBUG_DEFCONFIG=jf_debug_defconfig SELINUX_DEFCONFIG=selinux_defconfig SELINUX_LOG_DEFCONFIG=selinux_log_defconfig

echo " "
echo "**************************************************************"
echo "**************************************************************"
echo "      Modding .config file - "$VER $CURDATE    
echo "**************************************************************"
echo "**************************************************************"

sed -i 's,CONFIG_LOCALVERSION="negalite-s4",CONFIG_LOCALVERSION="'$VERSION'",' .config

echo "         ______                   _       _                   "
echo "        |  ___ \                 | |     (_)_                 "
echo "        | |   | | ____ ____  ____| |      _| |_  ____         "
echo "        | |   | |/ _  ) _  |/ _  | |     | |  _)/ _  )        "
echo "        | |   | ( (/ ( ( | ( ( | | |_____| | |_( (/ /         "
echo "        |_|   |_|\____)_|| |\_||_|_______)_|\___)____)        "
echo "                     (_____|                                  "
echo " "
echo "                     Negalite NG2 Kernel                      "
echo "                        Revision: $REVISION                   "
echo " "
echo "**************************************************************"
echo "**************************************************************"
echo "                 !!!!!!Now Compiling!!!!!!                    "
echo "        Log Being Sent To (Kernel Source)/build.log           "
echo "	    Only Errors Will Show Up In Terminal                    "
echo "     This May Take Up To An Hour, Depending On Hardware       "
echo "**************************************************************"
echo "**************************************************************"

# Start Timer
TIME1=$(date +%s)

function progress(){
echo -n "Please wait..."
while true
do
     echo -n "."
     sleep 5
done
}

function compile(){
	
	make -j`grep 'processor' /proc/cpuinfo | wc -l` V=s 2>&1 | tee build.log | grep -e ERROR -e Error

	if [ -e $PARENT/arch/arm/boot/zImage ]; then
		echo " "
		echo "**************************************************************"
		echo "**************************************************************"
		echo "                     zImage Compiled!!!                       "
		echo "**************************************************************"
		echo "**************************************************************"
		echo " "
		
		cp $PARENT/arch/arm/boot/zImage $PARENT/compiled/zImage
		cp -a `find -name \*.ko ! -name \*dev.ko ! -name \*test.ko ! -name \*bug.ko ! -name \*iosched.ko` $PARENT/compiled/installer/system/lib/modules/

		
		echo " "
		echo "**************************************************************"
		echo "**************************************************************"
		echo "                Packing zImage into boot.img                  "
		echo "**************************************************************"
		echo "**************************************************************"
		echo " "
		
		cd $INITRAMFS

		perl repack-bootimg.pl zImage boot.img-ramdisk boot.img 
		mv boot.img ./installer/kernel/boot.img
		
		echo " "
		echo "**************************************************************"
		echo "**************************************************************"
		echo "         Zipping The Kernel Up For Flashable Package          "
		echo "**************************************************************"
		echo "**************************************************************"
		echo " "
		
		cd $INSTALLER

		zip -9 -r negalite_kernel_NG2 cpu kernel META-INF setup system
		mv $INSTALLER/negalite_kernel_NG2.zip $INITRAMFS/negalite_kernel_NG2_r$REVISION.zip
		
		echo " "
		echo "**************************************************************"
		echo "**************************************************************"
		echo "              Compile finished Successfully!!!                "
		echo " Package 'negalite_kernel_NG2_r$REVISION.zip' Is Located In The 'compiled' Folder "
		echo "**************************************************************"
		echo "**************************************************************"
		echo " "
	else
		echo " "
		echo "**************************************************************"
		echo "**************************************************************"
		echo "        Something went wrong, zImage did not build...         "
		echo "**************************************************************"
		echo "**************************************************************"
		echo " "
	fi;
}

# Start progress bar in the background
progress &
# Start backup
compile

# End Timer, GetResult
TIME2=$(date +%s)
DIFFSEC="$(expr $TIME2 - $TIME1)"

echo "**************************************************************"
echo "**************************************************************"
echo | awk -v D=$DIFFSEC '{printf "                   Compile time: %02d:%02d:%02d\n",D/(60*60),D%(60*60)/60,D%60}'
echo "**************************************************************"
echo "**************************************************************"
echo " "

# Kill progress
kill $! 1>&1

# Upload File After Compile
if [ -e $INITRAMFS/negalite_kernel_NG2_r$REVISION.zip ]; then
#	echo " "
#	echo "**************************************************************"
#	echo "**************************************************************"
#	read -p "  Would You Like To Reboot The Device Into Recovery? <y/n> " prompt_1
#	echo "**************************************************************"
#	echo "**************************************************************"
#	echo " "
#	if [[ $prompt_1 == "y" || $prompt_1 == "Y" ]]; then
#		adb reboot recovery
#	fi
	
	if [ -e $INITRAMFS/ftp.sh ]; then
		URL="http://download.negalite.com/Negalite_S4_Kernel_NG2/negalite_kernel_NG2_r$REVISION.zip"
		if curl --output /dev/null --silent --head --fail "$URL"; then
			echo "**************************************************************"
			echo "**************************************************************"
			echo "     File Is Not Newer Than The Latest Revision On Server     "
			echo "**************************************************************"
			echo "**************************************************************"
			echo " "
		else	
			read -p "Are You Sure You Want To Upload This Zip To The Server? <y/n> " prompt_2
			if [[ $prompt_2 == "y" || $prompt_2 == "Y" ]]; then
				cd $INITRAMFS
				echo "**************************************************************"
				echo "**************************************************************"
				echo "         Uploading Latest Revision .zip To Server...          "
				echo "**************************************************************"
				echo "**************************************************************"
				echo " "
				sh ftp.sh
			else
				exit 0
			fi
		fi
	fi
fi
