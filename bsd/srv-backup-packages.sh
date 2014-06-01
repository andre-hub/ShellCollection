#!/bin/sh
Y=`date +%Y-%m-%d`
BACKUPDIR="configs"
LISTNAME="installed-port-list"

BACKUPLISTFILE="$BACKUPDIR/$LISTNAME-$Y.txt"

# make list from installed ports
echo "port backup"
portmaster --list-origins > $BACKUPLISTFILE

# insert portlist to portmaster
# portmaster -y --no-confirm `cat installed-port-list`
