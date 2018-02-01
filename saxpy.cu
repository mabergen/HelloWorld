#include <stdio.h>

//KERNEL CODE
//Executed by multiple threads in parallell
__global__
void saxpy(int n, float a, float *x, float *y){
	int i = blockIdx.x*blockDim.x + threadIdx.x;
	if (i < n) y[i] = a*x[i] + y[i];
}


int main(void){
	int N = 1<<20;
	float *x, *y, *d_x, *d_y;
	//the variables x and y points to the host arrays
	x = (float*)malloc(N*sizeof(float));
	y = (float*)malloc(N*sizeof(float));

	cudaMalloc(&d_x, N*sizeof(float)); 
	cudaMalloc(&d_y, N*sizeof(float));

	//The host code then initializes the host arrays
	for(int i=0; i<N; i++){
		x[i] = 1.0f	//Sets x to an array of 1s
		y[i] = 2.0f	//Sets y to an array of 2s
	}

	//Copy the data from x and y to the corresponding device arrays d_x and d_y
	cudaMemcpy(d_x, x, N*sizeof(float), cudaMemcpyHostToDevice);
	cudaMemcpy(d_y, y, N*sizeof(float), cudaMemcpyHostToDevice);

        // Launch the kernel
        // Perform SAXPY on 1M elements
        saxpy<<<(N+255)/256, 256>>>(N, 2.0f, d_x, d_y);

	//Copy result back to host
	cudaMemcpy(y, d_y, N*sizeof(float), cudaMemcpyDeviceToHost);

	float maxError = 0.0f;
	for (int i = 0; i < N; i++)
    		maxError = max(maxError, abs(y[i]-4.0f));
  	printf("Max error: %f\n", maxError);

	//Cleaning up
	cudaFree(d_x);
  	cudaFree(d_y);
  	free(x);
  	free(y);
}
