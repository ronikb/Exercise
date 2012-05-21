Common Comands

1. Commands for checking the size of a file:

	du -hs  <(File name)>

2. Find a file

	find ./ -name <filename>

3. screen commands

for listing all screens

	screen -ls

for showing Detached screens

	screen -r <screen.name>

for showing attached screens

	screen -x -r <screen.name>

4.command for getting correct file size/folder size

	du -hs file.name> 

5.Display Free Disk Space

	df -h

6.Repair mysql tables:

	mysqlcheck -r -–all-databases
	mysqlcheck -r databasename

7.Optimize mysql tables in databases;

	mysqlcheck -op -–all-databases
	mysqlcheck -op databasename

8. MySql Backup

	mysqldump -u username -h localhost -p database_name | gzip -9 > backup_db.sql.gz

9. create tar ball file

	tar czf new-tar-file-name.tar.gz file-or-folder-to-archive


