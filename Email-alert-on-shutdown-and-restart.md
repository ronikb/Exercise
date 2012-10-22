## Email alert on Ubuntu server while shutdown and Restart

	sudo apt-get install mutt

Create the following script in /etc/init.d

	#!/bin/sh
	# Description: Sends an email at system start and shutdown
	 
	#############################################
	#                                           #
	# Send an email on system start/stop to     #
	# a user.                                   #
	#                                           #
	#############################################
	 
	EMAIL="system-startup-shutdown-notification@xyz.org"
	RESTARTSUBJECT="["`hostname`"] - System Startup"
	SHUTDOWNSUBJECT="["`hostname`"] - System Shutdown"
	RESTARTBODY="This is an automated message to notify you that "`hostname`" started successfully.
	 
	Start up Date and Time: "`date`
	SHUTDOWNBODY="This is an automated message to notify you that "`hostname`" is shutting down.
	Shutdown Date and Time: "`date`
	LOCKFILE=/var/lock/SystemEmail
	RETVAL=0
 
	# Source function library.
	#. /etc/init.d/functions
	. /lib/lsb/init-functions
	 
	stop()
	{
	echo -n $"Sending Shutdown Email: "
	echo "${SHUTDOWNBODY}" | mutt -s "${SHUTDOWNSUBJECT}" ${EMAIL}
	RETVAL=$?
	 
	if [ ${RETVAL} -eq 0 ]; then
	rm -f ${LOCKFILE}
	success
	else
	failure
	fi
	echo
	return ${RETVAL}
	}
	 
	start()
	{
	echo -n $"Sending Startup Email: "
	echo "${RESTARTBODY}" | mutt -s "${RESTARTSUBJECT}" ${EMAIL}
	RETVAL=$?
	 
	if [ ${RETVAL} -eq 0 ]; then
	touch ${LOCKFILE}
	success
	else
	failure
	fi
	echo
	return ${RETVAL}
	}
	 
	case $1 in
	stop)
	stop
	;;
	 
	start)
	start
	;;
	 
	*)
	 
	esac
	exit ${RETVAL}

Put appropriate permission in this script

	sudo chown root:root system-startup-shutdown-notification.sh

Enable this script for different run level

	sudo update-rc.d system-startup-shutdown-notification.sh start 98 2 3 4 5 . stop 02 0 1 6 .

