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

sed -i 's:#include <cuda.*://\0:g' $file
sed -i 's:#include <curand.*://\0:g' $file
sed -i 's:curandState[^;]*;::g' $file
sed -i 's:curand_init[^;]*:srand(time(NULL)):g' $file
sed -i 's:curand_uniform_double[^;]*:(double)rand() / (double)RAND_MAX:g' $file
sed -i 's:curand_uniform[^;]*:(float)rand() / (float)RAND_MAX:g' $file
sed -Ei "s:(\#include[^.]*)(\.cuh):\1$CU2C_CUH:g" $file
sed -Ei "s:(\#include[^.]*)(\.cu):\1$CU2C_CU:g" $file
sed -i "s:cudaGetLastError():true:g" $file
sed -Ei 's:(.*)(cudaGetError[^\)]*)\)(.*):\1"CU2C\: Failed error management"\3 :g' $file
sed -Ei "s:(.*)(cudaGet[^;]*);(.*):\1/*\2;*/\3 :g" $file
sed -Ei "s:(.*)(cudaSet[^;]*);(.*):\1/*\2;*/\3 :g" $file
sed -Ei "s:cudaEvent[^;]*;::g" $file
sed -Ei "s:cudaProfiler[^;]*;::g" $file

sed -Ei "s:cudaThreadSynchronize\(\);:/*CUDA Thread synch removed*/:g" $file
sed -i "s:cudaSuccess:true:g" $file
sed -i "s:cudaError_t:int:g" $file
sed -Ei "s:cudaDeviceProp[^;]*;::g" $file
