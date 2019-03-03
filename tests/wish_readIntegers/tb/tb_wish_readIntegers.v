
module tb_wish_readIntegers;
  localparam DATA_WIDTH = 32;
  localparam N = 2;
  localparam filename = "testcases/test0.dat";
  localparam LITTLE_ENDIAN = 1;
  
  reg clk;
  reg rst;
  wire [DATA_WIDTH * N - 1 : 0] dat;
  wire stb;
  wire cyc;
  wire ack;
  wire [1:0] tgc;


  wish_readIntegers #(
                  .DATA_WIDTH(DATA_WIDTH),
                  .N(N),
                  .filename(filename),
                  .LITTLE_ENDIAN(LITTLE_ENDIAN)
                  ) uut (
                         .clk_i(clk),
                         .rst_i(rst),
                         .stb_o(stb),
                         .cyc_o(cyc),
                         .dat_o(dat),
                         .ack_i(ack),
                         .tgc_o(tgc)
                         );

  assign ack = !rst;

  initial begin
    clk = 0;
    rst = 1;
  end
  always begin
    #5 clk = !clk;
  end

  always @(posedge(clk)) begin
    $display("Time= %t\trst= %d\tdat= %x\tstb= %d\tcyc= %d\tack= %d", $time, rst, dat, stb, cyc, ack);
  end
  initial begin
    @(posedge(clk));
    rst <= 0;
    repeat (12) begin
      @(posedge(clk));
    end
    $finish;
  end

endmodule // tb_wish_readIntegers

