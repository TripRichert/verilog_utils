
module tb_wish_pack;
  
  localparam DATA_WIDTH = 8;
  localparam NUM_PACK   = 4;
  localparam TGC_WIDTH  = 2;
  localparam LITTLE_ENDIAN = 0;
  localparam filename = "testcases/test1.dat";
  localparam logfilename = "testcases/test1.result";

  reg  clk;
  reg  rst;
  wire  s_stb;
  wire  s_cyc;
  wire s_ack;
  wire s_stall;

  wire [DATA_WIDTH-1:0] s_dat;
  wire [TGC_WIDTH-1:0]  s_tgc;

  wire                 d_stb;
  wire                 d_cyc;
  wire                 d_ack;

  wire [(DATA_WIDTH * NUM_PACK) - 1:0] d_dat;
  wire [TGC_WIDTH-1:0]               d_tgc;
  
  reg                                  init_1z;

  

  wish_readIntegers #(
                  .DATA_WIDTH(DATA_WIDTH),
                  .N(1),
                  .filename(filename),
                  .LITTLE_ENDIAN(LITTLE_ENDIAN)
                      ) stim 
    (
     .clk_i(clk),
     .rst_i(rst),
     .stb_o(s_stb),
     .cyc_o(s_cyc),
     .dat_o(s_dat),
     .ack_i(s_ack),
     .tgc_o(s_tgc)
     );
  
 

  wish_pack 
    #(
      .LITTLE_ENDIAN(LITTLE_ENDIAN),
      .TGC_WIDTH(TGC_WIDTH),
      .NUM_PACK(NUM_PACK),
      .DATA_WIDTH(DATA_WIDTH)
      ) utt
      (
       .clk_i(clk),
       .rst_i(rst),
       .s_stb_i(s_stb),
       .s_cyc_i(s_cyc),
       .s_ack_o(s_ack),
       .s_dat_i(s_dat),
       .s_tgc_i(s_tgc),
       .s_stall_o(s_stall),
       .d_stb_o(d_stb),
       .d_cyc_o(d_cyc),
       .d_dat_o(d_dat),
       .d_tgc_o(d_tgc)
       );

  wish_writeIntegers 
    #(
      .LITTLE_ENDIAN(LITTLE_ENDIAN),
      .N(NUM_PACK),
      .DATA_WIDTH(DATA_WIDTH),
      .filename(logfilename)
      ) logger
      (
       .clk_i(clk),
       .rst_i(rst),
       .stb_i(d_stb),
       .cyc_i(d_cyc),
       .ack_o(d_ack),
       .dat_i(d_dat),
       .tgc_i(d_tgc[1])
       );
  

  initial begin
    clk = 0;
    #5;
    forever begin
      #5 clk = !clk;
    end
  end
  
  initial begin
	$monitor("Time=", $time, " clk=", clk, " rst="
			  ,  rst, " s_dat=", s_dat, "  dat=", d_dat, "  d_stb=", d_stb, " d_cyc=", d_cyc, " d_ack=", d_ack,
             " s_ack=", s_ack, " s_first=", s_tgc[0], " s_tlast=", s_tgc[1], " d_tlast=", d_tgc[1]);

    rst = 1;
    @(posedge(clk));
    @(posedge(clk));
    rst = 0;
    @(posedge(clk));
    @(posedge(clk));
    @(posedge(clk));
    @(posedge(clk));
    @(posedge(clk));
    @(posedge(clk));
    @(posedge(clk));
    @(posedge(clk));
    @(posedge(clk));
    @(posedge(clk));
    @(posedge(clk));
    @(posedge(clk));
    @(posedge(clk));
    @(posedge(clk));
    @(posedge(clk));
    @(posedge(clk));
    @(posedge(clk));
    @(posedge(clk));
    @(posedge(clk));
    @(posedge(clk));
    @(posedge(clk));
    @(posedge(clk));
    @(posedge(clk));
    @(posedge(clk));
    @(posedge(clk));
    @(posedge(clk));
    @(posedge(clk));
    @(posedge(clk));
    @(posedge(clk));
    @(posedge(clk));
    $finish;
    
  end
  
endmodule
