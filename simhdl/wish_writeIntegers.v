/** @interface wish_writeIntegers
 * @brief reads N Integers per line
 */
module wish_writeIntegers
  (
   clk_i,
   rst_i,

   dat_i,
   stb_i,
   cyc_i,
   ack_o,
   tgc_i //tlast
   );

  parameter N = 2;
  parameter DATA_WIDTH = 32;
  parameter LITTLE_ENDIAN = 1;
  parameter filename = "test.dat";

  input clk_i;
  input rst_i;
  input [DATA_WIDTH * N - 1 : 0] dat_i;
  input                     stb_i;
  input                     cyc_i;
  output                      ack_o;
  input                     tgc_i;

  integer                    data_file;
  integer                    i;

  reg                        loaded;
  integer                    tmp;
  integer                    char;
  
  
  

  assign ack_o = !rst_i;
  
  initial begin
    loaded = 0;
    data_file = $fopen(filename, "w");
    if (data_file == 0) begin
      $display("data_file handle was NULL");
      $finish;
    end
  end
  
  always @(posedge clk_i) begin
    if (!rst_i)  begin
      if (stb_i && cyc_i) begin
        for (i = 0; i < N; i = i + 1) begin
          tmp = dat_i[DATA_WIDTH * i +: DATA_WIDTH];
          $fwrite(data_file, "%0d", tmp);
          if (i + 1 < N) begin
            $fwrite(data_file, " ");
          end else begin
            if (tgc_i) begin
              $fwrite(data_file, ";");
            end
            $fwrite(data_file, "\n");
          end
        end
      end
    end      
  end

endmodule
  
