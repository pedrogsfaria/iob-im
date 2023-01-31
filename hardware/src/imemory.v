/*
 * file    imemory.v
 * date    December 2022
 * 
 * brief   Image Memory (IM) module.
 *
*/
`timescale 1ns/1ps
`include "iob_im_swreg_def.vh"

module imemory  	
  #(
    parameter IM0_DATA_W = 32,
    parameter IM0_ADDR_W = 32,
    parameter IM1_DATA_W = 32,
    parameter IM1_ADDR_W = 32,

    parameter IM0_X_LEN = 0,
    parameter IM0_Y_LEN = 0,
    parameter IM1_X_LEN = 0,
    parameter IM1_Y_LEN = 0,    
    
    parameter HEXFILE0 = "none",
    parameter HEXFILE1 = "none"
   )
   (	   
    input 		   clk, 
    input [`IM_ISEL_W-1:0] isel,    // image selector
    input [9:0] 	   pixel_x,
    input [9:0] 	   pixel_y,
	
    output [11:0] 	   rgb
    );
	
   
   // Core signals
   reg 			   im0_r_en;		   
   reg [`IM0_ADDR_W-1:0]   im0_r_addr;
   reg [`IM0_DATA_W-1:0]   im0_rom_data;
   reg [15:0] 		   im0_idx;   
   reg [15:0] 		   im0_idy;

   reg 			   im1_r_en;
   reg [`IM1_ADDR_W-1:0]   im1_r_addr;
   reg [`IM1_DATA_W-1:0]   im1_rom_data;
   reg [15:0] 		   im1_idx;   
   reg [15:0] 		   im1_idy;

   reg [11:0] 		   lrgb;
   
      
   // Image 0  specs
   localparam IM0_X_LEFT = 320 - (IM0_X_LEN/2);
   localparam IM0_X_RIGHT = IM0_X_LEFT + IM0_X_LEN - 1;
   localparam IM0_Y_TOP = 240 - (IM0_Y_LEN/2);
   localparam IM0_Y_BOT = IM0_Y_TOP + IM0_Y_LEN - 1;        
   localparam [11:0] FRAME_COLOR_0 = 12'h000;

   assign im0_r_en = ( IM0_X_LEFT <= pixel_x && pixel_x <= IM0_X_RIGHT && 
		       IM0_Y_TOP  <= pixel_y && pixel_y <= IM0_Y_BOT ) ? 1:0; // Enable area to display image

   assign im0_idx = pixel_x - IM0_X_LEFT;	                              // Image dedicated coordinate
   assign im0_idy = pixel_y - IM0_Y_TOP;	                              // Image dedicated coordinate
   assign im0_r_addr = im0_idx + im0_idy*(IM0_X_LEN);

   // Image 1  specs
   localparam IM1_X_LEFT = 320 - (IM1_X_LEN/2);
   localparam IM1_X_RIGHT = IM1_X_LEFT + IM1_X_LEN - 1;
   localparam IM1_Y_TOP = 240 - (IM1_Y_LEN/2);
   localparam IM1_Y_BOT = IM1_Y_TOP + IM1_Y_LEN - 1;        
   localparam [11:0] FRAME_COLOR_1 = 12'hFFF;

   assign im1_r_en = ( IM1_X_LEFT <= pixel_x && pixel_x <= IM1_X_RIGHT && 
		       IM1_Y_TOP  <= pixel_y && pixel_y <= IM1_Y_BOT ) ? 1:0; // Enable area to display image

   assign im1_idx = pixel_x - IM1_X_LEFT;	                              // Image dedicated coordinate
   assign im1_idy = pixel_y - IM1_Y_TOP;	                              // Image dedicated coordinate
   assign im1_r_addr = im1_idx + im1_idy*(IM1_X_LEN);

   
   // Image selector    
   always @ (*) begin
      if(isel == 2'b00) begin
	 if(im0_r_en)
	   lrgb = im0_rom_data[11:0];
	 else
	   lrgb = FRAME_COLOR_0;
      end      
      else begin
	 if(im1_r_en)
	   lrgb = im1_rom_data[11:0];
	 else
	   lrgb = FRAME_COLOR_1;
      end // else: !if(~isel)
      
   end // always @ (*)
   
   assign rgb = lrgb;
   
        			 
   // Modules instance 
   iob_rom_sp 
     #(
       .DATA_W(`IM0_DATA_W),
       .ADDR_W(`IM0_ADDR_W),
       .HEXFILE(HEXFILE0)
       )       
   rom0
     (
      .clk(clk),
      .r_en(im0_r_en),
      .addr(im0_r_addr),
      .r_data(im0_rom_data)
      );

   iob_rom_sp 
     #(
       .DATA_W(`IM1_DATA_W),
       .ADDR_W(`IM1_ADDR_W),
       .HEXFILE(HEXFILE1)
       )       
   rom1
     (
      .clk(clk),
      .r_en(im1_r_en),
      .addr(im1_r_addr),
      .r_data(im1_rom_data)
      );  

endmodule // imemory
