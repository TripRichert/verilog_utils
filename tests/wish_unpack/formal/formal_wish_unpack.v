
module formal_wish_unpack
  (
   //system
   rst_i,
  
   //src ctrl
   s_stb_i,
   s_cyc_i,
   s_ack_o,
   s_stall_o,//not required
  
   s_dat_i,
   s_tgc_i,//src meta
  
   //dest ctrl
   d_stb_o,
   d_cyc_o,
   d_ack_i,
  
   d_dat_o,
   d_tgc_o//logical or of packed s_tgc_i
   );

localparam DATA_WIDTH = 8;
localparam NUM_PACK   = 4;
localparam TGC_WIDTH  = 2;
localparam LITTLE_ENDIAN = 1;
  
  input    rst_i;
  input    s_stb_i;
  input    s_cyc_i;
  output   s_ack_o;
  output   s_stall_o;

  input    [DATA_WIDTH * NUM_PACK-1:0] s_dat_i;
  input    [1:0]  s_tgc_i;

  output   d_stb_o;
  output   d_cyc_o;
  input    d_ack_i;

  output   [DATA_WIDTH - 1:0] d_dat_o;
  output   [1:0]              d_tgc_o;

  reg      clk;
/*  reg      [$clog2(NUM_PACK)+1:0]index;
  reg      [DATA_WIDTH * NUM_PACK - 1:0] dat;
  reg                                    cached;
  */
  
  wish_unpack #(.LITTLE_ENDIAN(LITTLE_ENDIAN),
      .NUM_PACK(NUM_PACK),
      .DATA_WIDTH(DATA_WIDTH)
      )
  utt
    (
     .clk_i(clk),
     .rst_i(rst_i),
     .s_stb_i(s_stb_i),
     .s_cyc_i(s_cyc_i),
     .s_ack_o(s_ack_o),
     .s_dat_i(s_dat_i),
     .s_stall_o(s_stall_o),
     .d_stb_o(d_stb_o),
     .d_cyc_o(d_cyc_o),
     .d_dat_o(d_dat_o),
     .d_tgc_o(d_tgc_o)
     );
/*
`ifdef FORMAL
    initial assume(rst_i);
`endif


  initial begin
    index = 0;
    cached = 0;
  end

  always @(posedge clk) begin
    if (s_stb_i && s_cyc_i && s_ack_o && !rst_i) begin
      dat <= s_dat_i;
      cached <= 1;
    end
    if (rst_i) begin
      index <= 0;
    end else begin
      if (d_stb_o && d_cyc_o && d_ack_i) begin
  `ifdef FORMAL
        assert(dat[DATA_WIDTH * index +:DATA_WIDTH]);
        `endif
        if (index == NUM_PACK - 1 && (!s_stb_i || !s_cyc_i || !s_ack_o)) begin
          cached <= 0;
        end
        index <= (index + 1) % NUM_PACK;
      end
    end
    `ifdef FORMAL
    assume(!(s_stb_i && s_cyc_i) || !cached || ((index == NUM_PACK - 1) && (d_stb_o && d_cyc_o && d_ack_i)));
    assume(!rst_i || !(s_stb_i || s_cyc_i || d_ack_i));
    `endif
  end
*/
  initial begin
    clk = 0;
  end
  
  always
    #5 clk = !clk;    
  
endmodule
