#!/bin/sh
Y=`date +%Y-%m-%d`
CFGBACKUPMAINDIR="srv-scripts"
SCRIPTBACKUPDIR=$CFGBACKUPMAINDIR"/scripts"-$Y

SrvBackupSingleFile() {
    CFGBACKUPFILE=`echo $1 | sed -e 's/\//-/g'`
    CFGBACKUPFILE=$2/$CFGBACKUPFILE
    echo "- backup file: /$1"
    cp /$1 $CFGBACKUPFILE
}

if [ ! -d $SCRIPTBACKUPDIR ]; then
    mkdir $SCRIPTBACKUPDIR
fi

# home
SrvBackupSingleFile "home/andre/mount-data.sh" $SCRIPTBACKUPDIR


SrvBackupSingleFile "root/snortLog.pl" $SCRIPTBACKUPDIR

# srv backup scripts
SrvBackupSingleFile "srv-backup-cfg.sh" $SCRIPTBACKUPDIR
SrvBackupSingleFile "srv-backup-packages.sh" $SCRIPTBACKUPDIR
SrvBackupSingleFile "srv-backup-scripts.sh" $SCRIPTBACKUPDIR

# Jail Scripte
SrvBackupSingleFile "usr/jails/srv2.local/usr/local/bin/blacklist.sh" $SCRIPTBACKUPDIR


#/usr/local/bin\.... scripte
SrvBackupSingleFile "usr/local/bin/jails-backup.sh" $SCRIPTBACKUPDIR
SrvBackupSingleFile "usr/local/bin/mount-jails-ports.sh" $SCRIPTBACKUPDIR