# Prosody uberspace setup
#
# ©10.01.2015
# github.com/andre-hub/ShellCollection/tree/master/lnx/prosody_uberspace_setup.sh
# 
# based on a article from 2013-02-07 - prosody auf dem uberspace installieren 
#  - by Christian Ruesch - https://blog.rt.fm/ -> thanks!

# prosody auf dem uberspace installieren
YOUR_DOMAIN="---domain--"
YOUR_USERNAME="--username--"

SRV_ADMIN_JABBER_ID="/"$YOUR_USERNAME@$YOUR_DOMAIN/""
CLIENT2SRV_PORTS="53728" # c2s_ports
SRV2SRV_PORTS="53729" # s2s_ports

SSL_VERSION="1.0.1k"
PROSODY_VERSION="0.9.7"
LUA_VERSION="5.1"

# prosody installieren:
echo "# added for Prosody and Luarocks" >> .bash_profile
echo "export LUA_PATH='/home/$YOUR_USERNAME/.luarocks/share/lua/$LUA_VERSION/?.lua;/home/$YOUR_USERNAME/.luarocks/share/lua/$LUA_VERSION/?/init.lua;./?.lua;/usr/share/lua/$LUA_VERSION/?.lua;/usr/share/lua/$LUA_VERSION/?/init.lua;/home/$YOUR_USERNAME/.luarocks/share/lua/$LUA_VERSION/?.lua;/home/$YOUR_USERNAME/.luarocks/share/lua/$LUA_VERSION/?/init.lua;./?.lua;/usr/lib64/lua/$LUA_VERSION/?.lua;/usr/lib64/lua/$LUA_VERSION/?/init.lua;/home/$YOUR_USERNAME/.luarocks/share/lua/$LUA_VERSION/?.lua;/home/$YOUR_USERNAME/.luarocks/share/lua/$LUA_VERSION/?/init.lua;./?.lua'" >> .bash_profile
echo "export LUA_CPATH='/home/$YOUR_USERNAME/.luarocks/lib/lua/$LUA_VERSION/?.so;/usr/lib/lua/$LUA_VERSION/?.so;/home/$YOUR_USERNAME/.luarocks/lib/lua/$LUA_VERSION/?.so;./?.so;/usr/lib64/lua/$LUA_VERSION/?.so;/usr/lib64/lua/$LUA_VERSION/loadall.so;/home/$YOUR_USERNAME/.luarocks/lib/lua/$LUA_VERSION/?.so'" >> .bash_profile 

source ~/.bash_profile

luarocks install luasocket --local
luarocks install luaexpat --local
luarocks install luafilesystem --local
luarocks install luasec --local OPENSSL_DIR=/home/$YOUR_USERNAME/.toast/armed/usr/local/

toast arm https://www.openssl.org/source/openssl-$SSL_VERSION.tar.gz
toast arm https://prosody.im/downloads/source/prosody-$PROSODY_VERSION.tar.gz

if [ -d /home/$YOUR_USERNAME/.ssl ]; then
	mkdir /home/$YOUR_USERNAME/.ssl
fi

# certs anlegen:
cd /home/$YOUR_USERNAME/.ssl/
if [ -f localhost.key -o -f localhost.crt ]; then
	mv loscalhost.key localhost.key.orig
	mv localhost.cert localhost.cert.orig
fi
openssl genrsa -out localhost.key 4096
openssl req -new -x509 -key localhost.key -out localhost.crt -days 365
openssl genrsa -out "$YOUR_DOMAIN"_prosody.key 4096
openssl req -new -x509 -key "$YOUR_DOMAIN"_prosody.key -out "$YOUR_DOMAIN"_prosody.crt -days 365

# notwendige directories anlegen:
mkdir -p /home/$YOUR_USERNAME/var/prosody/data/

# damit jabber auf dem uberspace funktioniert, muessen die ports freigegeben werden
# hierzu eine email an hallo@uberspace.de schicken und um Portfreigabe bitten
# die u.a. Beispielports 53728 (client) und 53729 (server) durch eure freigegebenen ports ersetzen
# Anmerkung: nicht vergessen, die SRV Eintraege in eurem DNS auf diese ports zu setzen

# prosody.cfg.lua config anpassen:
cat <<__EOF__ > /home/$YOUR_USERNAME/var/prosody/data/prosody.cfg.lua  
    admins = { $SRV_ADMIN_JABBER_ID }
    pidfile = "/home/$YOUR_USERNAME/var/prosody/prosody.pid";
    modules_enabled = {
	-- Generally required
		"roster"; -- Allow users to have a roster. Recommended ;)
		"saslauth"; -- Authentication for clients and servers. Recommended if you want to log in.
		"tls"; -- Add support for secure TLS on c2s/s2s connections
		"dialback"; -- s2s dialback support
		"disco"; -- Service discovery

	-- Not essential, but recommended
		"private"; -- Private XML storage (for room bookmarks, etc.)
		"vcard"; -- Allow users to set vCards
	
	-- These are commented by default as they have a performance impact
		--"privacy"; -- Support privacy lists
		--"compression"; -- Stream compression

	-- Nice to have
		--"version"; -- Replies to server version requests
		--"uptime"; -- Report how long server has been running
		--"time"; -- Let others know the time here on this server
		--"ping"; -- Replies to XMPP pings with pongs
		--"pep"; -- Enables users to publish their mood, activity, playing music and more
		--"register"; -- Allow users to register on this server using a client and change passwords

	-- Admin interfaces
		"admin_adhoc"; -- Allows administration via an XMPP client that supports ad-hoc commands
		--"admin_telnet"; -- Opens telnet console interface on localhost port 5582
	
	-- HTTP modules
		--"bosh"; -- Enable BOSH clients, aka "Jabber over HTTP"
		--"http_files"; -- Serve static files from a directory over HTTP

	-- Other specific functionality
		"posix"; -- POSIX functionality, sends server to background, enables syslog, etc.
		--"groups"; -- Shared roster support
		--"announce"; -- Send announcement to all online users
		--"welcome"; -- Welcome users who register accounts
		"watchregistrations"; -- Alert admins of registrations
		--"motd"; -- Send a message to users when they log in
		--"legacyauth"; -- Legacy authentication. Only used by some old clients and bots.
};
daemonize = false; -- IMPORTANT for daemontools! DO NOT EDIT!  
data_path = "/home/$YOUR_USERNAME/var/prosody/data";
log = { "*console" } -- IMPORTANT for daemontools! DO NOT EDIT!  
allow_registration = false;
s2s_ports = { $SRV2SRV_PORTS } -- freien Port suchen & eintragen!  
c2s_ports = { $CLIENT2SRV_PORTS } -- freien Port (+1) suchen & eintragen!  
c2s_require_encryption = true  
s2s_require_encryption = true  
authentication = "internal_hashed" -- do not save passphrases in cleartext!

VirtualHost "$YOUR_DOMAIN"  
        enabled = true

Component "muc.$YOUR_DOMAIN" "muc"
	name = "muc"
	restrict_room_creation = false

ssl = {  
        key = "/home/$YOUR_USERNAME/.ssl/$YOUR_DOMAIN"_prosody.key";
        certificate = "/home/$YOUR_USERNAME/.ssl/$YOUR_DOMAIN_prosody.crt";
        ciphers = "kEDH:AESGCM:HIGH:MEDIUM:TLSv1:!RC4:!RC2:!3DES:!DES:!MD5:!DSS:!aNULL:!eNULL";
        options = { "no_ticket", "no_compression", "no_sslv2", "no_sslv3", "cipher_server_preference" }
}
__EOF__ 

rm /home/$YOUR_USERNAME/.toast/armed/etc/prosody/prosody.cfg.lua
ln -s /home/$YOUR_USERNAME/var/prosody/data/prosody.cfg.lua /home/$YOUR_USERNAME/.toast/armed/etc/prosody/prosody.cfg.lua

# prosody test
prosodyctl about

# prosody starten:
prosodyctl start

# bugfixes:
# ln -s /home/%USERNAME%/.toast/pkg/prosody/v%VERSION%/1/root/bin/prosody prosody
# ln -s /home/%USERNAME%/.toast/pkg/prosody/v%VERSION%/1/root/bin/prosodyctl prosodyctl
echo "Installation Fertig!"
echo "Hinweis:"
echo "ein daemontools-service erstellen: $ uberspace-setup-svscan"
echo "und weiter .... $ uberspace-setup-service prosody ~/.toast/armed/bin/prosody"
echo "prosodyctl adduser me@jabber.fix.me"