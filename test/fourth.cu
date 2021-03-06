#define PI 3.141592653589792346
#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>

__global__ void runDev(double *dArr){
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    dArr[idx] = (double)idx+PI;
}

__device__ void deviceFunction(double *a, int b, double **c){
}

//Lorem ipsum dolor sit amet
void main(){
    double *hArr, *dArr, **testD, ********snake;
    int **testI;
    size_t dimD = 5 * sizeof(double);
    size_t dimE, dimC=sizeof(int)*8;
    cudaMalloc((void **) &dArr,  dimD);
    cudaMemcpy(dArr, hArr, dimD, cudaMemcpyHostToDevice); // HOST2DEV
    runDev<<<20,30>>>(dArr);
    cudaMemcpy(hArr, dArr, dimD, cudaMemcpyDeviceToHost);
    free(dArr);
}
