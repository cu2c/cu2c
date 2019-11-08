#define PI 3.141592653589792346
#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>


// Global CUDA function
void runDev(double *dArr){
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    dArr[idx] = (double)idx+PI;
}

//Lorem ipsum dolor sit amet
void main(){
    double *hArr, *dArr;
    size_t dimD = 5 * sizeof(double);
    cudaMalloc((void **) &dArr,  dimD);
    cudaMemcpy(dArr, hArr, dimD, cudaMemcpyHostToDevice);
    <<20,30>> runDev(dArr);
    cudaMemcpy(hArr, dArr, dimD, cudaMemcpyDeviceToHost);
    free(dArr);
}
