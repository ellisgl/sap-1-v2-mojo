`timescale 1ns / 1ps
/**
 * Program Memory (RAM) - 16 Bytes (8 bits x 16 address)
 * No need for MAR, since we have a seperate address bus.
 * nWE    = Write Enable. 0 - Write to memory.
 * nCE    = Chip Enable / Enabled the output. 0 - Read from RAM.
 * nLm    = Load address. 0 - Load.
 * ABUS   = Address bus.
 * WBUS   = Output to the data bus.
 * ABOUT  = LED Output for address.
 * WBOUT  = LED Output for data.
 */
module mem(
  input        CLK,
  input        nWE,
  input        nCE,
  input        nLm,
  input  [3:0] ABUS,
  inout  [7:0] DBUS,
  output [3:0] ma,
  output [7:0] md
);

  reg   [7:0] memory [0:(1 << 4) - 1];
  reg   [7:0] DBUSreg = 8'b0;
  reg   [3:0] addrreg;

  assign DBUS  = (nWE && !nCE) ? DBUSreg : 8'bzzzz_zzzz;
  assign ma = ABUS;
  assign md = memory[ABUS];
 
  always @(posedge CLK)
  begin
    if(!nLm)
    begin
      addrreg <= ABUS;
    end  
  end
  
  always @(*)
  begin
    if(!nWE)
    begin
      // Write to memory.
      memory[ABUS] <= DBUS;
    end
    else if(!nCE)
    begin
      // Read from memory.
      DBUSreg <= memory[addrreg];
    end    
  end
endmodule
