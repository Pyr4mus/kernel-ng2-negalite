#!/sbin/busybox sh
#

# Remount FileSys RW
/sbin/busybox mount -t rootfs -o remount,rw rootfs

echo "Running Post-Init Script"

# Default Frequencies
# Temp Workarround ...
# Setting default values here is uncommon
#
# This JOB should be done by a App/Service
#
# We will take care about that later ...

## CPU 0 is always online!
echo "Setting Min/Max freq to core 0"
echo "1890000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo "384000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq

## CPU 1
if [ -f /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq ];
then
  echo "CPU 1 already online, setting Min/Max Freq"
  echo "1890000" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
  echo "384000" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq
else
  echo "CPU1 is down, hotpluging to set Min/Max Freq"
  echo "1" >  /sys/devices/system/cpu/cpu1/online
  echo "1890000" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
  echo "384000" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq
  echo "0" >  /sys/devices/system/cpu/cpu1/online
fi

## CPU 2
if [ -f /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq ];
then
  echo "CPU 2 already online, setting Min/Max Freq"
  echo "1890000" > /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq
  echo "384000" > /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq
else
  echo "CPU2 is down, hotpluging it to set Min/Max Freq"
  echo "1" >  /sys/devices/system/cpu/cpu2/online
  echo "1890000" > /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq
  echo "384000" > /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq
  echo "0" >  /sys/devices/system/cpu/cpu2/online
fi

## CPU 3
if [ -f /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq ];
then
  echo "CPU 3 already online, setting Min/Max Freq"
  echo "1890000" > /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq
  echo "384000" > /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq
else
  echo "CPU3 is down, hotpluging it to set Min/Max Freq"
  echo "1" >  /sys/devices/system/cpu/cpu3/online
  echo "1890000" > /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq
  echo "384000" > /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq
  echo "0" > /sys/devices/system/cpu/cpu3/online
fi

# Remount FileSys RO
/sbin/busybox mount -t rootfs -o remount,ro rootfs


echo "Post-init finished ..."
