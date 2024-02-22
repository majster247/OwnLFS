#Own ARM LFS [in build]


export CLFS=/mnt/clfs

#Version check
./version-check.sh

#disk format
./disk-format.sh


mkdir -pv ${CLFS}
mount -v /dev/mmcblk0p1 ${CLFS}

#download packages from cve and extract with checking md5sum
