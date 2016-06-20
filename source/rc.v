`timescale 1ns / 1ps
module rc (
  input            CLK,
  input            nCLR,
  output reg [5:0] state
);
  
  initial
  begin
    state <= 6'b00000;
  end

  always @(negedge CLK or negedge nCLR)
  begin
    if(!nCLR)
      begin
      state <= 6'b000000;
    end
    else
      begin
      case(state)
		  6'b00000:
		  begin
		    state <= 6'b000001;
		  end
        6'b00001:
        begin
          state <= 6'b000010;
        end
        6'b000010:
        begin
          state <= 6'b000100;
        end
        6'b000100:
        begin
          state <= 6'b001000;
        end
        6'b001000:
        begin
          //state <= 6'b010000;
          state <= 6'b000001;
        end
		  6'b010000:
		  begin
		    state <= 6'b000001;
		  end
        default:
        begin
          state <= 6'b000000;
        end
      endcase
    end
  end
endmodule
