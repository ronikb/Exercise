#How to setup Percona mysql replication

##Setting up Percona mysql master server
	
	1. Install Percona mysql server
	2. Install Percona xtrabackup

Make a full mysql data backup and prepare it

	innobackupex --user=root --password=<password> /path/to/backupdir
	
In order for snapshot to be consistent you need to prepare the data
	
	innobackupex --user=root --password=<password> --apply-log /path/to/backupdir/$TIMESTAMP/

Create a mysql user with replication privilages

	GRANT REPLICATION SLAVE ON *.*  TO 'repl'@'$slaveip' IDENTIFIED BY '$pass';
	grant all on *.* to repl@’192.168.1.85’ identified by ‘pass’;

Copy this backed up data in to the Slave server

	rsync -avprP -e ssh /path/to/backupdir/$TIMESTAMP/ user@slave-server:/percona-backup/ 

Edit my.cnf file for preparing this server as a master. Add the followings in this file

	bind-address=<master server IP>
	server-id=1
	log_bin=/var/log/mysql/mysql-bin.log


	sudo mysql restart

Enable mysql port from slave server

	sudo ufw allow proto tcp from <slave server IP> to any port 3306

##Setting up Percona mysql slave server

copy my.cnf file from master to slave server (put it in /etc/mysql/) and edit the following for prepaire this server as slave

	bind-address= <IP address to slave server>
	server-id=2

Need to change the password in /etc/mysql/debian.cnf in slave. Check with corresponding file in master server for getting password. Make sure this password is same in both servers.

Create a backup of current mysql data folder. Before doing this stop the mysql service
	
	sudo mv /var/lib/mysql /var/lib/mysql_bak

and move the snapshot from the Master in its place

	mv /percona-backup/$TIMESTAMP/ /var/lib/mysql/

After moving data over, make sure MySQL has proper permissions to access them.

	chown -R mysql:mysql /var/lib/mysql


Go to mysql promt and type the following with proper values. Look at the content of the file xtrabackup_binlog_info. you will get the values for MASTER_LOG_FILE and MASTER_LOG_POS

	cat /var/lib/mysql/xtrabackup_binlog_info

	CHANGE MASTER TO MASTER_HOST='<IP Address of master server>';
	CHANGE MASTER TO MASTER_USER='mysql Replication user';
	CHANGE MASTER TO MASTER_PASSWORD='User password';
	CHANGE MASTER TO MASTER_LOG_FILE='mysql-bin.000001';
	CHANGE MASTER TO MASTER_LOG_POS=107;
	START SLAVE;

Make sure everything went OK with the following command. type this command in mysql console at slave.

	SHOW SLAVE STATUS \G

Ref: http://www.percona.com/doc/percona-xtrabackup/howtos/setting_up_replication.html#replication-howto
 

	
	note: XtraBackup knows where your mysql data is by reading your my.cnf



	