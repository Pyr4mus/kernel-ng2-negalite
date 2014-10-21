#!/system/bin/sh

##################################################
#  ______                   _       _            #
# |  ___ \                 | |     (_)_          #
# | |   | | ____ ____  ____| |      _| |_  ____  #
# | |   | |/ _  ) _  |/ _  | |     | |  _)/ _  ) #
# | |   | ( (/ ( ( | ( ( | | |_____| | |_( (/ /  #
# |_|   |_|\____)_|| |\_||_|_______)_|\___)____) #
#              (_____|                           #
##################################################
#                                                #
#     Created By Negamann303 for NegaLite S4     #
#                                                #
##################################################
#                                                #
#     Any changes made will require a Reboot     #
#      Don't forget to re-set permissions        #
#                                                #
##################################################

#===============================================================

##############################
# User Customizable Settings #
##############################

#===============================================================

PERFORMANCE_CONTROL="On"  #choices [On, off]
COLOR_RES_CONTROL="On"  #choices [On, off]
SD_MEMORY_CONTROL="On"  #choices [On, off]
MEMORY_CONTROL="On"  #choices [On, off]
DEFRAG_DB_CONTROL="On"  #choices [On, off]
ZIPALIGN_CONTROL="On"  #choices [On, off] 
DISABLE_LOGCAT_CONTROL="Off"  #choices [On, off] (Turning 'On' will disable logcat)

#===============================================================

# Color Resolution ( If COLOR_RES_CONTROL is set to "On" )
COLOR_RES="32"  #choices[16, 24, 32]

# LED Notification Duration
LED_NOTIF_DUR="0" #[0 = Forever]

# Vibration Strength
VIBRATION="120"

#===============================================================

# Memory Settings ( If MEMORY_CONTROL is set to "On" )
MEM_MINFREE="4096,8192,16384,32768,49152,65536"
MEM_KILL="0,1,2,4,7,15"
MEM_COST="32"
MEM_DEBUG_LEVEL="0"

#===============================================================

# SD Cache Settings ( If SD_MEMORY_CONTROL is set to "On" )
READ_AHEAD_KB="3072"
VIR_READ_AHEAD_KB="128"
MTD_READ_AHEAD_KB="16"
MAX_RATIO="100"

#####################################
# End Of User Customizable Settings #
#####################################

# Remounts with noatime and nodiratime.
mount -o remount,ro /
mount -o remount,ro rootfs
mount -o remount,ro /system 2>/dev/null
mount -o remount,noatime,barrier=0,nobh /system
mount -o remount,noatime,noauto_da_alloc,nosuid,nodev,nodiratime,barrier=0,nobh /cache /cache
mount -o remount,noatime,noauto_da_alloc,nosuid,nodev,nodiratime,barrier=0,nobh /data /data
mount -t debugfs none /sys/kernel/debug

if [ -e /system/etc/post-init.sh ]; then
	sh /system/etc/post-init.sh
fi

# set msm_mpdecision parameters
echo 45000 > /sys/module/msm_mpdecision/slack_time_max_us
echo 15000 > /sys/module/msm_mpdecision/slack_time_min_us
echo 100000 > /sys/module/msm_mpdecision/em_win_size_min_us
echo 1000000 > /sys/module/msm_mpdecision/em_win_size_max_us
echo 3 > /sys/module/msm_mpdecision/online_util_pct_min
echo 25 > /sys/module/msm_mpdecision/online_util_pct_max
echo 97 > /sys/module/msm_mpdecision/em_max_util_pct
echo 2 > /sys/module/msm_mpdecision/rq_avg_poll_ms
echo 10 > /sys/module/msm_mpdecision/mp_em_rounding_point_min
echo 85 > /sys/module/msm_mpdecision/mp_em_rounding_point_max
echo 50 > /sys/module/msm_mpdecision/iowait_threshold_pct

soc_id=`cat /sys/devices/system/soc/soc0/id`

case "$soc_id"
	in "130")
		echo 230 > /sys/class/gpio/export
		echo 228 > /sys/class/gpio/export
		echo 229 > /sys/class/gpio/export
		echo "in" > /sys/class/gpio/gpio230/direction
		echo "rising" > /sys/class/gpio/gpio230/edge
		echo "in" > /sys/class/gpio/gpio228/direction
		echo "rising" > /sys/class/gpio/gpio228/edge
		echo "in" > /sys/class/gpio/gpio229/direction
		echo "rising" > /sys/class/gpio/gpio229/edge
		echo 253 > /sys/class/gpio/export
		echo 254 > /sys/class/gpio/export
		echo 257 > /sys/class/gpio/export
		echo 258 > /sys/class/gpio/export
		echo 259 > /sys/class/gpio/export
		echo "out" > /sys/class/gpio/gpio253/direction
		echo "out" > /sys/class/gpio/gpio254/direction
		echo "out" > /sys/class/gpio/gpio257/direction
		echo "out" > /sys/class/gpio/gpio258/direction
		echo "out" > /sys/class/gpio/gpio259/direction
		chown -h media /sys/class/gpio/gpio253/value
		chown -h media /sys/class/gpio/gpio254/value
		chown -h media /sys/class/gpio/gpio257/value
		chown -h media /sys/class/gpio/gpio258/value
		chown -h media /sys/class/gpio/gpio259/value
		chown -h media /sys/class/gpio/gpio253/direction
		chown -h media /sys/class/gpio/gpio254/direction
		chown -h media /sys/class/gpio/gpio257/direction
		chown -h media /sys/class/gpio/gpio258/direction
		chown -h media /sys/class/gpio/gpio259/direction
		echo 0 > /sys/module/rpm_resources/enable_low_power/vdd_dig
		echo 0 > /sys/module/rpm_resources/enable_low_power/vdd_mem
	;;
esac


emmc_boot=`getprop ro.boot.emmc`
case "$emmc_boot"
    in "true")
        chown -h system /sys/devices/platform/rs300000a7.65536/force_sync
        chown -h system /sys/devices/platform/rs300000a7.65536/sync_sts
        chown -h system /sys/devices/platform/rs300100a7.65536/force_sync
        chown -h system /sys/devices/platform/rs300100a7.65536/sync_sts
    ;;
esac

echo 10 > /sys/devices/platform/msm_sdcc.3/idle_timeout


start thermald
#start thermal-engine
#start mpdecision

#fastrpc permission setting
#insmod /system/lib/modules/adsprpc.ko
#chown -h system.system /dev/adsprpc-smd
#chmod -h 666 /dev/adsprpc-smd

if [ $PERFORMANCE_CONTROL = "On" ]; then
	# Kernel
	echo "NO_NORMALIZED_SLEEPER" > /proc/sys/kernel/debug/sched_features
	echo "100000" > /proc/sys/kernel/sched_rt_period_us
	echo "95000" > /proc/sys/kernel/sched_rt_runtime_us
	echo "0" > /proc/sys/kernel/sched_child_runs_first
	echo "0" > /proc/sys/kernel/tainted
	echo "5" > /proc/sys/kernel/panic
	echo "0" > /proc/sys/kernel/panic_on_oops
	echo "1333" > /proc/sys/kernel/random/read_wakeup_threshold
	echo "4096" > /proc/sys/kernel/random/write_wakeup_threshold
	echo "524288" > /proc/sys/kernel/threads-max
	echo "268435456" > /proc/sys/kernel/shmmax
	echo "16777216" > /proc/sys/kernel/shmall
	echo "5000000" > /proc/sys/kernel/sched_latency_ns
	echo "1000000" > /proc/sys/kernel/sched_min_granularity_ns
	echo "1000000" > /proc/sys/kernel/sched_wakeup_granularity_ns

	# FileSystem
	echo "524288" > /proc/sys/fs/file-max
	echo "32000" > /proc/sys/fs/inotify/max_queued_events
	echo "256" > /proc/sys/fs/inotify/max_user_instances
	echo "10240" > /proc/sys/fs/inotify/max_user_watches
	echo "10" > /proc/sys/fs/lease-break-time
	echo "1048576" > /proc/sys/fs/nr_open

	# Sysctl
	echo "0" > /proc/sys/vm/block_dump
	echo "1" > /proc/sys/vm/oom_dump_tasks
	echo "3" > /proc/sys/vm/drop_caches
	echo "1" > /proc/sys/vm/overcommit_memory
	echo "100" > /proc/sys/vm/overcommit_ratio
	echo "0" > /proc/sys/vm/swappiness
	
	swapoff nullswap
	
	echo "60" > /proc/sys/vm/dirty_ratio
	echo "40" > /proc/sys/vm/dirty_background_ratio
	echo "25" > /proc/sys/vm/vfs_cache_pressure
	echo "0" > /proc/sys/vm/oom_kill_allocating_task
	echo "4096" > /proc/sys/vm/min_free_kbytes
	echo "0" > /proc/sys/vm/panic_on_oom
	echo "3" > /proc/sys/vm/page-cluster
	echo "0" > /proc/sys/vm/laptop_mode
	echo "4" > /proc/sys/vm/min_free_order_shift
	echo "1000" > /proc/sys/vm/dirty_expire_centisecs
	echo "2000" > /proc/sys/vm/dirty_writeback_centisecs

	# Net
	echo "1048576" > /proc/sys/net/core/wmem_max
	echo "1048576" > /proc/sys/net/core/rmem_max
	echo "524288" > /proc/sys/net/core/rmem_default
	echo "524288" > /proc/sys/net/core/wmem_default

	echo "0" > /proc/sys/net/ipv4/tcp_ecn
	echo "1" > /proc/sys/net/ipv4/route/flush
	echo "1" > /proc/sys/net/ipv4/tcp_rfc1337
	echo "0" > /proc/sys/net/ipv4/ip_no_pmtu_disc
	echo "1" > /proc/sys/net/ipv4/tcp_sack
	echo "1" > /proc/sys/net/ipv4/tcp_fack
	echo "1" > /proc/sys/net/ipv4/tcp_window_scaling
	echo "0" > /proc/sys/net/ipv4/conf/all/accept_redirects
	echo "0" > /proc/sys/net/ipv4/conf/all/secure_redirects
	echo "0" > /proc/sys/net/ipv4/conf/all/accept_source_route
	echo "1" > /proc/sys/net/ipv4/conf/all/rp_filter
	echo "0" > /proc/sys/net/ipv4/conf/default/accept_redirects
	echo "0" > /proc/sys/net/ipv4/conf/default/secure_redirects
	echo "0" > /proc/sys/net/ipv4/conf/default/accept_source_route
	echo "1" > /proc/sys/net/ipv4/conf/default/rp_filter
	echo "cubic" > /proc/sys/net/ipv4/tcp_congestion_control
	echo "2" > /proc/sys/net/ipv4/tcp_synack_retries
	echo "2" > /proc/sys/net/ipv4/tcp_syn_retries
	echo "1024" > /proc/sys/net/ipv4/tcp_max_syn_backlog
	echo "16384" > /proc/sys/net/ipv4/tcp_max_tw_buckets
	echo "1" > /proc/sys/net/ipv4/icmp_echo_ignore_all
	echo "1" > /proc/sys/net/ipv4/icmp_ignore_bogus_error_responses
	echo "1" > /proc/sys/net/ipv4/tcp_no_metrics_save
	echo "1" > /proc/sys/net/ipv4/tcp_moderate_rcvbuf
	echo "1800" > /proc/sys/net/ipv4/tcp_keepalive_time
	echo "0" > /proc/sys/net/ipv4/ip_forward
	echo "1" > /proc/sys/net/ipv4/tcp_timestamps
	echo "1" > /proc/sys/net/ipv4/tcp_tw_reuse
	echo "1" > /proc/sys/net/ipv4/tcp_tw_recycle
	echo "5" > /proc/sys/net/ipv4/tcp_keepalive_probes
	echo "30" > /proc/sys/net/ipv4/tcp_keepalive_intvl
	echo "15" > /proc/sys/net/ipv4/tcp_fin_timeout
	echo "1" > /proc/sys/net/ipv4/tcp_workaround_signed_windows
	echo "1" > /proc/sys/net/ipv4/tcp_low_latency
	echo "0" > /proc/sys/net/ipv4/ip_no_pmtu_disc
	echo "1" > /proc/sys/net/ipv4/tcp_mtu_probing
	echo "2" > /proc/sys/net/ipv4/tcp_frto
	echo "2" > /proc/sys/net/ipv4/tcp_frto_response
fi

# Color Resolution
if [ $COLOR_RES_CONTROL = "On" ]; then
    echo $COLOR_RES > /sys/kernel/debug/msm_fb/0/bpp	
fi

# LED Notification
if [ -e /sys/kernel/notification_leds/off_timer_multiplier ]; then
	echo $LED_NOTIF_DUR > /sys/kernel/notification_leds/off_timer_multiplier
fi	

# SD Card Tweaks
if [ $SD_MEMORY_CONTROL = "On" ]; then
	echo "10" > /sys/devices/platform/msm_sdcc.3/idle_timeout	
	echo "8" > /sys/block/mtdblock0/bdi/read_ahead_kb
	echo "8" > /sys/block/mtdblock1/bdi/read_ahead_kb
	echo "8" > /sys/block/mtdblock2/bdi/read_ahead_kb
	echo "8" > /sys/block/mtdblock3/bdi/read_ahead_kb

	echo $READ_AHEAD_KB > /sys/block/stl10/bdi/read_ahead_kb
	echo $READ_AHEAD_KB > /sys/block/stl11/bdi/read_ahead_kb
	echo $READ_AHEAD_KB > /sys/block/stl9/bdi/read_ahead_kb
	echo $READ_AHEAD_KB > /sys/block/mmcblk0/queue/read_ahead_kb
	echo $READ_AHEAD_KB > /sys/block/mmcblk1/queue/read_ahead_kb

	echo $READ_AHEAD_KB > /sys/devices/virtual/bdi/179:0/read_ahead_kb
	echo $READ_AHEAD_KB > /sys/devices/virtual/bdi/179:32/read_ahead_kb
	echo $MAX_RATIO > /sys/devices/virtual/bdi/179:0/max_ratio
	echo $MAX_RATIO > /sys/devices/virtual/bdi/default/max_ratio

	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/1:0/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/1:1/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/1:2/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/1:3/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/1:4/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/1:5/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/1:6/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/1:7/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/1:8/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/1:9/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/1:10/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/1:11/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/1:12/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/1:13/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/1:14/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/1:15/read_ahead_kb	
	
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/7:0/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/7:1/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/7:2/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/7:3/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/7:4/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/7:5/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/7:6/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/7:7/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/7:8/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/7:9/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/7:10/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/7:11/read_ahead_kb
	
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/253:0/read_ahead_kb	
	
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/254:0/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/254:1/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/254:2/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/254:3/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/254:4/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/254:5/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/254:6/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/254:7/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/254:8/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/254:9/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/254:10/read_ahead_kb
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/254:11/read_ahead_kb
	
	echo $VIR_READ_AHEAD_KB > /sys/devices/virtual/bdi/default/read_ahead_kb
fi

# Memory Management
if [ $MEMORY_CONTROL = "On" ]; then
	chmod 664 /sys/module/lowmemorykiller/parameters/minfile
	chmod 664 /sys/module/lowmemorykiller/parameters/minfree
	echo $MEM_MINFREE > /sys/module/lowmemorykiller/parameters/minfree
	echo $MEM_COST > /sys/module/lowmemorykiller/parameters/cost
	echo $MEM_DEBUG_LEVEL > /sys/module/lowmemorykiller/parameters/debug_level
	echo $MEM_KILL > /sys/module/lowmemorykiller/parameters/adj

	# Flags blocks as non-rotational and increases cache size
	LOOP=`ls -d /sys/block/loop*`
	RAM=`ls -d /sys/block/ram*`
	MMC=`ls -d /sys/block/mmc*`

	for r in $LOOP $RAM; do
        echo "0" > $r/queue/rotational
		echo "1" > $r/queue/iosched/back_seek_penalty
		echo "1" > $r/queue/iosched/low_latency
		echo "1" > $r/queue/iosched/slice_idle
		echo "4" > $r/queue/iosched/fifo_batch
		echo "1" > $r/queue/iosched/writes_starved
		echo "8" > $r/queue/iosched/quantum
		echo "1" > $r/queue/iosched/rev_penalty
		echo "1" > $r/queue/rq_affinity
		echo "0" > $r/queue/iostats
		echo "2" > $r/queue/iosched/writes_starved		
	done

	for m in $LOOP $MMC; do
		echo "1024" > $m/queue/nr_requests
	done
fi

# Kill old garbage market doesnt clean
busybox rm -f /cache/*.apk
busybox rm -f /cache/*.tmp
busybox rm -f /cache/recovery/*
busybox rm -f /data/dalvik-cache/*.apk
busybox rm -f /data/dalvik-cache/*.tmp
busybox rm -f /data/system/userbehavior.db
busybox chmod 400 /data/system/usagestats/

# Disable GSF Check In
if [ -e /data/data/com.google.android.gsf/databases/gservices.db ]; then
	sqlite3 /data/data/com.google.android.gsf/databases/gservices.db "update main set value = 'false' where name = 'perform_market_checkin' and value = 'true'"
	sqlite3 /data/data/com.google.android.gsf/databases/gservices.db "update main set value = 'false' where name = 'checkin_dropbox_upload:system_update' and value = 'true'"
	sqlite3 /data/data/com.google.android.gsf/databases/gservices.db "update main set value = 0 where name = 'market_force_checkin' and value = 1"
	sqlite3 /data/data/com.google.android.gsf/databases/gservices.db "update main set value = 0 where name = 'checkin_interval'"
	sqlite3 /data/data/com.google.android.gsf/databases/gservices.db "update main set value = 0 where name = 'secure:bandwidth_checkin_stat_interval'"
fi

# Disable Logcat
if [ $DISABLE_LOGCAT_CONTROL = "On" ]; then
	if [ -e /dev/log/main ]; then
		busybox rm /dev/log/main
	fi
fi

# Defrag Databases
if [ $DEFRAG_DB_CONTROL = "On" ]; then
	for i in \
	`busybox find /data -iname "*.db"`
	do \
		/system/xbin/sqlite3 $i 'VACUUM;'
		/system/xbin/sqlite3 $i 'REINDEX;'
	done

	if [ -d "/dbdata" ]; then
		for i in \
		`busybox find /dbdata -iname "*.db"` 
		do \
			/system/xbin/sqlite3 $i 'VACUUM;'
			/system/xbin/sqlite3 $i 'REINDEX;'
		done
	fi

	if [ -d "/datadata" ]; then
		for i in \
		`busybox find /datadata -iname "*.db"`
		do \
			/system/xbin/sqlite3 $i 'VACUUM;'
			/system/xbin/sqlite3 $i 'REINDEX;'
		done
	fi

	for i in \
	`busybox find /sdcard -iname "*.db"`
	do \
		/system/xbin/sqlite3 $i 'VACUUM;'
		/system/xbin/sqlite3 $i 'REINDEX;'
	done

	for i in \
	`busybox find /external_sd -iname "*.db"`
	do \
		/system/xbin/sqlite3 $i 'VACUUM;'
		/system/xbin/sqlite3 $i 'REINDEX;'
	done	
fi

# Zipalign
if [ $ZIPALIGN_CONTROL = "On" ]; then
	for apk in /system/app/*.apk /system/priv-app/*.apk /system/framework/*.apk; do
		zipalign -c 4 $apk
		ZIPCHECK=$?
		if [ $ZIPCHECK -eq 1 ]; then
			echo ZipAligning $(basename $apk)
			zipalign -f 4 $apk /cache/$(basename $apk)
			if [ -e /cache/$(basename $apk) ]; then
				cp -f -p /cache/$(basename $apk) $apk
				rm /cache/$(basename $apk)
			else
				echo ZipAligning $(basename $apk)
			fi
		else
			echo ZipAlign already completed on $apk
		fi
	done	
	
	for apk in /data/app/*.apk; do
		zipalign -c 4 $apk
		ZIPCHECK=$?
		if [ $ZIPCHECK -eq 1 ]; then
			echo ZipAligning $(basename $apk)
			zipalign -f 4 $apk /cache/$(basename $apk)
			if [ -e /cache/$(basename $apk) ]; then
				cp -f -p /cache/$(basename $apk) $apk
				rm /cache/$(basename $apk)
			else
				echo ZipAligning $(basename $apk) Failed
			fi
		else
			echo ZipAlign already completed on $apk
		fi
	done
fi

# Fix Permissions
for file in /system/app/* /system/priv-app/* /system/framework/* /data/app/*; do
	chmod 644 $file
done

if [ -e /data/data/com.android.providers.contacts/files ]; then
	chmod -R 777 /data/data/com.android.providers.contacts/files
fi

# Run Init.d Scripts
if [ -e /system/etc/init.d ]; then
    busybox run-parts /system/etc/init.d
fi

# Journaling
tune2fs -o journal_data_writeback /dev/block/mmcblk0p16
tune2fs -o journal_data_writeback /dev/block/mmcblk0p18
tune2fs -o journal_data_writeback /dev/block/mmcblk0p29

# Unmount debug filesystem
busybox unmount /sys/kernel/debug
umount /sys/kernel/debug

