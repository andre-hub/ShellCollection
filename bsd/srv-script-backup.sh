#!/bin/sh

CFGBACKUPDIR="srv-scripte/configs/"

cd ~
if [ ! -d $CFGBACKUPDIR ]; then
	mkdir srv-scripte
	cd srv-scripte
	mkdir configs
fi

# make list from installed ports
portmaster --list-origins > $CFGBACKUPDIR"installed-port-list"
# insert portlist to portmaster
# portmaster -y --no-confirm `cat installed-port-list`

echo "etc rc.d"
cd /etc/
tar cvfj ~/srv-scripte/configs/etc-rc.d.tar.bz2 rc.d/
cd /usr/local/etc/
tar cvfj ~/srv-scripte/configs/usr-local-etc-rc.d.tar.bz2 rc.d/

cd ~

CFGBACKUPFILE="boot-loader.conf"
echo $CFGBACKUPFILE
cp /boot/loader.conf $CFGBACKUPDIR$CFGBACKUPFILE

CFGBACKUPFILE="etc-crontab"
echo $CFGBACKUPFILE
cp /etc/crontab $CFGBACKUPDIR$CFGBACKUPFILE

CFGBACKUPFILE="etc-sysctl.conf"
echo $CFGBACKUPFILE
cp /etc/sysctl.conf $CFGBACKUPDIR$CFGBACKUPFILE

CFGBACKUPFILE="etc-hosts.allow"
echo $CFGBACKUPFILE
cp /etc/hosts.allow $CFGBACKUPDIR$CFGBACKUPFILE

CFGBACKUPFILE="etc-pf.conf"
echo $CFGBACKUPFILE
cp /etc/pf.conf $CFGBACKUPDIR$CFGBACKUPFILE

CFGBACKUPFILE="etc-ppp-ppp.conf"
echo $CFGBACKUPFILE
cp /etc/ppp/ppp.conf $CFGBACKUPDIR$CFGBACKUPFILE

CFGBACKUPFILE="etc-rc.conf"
echo $CFGBACKUPFILE
cp /etc/rc.conf $CFGBACKUPDIR$CFGBACKUPFILE

CFGBACKUPFILE="usr-local-etc-dhcpd.conf"
echo $CFGBACKUPFILE
cp /usr/local/etc/dhcpd.conf $CFGBACKUPDIR$CFGBACKUPFILE

CFGBACKUPFILE="usr-local-etc-dhcpd6.conf"
echo $CFGBACKUPFILE
cp /usr/local/etc/dhcpd6.conf $CFGBACKUPDIR$CFGBACKUPFILE


CFGBACKUPFILE="usr-local-etc-smartd.conf"
echo $CFGBACKUPFILE
cp /usr/local/etc/smartd.conf $CFGBACKUPDIR$CFGBACKUPFILE

CFGBACKUPFILE="usr-local-etc-unbound-dnsspoof.conf"
echo $CFGBACKUPFILE
cp /usr/local/etc/unbound/dnsspoof.conf $CFGBACKUPDIR$CFGBACKUPFILE

CFGBACKUPFILE="usr-local-etc-unbound-unbound.conf"
echo $CFGBACKUPFILE
cp /usr/local/etc/unbound/unbound.conf $CFGBACKUPDIR$CFGBACKUPFILE

CFGBACKUPFILE="usr-local-etc-zfs-snapshot-mgmt.conf"
echo $CFGBACKUPFILE
cp /usr/local/etc/zfs-snapshot-mgmt.conf $CFGBACKUPDIR$CFGBACKUPFILE