`timescale 1ns / 1ps
/**
* Ouput Register /
*
* CLK  = Clock
* nLo  = Load data from ABUS & DBUS
* ABUS = Address bus
* DBUS = Data bus
* OBUS = Output bus
*/
module out(
    input        CLK,
    input        CLR,
    input        nLo,
    input  [7:0] DBUS,
    output [7:0] OBUS
  );
  
  reg [7:0] OBUSreg;
  
  assign OBUS = OBUSreg;
  
  always @(negedge CLK or posedge CLR)
  begin
    if(CLR)
      begin
        OBUSreg <= 8'b0000_0000;
      end
    else if(!nLo)
      begin
      // Load from DBUS
      OBUSreg <= DBUS;
    end
  end
endmodule