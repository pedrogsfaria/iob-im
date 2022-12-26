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
    parameter IM_DATA_W = 8,
    parameter IM_ADDR_W = 32,	// For simulation must change
    parameter HEXFILE0 = "none",
    parameter HEXFILE1 = "none",
    parameter HEXFILE2 = "none"
   )
   (
    input 		   clk,
    input 		   rst, 
	
    input [`IM_ISEL_W-1:0] isel, // image block selector
	
    // ROM blocks
    input 		   r_en,
    input [`IM_ADDR_W-1:0]    r_addr,
    output [`IM_DATA_W-1:0]   r_data,    
	
    // RAM block
    input 		   w_en,
    input [`IM_ADDR_W-1:0]    w_addr, 
    input [`IM_DATA_W-1:0]    w_data	
    );

   // Implement verilog

endmodule // imemory
