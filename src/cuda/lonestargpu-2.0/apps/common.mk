BIN    		:= $(TOPLEVEL)/bin
INPUTS 		:= $(TOPLEVEL)/inputs

NVCC 		:= nvcc
GCC  		:= g++
CC := $(GCC)
#CUB_DIR := $(TOPLEVEL)/../cub

# Compiler-specific flags (by default, we always use sm_10, sm_20, and sm_30), unless we use the SMVERSION template
GENCODE_SM10 ?=
GENCODE_SM13 ?=
GENCODE_SM20 ?=
GENCODE_SM30 ?=
GENCODE_SM35 ?=
GENCODE_SM50 ?=
GENCODE_SM60 ?=
GENCODE_SM62 ?=
GENCODE_SM70 ?=
GENCODE_SM75 ?= -gencode=arch=compute_75,code=\"sm_75,compute_75\"

ifdef debug
FLAGS := $(GENCODE_SM10)  $(GENCODE_SM13) $(GENCODE_SM20) $(GENCODE_SM30) $(GENCODE_SM35) $(GENCODE_SM35)  $(GENCODE_SM50) $(GENCODE_SM60)  $(GENCODE_SM62) $(GENCODE_SM70) $(GENCODE_SM75) -g -DLSGDEBUG=1 -G
else
# including -lineinfo -G causes launches to fail because of lack of resources, pity.
FLAGS := -O3 $(GENCODE_SM10)  $(GENCODE_SM13) $(GENCODE_SM20) $(GENCODE_SM30) $(GENCODE_SM35) $(GENCODE_SM35)  $(GENCODE_SM50) $(GENCODE_SM60)  $(GENCODE_SM62) $(GENCODE_SM70) $(GENCODE_SM75) -g -Xptxas -v  #-lineinfo -G
endif
INCLUDES := -I $(TOPLEVEL)/include -I $(NVIDIA_COMPUTE_SDK_LOCATION)/common/inc
LINKS := 

EXTRA := $(FLAGS) $(NVCC_ADDITIONAL_ARGS) $(INCLUDES) $(LINKS)

.PHONY: clean variants support optional-variants

ifdef APP
$(APP): $(SRC) $(INC)
	$(NVCC) $(EXTRA) -DVARIANT=0 -o $@ $<
	cp $@ $(BIN)

variants: $(VARIANTS)

optional-variants: $(OPTIONAL_VARIANTS)

support: $(SUPPORT)

clean: 
	rm -f $(APP) $(BIN)/$(APP)
ifdef VARIANTS
	rm -f $(VARIANTS)
endif
ifdef OPTIONAL_VARIANTS
	rm -f $(OPTIONAL_VARIANTS)
endif

endif
