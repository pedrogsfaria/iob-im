`timescale 1ns / 1ps

module im_tb;
   
   parameter clk_frequency = 100e6; //100 MHz
   parameter clk_per = 1e9/clk_frequency;

   parameter rom0_rawd = 'hE12;
   parameter rom1_rawd = 'h777;
   parameter rom2_rawd = 'h0AE;   
  
   //iterator
   integer               i, mem, seq_ini;

   // CORE SIGNALS
   reg 			 clk;
   
   //control interface (backend)
   reg [`IM_ISEL_W-1:0]  isel; 
   // ROM blocks
   reg 			 r_en;			    
   reg [`IM_ADDR_W-1:0]  r_addr;	    
   
   	
   // RAM block
   reg 			 w_en;			    
   reg [`IM_ADDR_W-1:0]  w_addr;   
   reg [`IM_DATA_W-1:0]  w_data;  

   
   //imemory interface (frontend)
   // ROM blocks
   reg [`IM_DATA_W-1:0]  r_data; 

				
   initial begin

      // Initialize Inputs
      clk = 1;
      r_en = 0;
      r_addr = 0;
      w_en = 0;
      w_addr = 0;
      w_data = 0;
      isel = 0;
      seq_ini = 32;

      // optional VCD
`ifdef VCD
      $dumpfile("uut.vcd");
      $dumpvars();
`endif

      // Write all the locations of RAM
      @(posedge clk) #1;
      w_en = 1;
            
      for(i = 0; i < 2**`IM_ADDR_W; i = i + 1) begin
         w_data = i+seq_ini;
         w_addr = i;
         @(posedge clk) #1;
      end

      w_en = 0;
      @(posedge clk) #1;

      // Confirm data in memory blocks
      #clk_per;
      @(posedge clk) #1;
      r_en = 1; 
      
      for(mem = 0; mem < 4; mem = mem + 1) begin

	  $display("Memory Block: %h\n", mem);

	 //Select rom\
	 #clk_per;
	 @(posedge clk) #1;
	 isel = mem;
	 
	 // Individual mem readout
	 @(posedge clk) #1;
	 for(i = 0; i < 2**`IM_ADDR_W; i = i + 1) begin
	    r_addr = i;

	    @(posedge clk) #1;
	    $display("Data: %h", r_data);

	    case(mem)	    
	      'h00 : begin
		 if(r_data != rom0_rawd) begin
		    $display("Test failed: read error in position %d, where expected data=%h but r_data=%h", i, rom0_rawd, r_data);
		    $finish;
		 end
	      end
	      'h01 : begin
		 if(r_data != rom1_rawd) begin
		    $display("Test failed: read error in position %d, where expected data=%h but r_data=%h", i, rom1_rawd, r_data);
		    $finish;
		 end
	      end
	      'h02 : begin
		 if(r_data != rom2_rawd) begin
		    $display("Test failed: read error in position %d, where expected data=%h but r_data=%h", i, rom2_rawd, r_data);
		    $finish;
		 end
	      end
	      'h03 : begin
		 if(r_data != i+seq_ini) begin
		    $display("Test failed: read error in position %d, where expected data=%h but r_data=%h", i, i+seq_ini, r_data);
		    $finish;
		 end
	      end
	    endcase // case (mem)
	 end // for (i = 0; i < 2**`IM_ADDR_W; i = i + 1)
	 
	 @(posedge clk) #1;
	 @(posedge clk) #1;
	 @(posedge clk) #1;

      end // for (mem = 0; mem < 4; mem = mem + 1)
            
      r_en = 0;
      @(posedge clk) #1;

      #clk_per;      
      $display("Test completed successfully.");
      #(5*clk_per) $finish;

   end

   // Instantiate the Unit Under Test (UUT)
   imemory
     #(
       .IM_DATA_W(`IM_DATA_W),
       .IM_ADDR_W(`IM_ADDR_W),
       .HEXFILE0("rom0_test.hex"),
       .HEXFILE1("rom1_test.hex"),
       .HEXFILE2("rom2_test.hex")
       )
   uut
     (
      .clk(clk),
      .isel(isel),
      .r_en(r_en),
      .r_addr(r_addr),
      .r_data(r_data),
      .w_en(w_en),
      .w_addr(w_addr),
      .w_data(w_data)      
      );

   // system clock
   always #(clk_per/2) clk = ~clk;

endmodule // im_tb

