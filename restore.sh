#!/bin/bash
#s


if [ $# -lt 2 ]
then
 echo "please provide dir, malicious_dir as attributes"
 exit 1
fi

malicious_dir=$2
dir=$1

count=$(ls $malicious_dir | wc -l)
if [ $count -eq 0 ]
then
echo "No malicious files to review."
exit 1
fi


option=0
while true
do

files=$(ls $malicious_dir)

index=1
for file in $files
do
echo "$index. $file"
index=$((index + 1))
done
read -rp "Please select which file to interact with from above (1 to $count): " fileNumber
fileName=$(ls $malicious_dir | head -n $fileNumber  | tail -n 1)

echo "<$fileName>"
read -rp $'Please choose one of the following options:\n1. Restore\n2. Delete:\n3. Leave\n ' option
if [ $option -eq 1 ]
then
echo "$dir$fileName" >> whitelist.txt
mv "$malicious_dir$fileName" $dir
echo "Restored <$fileName> to <$dir>".
break
elif [ $option -eq 2 ]
then
rm  "$malicious_dir$fileName"
echo "<$fileName> permanently deleted."
break
elif [ $option -eq 3 ]
then
echo "Leaving.."
else
break
fi
done
