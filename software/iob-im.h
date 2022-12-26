#include <stdbool.h>

#include "iob_im_swreg.h"

//IM functions

//Set IM base address
void im_init(int base_address);

//Set image memory source
void im_set(uint8_t mblock);
