#!/bin/sh
Y=`date +%Y-%m-%d`
BACKUPDIR="backup-srv"
CFGBACKUPMAINDIR=$BACKUPDIR"/srv-scripte"
CFGBACKUPDIR=$CFGBACKUPMAINDIR"/configs"-$Y

SrvBackupSingleFile() {
    CFGBACKUPFILE=`echo $1 | sed -e 's/\//-/g'`
    CFGBACKUPFILE=$CFGBACKUPDIR"/"$CFGBACKUPFILE
    echo "- backup file: /$1"
    cp /$1 $CFGBACKUPFILE
}

if [ ! -d ~/$CFGBACKUPDIR ]; then
    mkdir ~/$CFGBACKUPDIR
fi

cd ~
CFGBACKUPDIR=~/$CFGBACKUPDIR
# make list from installed ports
portmaster --list-origins > $CFGBACKUPDIR"/installed-port-list"
# insert portlist to portmaster
# portmaster -y --no-confirm `cat installed-port-list`

echo "backup files: /etc/rc.d/*"
cd /etc/
tar cvfj $CFGBACKUPDIR/etc-rc.d.tar.bz2 rc.d/
cd /usr/local/etc/
tar cvfj $CFGBACKUPDIR/usr-local-etc-rc.d.tar.bz2 rc.d/

echo "backup files: /etc/ssh"
cd /etc/
tar cvfj $CFGBACKUPDIR/etc-ssh.tar.bz2 ssh/

cd $CFGBACKUPDIR
# /etc/.....
SrvBackupSingleFile "boot/loader.conf"
SrvBackupSingleFile "etc/crontab"
SrvBackupSingleFile "etc/group"
SrvBackupSingleFile "etc/hosts.allow"
SrvBackupSingleFile "etc/passwd"
SrvBackupSingleFile "etc/periodic.conf"
SrvBackupSingleFile "etc/make.conf"
SrvBackupSingleFile "etc/pf.conf"
SrvBackupSingleFile "etc/ppp/ppp.conf"
SrvBackupSingleFile "etc/rc.conf"
SrvBackupSingleFile "etc/resolv.conf"
SrvBackupSingleFile "etc/sysctl.conf"

# /usr/local/etc
SrvBackupSingleFile "usr/local/etc/dhcpcd.conf"
SrvBackupSingleFile "usr/local/etc/dhcpd.conf"
SrvBackupSingleFile "usr/local/etc/dhcpd6.conf"
SrvBackupSingleFile "usr/local/etc/ezjail/hippy_local"  
SrvBackupSingleFile "usr/local/etc/ezjail/srv1_local"
SrvBackupSingleFile "usr/local/etc/ezjail/srv2_local"
SrvBackupSingleFile "usr/local/etc/ezjail.conf"
SrvBackupSingleFile "usr/local/etc/named.cache"
SrvBackupSingleFile "usr/local/etc/pkg.conf"
SrvBackupSingleFile "usr/local/etc/portaudit.conf"
SrvBackupSingleFile "usr/local/etc/portaudit.pubkey"
SrvBackupSingleFile "usr/local/etc/portmaster.rc"
SrvBackupSingleFile "usr/local/etc/rkhunter.conf"
SrvBackupSingleFile "usr/local/etc/rsyncd.conf"
SrvBackupSingleFile "usr/local/etc/smartd.conf"
SrvBackupSingleFile "usr/local/etc/vnstat.conf"


# /usr/local/.../unbound
SrvBackupSingleFile "usr/local/etc/unbound/dnsspoof.conf"
srvBackupSingleFile "usr/local/etc/unbound/unbound_control.key"
SrvBackupSingleFile "usr/local/etc/unbound/unbound_control.pem"
SrvBackupSingleFile "usr/local/etc/unbound/unbound_server.key"
SrvBackupSingleFile "usr/local/etc/unbound/unbound_server.pem"
SrvBackupSingleFile "usr/local/etc/unbound/unbound.conf"
SrvBackupSingleFile "usr/local/etc/unbound/blacklist.sh"


#/usr/local/bin\.... scripte
SrvBackupSingleFile "usr/local/bin/jails-backup.sh"
SrvBackupSingleFile "usr/local/bin/mount-jails-ports.sh"