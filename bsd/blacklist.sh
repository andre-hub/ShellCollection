#!/bin/sh
# blacklist for unbound

echo "clean dirs"
rm -r  /tmp/blacklists
rm /tmp/blacklists.tar.gz;

echo "download the list"
cd /tmp
ftp ftp://ftp.univ-tlse1.fr/blacklist/blacklists.tar.gz ?> /tmp/ftp.failed

if [ -f "/tmp/blacklists.tar.gz" ]; then
echo "file is local"
	cd /tmp/
	tar -xzvf /tmp/blacklists.tar.gz

echo "modify the file domains in the subfolders"
	cd /tmp/blacklists/

echo " 1. add the ip"
	for dir in adult agressif arjel astrology audio-video bank blog celebrity chat child\
        	cleaning dangerous_material dating drogue filehosting financial forums\
	        gambling games hacking jobsearch liste_bu malware manga marketingware\
        	mixed_adult mobile-phone phishing press publicite radio reaffected redirector\
       		remote-control sect sexual_education shopping social_networks sports\
        	strict_redirector strong_redirector tricheur warez webmail ;\
		do (echo "transform " $dir "step 1";cd $dir;\
			sed -e 's/$/.  IN A 0.0.0.0\"/g' domains > domains.tmp) ; done

echo "2. add the local-data"
	for dir in adult agressif arjel astrology audio-video bank blog celebrity chat child\
        	cleaning dangerous_material dating drogue filehosting financial forums\
	        gambling games hacking jobsearch liste_bu malware manga marketingware\
        	mixed_adult mobile-phone phishing press publicite radio reaffected redirector\
	        remote-control sect sexual_education shopping social_networks sports\
        	strict_redirector strong_redirector tricheur warez webmail ;\
		do (echo "transform " $dir "step 2";cd $dir;\
			sed -e 's/^/local-data: \"/g' domains.tmp > domains.tmp2 ;rm -f domain.tmp) ; done

echo "3. set header"
	for dir in adult agressif arjel astrology audio-video bank blog celebrity chat child\
        	cleaning dangerous_material dating drogue filehosting financial forums\
	        gambling games hacking jobsearch liste_bu malware manga marketingware\
        	mixed_adult mobile-phone phishing press publicite radio reaffected redirector\
	        remote-control sect sexual_education shopping social_networks sports\
        	strict_redirector strong_redirector tricheur warez webmail ;\
        	do (echo "transform " $dir "step 3";cd $dir;\
			echo "server:" > domains.unbound; cat domains.tmp2 >>  domains.unbound ;\
			rm -f domain.tmp2) ; done 

echo "change adult blacklist"
	cd /tmp/blacklists/adult/
	cat domains.unbound | grep .de. > domains_de.unbound
	cat domains.unbound | grep .com. > domains_com.unbound
	cat domains.unbound | grep .net. > domains_net.unbound
	cat domains.unbound | grep .org. > domains_org.unbound
	cat domains.unbound | grep .nl. > domains_nl.unbound
	cat domains.unbound | grep .ru. > domains_ru.unbound

echo "copy to the db path"
	mv /var/db/blacklists/ /var/db/blacklists_backup/
	echo "copy files"
	cp -R /tmp/blacklists/ /var/db/blacklists/

echo "restart unbound server"
	service unbound restart

echo "cleaning"
	rm -f -R /tmp/blacklists/
        rm /tmp/blacklists.tar.gz
fi
