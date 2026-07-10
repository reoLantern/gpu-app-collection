#!/bin/bash
nvcc ${GENCODE_ARCH:--gencode=arch=compute_75,code=sm_75} -std=c++17 gru_host.cu -o $BINDIR/$BINSUBDIR/Tango-GRU
