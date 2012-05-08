# Configure SSL for Drupal6 sites

for CentOS,

ref: http://wiki.centos.org/HowTos/Https 

	yum install mod_ssl openssl

Then we need to update the Apache SSL configuration file

	vi /etc/httpd/conf.d/ssl.conf
Change the paths to match where the Key file is stored

	SSLCertificateFile /etc/pki/tls/certs/ca.crt
	SSLCertificateKeyFile /etc/pki/tls/private/ca.key


Restart httpd service

	/etc/init.d/httpd restart

Setting up the virtual hosts

	NameVirtualHost *:443

and then a VirtualHost record something like this:

	<VirtualHost *:443>
        SSLEngine on
        SSLCertificateFile /etc/pki/tls/certs/ca.crt
        SSLCertificateKeyFile /etc/pki/tls/private/ca.key
        <Directory /var/www/vhosts/yoursite.com/httpsdocs>
        AllowOverride All
        </Directory>
        DocumentRoot /var/www/vhosts/yoursite.com/httpsdocs
        ServerName yoursite.com
	</VirtualHost>
Restart Apache

	/etc/init.d/httpd restart

Configure the firewall for enabling port 443

	iptables -A INPUT -p tcp --dport 443 -j ACCEPT
	/sbin/service iptables save
	iptables -L -v

-------------------------------------------------------

the we need to install drupal module for enabling ssl in Drupal

Download and install Secure pages module from http://drupal.org/project/securepages

	wget http://ftp.drupal.org/files/projects/securepages-6.x-1.9.tar.gz
	tar -zxvf securepages-6.x-1.9.tar.gz
	mv securepages /var/www/html/fairview-drupal/public_site/sites/all/modules

Enable this module through Drupal admin console