#!/bin/bash
#

dir=/home/ubuntu/antivirus_daemon/dir/
malDir=/home/ubuntu/antivirus_daemon/malicious_dir/

scan(){
virusExtensions=$(find $dir \( -name "*.exe" -o -name "*.bat" -o -name "*.vbs" -o -name "*.scr" -o -name "*.ps1" \))
virusWord=$(grep -ril -e "virus" -e "trojan" -e  "malware" -e "worm" -e "ransomware" $dir)
all=$(printf '%s\n%s\n' "$virusExtensions" "$virusWord" | sort -u)

if [ -n "$all" ]
then
 for file in $all
   do
    if grep -q $file whitelist.txt; then
      continue
    fi
    echo "<$file> is malicious and it is DELETED BY CRONJOB"
    mv $file $malDir
   done
fi
}


last=$(find . -name "directory-info.last")
new=$(find . -name "directory-info.new")

if [ "$last"  == "" ]
then
 touch directory-info.last
 scan
 ls -l $dir > directory-info.last
 exit 1
fi

if [ "$new"  == "" ]
then
 touch directory-info.new
 new="directory-info.new"
fi

ls -l $dir > directory-info.new

if ! cmp -s directory-info.new directory-info.last
then
 scan
 ls -l $dir > directory-info.last
fi
