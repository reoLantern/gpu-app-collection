#ifndef HW_DEF_H
#define HW_DEF_H

//#include "kepler_TITAN_hw_def.h"

//#include "pascal_TITANX_hw_def.h"

//#include "volta_QV100_hw_def.h"

//#include "turing_RTX2060_hw_def.h"

// #include "volta_TITANV_hw_def.h"

// #include "ampere_A100_hw_def.h"
// #include "blackwell_B200_hw_def.h"

// per-card 构建设置(非共享改进):换卡改这一行。3060Ti=GA104 用新格式 ampere_GA104 def
//(旧 ampere_RTX3070/A100 def 是旧格式 active #define CLK_FREQUENCY,会与 config.CLK_FREQUENCY 冲突→勿用)。
// 时钟/SM 数由 gpuConfig.h 运行时读(cudaDeviceGetAttribute,兼容 CUDA 13.3),自动适配本卡。
// TODO: 将来按 compute_cap 自动选(仿 GENCODE A2)。
#include "ampere_GA104_hw_def.h"

#endif
