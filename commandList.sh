sed -i 's/cudaFree/free/g' $1
sed -i 's:__global__\s:// Global CUDA function\n:g' $1
#sed 's' $1
echo "-------------"
sed '' $1

