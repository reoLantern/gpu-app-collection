#ifndef AMPERE_GA104_DEF_H
#define AMPERE_GA104_DEF_H

// GA104(RTX 3060 Ti / RTX 3070,sm_86)新格式 hw_def。
// 时钟(核心/显存)与 SM 数由 ./common/gpuConfig.h 的 initializeDeviceProp 运行时读取
// (用 cudaDeviceGetAttribute(cudaDevAttrClockRate / cudaDevAttrMemoryClockRate),兼容 CUDA 13.3,
// 不用被 CUDA 13 移除的 cudaDeviceProp::clockRate/memoryClockRate),因此本文件【不】 #define CLK_FREQUENCY。
// 旧的 ampere_RTX3070_hw_def.h / ampere_A100_hw_def.h 是旧格式(active #define CLK_FREQUENCY),
// 会和代码里的 config.CLK_FREQUENCY 冲突成 `config.<数字>`(expected a member name),勿用。

#include "./common/common.h"
#include "./common/deviceQuery.h"

#define L1_SIZE (128 * 1024) // GA10x 消费级 L1/shared 合一,最大 L1 128KB(3060Ti/3070 同)

// #define CLK_FREQUENCY 1665 // 运行时从 config 取,勿启用(启用会与 config.CLK_FREQUENCY 冲突)

#define ISSUE_MODEL issue_model::single // single issue core or dual issue
#define CORE_MODEL core_model::subcore  // subcore model or shared model
#define DRAM_MODEL dram_model::GDDR6    // memory type(GA104 = GDDR6 256-bit)
#define WARP_SCHEDS_PER_SM 4            // number of warp schedulers per SM


#define SASS_hmma_per_PTX_wmma 2


#define L2_BANKS_PER_MEM_CHANNEL 2
#define L2_BANK_WIDTH_in_BYTE 32

#endif
