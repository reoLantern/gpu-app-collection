BASE_DIR := $(shell pwd)
BIN_DIR := $(BASE_DIR)/bin
ALL_SUB_DIRS    = $(wildcard ubench/*/*/)
GMMA_DIRS       = $(filter %gmma/,$(ALL_SUB_DIRS))
# tma/ 探针硬编码 Blackwell(compute_101),非 Blackwell 卡 nvcc fatal → 从默认 all 剔除(同 gmma 处理),
# 只在 Blackwell 上用 `make tma` 单独编。令 GPU_Microbenchmark 在 2070S/3060Ti/A100/H100 默认 build 干净。
TMA_DIRS        = $(filter ubench/tma/%,$(ALL_SUB_DIRS))
SUB_DIRS        = $(filter-out $(GMMA_DIRS) $(TMA_DIRS),$(ALL_SUB_DIRS))
SUB_DIRS_ALL    = $(SUB_DIRS:%=all-%)
SUB_DIRS_CLEAN  = $(SUB_DIRS:%=clean-%)
GMMA_DIRS_ALL   = $(GMMA_DIRS:%=all-%)
GMMA_DIRS_CLEAN = $(GMMA_DIRS:%=clean-%)
TMA_DIRS_ALL    = $(TMA_DIRS:%=all-%)
TMA_DIRS_CLEAN  = $(TMA_DIRS:%=clean-%)


all: create_dir $(SUB_DIRS_ALL)
gmma: create_dir $(GMMA_DIRS_ALL)
tma: create_dir $(TMA_DIRS_ALL)
clean: delete_dir $(SUB_DIRS_CLEAN)
clean_gmma: $(GMMA_DIRS_CLEAN)
clean_tma: $(TMA_DIRS_CLEAN)

$(SUB_DIRS_ALL) $(GMMA_DIRS_ALL) $(TMA_DIRS_ALL):
	$(MAKE) $(MAKE_FLAGS) -C $(@:all-%=%)

$(SUB_DIRS_CLEAN) $(GMMA_DIRS_CLEAN) $(TMA_DIRS_CLEAN):
	$(MAKE) $(MAKE_FLAGS) -C $(@:clean-%=%) clean

create_dir:
	mkdir -p $(BIN_DIR)

delete_dir:
	cd $(BIN_DIR); rm -f *
