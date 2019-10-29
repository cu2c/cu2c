#/usr/bash

source=$1
dest=$2

if [ -z "$source" ]
then
    echo -e "ERROR: There is no input source. Please use the command as:\n\t./convert.sh input_source output"
else
    if [ -z "$dest" ]; then
        dest=$source"_cu2c"
        echo -e "The output folder set up to $dest."
    fi

    if [ -d $dest ]; then
       read -r -p "The $source folder exists. Would you like to overwrite? " response
       case "$response" in 
          [yY][eE][sS]|[yY])
              rm -rf $dest
              ;;
          *)
              echo -e "Synchronisation is suspended."
              exit 0
          ;;
      esac
    fi

    rsync -av --exclude=".*" $source $dest
    echo -e "Files copied from $source to $dest."
    fileList=($(find $source -type f ! -name ".*"))
#echo $filelist
    for file in ${fileList[@]}; do
        echo "->" $file
    done
fi
