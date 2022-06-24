#!/bin/sh

destdir=/mnt
bln_on=0

bln_begin()
{
        cd /sys/class/gpio/
        echo 4 > export
        cd gpio4/
        echo out > direction
}

bln()
{
	while :
	do
		echo 0 > value
        	sleep 0.1
        	echo 1 > value
		sleep 0.1
	done
}

bln_end()
{
	cd /sys/class/gpio/
	echo 1 > value
	cd /sys/class/gpio/
	echo 4 > unexport
}

my_umount()
{
	if grep -qs "^/dev/$1 " /proc/mounts ; then
		sync
		umount "${destdir}/$1";
	fi

	[ -d "${destdir}/$1" ] && rmdir "${destdir}/$1"
}

my_mount()
{
	mkdir -p "${destdir}/$1" || exit 1
	fsck.vfat -a "/dev/$1"
	if ! mount -t auto "/dev/$1" "${destdir}/$1"; then
		# failed to mount, clean up mountpoint
		rmdir "${destdir}/$1"
		exit 1
	else
		mkdir -p "${destdir}/$1"/candtu-logs
		bln_begin
		bln&
		bln_pid=$!
		cp -avrf /mnt/mmcblk0p1/logs/* "${destdir}/$1"/candtu-logs
		#rsync -avc /mnt/mmcblk0p1/logs/ "${destdir}/$1"/candtu-logs
		sync
		umount "${destdir}/$1"
		kill $bln_pid
		wait $bln_pid
		bln_end
	fi
}

case "${ACTION}" in
add|"")
	my_umount ${MDEV}
	my_mount ${MDEV}
	;;
remove)
	my_umount ${MDEV}
	;;
esac
