#!/bin/sh

export INITRAMFS=`readlink -f .`
export INSTALLER=$INITRAMFS/installer
REVISION="$(svn info https://kernel-nae-negalite.googlecode.com/svn/ | grep "^Revision:" | cut -c 11-)"

perl repack-bootimg.pl zImage boot.img-ramdisk boot.img 
mv boot.img ./installer/kernel/boot.img

echo "Zipping The Kernel Up For Flashable Package"
cd $INSTALLER

zip -9 -r negalite_kernel_NAE cpu kernel META-INF setup system
mv $INSTALLER/negalite_kernel_NAE.zip $INITRAMFS/negalite_kernel_NAE_r$REVISION.zip
echo "Done"
