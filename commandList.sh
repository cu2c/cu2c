# Modify cuda index
sed -i 's:int [iI][dD][xX][ ]*=[ ]*[^;0-9]*;:/* CUDA index definition removed */:g' $file
sed -i 's:long [iI][dD][xX][ ]*=[ ]*[^;0-9]*;:/* CUDA index definition removed */:g' $file
sed -i 's:[iI][dD][xX]:cu2c_idx:g' $file

# Modify memory management
#sed -Ei "s:(cudaMemcpy\()([^,]*),([^,]*),([^;]*)(.*):\2 =\3\5:" $file
sed -Ei "s:(cudaMemcpy[ ]*)([^,]*,[^,]*,[^,]*)(,[^)]*)([^;]*):memcpy\2\4:" $file
source cu2cAlloc.sh
sed -i 's/cudaFree/free/g' $file

# Modify global cuda calls
sed -Ei 's:([ ]*)([a-zA-Z0-9_]*[ ]*)(<<<[ ]*)([a-zA-Z0-9_\.]*)[ ]*,[ ]*([a-zA-Z0-9_\.]*)([ ]*>>>[ ]*)(\()(.*;)(.*):\n\1for(long cu2c_idx = 0; cu2c_idx < \4*\5 ; ++cu2c_idx){\n\1    \2(cu2c_idx, \8\n\1}\9\n:g' $file

# Remove cuda declspecs
sed -Ei 's:(__device__[ ]*__host__)\s:// Combined device&host CUDA function\n:g' $file
sed -Ei 's:(__host__[ ]*__device__)\s:// Combined device&host CUDA function\n:g' $file
sed -Ei 's:(__device__)\s:// Device CUDA function\n:g' $file
sed -Ei 's:(__host__)\s:// Host CUDA function\n:g' $file
sed -Ei 's:([^_]*)(__global__ )([^(]*\()(.*):// Global CUDA function\n\1\3long cu2c_idx, \4:g' $file

# Modify random number operations
sed -i 's:curandState[^;]*;::g' $file
sed -i 's:curand_init[^;]*:srand(time(NULL)):g' $file
sed -i 's:curand_uniform_double([^)]*):(double)rand() / (double)RAND_MAX:g' $file
sed -i 's:curand_uniform([^)]*):(float)rand() / (float)RAND_MAX:g' $file

# Change include path
sed -i 's:#include <cuda.*://\0:g' $file
sed -i 's:#include <curand.*://\0:g' $file
sed -Ei "s:(\#include[^.]*)(\.cuh):\1$CU2C_CUH:g" $file
sed -Ei "s:(\#include[^.]*)(\.cu):\1$CU2C_CU:g" $file

# Remove cuda getters and setters
sed -i "s:cudaGetLastError():true:g" $file
sed -Ei 's:(.*)(cudaGetError[^\)]*)\)(.*):\1"CU2C\: Failed error management"\3 :g' $file
sed -Ei "s:(.*)(cudaGet[^;]*);(.*):\1\3 :g" $file
sed -Ei "s:(.*)(cudaSet[^;]*);(.*):\1\3 :g" $file

# Remove cuda profile
sed -Ei "s:cudaEvent[^;]*;::g" $file
sed -Ei "s:cudaProfiler[^;]*;::g" $file

# Remove cuda exception handling
sed -i "s:cudaSuccess:true:g" $file
sed -i "s:cudaError_t:int:g" $file

# Remove thread sync
sed -Ei "s:cudaThreadSynchronize\(\);:/*CUDA Thread synch removed*/:g" $file

# Remove cuda device properties
cdpline=$(grep "cudaDeviceProp" $file)
cuda_dev_prop=$(sed -E "s:(cudaDeviceProp[ ]*)(.*);:    \2:g"<<< $cdpline)
if [ ! -z "$cuda_dev_prop" ]; then
echo $cuda_dev_prop
    cuda_dev_prop=$(echo $cuda_dev_prop | sed 's/\.//g')
    sed -i -e ':a' -e 'N' -e '$!ba' -e "s:\n:§newline§:g" $file
    sed -Ei "s:(for[^;}]*;)([^;]*$cuda_dev_prop[^;]*):\1 false:g" $file
    sed -Ei "s:(if[ ]*\()([^\)]*$cuda_dev_prop[^\)]*):\1 false:g" $file
    sed -Ei "s:([^;{}]*)($cuda_dev_prop)([^;]*[;])::g" $file
    sed -i "s:\§newline§:\n:g" $file
fi
#sed -Ei "s:cudaDeviceProp[^;]*;::g" $file
