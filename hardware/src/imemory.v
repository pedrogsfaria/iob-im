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
    parameter IM_DATA_W = 32,
    parameter IM_ADDR_W = 32,	
    parameter HEXFILE0 = "none"
   )
   (
    input 		   rst,		   
    input 		   clk, 
    input [`IM_ISEL_W-1:0] isel, // image block selector
    input [9:0] 	   pixel_x,
    input [9:0] 	   pixel_y,
	
    output [11:0] 	   rgb
    );
	
   
   // Internal signals
   reg 			   r_en;   
   reg [`IM_ADDR_W-1:0]    r_addr;   
   reg [`IM_DATA_W-1:0]    rom0_data;
   reg [15:0] 		    idx;   
   reg [15:0] 		    idy;
   reg [11:0] 		    lrgb;
   
   
    	

   // Image specs
   localparam IM_SIZE = 40;   
   localparam XLEN = 40; 
   localparam YLEN = 40;
   
   
   localparam X_LEFT = 20;
   localparam X_RIGHT = X_LEFT + XLEN - 1;
   localparam Y_LEFT = 20;
   localparam Y_RIGHT = Y_LEFT + YLEN - 1;
      
   localparam [11:0] FRAME_COLOR = 12'hFFF;
   
   
   assign r_en = ( X_LEFT <= pixel_x && pixel_x <= X_RIGHT && 
		   Y_LEFT <= pixel_y && pixel_y <= Y_RIGHT ) ? 1:0; // Enable area to display image

   assign idx = pixel_x - X_LEFT;	// Image dedicated coordinate
   assign idy = pixel_y - X_LEFT;	// Image dedicated coordinate
   assign r_addr = idx + idy*(IM_SIZE);
   
   // Multiplexer for image output    
   always @ (*) begin
      if(r_en)
	lrgb = rom0_data[11:0];
	//lrgb = 12'h000;        
      else
        lrgb = FRAME_COLOR;
   end
   
   assign rgb = lrgb;
   
        			 
   // Modules instance 
   iob_rom_sp 
     #(
       .DATA_W(`IM_DATA_W),
       .ADDR_W(`IM_ADDR_W),
       .HEXFILE(HEXFILE0)
       )       
   rom0
     (
      .clk(clk),
      .r_en(r_en),
      .addr(r_addr),
      .r_data(rom0_data)
      );  

endmodule // imemory
