TOPLEVEL := .
# pta (andersen.cu) uses thrust::unary_function-derived functors whose return types
# CUDA 13's thrust can no longer deduce; sp/nsp is not in accel-sim's app list. Both excluded.
APPS := bfs bh dmr mst sssp
INPUT_URL := http://iss.ices.utexas.edu/projects/galois/downloads/lonestargpu2-inputs.tar.bz2
INPUT := lonestargpu2-inputs.tar.bz2

.PHONY: all clean inputs

all: $(APPS)

$(APPS):
	$(SETENV) make $(MAKE_ARGS) -C apps/$@
	$(SETENV) make $(MAKE_ARGS) -C apps/$@ variants

include apps/common.mk

inputs:
	@echo "Downloading inputs ..."
	@wget $(INPUT_URL) -O $(INPUT)
	@echo "Uncompressing inputs ..."
	@tar xvf $(INPUT)
	@rm $(INPUT)
	@echo "Inputs available at $(TOPLEVEL)/inputs/"

clean:
	for APP in $(APPS); do make -C apps/$$APP clean; done

