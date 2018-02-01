#include <stdio.h>

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

//Copy result back to host
cudaMemcpy(y, d_y, N*sizeof(float), cudaMemcpyDeviceToHost);
