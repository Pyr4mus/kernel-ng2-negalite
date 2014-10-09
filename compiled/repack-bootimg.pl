#!/usr/bin/perl -W

use strict;
use Cwd;

my $dir = getcwd;

my $usage = "repack-bootimg.pl <kernel> <ramdisk-directory> <outfile>\n";

die $usage unless $ARGV[0] && $ARGV[1] && $ARGV[2];

chdir $ARGV[1] or die "$ARGV[1] $!";

system ("find . | cpio -o -H newc | gzip > $dir/ramdisk-repack.cpio.gz");

chdir $dir or die "$ARGV[1] $!";;

system ("mkbootimg --cmdline 'console = null androidboot.hardware=qcom user_debug=31 msm_rtb.filter=0x3F ehci-hcd.park=3 maxcpus=4 zcache' --kernel $ARGV[0] --ramdisk ramdisk-repack.cpio.gz --base 0x80200000 --pagesize 2048 --ramdisk_offset 0x02000000 -o $ARGV[2]");

unlink("ramdisk-repack.cpio.gz") or die $!;
