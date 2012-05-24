rsync is a free software computer program for Unix and Linux like systems which synchronizes files and directories from one location to another while minimizing data transfer using delta encoding when appropriate. 

http://www.cyberciti.biz/tips/linux-use-rsync-transfer-mirror-files-directories.html

ubuntu,

	# apt-get install rsync

CentOS,

	# yum install rsync

Task : Copy file from a local computer to a remote server

	$ rsync -v -e ssh /www/backup.tar.gz test@ip:~

Task : Copy file from a remote server to a local computer
Copy file /home/jerry/webroot.txt from a remote server openbsd.nixcraft.in to a local computer /tmp directory:

	$ rsync -v -e ssh test@ip:~/webroot.txt /tmp

move files

	rsync -avz --progress --remove-source-files /home/ubuntu/test/* /opt/songs
