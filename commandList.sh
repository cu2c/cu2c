sed -i 's/cudaFree/free/g' $file
sed -Ei 's:(__global__)([^\(])\((.*):// Global CUDA function\n\1\3:g' $file
sed -i 's:[iI][dD][xX]:cu2c_idx:g' $file
sed -i 's:int cu2c\_idx[ ]*=[^;]*;:/*IDX definition removed*/:g' $file
sed -i 's:long cu2c\_idx[ ]*=[^;]*;:/*IDX definition removed*/:g' $file
sed -Ei "s:(cudaMemcpy\()([^,]*),([^,]*),([^;]*)(.*):\2 =\3\5:" $file
source cu2cAlloc.sh
sed -Ei 's:([^<]*)(<<)([^,]*)(,[ ]*.+)([^>])*(>>[ ]*)([^(]*\()(.*):\1for (long cu2c_idx = 0; cu2c_idx<\3*\5; ++cu2c_idx){\n\1    \7cu2c_idx, \8\n\1}:g' $file
sed -Ei 's:([^_]*)(__global__ )([^(]*\()(.*):// Global CUDA function\n\1\3long cu2c_idx, \4:g' $file
sed -Ei 's:(__device__)\s:// Device CUDA function\n:g' $file
