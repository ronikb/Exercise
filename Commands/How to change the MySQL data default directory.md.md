
How to change the MySQL data default directory
_________________________________________________________________________________

First you need to Stop MySQL using the following command
	
	sudo /etc/init.d/mysql stop

Now Copy the existing data directory (default located in /var/lib/mysql) using the following command

	sudo cp -R -p /var/lib/mysql /path/to/new/datadir

All you need are the data files, so delete the others with the command

	sudo rm /path/to/new/datadir

Now edit the MySQL configuration file with the following command

	vi  /etc/mysql/my.cnf
Look for the entry for “datadir”, and change the path (which should be “/var/lib/mysql”) to the new data directory.

Important Note:-From Ubuntu 7.10 (Gutsy Gibbon) forward, Ubuntu uses some security software called AppArmor that specifies the areas of your filesystem applications are allowed to access. Unless you modify the AppArmor profile for MySQL, you’ll never be able to restart MySQL with the new datadir location.

In the terminal, enter the command

	vi /etc/apparmor.d/usr.sbin.mysqld

Copy the lines beginning with “/var/lib/mysql”, comment out the originals with hash marks (“#”), and paste the lines below the originals.

Now change “/var/lib/mysql” in the two new lines with “/path/to/new/datadir”. Save and close the file.

Restart the AppArmor profiles with the command

	sudo /etc/init.d/apparmor reload

Restart MySQL with the command

	sudo /etc/init.d/mysql restart

ow MySQL should start with no errors, and your data will be stored in the new data directory location.









































