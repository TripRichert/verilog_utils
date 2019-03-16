/** @interface wish_pack
 *  @brief wishbone peripheral that packs NUM_PACK data words into destination.
 */
module wish_pack 
  (
   //system
   clk_i,//! clock
   rst_i,//! rest
  
   //src ctrl
   s_stb_i,//! src bus stb_i
   s_cyc_i,//! src bus cyc_i
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

  parameter DATA_WIDTH = 8;
  parameter NUM_PACK   = 4;
  parameter TGC_WIDTH  = 2;
  parameter LITTLE_ENDIAN = 1;
  

  input  clk_i;
  input  rst_i;
  input  s_stb_i;
  input  s_cyc_i;
  output s_ack_o;
  output s_stall_o;

  input [DATA_WIDTH-1:0] s_dat_i;
  input [TGC_WIDTH-1:0]  s_tgc_i;

  output reg             d_stb_o = 0;
  output reg             d_cyc_o = 0;
  input                  d_ack_i;

  output [(DATA_WIDTH * NUM_PACK) - 1 : 0] d_dat_o;
  output reg [TGC_WIDTH-1:0]               d_tgc_o;

  reg [(NUM_PACK * DATA_WIDTH) - 1 : 0]        data_buf;
  reg [$clog2(NUM_PACK) - 1:0]           cnt;
  
  //blocking, only use locally!!!
  reg                                    var_move = 0;
  
  reg     [TGC_WIDTH-1:0] stored_tgc = 0;



  assign s_stall_o = ((cnt == 4 && !d_ack_i) && d_stb_o && d_cyc_o);
  
  assign s_ack_o   = (s_stb_i && s_cyc_i && (cnt < NUM_PACK || d_ack_i) && !rst_i);

  assign d_dat_o = data_buf;
  

  
  always @(posedge clk_i)
  begin

    if (rst_i) begin
      cnt <= 0;
      var_move = 0;
      stored_tgc <= 0;
      d_tgc_o <= 0;
      d_stb_o <= 0;
      d_cyc_o <= 0;
      data_buf <= 0;
    end else begin
      
      var_move = (s_stb_i && s_cyc_i && (cnt < NUM_PACK || d_ack_i) && !rst_i);

      if (d_ack_i && d_stb_o && d_cyc_o) begin
        cnt <= 0;//overwritten if new data
        d_stb_o <= 0;
        d_cyc_o <= 0;
        if (s_stb_i && s_cyc_i && s_ack_o) begin
          stored_tgc <= s_tgc_i;
        end else begin
          stored_tgc <= 0;
        end
      end

      if (var_move) begin
        if (cnt == 0 || cnt == NUM_PACK) begin
          stored_tgc <= s_tgc_i;
        end else begin
          stored_tgc <= s_tgc_i | stored_tgc;
        end
        if (!LITTLE_ENDIAN) begin
          data_buf[(DATA_WIDTH * NUM_PACK) - 1 : DATA_WIDTH] <= data_buf[(DATA_WIDTH * (NUM_PACK - 1)) - 1:0];
          data_buf[DATA_WIDTH - 1 : 0] <= s_dat_i;
        end else begin
          data_buf[(DATA_WIDTH * (NUM_PACK - 1)) - 1:0] <= data_buf[(DATA_WIDTH * NUM_PACK) - 1 : DATA_WIDTH];
          data_buf[(DATA_WIDTH * NUM_PACK) - 1: (DATA_WIDTH * (NUM_PACK - 1))] <= s_dat_i;
        end

        if (cnt < NUM_PACK) begin

          if (cnt == NUM_PACK - 1) begin
            d_stb_o <= 1;
            d_cyc_o <= 1;
            d_tgc_o <= s_tgc_i | stored_tgc;
          end else begin
            d_stb_o <= 0;
            d_cyc_o <= 0;
            d_tgc_o <= 0;
          end


          cnt <= cnt + 1;
        end else begin//end cnt < NUM_PACK
          cnt <= 1;
//          stored_tgc <= s_tgc_i;
        end//end cnt >= NUM_PACK

      end//end var move

   end//end reset
  end//end synchronous always
  
endmodule
