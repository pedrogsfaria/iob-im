SHELL:=/bin/bash

TOP_MODULE=iob_im

#PATHS
REMOTE_ROOT_DIR ?=sandbox/iob-im
SIM_DIR ?=$(IM_HW_DIR)/simulation/$(SIMULATOR)
FPGA_DIR ?=$(IM_DIR)/hardware/fpga/$(FPGA_COMP)
DOC_DIR ?=

LIB_DIR ?=$(IM_DIR)/submodules/LIB
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
