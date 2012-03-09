#
# Regular cron jobs for the cloudweb package
#
0 4	* * *	root	[ -x /usr/bin/cloudweb_maintenance ] && /usr/bin/cloudweb_maintenance
