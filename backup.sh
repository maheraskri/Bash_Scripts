#!/bin/bash 
while getopts "s:d:c" meher ; do 
	case $meher in 
		s) source_dir=$OPTARG ;;
		d) dest_dir=$OPTARG ;;
		c) compress=true ;;
		*) echo " wrong options" ;;
	esac
done
shift $[ $OPTIND -1 ]
basename="$(basename $source_dir)-$(date +%m-%d-%H)"

if [ -z $source_dir ] && [ -z $dest_dir ] ; then 
	echo "options correct " &>/dev/null 
	exit 1 
fi 
echo " perform backup $source_dir to $dest_dir .............." 
if  [ "$compress" = true ] ; then 
	echo "compress enabled"
	tar -czvf "$dest_dir/$basename.tar.gz" $source_dir &>/dev/null
	echo "backup complete ..."
else
	echo "compress disabled"
	tar -cvf "$dest_dir/$basename.tar" $source_dir  &>/dev/null
	echo "backup complete ..."
fi
