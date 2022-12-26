   // IM
   // ROM blocks
   input 		            im_r_en,
   input [`IM_ADDR_W-1:0] 	    im_r_addr,
   output[`IM_DATA_W-1:0]           im_r_data,			    
	
   // RAM block
   input 		            im_w_en,			    
   input [`IM_ADDR_W-1:0] 	    im_w_addr,
   input [`IM_DATA_W-1:0] 	    im_w_data,
