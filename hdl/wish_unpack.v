/** @interface wish_unpack
 *  @brief wishbone peripheral that packs NUM_PACK data words into destination.
 */
module wish_unpack 
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
  parameter LITTLE_ENDIAN = 1;
  

  input  clk_i;
  input  rst_i;
  input  s_stb_i;
  input  s_cyc_i;
  output s_ack_o;
  output s_stall_o;

  input [(DATA_WIDTH * NUM_PACK) -1:0] s_dat_i;
  input [1:0]  s_tgc_i;

  output             d_stb_o;
  output             d_cyc_o;
  input                  d_ack_i;

  output [DATA_WIDTH - 1 : 0] d_dat_o;
  output [1:0]               d_tgc_o;

  reg [(NUM_PACK * DATA_WIDTH) - 1 : 0]        data_buf;
  reg [$clog2(NUM_PACK):0]           cnt;
  
  
  integer                                i;
  reg                                    stored = 0;
  reg                                    [1:0]tgc_buf;
    
  assign d_dat_o = (LITTLE_ENDIAN)?data_buf[DATA_WIDTH * cnt +:DATA_WIDTH]:data_buf[DATA_WIDTH * (NUM_PACK - 1 - cnt) +:DATA_WIDTH];
  
  assign d_stb_o = !rst_i && stored;
  assign d_cyc_o = !rst_i && stored;
  assign s_ack_o = !rst_i && (!stored || (d_ack_i && ((cnt + 1) == NUM_PACK)));
  assign s_stall_o = stored && !d_ack_i;
  assign d_tgc_o[0] = (cnt == 0)? (!rst_i && tgc_buf[0]) : 1'b0;
  assign d_tgc_o[1] = (cnt + 1 == NUM_PACK)? (!rst_i &&  tgc_buf[1]) : 1'b0;
  
  
  always @(posedge clk_i)
  begin
    if (rst_i) begin
      cnt <= 0;
      stored <= 0;
    end else begin      
      if (s_stb_i && s_cyc_i && s_ack_o) begin
        tgc_buf  <= s_tgc_i;
        data_buf <= s_dat_i;
        stored <= 1'b1;
        cnt <= 0;
      end else begin
        if (cnt + 1 == NUM_PACK && d_stb_o && d_cyc_o && d_ack_i) begin
          stored <= 1'b0;
        end else begin
          stored <= stored;
        end
        if (d_stb_o && d_cyc_o && d_ack_i) begin
          if (cnt + 1 == NUM_PACK) begin
            cnt <= 0;
          end else begin
            cnt <= cnt + 1;
          end
        end else begin
          cnt <= cnt;
        end        
      end
   end//end reset
  end//end synchronous always
  
endmodule
