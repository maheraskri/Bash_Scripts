#!/bin/bash 
#Author: Meher 
#Description : this a simple script to create users && groups 

declare -A my_list

my_list["julie"]="south"
my_list["lisa"]="north"
my_list["mike"]="west"
my_list["bill"]="east"

for i in "${!my_list[@]}"; do
        groupname=${my_list[$i]}
	groupadd $groupname
	useradd -g $groupname $i
	echo "test" | passwd --stdin $i
done


