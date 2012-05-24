Common Comands

1. Commands for checking the size of a file:

	du -hs  (File name)

2. Find a file

	find ./ -name (filename)

3. screen commands

for listing all current screens

	screen -ls

entring into Detached screens

	screen -r <screen.name>

entering into attached screens

	screen -x -r <screen.name>

4.command for getting correct file size/folder size

	du -hs <file.name> 
	du -
	ls -lh /
	df -h
	watch ls -al
Note :watch command is used to get realtime updations


5. 


6.Repair mysql tables:

	mysqlcheck -r -–all-databases
	mysqlcheck -r databasename

7.Optimize mysql tables in databases;

	mysqlcheck -op -–all-databases
	mysqlcheck -op databasename

8. MySql Backup

	mysqldump -u username -h localhost -p database_name | gzip -9 > backup_db.sql.gz

9. Mysql restore

	mysql -u root -p database < database.sql

10. create tar ball file

	tar czf new-tar-file-name.tar.gz file-or-folder-to-archive


