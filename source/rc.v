`timescale 1ns / 1ps
module rc (
  input            CLK,
  input            nCLR,
  output reg [3:0] state
);
  
  initial
  begin
    state <= 4'b0000;
  end

  always @(negedge CLK or negedge nCLR)
  begin
    if(!nCLR)
      begin
      state <= 4'b0000;
    end
    else
      begin
      case(state)
        4'b0000:
        begin
          state <=4'b0001;
        end
        4'b0001:
        begin
          state <= 4'b0010;
        end
        4'b0010:
        begin
          state <= 4'b0100;
        end
        4'b0100:
        begin
          state <= 4'b1000;
        end
        4'b1000:
        begin
          state <= 4'b0001;
        end
        default:
        begin
          state <= 4'b0001;
        end
      endcase
    end
  end
endmodule
