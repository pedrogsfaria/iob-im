`timescale 1ns / 1ps

module im_tb;
   
   parameter clk_frequency = 100e6; //100 MHz
   parameter clk_per = 1e9/clk_frequency;

   parameter rom0_rawd = 'hE12;
   parameter rom1_rawd = 'hFFF;
  
   //iterator
   integer               idx, idy;

   // CORE SIGNALS
   reg 			 clk;
   reg 			 rst;			 
   
   //control interface (backend)
   reg [`IM_ISEL_W-1:0]  isel;
   reg [9:0] 		 im_pixel_x;
   reg [9:0] 		 im_pixel_y;
   
   //imemory interface (frontend)
   reg [11:0] 		 im_rgb;
   			
   initial begin

      // Initialize Inputs
      clk = 1;
      isel = 0;
      rst = 1;
      

      // optional VCD
`ifdef VCD
      $dumpfile("uut.vcd");
      $dumpvars();
`endif

      // deassert hard reset
      #100 @(posedge clk) #1 rst = 0;

      for(idy = 0; idy < 640; idy = idy + 1) begin
	    im_pixel_y = idy;
	    $display("Pixel y: %d\n", idy);

	 for(idx = 0; idx < 480; idx = idx + 1) begin
	    im_pixel_x = idx;
	    $display("Pixel x: %d\n", idx);
	    @(posedge clk) #1;

	    if( (im_rgb != rom0_rawd) && (im_rgb != rom1_rawd) ) begin
	       $display("Test failed: read error in pixel: (%d, %d) with a value of %h", idx, idy, im_rgb);	            
	       //$finish;	    
	    end

	    
	 end // for (idx = 0; idx < 480; idx = idx + 1)
	 
	 @(posedge clk) #1;
      end // for (idy = 0; idy < 640; idy = idy + 1)
      

      #clk_per;      
      $display("Test completed successfully.");
      #(3000*clk_per) $finish;
   end // initial begin
   

   // Instantiate the Unit Under Test (UUT)
   imemory
     #(
       .IM_DATA_W(`IM_DATA_W),
       .IM_ADDR_W(`IM_ADDR_W),
       .HEXFILE0("rom0_test.hex")     
      )
   uut
     (
      .rst (rst),
      .clk (clk),
      .isel (isel),
      .pixel_x (im_pixel_x),
      .pixel_y (im_pixel_y),
      .rgb (im_rgb)  
      );

   // system clock
   always #(clk_per/2) clk = ~clk;

endmodule // im_tb

