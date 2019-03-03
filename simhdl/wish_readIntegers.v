/** @interface wish_readIntegers
 * @brief reads N Integers per line
 */
module wish_readIntegers
  (
   clk_i,
   rst_i,

   dat_o,
   stb_o,
   cyc_o,
   ack_i,
   tgc_o
   );

  parameter N = 2;
  parameter DATA_WIDTH = 32;
  parameter LITTLE_ENDIAN = 1;
  
 // parameter N = 2;
  parameter filename = "test.dat";

  input clk_i;
  input rst_i;
  output reg [DATA_WIDTH * N - 1 : 0] dat_o;
  output                     stb_o;
  output                     cyc_o;
  input                      ack_i;
  output reg        [1 : 0]     tgc_o;

  integer                    data_file;
  integer                    scan_file;
  integer                    i;

  reg                        loaded;
  reg [DATA_WIDTH - 1:0]     tmp0;
  reg [DATA_WIDTH - 1:0]     tmp1;
  integer                    tmp;
  
  

//  assign dat_o = {tmp1, tmp0};
  
  
  initial begin
    loaded = 0;
    data_file = $fopen(filename, "r");
    if (data_file == 0) begin
      $display("data_file handle was NULL");
      $finish;
    end
    tgc_o = 0;
    if (!$feof(data_file)) begin
      for (i = 0; i < N; i = i + 1) begin
        scan_file = $fscanf(data_file, "%d", tmp);
        if (LITTLE_ENDIAN) begin
          dat_o[DATA_WIDTH * i +: DATA_WIDTH] <= tmp;
        end else begin
          dat_o[DATA_WIDTH * (N - i - 1) +: DATA_WIDTH] <= tmp;
        end
      end
      
      loaded <= 1;
//      end
    end
  end

  assign stb_o = loaded && !rst_i;
  assign cyc_o = loaded && !rst_i;  
  
  always @(posedge clk_i) begin
    if (!rst_i && ack_i)  begin
      loaded <= 0;
    end  
    if (!$feof(data_file)) begin
      if (!loaded || ack_i) begin
        for (i = 0; i < N; i = i + 1) begin    
          scan_file = $fscanf(data_file, "%d", tmp);
          if (LITTLE_ENDIAN) begin
            dat_o[DATA_WIDTH * i +: DATA_WIDTH] <= tmp;
          end else begin
            dat_o[DATA_WIDTH * (N - i - 1) +: DATA_WIDTH] <= tmp;
          end
        end
        loaded <= 1;
      end
    end
  end

endmodule
  
