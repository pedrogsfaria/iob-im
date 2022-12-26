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
   `IOB_INPUT(im_r_en, 1),
   `IOB_INPUT(im_r_addr, `IM_ADDR_W),
   `IOB_OUTPUT(im_r_data,`IM_DATA_W),   
   
   `IOB_INPUT(im_w_en, 1),
   `IOB_INPUT(im_w_addr, `IM_ADDR_W),
   `IOB_OUTPUT(im_w_data,`IM_DATA_W),
   
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
       .IM_DATA_W(`IM_DATA_W),
       .IM_ADDR_W(`IM_ADDR_W),
       .HEXFILE0("rom0.hex"),
       .HEXFILE1("rom1.hex"),
       .HEXFILE2("rom2.hex")       
      )
   im_core
     (
      .clk (clk),
      .rst (rst),
      .isel (IM_ISEL),
      .r_en (im_r_en),
      .r_addr (im_r_addr),
      .r_data (im_r_data),
      .w_en (im_w_en),
      .w_addr (im_w_addr),
      .w_data (im_w_data)      
      );			     

endmodule // iob_im
       
       
