#!/bin/bash

varNameList=()
varTypeList=()

while read -r line; do
    oneline=$(echo "$line" | sed -E "s:(size_t )([^;]*);:\2:")
    IFS=','; read -a linearray <<< "$oneline"; unset IFS;
    for s in "${linearray[@]}"; do
        s=$(echo "$s" | tr -d " \t")
        varname=$(echo "$s" | sed -E "s:([^=].+)=.+(.*):\1:")
        vartype=$(echo "$s" | sed -E "s:([^=].+)=([^(]*).+\(([^)]*).+(.*):\3:")
        if [ $varname = $vartype ]; then
            : #echo "$varname: !ERROR!"
        elif [ -z $vartype ]; then
            :
        elif [ -z $varname ]; then
            :
        else
            varNameList+=("$varname")
            varTypeList+=("$vartype")
        fi
    done
done < <(grep "size_t" $file )

for (( i=0; i<"${#varNameList[@]}"; i++ )); do
    varName=${varNameList[$i]}
    varType=${varTypeList[$i]}
    sed -Ei "s:(.*)(cudaMalloc[ ]*\([ ]*\(*void[ ]*\*\*\)[ ]*\&)([^,]*)(,[ ]*)($varName)([ ]*\).*):\1\3 = \($varType \*\) malloc\($varName\6:" $file
done
