#!/bin/sh
#


if [ $# -lt 3 ]
then
 echo "needs 3 arguments, directory malDir and timeBetweenScans"
 exit 1
else
  dir = $1
  malDir = $2
  timeBetweenScans = $3
fi

if [ ! -f "$~/directory-info.last" ]
then
    touch ~/directory-info.last
else
 
fi
