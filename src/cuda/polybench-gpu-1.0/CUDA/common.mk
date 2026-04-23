# Compiler flags — rewritten for modern-modeling-v2 to skip obsolete
# architectures nvcc 13+ no longer supports (compute_10/13/20/30/35/50/60/62/70).
# Defaults now only cover sm_75+ targets; override via env or cmdline if needed.
GENCODE_SM75 ?= -gencode=arch=compute_75,code=\"sm_75,compute_75\"
GENCODE_SM80 ?= -gencode=arch=compute_80,code=\"sm_80,compute_80\"
GENCODE_SM86 ?= -gencode=arch=compute_86,code=\"sm_86,compute_86\"

all:
	nvcc -O3 ${GENCODE_SM75} ${GENCODE_SM80} ${GENCODE_SM86} ${NVCC_ADDITIONAL_ARGS} ${CUFILES} -o ${EXECUTABLE}
clean:
	rm -f *~ *.exe
