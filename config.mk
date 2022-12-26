SHELL:=/bin/bash

TOP_MODULE=iob_im

#IM
IM_DATA_W := 12
IM_ADDR_W := 6


#PATHS
REMOTE_ROOT_DIR ?=sandbox/iob-im
SIM_DIR ?=$(IM_HW_DIR)/simulation/$(SIMULATOR)
FPGA_DIR ?=$(IM_DIR)/hardware/fpga/$(FPGA_COMP)
DOC_DIR ?=

#define macros
DEFINE+=$(defmacro)IM_DATA_W=$(IM_DATA_W)
DEFINE+=$(defmacro)IM_ADDR_W=$(IM_ADDR_W)

LIB_DIR ?=$(IM_DIR)/submodules/LIB
MEM_DIR ?=$(IM_DIR)/submodules/MEM
IM_HW_DIR:=$(IM_DIR)/hardware

#MAKE SW ACCESSIBLE REGISTER
MKREGS:=$(shell find $(LIB_DIR) -name mkregs.py)

#DEFAULT FPGA FAMILY AND FAMILY LIST
FPGA_FAMILY ?=XCKU
FPGA_FAMILY_LIST ?=CYCLONEV-GT XCKU

#DEFAULT DOC AND DOC LIST
DOC ?=pb
DOC_LIST ?=pb ug

# default target
default: sim

# VERSION
VERSION ?=V0.1
$(TOP_MODULE)_version.txt:
	echo $(VERSION) > version.txt

#cpu accessible registers
iob_im_swreg_def.vh iob_im_swreg_gen.vh: $(IM_DIR)/mkregs.conf
	$(MKREGS) iob_im $(IM_DIR) HW

im-gen-clean:
	@rm -rf *# *~ version.txt

.PHONY: default im-gen-clean
