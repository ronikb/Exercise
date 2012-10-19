#!/bin/sh
#
# This script to run innobackupex script for all databases on server, check for success, and apply logs to backups.
#
# (C)2012 Roni@Citrus Informatics.com

INNOBACKUPEX=innobackupex-1.5.1
INNOBACKUPEXFULL=/usr/bin/$INNOBACKUPEX
USEROPTIONS="--user=root --password=xxx"
BACKUPDIR=/backup
BACKUPUSER=backup
TMPFILE="/tmp/innobackupex-runner.$$.tmp"

# Age of oldest retained backups in days.
AGE=7

# Some info output

echo "----------------------------"
echo
echo "innobackupex-runner.sh: MySQL backup script"
echo "started: `date`"
echo

# Check options before proceeding

if [ ! -x $INNOBACKUPEXFULL ]; then
 error
 echo "$INNOBACKUPEXFULL does not exist."; echo
 exit 1
fi

if [ ! -d $BACKUPDIR ]; then
 error
 echo "Backup destination folder: $BACKUPDIR does not exist."; echo
 exit 1
fi

if [ -z "`/usr/sbin/service mysql status | grep 'mysql start/running'`" ] ; then
 echo "HALTED: MySQL does not appear to be running."; echo
 exit 1
fi

if ! `echo 'exit' | /usr/bin/mysql -s $USEROPTIONS` ; then
 echo "HALTED: Supplied mysql username or password appears to be incorrect (not copied here for security, see script)"; echo
 exit 1
fi

# Now run the command to produce the backup; capture it's output.

echo "Check completed OK; running $INNOBACKUPEX command."

$INNOBACKUPEXFULL $USEROPTIONS --defaults-file=/etc/mysql/my.cnf $BACKUPDIR > $TMPFILE 2>&1

if [ -z "`tail -1 $TMPFILE | grep 'completed OK!'`" ] ; then
 echo "$INNOBACKUPEX failed:"; echo
 echo "---------- ERROR OUTPUT from $INNOBACKUPEX ----------"
 cat $TMPFILE
 rm -f $TMPFILE
 exit 1
fi

THISBACKUP=`awk -- "/Backup created in directory/ { split( \\\$0, p, \"'\" ) ; print p[2] }" $TMPFILE`
rm -f $TMPFILE

echo "Databases backed up successfully to: $THISBACKUP"
echo
echo "Now applying logs to the backuped databases"

# Run the command to apply the logfiles to the backup directory.
$INNOBACKUPEXFULL --apply-log --defaults-file=/etc/mysql/my.cnf $THISBACKUP > $TMPFILE 2>&1

if [ -z "`tail -1 $TMPFILE | grep 'completed OK!'`" ] ; then
 echo "$INNOBACKUPEX --apply-log failed:"; echo
 echo "---------- ERROR OUTPUT from $INNOBACKUPEX --apply-log ----------"
 cat $TMPFILE
 rm -f $TMPFILE
 exit 1
fi

echo "Logs applied to backuped databases"
echo

#Compress backup
echo "Compressing backup files"
tar -zcf $THISBACKUP.tar.gz -C / $(echo $THISBACKUP | cut -c 2-)
chown $BACKUPUSER:$BACKUPUSER $THISBACKUP.tar.gz
rm -r $THISBACKUP

# Cleanup

echo "Cleaning up old backups (older than $AGE days) and temporary files"
rm -f $TMPFILE
cd /tmp ; find $BACKUPDIR -maxdepth 1 -ctime +$AGE -exec echo "removing: "{} \; -exec rm -rf {} \;

echo
echo "completed: `date`"
exit 0