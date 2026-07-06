// Minimal CUTLASS GEMM driver for NVBit trace collection at arbitrary m/n/k.
//
// Rationale: Huerta's cutlass_perf_test was old-CUTLASS's *lean* perf test (tools/test/perf/),
// which traces fine. The modern heavy cutlass_profiler (tools/profiler/) hangs under NVBit (it
// only ever emits the NVBit banner, no dynamic_trace.pb). This driver launches exactly ONE GEMM
// kernel per run and exits cleanly, so it traces like deepbench/tango. Modern CUTLASS 4.1.0 kernels
// (fidelity: not per-kernel identical SASS to Huerta's old CUTLASS, but same sgemm_nn/wmma_gemm_nn
// class at the same m/n/k).
//
// Usage:  cutlass_gemm_nn <m> <n> <k> [mode]     mode 0 = sgemm_nn (SIMT fp32, default)
//                                                mode 1 = wmma_gemm_nn (Turing tensor-op fp16)
#include <cstdio>
#include <cstdlib>
#include <cuda_runtime.h>
#include <cutlass/cutlass.h>
#include <cutlass/gemm/device/gemm.h>
#include <cutlass/numeric_types.h>
#include <cutlass/arch/arch.h>
#include <cutlass/arch/mma.h>

template <typename Gemm, typename Element>
static int run(int M, int N, int K, const char *tag) {
  Element *A = nullptr, *B = nullptr, *C = nullptr;
  cudaMalloc(&A, sizeof(Element) * (size_t)M * K);
  cudaMalloc(&B, sizeof(Element) * (size_t)K * N);
  cudaMalloc(&C, sizeof(Element) * (size_t)M * N);
  cudaMemset(A, 0, sizeof(Element) * (size_t)M * K);
  cudaMemset(B, 0, sizeof(Element) * (size_t)K * N);
  cudaMemset(C, 0, sizeof(Element) * (size_t)M * N);

  // Column-major NN: A is MxK (lda=M), B is KxN (ldb=K), C is MxN (ldc=M).
  Gemm op;
  typename Gemm::Arguments args({M, N, K}, {A, M}, {B, K}, {C, M}, {C, M},
                               {typename Gemm::ElementC(1), typename Gemm::ElementC(0)});
  cutlass::Status st = op(args);
  cudaDeviceSynchronize();
  cudaError_t err = cudaGetLastError();
  printf("%s %dx%dx%d cutlass_status=%d cuda=%s\n", tag, M, N, K, (int)st, cudaGetErrorString(err));
  fflush(stdout);
  cudaFree(A); cudaFree(B); cudaFree(C);
  // Explicitly tear down the CUDA context so the NVBit tracer finalizes the trace and the process
  // exits cleanly. Without this, CUTLASS/runtime static teardown hangs under instrumentation.
  cudaDeviceReset();
  return st == cutlass::Status::kSuccess ? 0 : 2;
}

int main(int argc, char **argv) {
  int M = argc > 1 ? atoi(argv[1]) : 2560;
  int N = argc > 2 ? atoi(argv[2]) : 16;
  int K = argc > 3 ? atoi(argv[3]) : 2560;
  int mode = argc > 4 ? atoi(argv[4]) : 0;

  if (mode == 0) {
    using SgemmNN = cutlass::gemm::device::Gemm<
        float, cutlass::layout::ColumnMajor,
        float, cutlass::layout::ColumnMajor,
        float, cutlass::layout::ColumnMajor>;
    return run<SgemmNN, float>(M, N, K, "sgemm_nn");
  } else {
    using WmmaGemmNN = cutlass::gemm::device::Gemm<
        cutlass::half_t, cutlass::layout::ColumnMajor,
        cutlass::half_t, cutlass::layout::ColumnMajor,
        cutlass::half_t, cutlass::layout::ColumnMajor,
        float,
        cutlass::arch::OpClassTensorOp,
        cutlass::arch::Sm75,
        cutlass::gemm::GemmShape<128, 256, 32>,
        cutlass::gemm::GemmShape<64, 64, 32>,
        cutlass::gemm::GemmShape<16, 8, 8>>;
    return run<WmmaGemmNN, cutlass::half_t>(M, N, K, "wmma_gemm_nn");
  }
}
