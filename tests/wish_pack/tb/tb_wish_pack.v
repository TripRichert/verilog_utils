
module tb_wish_pack;
  
  localparam DATA_WIDTH = 8;
  localparam NUM_PACK   = 4;
  localparam TGC_WIDTH  = 2;
  localparam LITTLE_ENDIAN = 0;

  reg  clk;
  reg  rst;
  reg  s_stb;
  reg  s_cyc;
  wire s_ack;
  wire s_stall;

  wire [DATA_WIDTH-1:0] s_dat;
  reg [TGC_WIDTH-1:0]  s_tgc;

  wire                 d_stb;
  wire                 d_cyc;
  reg                  d_ack;

  wire [(DATA_WIDTH * NUM_PACK) - 1:0] d_dat;
  wire [TGC_WIDTH-1:0]               d_tgc;
  
  reg                                  init_1z;
  reg                              [3:0]index = 0;

  integer                              test_set[7:0];
  integer                              i;
  

  

  wish_pack #(.LITTLE_ENDIAN(LITTLE_ENDIAN),
      .TGC_WIDTH(TGC_WIDTH),
      .NUM_PACK(NUM_PACK),
      .DATA_WIDTH(DATA_WIDTH)
      )
  utt
    (
     .clk_i(clk),
     .rst_i(rst),
     .s_stb_i(s_stb),
     .s_cyc_i(s_cyc),
     .s_ack_o(s_ack),
     .s_stall_o(s_stall),
     .d_stb_o(d_stb),
     .d_cyc_o(d_cyc),
     .d_dat_o(d_dat),
     .d_tgc_o(d_tgc)
     );
  
  initial begin
    for (i = 0; i < 8; i=i+1) begin
      test_set[i] = i;
    end
  end

  initial begin
    clk = 0;
    #5;
    forever begin
      #5 clk = !clk;
    end
  end

  assign s_dat = test_set[index];

  always @(posedge clk) begin
    if (s_stb && s_cyc && s_ack) begin
      index = index + 1;
    end
  end  
  
  initial begin
	$monitor("Time=", $time, " clk=", clk, " rst="
			  ,  rst, " s_dat=", s_dat, "  dat=", d_dat, "  d_stb=", d_stb, " d_cyc=", d_cyc, " d_ack=", d_ack,
             " index=", index, " s_ack=", s_ack);

    index = 0;
    rst = 1;
    s_stb = 0;
    s_cyc = 0;
    d_ack = 0;
    @(posedge(clk));
    @(posedge(clk));
    rst = 0;
    s_stb = 1;
    s_cyc = 1;
    d_ack = 1;
    @(posedge(clk));
    @(posedge(clk));
    @(posedge(clk));
    @(posedge(clk));
    @(posedge(clk));
    @(posedge(clk));
    $finish;
    
  end
  
endmodule
