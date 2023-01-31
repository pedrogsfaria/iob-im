/*
 * file    iob_im
 * date    December 2022
 * 
 * brief   Image Memory (IM) driver Wrapper.
*/
`timescale 1ns/1ps

`include "iob_lib.vh"
`include "iob_im_swreg_def.vh"

module iob_im 
  # (
     parameter DATA_W = 32,        //PARAM & 32 & 64 & CPU data width
     parameter ADDR_W = `iob_im_swreg_ADDR_W 	//CPU address section width    
     )
  (

   //CPU interface
`include "iob_s_if.vh"

   //additional inputs and outputs  
   `IOB_INPUT(im_pixel_x, 10),
   `IOB_INPUT(im_pixel_y, 10),   
   
   `IOB_OUTPUT(im_rgb, 12),
   
`include "iob_gen_if.vh"
   );

//BLOCK Register File & Configuration control and status register file.
`include "iob_im_swreg_gen.vh"

    // SWRegs   
    `IOB_WIRE(IM_ISEL, 8)
    iob_reg #(.DATA_W(8), .RST_VAL(0))
    im_isel (
        .clk        (clk),
        .arst       (rst),
        .rst        (rst),
        .en         (IM_ISEL_en),
        .data_in    (IM_ISEL_wdata),
        .data_out   (IM_ISEL)
    );

   
   // Image memory instantiation
   imemory
     #(
       .IM0_DATA_W(`IM0_DATA_W),
       .IM0_ADDR_W(`IM0_ADDR_W),
       .IM1_DATA_W(`IM1_DATA_W),
       .IM1_ADDR_W(`IM1_ADDR_W),
       .IM0_X_LEN(`IM0_X_LEN),
       .IM0_Y_LEN(`IM0_Y_LEN),
       .IM1_X_LEN(`IM1_X_LEN),
       .IM1_Y_LEN(`IM1_Y_LEN),
       .HEXFILE0("rom0.hex"),
       .HEXFILE1("rom1.hex")
      )
   im_core
     (
      .clk (clk),
      .isel (IM_ISEL),
      .pixel_x (im_pixel_x),
      .pixel_y (im_pixel_y),
      .rgb (im_rgb)  
      );			     

endmodule // iob_im
       
       
