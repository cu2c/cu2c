#!/bin/bash
while IFS='' read -r line || [[ -n "$line" ]]; do
    first=$(echo $line | awk '{print $1;}')

    if [[ $first = "double" || $first = "int" || $first = "char" ]]; then

        echo -e "-----" #"$first     \t>>> $line"
	lastchar=","
	i=2;
        while [[ $lastchar == "," ]]; do
            next=$(echo $line | awk '{print $'$i';}')
            firstchar=$(echo "${next:0:1}")
            lastchar=$(echo "${next: -1}")
            varname=""

            while [[ $firstchar == "*" ]]; do
                varname=$varname"p_"
                next=$(echo "${next: 1}")
                firstchar=$(echo "${next:0:1}")
            done

            if [[ $lastchar = "," || $lastchar == ";" ]]; then
                next=$(echo "${next:0:-1}")
            fi
            varname=$varname$next

            echo -e "$varname: $first"
            i=`expr $i + 1`
        done
    fi
done < "$1"
