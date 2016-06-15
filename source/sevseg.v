module sevseg(
 input        clk,
 input        CLR,
 input  [7:0] OBUS,
 output [6:0] ss,
 output       an0,
 output       an1
 );
 
  reg        sclk  = 1'b0;
  reg [12:0] sscnt = 13'b0;
  reg [6:0]  ssreg = 7'b0111111;
  reg [3:0]  sstmp = 4'b0;
  reg        aclk  = 1'b0;
  reg [7:0]  ncnt  = 8'b0;
  reg [3:0]  stmp  = 4'b0;

  assign ss        = ssreg;
  assign an0       = aclk;
  assign an1       = ~aclk;

  always @(posedge clk or posedge CLR)
    begin
      if (CLR)
        begin
          sclk  = 1'b0;
          sscnt = 16'b0;
          ssreg = 7'b0111111;
          sstmp = 4'b0;
          aclk  = 1'b0;
          ncnt  = 1'b0;
          stmp  = 1'b0;
        end
      else
        begin
          // 1KHz clocking for the 7 segement display selection (an0 and an1).
          if(sscnt == 4999)
            begin
              sstmp = (aclk) ? {OBUS[7], OBUS[6], OBUS[5], OBUS[4]} : {OBUS[3], OBUS[2], OBUS[1], OBUS[0]};
      
              case(sstmp)
                  4'h0:
                    begin
                      ssreg = 7'b1000000;
                    end
                  4'h1:
                    begin
                      ssreg = 7'b1111001;
                    end
                  4'h2:
                    begin
                      ssreg = 7'b0100100;
                    end
                  4'h3:
                    begin
                      ssreg = 7'b0110000;
                    end
                  4'h4:
                    begin
                      ssreg = 7'b0011001;
                    end
                  4'h5:
                    begin
                      ssreg = 7'b0010010;
                    end
                  4'h6:
                    begin
                      ssreg = 7'b0000010;
                    end
                  4'h7:
                    begin
                      ssreg = 7'b1111000;
                    end
                  4'h8:
                    begin
                      ssreg = 7'b0000000;
                    end
                  4'h9:
                    begin
                      ssreg = 7'b0011000;
                    end
                  4'ha:
                    begin
                      ssreg = 7'b0001000;
                    end
                  4'hb:
                    begin
                      ssreg = 7'b0000011;
                    end
                  4'hc:
                    begin
                      ssreg = 7'b1000110;
                    end
                  4'hd:
                    begin
                      ssreg = 7'b0100001;
                    end
                  4'he:
                    begin
                      ssreg = 7'b0000110;
                    end
                  4'hf:
                    begin
                      ssreg = 7'b0001110;
                    end
                  default:
                    begin
                      ssreg = 7'b0111111;
                    end
                endcase
      
              aclk  = ~aclk;
            end
            
            sscnt = (sscnt == 13'd4999)    ? 13'd0 : sscnt + 1'd1;  
        end
    end
endmodule