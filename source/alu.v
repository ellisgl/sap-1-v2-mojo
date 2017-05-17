`timescale 1ns / 1ns
/**
 * 8-bit simple ALU
 *
 * ina  = From Accumulator (Register A)
 * inb  = From Register B.
 * Su   = Operation. 0 = Add, 1 = Sub.
 * Eu   = Enable output to WBUS
 * DBUS = Data bus.
 */
module alu(
  input  [7:0] ina,
  input  [7:0] inb,
  input        Su,
  input        Eu,
  output [7:0] DBUS
);

  // If Eu is high and Su is high, subtract Register B from Accumulator and output to the DBUS
  // If Eu is high and Su is low, Add Accumulator to Register B and output to the DBUS
  // If Eu is low, then go hi-impededance on the DBUS.
  assign DBUS = (Eu) ? ((Su) ? (ina - inb) : (ina + inb)) : 8'bzzzz_zzzz;
  
  always @(DBUS or Eu)
  begin
    if(Eu)
    begin
        //$display("%t ALU IS OUTPUTING", $realtime);
    end
  end
endmodule
