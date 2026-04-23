GENCODE_SM10 ?=
GENCODE_SM13 ?=
GENCODE_SM20 ?=
GENCODE_SM30 ?=
GENCODE_SM35 ?=
GENCODE_SM50 ?=
GENCODE_SM60 ?=
GENCODE_SM62 ?=

CPPSRC = ../graph_parser/util.cpp ../graph_parser/parse.cpp
CUSRC = mis.cu
EXECUTABLE = $(BINDIR)/$(BINSUBDIR)/mis
OPTS = -O3
CUOPTS = $(GENCODE_ARCH) $(GENCODE_SM10) $(GENCODE_SM13) $(GENCODE_SM20) $(GENCODE_SM30) $(GENCODE_SM35) $(GENCODE_SM50) $(GENCODE_SM60) $(GENCODE_SM62)
INC = -I$(NVIDIA_COMPUTE_SDK_LOCATION)/../4.2/C/common/inc -I$(CUDA_INSTALL_PATH)/include
LIBS = -L$(NVIDIA_COMPUTE_SDK_LOCATION)/../4.2/C/lib -lcutil_x86_64 -lcudart

OBJS = $(notdir $(CPPSRC:.cpp=.o))

all: $(OBJS)
	nvcc $(NVOPTS) $(OPTS) $(CUOPTS) $(CUSRC) *.o $(INC) -o $(EXECUTABLE) $(LIBS)

$(OBJS):
	g++ -c $(CPPSRC) $(OPTS)

clean:
	rm -f *.o *.cu.cpp $(EXECUTABLE)

cleancucpp:
	rm -f *.cu.cpp
