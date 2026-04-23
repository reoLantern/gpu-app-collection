GENCODE_SM10 ?=
GENCODE_SM13 ?=
GENCODE_SM20 ?=
GENCODE_SM30 ?=
GENCODE_SM35 ?=
GENCODE_SM50 ?=
GENCODE_SM60 ?=
GENCODE_SM62 ?=

CPPSRC = ../graph_parser/util.cpp ../graph_parser/parse.cpp
CUSRC =
BASEEXE = color
VARIANT ?= MAX
# CUDA source files (compiled with cudacc)
ifeq ($(VARIANT),MAX)
    EXECUTABLE = $(BINDIR)/$(BINSUBDIR)/$(BASEEXE)_max
    CUSRC += coloring_max.cu
else ifeq ($(VARIANT),MAXMIN)
    EXECUTABLE = $(BINDIR)/$(BINSUBDIR)/$(BASEEXE)_maxmin
    CUSRC += coloring_maxmin.cu
endif
OPTS = -O3
CUOPTS = $(GENCODE_ARCH) $(GENCODE_SM10) $(GENCODE_SM13) $(GENCODE_SM20) $(GENCODE_SM30) $(GENCODE_SM35) $(GENCODE_SM50) $(GENCODE_SM60) $(GENCODE_SM62)
INC = -I$(NVIDIA_COMPUTE_SDK_LOCATION)/../4.2/C/common/inc -I$(CUDA_INSTALL_PATH)/include
LIBS = -L$(NVIDIA_COMPUTE_SDK_LOCATION)/../4.2/C/lib -lcutil_x86_64 -lcudart

OBJS = $(notdir $(CPPSRC:.cpp=.o))

all: $(OBJS)
	mkdir -p $(BINDIR)/$(BINSUBDIR)
	nvcc $(NVOPTS) $(OPTS) $(CUOPTS) $(CUSRC) *.o $(INC) -o $(EXECUTABLE) $(LIBS)

$(OBJS):
	g++ -c $(CPPSRC) $(OPTS)

clean:
	rm -f *.o *.cu.cpp $(EXECUTABLE)

cleancucpp:
	rm -f *.cu.cpp
