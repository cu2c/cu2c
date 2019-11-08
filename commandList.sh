sed -i 's/cudaFree/free/g' $1
sed -i 's:__global__\s:// Global CUDA function\n:g' $1
sed -i 's:idx:cu2c_idx:g' $1
sed -i 's: [iI][dD][xX]:cu2c_idx:g' $1
#sed -i 's:cudaMemcpy(*,*,*):\0 = \1:g' $1
echo "-------------"
sed '' $1

