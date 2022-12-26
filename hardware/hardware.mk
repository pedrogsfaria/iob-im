ifeq ($(filter IM, $(HW_MODULES)),)

include $(IM_DIR)/config.mk

#add itself to HW_MODULES list
HW_MODULES+=IM


IM_INC_DIR:=$(IM_HW_DIR)/include
IM_SRC_DIR:=$(IM_HW_DIR)/src


#include files
VHDR+=$(wildcard $(IM_INC_DIR)/*.vh)
VHDR+=iob_im_swreg_gen.vh iob_im_swreg_def.vh
VHDR+=$(LIB_DIR)/hardware/include/iob_lib.vh $(LIB_DIR)/hardware/include/iob_s_if.vh $(LIB_DIR)/hardware/include/iob_gen_if.vh

#hardware include dirs
INCLUDE+=$(incdir). $(incdir)$(IM_INC_DIR) $(incdir)$(LIB_DIR)/hardware/include

#sources
VSRC+=$(wildcard $(IM_SRC_DIR)/*.v)

im-hw-clean:
	@rm -rf $(IM_HW_DIR)/fpga/vivado/XCKU $(IM_HW_DIR)/fpga/quartus/CYCLONEV-GT

.PHONY: im-hw-clean

endif
