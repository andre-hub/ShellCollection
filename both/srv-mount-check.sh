#!/bin/sh

SRVIP=">>>SERVER-IP<<<"
SRVPATH="/home/"
MNTPOINT="/mnt/srv"

PINGRES=`ping -c 1 -w 1 $SRVIP |  grep time= | colrm 1 52 | sed 's/ms//' | sed 's/ //'`
if [ ! $PINGRES ]; then
	echo "srv FAIL -> check mounting"
	MNTCHECK=`mount | grep $MNTPOINT`;
	if [ "$MNTCHECK" ]; then 
		echo "umount $MNTPOINT";
		umount -f $MNTPOINT;
	fi
else
	MNTCHECK=`mount | grep $MNTPOINT | sed 's/ //'`
	echo "srv OK -> check mounting"
        if [ ! $MNTCHECK ]; then 
		if [ ! -d $MNTPOINT]; then
			echo "create $MNTPOINT"
                	mkdir $MNTPOINT;
			chmod 777 $MNTPOINT;
	        fi
		echo "mount $MNTPOINT";
		mount $SRVIP:$SRVPATH $MNTPOINT;
	fi
fi

