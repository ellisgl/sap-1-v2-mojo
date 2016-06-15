`timescale 1ns / 1ps
module rc (CLK, nCLR, state);
  
  input        CLK;
  input        nCLR;
  output [5:0] state;
  reg    [5:0] state;
  
  always @(negedge CLK or negedge nCLR)
  begin
    if(!nCLR)
      begin
      state <= 6'b00_0000;
    end
    else
      begin
      case(state)
        6'b00_0000:
        begin
          state <= 6'b00_0001;
        end
        6'b000001:
        begin
          state <= 6'b00_0010;
        end
        6'b000010:
        begin
          state <= 6'b00_0100;
        end
        6'b000100:
        begin
          state <= 6'b00_1000;
        end
        6'b001000:
        begin
          state <= 6'b01_0000;
        end
        6'b010000:
        begin
          state <= 6'b10_0000;
        end
        6'b100000:
        begin
          state <= 6'b00_0001;
        end
      endcase
    end
  end
endmodule