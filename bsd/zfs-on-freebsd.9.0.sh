#boot from install cd and choose "Live CD"
#add devices and install bootloader
gpart create -s gpt ada0
gpart create -s gpt ada1
gpart add -a 4k -s 512k -t freebsd-boot ada0
gpart add -a 4k -s 512k -t freebsd-boot ada1

##gmirror-swap##
gpart add -a 4k -s 4G -t freebsd-swap -l swap0 ada0
gpart add -a 4k -s 4G -t freebsd-swap -l swap1 ada1
##gmirror-swap##

gpart add -a 4k -t freebsd-zfs -l disk0 ada0
gpart add -a 4k -t freebsd-zfs -l disk1 ada1
gpart bootcode -b /boot/pmbr -p /boot/gptzfsboot -i 1 ada0
gpart bootcode -b /boot/pmbr -p /boot/gptzfsboot -i 1 ada1

#create pool
gnop create -S 4096 /dev/gpt/disk0
gnop create -S 4096 /dev/gpt/disk1
zpool create -o altroot=/mnt -o cachefile=/var/tmp/zpool.cache zroot mirror /dev/gpt/disk0.nop /dev/gpt/disk1.nop
zpool export zroot
gnop destroy /dev/gpt/disk0.nop
gnop destroy /dev/gpt/disk1.nop
zpool import -o altroot=/mnt -o cachefile=/var/tmp/zpool.cache zroot

#setup pool
zpool set bootfs=zroot zroot
zfs set checksum=fletcher4 zroot

zfs create zroot/usr
zfs create zroot/usr/home
zfs create zroot/var
zfs create -o compression=on -o exec=on -o setuid=off zroot/tmp
zfs create -o compression=gzip-9 -o setuid=off zroot/usr/ports
zfs create -o compression=off -o exec=off -o setuid=off zroot/usr/ports/distfiles
zfs create -o compression=off -o exec=off -o setuid=off zroot/usr/ports/packages
zfs create -o compression=gzip-9 -o exec=off -o setuid=off zroot/usr/src
zfs create -o compression=lzjb -o exec=off -o setuid=off zroot/var/crash
zfs create -o exec=off -o setuid=off zroot/var/db
zfs create -o compression=lzjb -o exec=on -o setuid=off zroot/var/db/pkg
zfs create -o exec=off -o setuid=off zroot/var/empty
zfs create -o compression=lzjb -o exec=off -o setuid=off zroot/var/log
zfs create -o compression=gzip -o exec=off -o setuid=off zroot/var/mail
zfs create -o exec=off -o setuid=off zroot/var/run
zfs create -o compression=lzjb -o exec=on -o setuid=off zroot/var/tmp

#create swap
#zfs create -V 4G zroot/swap
#zfs set org.freebsd:swap=on zroot/swap
#zfs set checksum=off zroot/swap

##gmirror-swap##
gmirror label -b prefer swap gpt/swap0 gpt/swap1
##gmirror-swap##

#fix permissions
chmod 1777 /mnt/tmp
cd /mnt ; ln -s usr/home home
chmod 1777 /mnt/var/tmp

#install FreeBSD
cd /usr/freebsd-dist
export DESTDIR=/mnt
for file in base.txz kernel.txz doc.txz src.txz; #ports.txz lib32.txz
do (cat $file | tar --unlink -xpJf - -C ${DESTDIR:-/}); done

#final configuration
cp /var/tmp/zpool.cache /mnt/boot/zfs/zpool.cache
echo 'zfs_enable="YES"' >> /mnt/etc/rc.conf
echo 'zfs_load="YES"' >> /mnt/boot/loader.conf
echo 'vfs.root.mountfrom="zfs:zroot"' >> /mnt/boot/loader.conf
echo 'LOADER_ZFS_SUPPORT=YES' > /mnt/etc/src.conf
echo 'WRKDIRPREFIX=/usr/obj' >> /mnt/etc/make.conf
touch /mnt/etc/fstab

##gmirror-swap##
echo '/dev/mirror/swap none swap sw 0 0' >> /mnt/etc/fstab
echo 'geom_mirror_load="YES"' >> /mnt/boot/loader.conf
##gmirror-swap##

zfs set readonly=on zroot/var/empty

#reboot into the new system
#passwd root
#tzsetup
#cd /etc/mail ; make aliases
#echo 'WITH_PKGNG=yes' >> /etc/make.conf
#...edit rc.conf
#in login.conf eintragen:
##:charset=UTF-8:\
##:lang=de_DE.UTF-8:\
#cap_mkdb /etc/login.conf