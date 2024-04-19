#!/bin/bash 
missing_option=false
while getopts "s:d:c" meher ; do 
	case $meher in 
		s) source_dir=$OPTARG ;;
		d) dest_dir=$OPTARG ;;
		c) compress=true ;;
		*) echo " Essayez de nouveau " 
		   exit 1 ;;
	esac 
done
shift $[ $OPTIND -1 ]
if [ -z "$source_dir" ] || [ -z "$dest_dir" ]; then
    missing_option=true
    echo "Quelque chose manque, assurez-vous que -s et -d sont disponibles "
    exit 1
fi

if [ "$missing_option" = true ] && [ "$compress" = true ]; then
    echo " L'option -c ne peut pas être utilisée sans les options -s et -d  "
    exit 1
fi

basename="$(basename $source_dir)-$(date +%Y-%m-%d-%H)"

simple_function() {
echo " perform backup $source_dir to $dest_dir .............." 
if  [ "$compress" = true ] ; then 
	echo "compress enabled"
	tar -czvf "$dest_dir/$basename.tar.gz" $source_dir &>/dev/null
	echo "backup terminée ..."
else
	echo "compress disabled"
	tar -cvf "$dest_dir/$basename.tar" $source_dir  &>/dev/null
	echo "backup terminée ..."
fi
}
simple_function
