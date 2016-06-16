`timescale 1ns / 1ps
/**
 * Reg B / Register B
 *
 * CLK    = Clock.
 * nLb    = Load to Register B. 0 = Load
 * DBUS   = The data bus. 
 * ALU    = Data to ALU
 */
module regb(
  input        CLK,
  input        nLb,
  input  [7:0] DBUS,
  output [7:0] ALU
);

  reg [7:0] regbreg;
  
  initial
  begin
    regbreg <= 8'b0000_0000;
  end

  assign ALU  = regbreg;
  
  always @(posedge CLK)
    begin 
      if(!nLb)
        begin
          // Load Reg B from DBUS
          regbreg <= DBUS;
        end
    end
endmodule
