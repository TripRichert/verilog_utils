localparam DATA_WIDTH = 8;
localparam NUM_PACK   = 4;
localparam TGC_WIDTH  = 2;
localparam LITTLE_ENDIAN = 1;

module formal_wish_pack
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

  
  input  rst_i;
  input  s_stb_i;
  input  s_cyc_i;
  output s_ack_o;
  output s_stall_o;

  input [DATA_WIDTH-1:0] s_dat_i;
  input [TGC_WIDTH-1:0]  s_tgc_i;

  output                 d_stb_o;
  output                 d_cyc_o;
  input                  d_ack_i;

  output [DATA_WIDTH * NUM_PACK - 1:0] d_dat_o;
  output [TGC_WIDTH-1:0]               d_tgc_o;
  
  reg   clk;
  reg                                  init_1z;
  reg                              [$clog2(NUM_PACK):0]index;
  reg [DATA_WIDTH * NUM_PACK - 1:0]                    dat;

  reg [3:0]                                            gap_cnt;
  reg [3:0]                                            ack_gap_cnt;
  reg [TGC_WIDTH - 1 : 0]                              tgc;
  
  
  wish_pack #(.LITTLE_ENDIAN(LITTLE_ENDIAN),
      .TGC_WIDTH(TGC_WIDTH),
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

  initial assume(rst_i);


  initial begin
	init_1z = 0;
    gap_cnt = 0;
    ack_gap_cnt = 0;
   end

  
  
  always @(posedge clk) begin
    if (init_1z == 0) begin
      assume (rst_i);
    end
	init_1z <= 1;
	if (init_1z) begin
      restrict property (gap_cnt < NUM_PACK);
      restrict property (ack_gap_cnt < NUM_PACK + 2);
      assert(!(s_stall_o && s_ack_o));//stall and ack are multually exclusive
      assert(!(rst_i && s_ack_o));
      if (d_stb_o && d_cyc_o && d_ack_i && !rst_i) begin
        assert (dat == d_dat_o);
      end
    end
  end

  initial begin
    if (LITTLE_ENDIAN) begin
      index = 0;
    end else begin
      index = NUM_PACK - 1;
    end
    tgc <= 0;
  end

  always @(posedge clk) begin
    cover(s_stb_i && s_cyc_i && s_ack_o && !rst_i);
    cover(d_stb_o && d_cyc_o && d_ack_i && !rst_i);
    if (!(s_stb_i && s_cyc_i)) begin
      gap_cnt <= gap_cnt + 1;
    end else begin
      gap_cnt <= 0;
    end
    if (!d_ack_i) begin
      ack_gap_cnt <= ack_gap_cnt + 1;
    end else begin
      ack_gap_cnt <= 0;
    end
    if (s_stb_i && s_cyc_i && s_ack_o) begin
      dat[(index + 1) * DATA_WIDTH - 1 : index * DATA_WIDTH] <= s_dat_i;
      if ((LITTLE_ENDIAN)?(index == NUM_PACK - 1):(index == 0)) begin
        tgc <= s_tgc;
      end else begin
        tgc <= tgc | s_tgc;
      end
      
      if (LITTLE_ENDIAN) begin
        if (index == NUM_PACK - 1 ) begin
          index <= 0;
        end else begin
          index <= index + 1;
        end
      end else begin
        if (index == 0) begin
          index <= NUM_PACK;
        end else begin
          index <= index - 1;
        end
      end
    end
    if (rst_i) begin
      if (LITTLE_ENDIAN) begin
        index <= 0;
      end else begin
        index <= NUM_PACK - 1;
      end
    end
  
  end

  initial begin
    clk = 0;
  end
  
  always
    #5 clk = !clk;
  
endmodule
