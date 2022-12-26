   //
   // IM
   //

   iob_im im
     (
      .clk     (clk),
      .rst     (rst),

      // Registers interface
      .im_r_en (im_r_en),
      .im_r_addr (im_r_addr),
      .im_r_data (im_r_data),

      .im_w_en (im_w_en),
      .im_w_addr (im_w_addr),
      .im_w_data (im_w_data),      

      // CPU interface
      .valid   (slaves_req[`valid(`IM)]),
      .address (slaves_req[`address(`IM,`iob_im_swreg_ADDR_W+2)-2]),
      .wdata   (slaves_req[`wdata(`IM)]),
      .wstrb   (slaves_req[`wstrb(`IM)]),
      .rdata   (slaves_resp[`rdata(`IM)]),
      .ready   (slaves_resp[`ready(`IM)])
      );
