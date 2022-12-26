/*
 * file    imemory.v
 * date    December 2022
 * 
 * brief   Image Memory (IM) module.
 *
 * notes   Each memory block has a size capable of storing an image 
 *         with resolution of 640x480 (3686400 bits ~ 461 kbyte).
*/
`timescale 1ns/1ps
`include "iob_im_swreg_def.vh"

module imemory  	
  #(
    parameter IM_DATA_W = 32,
    parameter IM_ADDR_W = 32,	
    parameter HEXFILE0 = "none",
    parameter HEXFILE1 = "none",
    parameter HEXFILE2 = "none"
   )
   (
    input 			clk,
	
    input [`IM_ISEL_W-1:0] 	isel, // image block selector
	
    // ROM blocks
    input 			r_en,
    input [`IM_ADDR_W-1:0] 	r_addr,    
    output reg [`IM_DATA_W-1:0] r_data, 
	
    // RAM block
    input 			w_en,
    input [`IM_ADDR_W-1:0] 	w_addr, 
    input [`IM_DATA_W-1:0] 	w_data	
    );

   reg [`IM_DATA_W-1:0] 	    rom0_data;
   reg [`IM_DATA_W-1:0] 	    rom1_data;  
   reg [`IM_DATA_W-1:0] 	    rom2_data;   
   reg [`IM_DATA_W-1:0] 	    ram_data;
         
    
   // Multiplexer for image output    
   always @ (*) begin
      case(isel)
	'h00 : r_data <= rom0_data;
	'h01 : r_data <= rom1_data;
	'h02 : r_data <= rom2_data;
	'h03 : r_data <= ram_data;
      endcase; // case (isel)      
   end // always @ (isel)
      
	 
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

   iob_rom_sp 
     #(
       .DATA_W(`IM_DATA_W),
       .ADDR_W(`IM_ADDR_W),
       .HEXFILE(HEXFILE1)
      )       
   rom1
     (
      .clk(clk),
      .r_en(r_en),
      .addr(r_addr),
      .r_data(rom1_data)
      );

   iob_rom_sp 
     #(
       .DATA_W(`IM_DATA_W),
       .ADDR_W(`IM_ADDR_W),
       .HEXFILE(HEXFILE2)
      ) 
   rom2
     (
      .clk(clk),
      .r_en(r_en),
      .addr(r_addr),
      .r_data(rom2_data)
      );

   iob_ram_2p
     #(
       .DATA_W(`IM_DATA_W),
       .ADDR_W(`IM_ADDR_W)
       )
   ram0
     (
      .clk(clk),
      .w_en(w_en),
      .w_addr(w_addr),
      .w_data(w_data),

      .r_en(r_en),
      .r_addr(r_addr),
      .r_data(ram_data)
      );

endmodule // imemory
