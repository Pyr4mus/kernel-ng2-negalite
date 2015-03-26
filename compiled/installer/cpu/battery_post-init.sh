#!/system/bin/sh

#SELinux Control
SELINUX="Off"

# Sleep Control
SCREEN_OFF="On"

# CPU Settings ( If CPU_CONTROL is set to "On" )
CPU_AWAKE_MAX="1890000"
CPU_AWAKE_MIN="378000"

CPU_SLEEP_MAX="702000"

# CPU Cores Online
CPU_ONLINE_AWAKE="1" #(1=All Cores Enabled)
CPU_ONLINE_SLEEP="0" #(0=Cores'1', '2' And '3' Disabled, Core '0' Still Enabled)

# GPU Frequency
GPU_FREQ_AWAKE="450000000"
GPU_FREQ_SLEEP="320000000"

# Low Power Settings(l2_cache, Memory)
LOW_POWER_AWAKE="0"  #(0 = off)
LOW_POWER_SLEEP="1"  #(1 = on)

# Fsync
DYN_FSYNC="0"

# CPU Governor
CPU_GOV="ondemand"

# GPU Governor
GPU_GOV="ondemand"

# GPU Simple Governor
SIMPLE_GOV_RAMP="9000"
SIMPLE_LAZINESS="7"

# Ondemand Governor Settings
OND_SAMP_RATE="50000"
OND_SAMP_DOWN_FACT="2"
OND_UP_THRESH="65"
OND_DOWN_DIFF="3"
OND_UP_THRESH_MULTI="80"
OND_DOWN_DIFF_MULTI="3"
OND_OPT_FREQ="702000"
OND_SYNC_FREQ="702000"
OND_UP_THRESH_ANY_CPU_LOAD="80"
OND_IO_BUSY="1"

# FSync
if [ -e /sys/kernel/dyn_fsync/Dyn_fsync_active ]; then
	echo $DYN_FSYNC > /sys/kernel/dyn_fsync/Dyn_fsync_active
fi

# Intelli-Plug
INTELLI_PLUG="On" #choices: [On, Off]

# Auto HotPlug
AUTO_PLUG="On"  #choices: [On, Off]

# Fast Charge
FAST_CHARGE="On"  #choices: [On, Off]

SCHEDULER="noop"

###########################################

echo "Running Post-Init Script"

# SELinux Control
if [ $SELINUX = "On" ]; then
	echo "1" > /sys/fs/selinux/enforce
else
	echo "0" > /sys/fs/selinux/enforce
fi

# Trinity Colors
echo "1" > /sys/devices/virtual/sec/tsp/panel_colors

# LED Control
echo "1" > /sys/class/sec/led/led_fade
echo "1" > /sys/class/sec/led/led_fade_charging
echo "255" > /sys/class/sec/led/led_intensity

# Intelli-Plug
if [ $INTELLI_PLUG = "On" ]; then
	echo "1" > /sys/module/intelli_plug/parameters/intelli_plug_active
	echo "1" > /sys/module/intelli_plug/parameters/eco_mode_active
else
	echo "0" > /sys/module/intelli_plug/parameters/intelli_plug_active
	echo "0" > /sys/module/intelli_plug/parameters/eco_mode_active
fi

# Auto HotPlug
if [ $AUTO_PLUG = "On" ]; then
	echo "1" > /sys/devices/system/cpu/cpu0/cpufreq/enable_auto_hotplug
else
	echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/enable_auto_hotplug
fi

# FSync
if [ -e /sys/kernel/dyn_fsync/Dyn_fsync_active ]; then
	echo $DYN_FSYNC > /sys/kernel/dyn_fsync/Dyn_fsync_active
fi

# Fast charge
if [ $FAST_CHARGE = "On" ]; then
    echo "1" > /sys/kernel/fast_charge/force_fast_charge
else
 	echo "0" > /sys/kernel/fast_charge/force_fast_charge
fi

echo $SCHEDULER > /sys/block/stl10/queue/scheduler
echo $SCHEDULER > /sys/block/stl11/queue/scheduler
echo $SCHEDULER > /sys/block/stl9/queue/scheduler
echo $SCHEDULER > /sys/block/mmcblk0/queue/scheduler
echo $SCHEDULER > /sys/block/mmcblk1/queue/scheduler

# Governor Control
echo $CPU_GOV > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo $CPU_GOV > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
echo $CPU_GOV > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
echo $CPU_GOV > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor

GOVERNOR=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor`

if [ $GOVERNOR = "ondemand" ] || [ $GOVERNOR = "badass" ]; then
	echo $OND_SAMP_RATE > /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate
	echo $OND_UP_THRESH > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold
	echo $OND_DOWN_DIFF > /sys/devices/system/cpu/cpufreq/ondemand/down_differential
	echo $OND_UP_THRESH_MULTI > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold_multi_core
	echo $OND_DOWN_DIFF_MULTI > /sys/devices/system/cpu/cpufreq/ondemand/down_differential_multi_core
	echo $OND_OPT_FREQ > /sys/devices/system/cpu/cpufreq/ondemand/optimal_freq
	echo $OND_SYNC_FREQ > /sys/devices/system/cpu/cpufreq/ondemand/sync_freq
	echo $OND_UP_THRESH_ANY_CPU_LOAD > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold_any_cpu_load
	echo $OND_IO_BUSY > /sys/devices/system/cpu/cpufreq/ondemand/io_is_busy
	echo "1" > /sys/devices/system/cpu/cpufreq/ondemand/ignore_nice_load
	echo $OND_SAMP_DOWN_FACT > /sys/devices/system/cpu/cpufreq/ondemand/sampling_down_factor
fi

# GPU Control
echo $GPU_FREQ_AWAKE > /sys/devices/platform/kgsl-3d0.0/kgsl/kgsl-3d0/max_gpuclk
echo $GPU_GOV > /sys/devices/platform/kgsl-3d0.0/kgsl/kgsl-3d0/pwrscale/trustzone/governor
echo $SIMPLE_GOV_RAMP > /sys/devices/platform/kgsl-3d0.0/kgsl/kgsl-3d0/pwrscale/trustzone/simple_ramp_threshold
echo $SIMPLE_LAZINESS > /sys/devices/platform/kgsl-3d0.0/kgsl/kgsl-3d0/pwrscale/trustzone/simple_laziness


# CPU Control

echo "1" > /sys/devices/system/cpu/cpu0/cpufreq/freq_lock
echo "1" > /sys/devices/system/cpu/cpu0/cpufreq/screen_off_scaling_enable
echo "702000" > /sys/devices/system/cpu/cpu0/cpufreq/screen_off_scaling_mhz
echo "320000000" > /sys/devices/system/cpu/cpu0/cpufreq/screen_off_GPU_mhz
echo "powersave" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor_screen_off
echo "cfq" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_sched_screen_off

echo $LOW_POWER_AWAKE > /sys/module/rpm_resources/enable_low_power/L2_cache
echo $LOW_POWER_AWAKE > /sys/module/rpm_resources/enable_low_power/pxo
echo $LOW_POWER_AWAKE > /sys/module/rpm_resources/enable_low_power/vdd_dig
echo $LOW_POWER_AWAKE > /sys/module/rpm_resources/enable_low_power/vdd_mem

echo 0 > /sys/module/pm_8x60/modes/cpu0/retention/idle_enabled
echo 1 > /sys/module/pm_8x60/modes/cpu0/power_collapse/suspend_enabled
echo 1 > /sys/module/pm_8x60/modes/cpu1/power_collapse/suspend_enabled
echo 1 > /sys/module/pm_8x60/modes/cpu2/power_collapse/suspend_enabled
echo 1 > /sys/module/pm_8x60/modes/cpu3/power_collapse/suspend_enabled
echo 0 > /sys/module/pm_8x60/modes/cpu0/standalone_power_collapse/suspend_enabled
echo 0 > /sys/module/pm_8x60/modes/cpu1/standalone_power_collapse/suspend_enabled
echo 0 > /sys/module/pm_8x60/modes/cpu2/standalone_power_collapse/suspend_enabled
echo 0 > /sys/module/pm_8x60/modes/cpu3/standalone_power_collapse/suspend_enabled
echo 0 > /sys/module/pm_8x60/modes/cpu0/standalone_power_collapse/idle_enabled
echo 0 > /sys/module/pm_8x60/modes/cpu1/standalone_power_collapse/idle_enabled
echo 0 > /sys/module/pm_8x60/modes/cpu2/standalone_power_collapse/idle_enabled
echo 0 > /sys/module/pm_8x60/modes/cpu3/standalone_power_collapse/idle_enabled
echo 1 > /sys/module/pm_8x60/modes/cpu0/power_collapse/idle_enabled

echo $CPU_AWAKE_MAX > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo $CPU_AWAKE_MAX > /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
echo $CPU_AWAKE_MAX > /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq
echo $CPU_AWAKE_MAX > /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq

echo $CPU_AWAKE_MIN > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo $CPU_AWAKE_MIN > /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq
echo $CPU_AWAKE_MIN > /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq
echo $CPU_AWAKE_MIN > /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq

echo 1 > /sys/devices/system/cpu/cpu1/online
echo 1 > /sys/devices/system/cpu/cpu2/online
echo 1 > /sys/devices/system/cpu/cpu3/online

if [ $SCREEN_OFF = "On" ]; then
	(while [ 1 ]; do
		AWAKE=`cat /sys/power/wait_for_fb_wake`
		
		if [ $AWAKE = "awake" ]; then
			echo 1 > /sys/devices/system/cpu/cpu1/online
			echo 1 > /sys/devices/system/cpu/cpu2/online
			echo 1 > /sys/devices/system/cpu/cpu3/online
			#echo $CPU_AWAKE_MAX > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
			echo $LOW_POWER_AWAKE > /sys/module/rpm_resources/enable_low_power/L2_cache
			#echo $LOW_POWER_AWAKE > /sys/module/rpm_resources/enable_low_power/pxo
			echo $LOW_POWER_AWAKE > /sys/module/rpm_resources/enable_low_power/vdd_dig
			#echo $LOW_POWER_AWAKE > /sys/module/rpm_resources/enable_low_power/vdd_mem
			AWAKE=
		fi

		SLEEPING=`cat /sys/power/wait_for_fb_sleep`
		
		if [ $SLEEPING = "sleeping" ]; then	
			echo 0 > /sys/devices/system/cpu/cpu1/online
			echo 0 > /sys/devices/system/cpu/cpu2/online
			echo 0 > /sys/devices/system/cpu/cpu3/online
			#echo $CPU_SLEEP_MAX > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq	
			echo $LOW_POWER_SLEEP > /sys/module/rpm_resources/enable_low_power/L2_cache
			#echo $LOW_POWER_SLEEP > /sys/module/rpm_resources/enable_low_power/pxo
			echo $LOW_POWER_SLEEP > /sys/module/rpm_resources/enable_low_power/vdd_dig
			#echo $LOW_POWER_SLEEP > /sys/module/rpm_resources/enable_low_power/vdd_mem
			SLEEPING=
		fi		
	done &)
fi

echo "Post-init finished ..."

