#!/bin/bash
nvcc -gencode=arch=compute_75,code=sm_75 -std=c++17 lstm.cu -o $BINDIR/$BINSUBDIR/Tango-LSTM
