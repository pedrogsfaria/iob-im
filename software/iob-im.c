#include "iob-im.h"

//IM functions

//Set IM base address
void im_init(int base_address){
  IOB_IM_INIT_BASEADDR(base_address);
}

//Set values on outputs
void gpio_set(uint8_t mblock){
  IOB_IM_SET_ISEL(mblock);
}
