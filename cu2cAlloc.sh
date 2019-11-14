#!/bin/bash
varNameList=()
varTypeList=()

while read -r line; do
#    echo "->$line"
    oneline=$(echo "$line" | sed -E "s:(size_t )([^;]*);(.*):\2:")
    IFS=','; read -a linearray <<< "$oneline"; unset IFS;
    for s in "${linearray[@]}"; do
#        echo ">> [$s]"
        s=$(echo "$s" | tr -d " \t")
#        echo "   [$s]"
        varname=$(echo "$s" | sed -E "s:([^=].+)=.+(.*):\1:")
        vartype=$(echo "$s" | sed -E "s:([^=].+)=([^(]*).+\(([^)]*).+(.*):\3:")
        if [ $varname = $vartype ]; then
            echo "$varname: !ERROR!"
        else
#            echo "$varname=$vartype"
            varNameList+=("$varname")
            varTypeList+=("$vartype")
        fi
    done
done < <(grep "size_t" $1 )
for (( i=0; i<"${#varNameList[@]}"; i++ )); do 
    varName=${varNameList[$i]}
    varType=${varTypeList[$i]}
    echo -e "$i\t$varName\t$varType"

#varName="dArr"
#varType="double"
#echo "    cudaMalloc((void **) &dArr,dimD);" |
sed -Ei "s:(.*)(cudaMalloc[ ]*\([ ]*\(*void[ ]*\*\*\)[ ]*\&)([^,]*)(,[ ]*)($varName)(.*):\1\3 = \($varType \*\) malloc\($varName\6:" $1

#sed -E "s:(.*)(cudaMalloc[ ]*\([ ]*\(*void[ ]*\*\*\)[ ]*\&)($varName)(,[ ]*)(.*):|\1|\2|\3|\4|\5|:"

#sed -E "s:(.*)(cudaMalloc)([ ]*)\)([ ]*)((\(*void \*\*\) \&)($sedcmd)(,[ ]*)(.*):\1|\2|\3|\4|\5|\6|\7|\8:"

#sed -E "s:(.*)(cudaMalloc\(\(*void \*\*\) \&)($sedcmd)(,[ ]*)(.*):|1\1|2\2|3\3|4\4|5\5:"



#cudaMalloc((void **) &dArr,  dimD);
#dArr = (double *) malloc(dimD);
done
