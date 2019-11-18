#/usr/bash

src=$1
dest=$2

source settings

if [ -z "$src" ]; then
    echo -e "ERROR: There is no input source. Please use the command as:\n\t./convert.sh input_source output"
else
    if [ -z "$dest" ]; then
        dest=$src"_cu2c"
        echo -e "The output folder set up to $dest."
    fi

    if [ -d $dest ]; then
       read -r -p "The $dest folder exists. Would you like to overwrite? " response
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

    rsync -av --exclude=".*" $src/* $dest
    echo -e "Files copied from $src to $dest."
    fileList=($(find $dest -type f ! -name ".*"))

    for file in ${fileList[@]}; do

        echo -e "\n->" $file
        if [ "${file##*.}" == "cu" ]; then
            fileold=$file
            file="${fileold%.*}.c"
            mv $fileold $file
            echo -e "=>" $file
        fi

        if [ "${file##*.}" == "cuh" ]; then
            fileold=$file
            file="${fileold%.*}.h"
            mv $fileold $file
            echo -e "=>" $file
        fi

        source commandList.sh
    done

#  echo -e "\n->" $dest/Makefile

    sed -i "s/$CU2C_NVCC/$CU2C_CC/g" $dest/Makefile
    sed -i "s/\.cuh/$CU2C_CUH/g" $dest/Makefile
    sed -i "s/\.cu/$CU2C_CU/g" $dest/Makefile

    cudaFlags=(" --ptxas-options" " -Xptxas" " -maxrregcount" " -arch" " -dlcm" " -lcurand")
    for s in "${cudaFlags[@]}"; do
        sed -i  "s/$s[ ]*=[ ]*[^ ]*//g" $dest/Makefile
        sed -i "s/$s//g" $dest/Makefile
    done
fi
