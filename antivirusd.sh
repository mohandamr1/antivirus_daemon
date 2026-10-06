#!/bin/bash
#

if [ $# -lt 3 ]
then
 echo "needs 3 arguments, directory malDir and timeBetweenScans"
 exit 1
else
  dir=$1
  malDir=$2
  timeBetweenScans=$3
fi

scan(){
virusExtensions=$(find $dir \( -name "*.exe" -o -name "*.bat" -o -name "*.vbs" -o -name "*.scr" -o -name "*.ps1" \))
virusWord=$(grep -ril -e "virus" -e "trojan" -e  "malware" -e "worm" -e "ransomware" $dir)
all=$(printf '%s\n%s\n' "$virusExtensions" "$virusWord" | sort -u)

if [ -n "$all" ]
then
 for file in $all
   do
    echo "<$file> is malicious and it is DELETED"
   done
 mv $all $malDir
fi
}



last=$(find . -name "directory-info.last")
new=$(find . -name "directory-info.new")

if [ "$last"  == "" ]
then
 touch directory-info.last
 last="directory-info.last"
fi

if [ "$new"  == "" ]
then
 touch directory-info.new
 new="directory-info.new"
fi

last="directory-info.last"
new="directory-info.new"

scan
ls -l $dir > $last

while true
do
 sleep $timeBetweenScans
 ls -l $dir > $new
 if cmp -s "$last" "$new"
 then
  echo "No changes found, directory clean"
 else
  echo "Changes found, scanning"
  scan
  ls -l $dir > $last
fi
done
