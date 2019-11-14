# CU2C test Makefile
NVCC = nvcc
CFLAGS = --ptxas-options=-v  -w  -Xptxas -dlcm=cg -maxrregcount=32 -O3  -lcurand -arch=sm_20

all: test.exe

test.exe: main.cu
	$(NVCC) $(CFLAGS) -o test.exe  first.cu second.c 3/third.c fourth.cu

clean:
	rm *.exe
