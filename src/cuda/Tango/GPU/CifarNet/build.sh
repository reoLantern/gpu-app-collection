#!/bin/bash
nvcc -gencode=arch=compute_75,code=sm_75 -std=c++17 CN_cuda.cu -o $BINDIR/$BINSUBDIR/Tango-CN
