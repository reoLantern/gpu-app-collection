#!/bin/bash
nvcc -gencode=arch=compute_75,code=sm_75 -std=c++17 alexnet_host.cu -o $BINDIR/$BINSUBDIR/Tango-AN
