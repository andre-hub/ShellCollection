#!/bin/sh
SRVIP=">>>SERVER-IP<<<"
SRVPATH="/home/"
MNTPOINT="/mnt/srv"

if [ $1 ]; then
    SRVUSER="$1";
else
	SRVUSER=">>>USERNAME<<<";
fi

PINGRES=`ping -c 1 -w 1 $SRVIP |  grep time= | colrm 1 52 | sed 's/ms//' | sed 's/ //'`
if [ ! $PINGRES ]; then
    echo "srv FAIL"
    echo " -> check mounting";
    MNTCHECK=`mount | grep $MNTPOINT`;
    if [ "$MNTCHECK" ]; then 
        echo "umount $MNTPOINT";
        umount -f $MNTPOINT;
    fi
else
    MNTCHECK=`mount | grep $MNTPOINT | sed 's/ //' | awk 'BEGIN{FS=OFS=" "}{$2=$3=$4=$5=""}{print}'`;
    echo "srv OK"
    echo " -> check mounting"
    if [ $MNTCHECK ]; then
        echo "FAIL -> remove mounting"
        umount -f $MNTPOINT
    fi
    sleep 2
    if [ ! $MNTCHECK ]; then 
        if [ ! -d "$MNTPOINT" ]; then
            echo "create $MNTPOINT"
                    mkdir $MNTPOINT;
            chmod 777 $MNTPOINT;
                else
                echo "unmount $MNTPOINT"
            umount -f $MNTPOINT
            fi
        echo "mount $SRVIP:$SRVPATH $MNTPOINT";
        #mount $SRVIP:$SRVPATH $MNTPOINT;
        sshfs $SRVUSER@$SRVIP:$SRVPATH $MNTPOINT;
    fi
fi