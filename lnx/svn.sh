#/bin/sh

svninstall () {
sudo apt-get install subversion
}

svnsvnservmake () {
svnservcfg
sudo groupadd subversion
sudo mkdir /var/local/svn
sudo adduser --system --home /var/local/svn --no-create-home --uid 1002 --ingroup subversion --disabled-password --disabled-login subversion
sudo chown -R root:root /etc/init.d/svnserve
sudo chmod +x /etc/init.d/svnserve
sudo update-rc.d svnserve defaults
sudo chown -R subversion:subversion /var/local/svn
sudo chmod -R ug+rw /var/local/svn
}

svnstart () {
sudo /etc/init.d/svnserve start
sudo svnadmin create --fs-type fsfs /var/local/svn
}

svnimport () {
if [ $2 ]; then
mkdir -p /tmp/$1/trunk
mkdir -p /tmp/$1/branch
mkdir -p /tmp/$1/tag
cp -R $2/* /tmp/$1/trunk
svn import /tmp/$1 svn://localhost/svn/$1 -m "initialer Import"
fi

}

svnservcfg () {
sudo echo "#!/bin/sh -e
#
# svnserve - brings up the svn server so anonymous users
# can access svn
#

# Get LSB functions
. /lib/lsb/init-functions
. /etc/default/rcS

SVNSERVE=/usr/bin/svnserve
SVN_USER=subversion
SVN_GROUP=subversion
SVN_REPO_PATH=/var/local/svn
SVN_FLAGS=\" -d --listen-port=3690 -r\"
# Check that the package is still installed
[ -x \$SVNSERVE ] || exit 0;

case \"\$1\" in
    start)
        log_begin_msg \"Starting svnserve...\"
        umask 002
        if start-stop-daemon --start      \\
            --chuid \$SVN_USER:\$SVN_GROUP  \\
            --exec \$SVNSERVE              \\
            --\$SVN_FLAGS \$SVN_REPO_PATH; then
            log_end_msg 0
        else
            log_end_msg \$?
        fi
        ;;

    stop)
        log_begin_msg \"Stopping svnserve...\"
        if start-stop-daemon --stop --exec \$SVNSERVE; then
                log_end_msg 0
        else
                log_end_msg \$?
        fi
        ;;

    restart|force-reload)
        \"\$0\" stop && \"\$0\" start
        ;;

    *)
        echo \"Usage: /etc/init.d/svnserve {start|stop|restart|force-reload}\"
        exit 1
        ;;
esac

exit 0
" > /tmp/svnserve
sudo mv /tmp/svnserve /etc/init.d/svnserve

}

svncpcfg () {
sudo echo "### This file controls the configuration of the svnserve daemon, if you
[general]
### unauthenticated  \"write\", \"read\", and \"none\"
anon-access = none
auth-access = write
### password-db
password-db = passwd
### authz-db
#authz-db = authz
### repository name
realm = $1 Repository
" > /tmp/svnserve.conf
sudo mv /tmp/svnserve.conf /var/local/svn/conf/svnserve.conf
sudo chown -R subversion:subversion /var/local/svn/conf/svnserve.conf

sudo echo "### This file is an example password file for svnserve.
### Its format is similar to that of svnserve.conf. As shown in the
### example below it contains one section labelled [users].
### The name and password for each user follow, one account per line.

[users]
user=passuser
user2=pass2user
" > /tmp/passwd
sudo mv /tmp/passwd /var/local/svn/conf/passwd
sudo chown -R subversion:subversion /var/local/svn/conf/passwd
sudo nano /var/local/svn/conf/passwd

sudo echo "### This file is an example authorization file for svnserve.
[groups]
admin = user
entwickler = user,user2

[/]
admin = rw
* =

[marchiv:/]
@entwickler = rw
* =
" > /tmp/authz
sudo mv /tmp/authz /var/local/svn/conf/authz
sudo chown -R subversion:subversion /var/local/svn/conf/authz

}

if [ $1 ]; then
if [ $2 ]; then
svninstall
svnsvnservmake
svnstart
svncpcfg
svnimport $1 $2
else
echo "Quellpfad angeben"
fi
else
echo "Projektname angeben"
fi
