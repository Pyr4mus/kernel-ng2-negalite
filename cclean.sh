#!/bin/sh

export PARENT=`readlink -f .`
export INITRAMFS=$PARENT/compiled
export INSTALLER=$PARENT/compiled/installer

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
if [ -e $INITRAMFS/negalite_kernel_*.zip ]; then
	echo "  CLEAN   kernel.zip"
	rm $INITRAMFS/negalite_kernel_*.zip
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
