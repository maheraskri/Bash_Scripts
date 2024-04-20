while getopts "s:d:c" meher ; do
        case $meher in
                s) source_dir=$OPTARG ;;
                d) dest_dir=$OPTARG ;;
                c) compress=true ;;
                *) echo " Invalid or empty Option, Try Again " 
                        exit 1 ;;
        esac
done
shift $[ $OPTIND -1 ]

if [ -z "$source_dir" ] || [ -z "$dest_dir" ]; then
        echo " You missing something "
        if [ -n "$compress" ] ; then
        echo  " you can't use compress with nothing "
        fi
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
