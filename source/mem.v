`timescale 1ns / 1ps
/**
* Program Memory (RAM) - 16 Bytes (8 bits x 16 address)
* No need for MAR, since we have a seperate address bus.
* nWE  = Write Enable. 0 - Write to memory.
* nCE  = Chip Enable / Enabled the output. 0 - Read from RAM.
* nLm  = Load address. 0 - Load.
* ABUS = Address bus.
* ma   = LED Output for address.
* md   = LED Output for data.
*/
module mem (
  input  [3:0] ABUS, // Address Input
  input        CS,   // Chip Select
  input        nWE,  // Write Enable/Read Enable
  input        nCE,  // Output Enable
  inout  [7:0] DBUS,  // Data bi-directional
  output [3:0] ma,
  output [7:0] md
);          

  reg [7:0] data_out;
  reg [7:0] ram [0:15];

  initial
  begin
    ram[0]  = 8'b0000_0000;
    ram[1]  = 8'b0000_0000;
    ram[2]  = 8'b0000_0000;
    ram[3]  = 8'b0000_0000;
    ram[4]  = 8'b0000_0000;
    ram[5]  = 8'b0000_0000;
    ram[6]  = 8'b0000_0000;
    ram[7]  = 8'b0000_0000;
    ram[8]  = 8'b0000_0000;
    ram[9]  = 8'b0000_0000;
    ram[10] = 8'b0000_0000;
    ram[11] = 8'b0000_0000;
    ram[12] = 8'b0000_0000;
    ram[13] = 8'b0000_0000;
    ram[14] = 8'b0000_0000;
    ram[15] = 8'b0000_0000;  
  end

  assign ma = ABUS;
  assign md = ram[ABUS];

  // Tri-State Buffer control 
  // output : When nWE = 1, nCE = 0, CS = 1
  assign DBUS = (CS && !nCE &&  nWE) ? data_out : 8'bz; 
  
  // Memory Write Block 
  // Write Operation : When nWE = 0, CS = 1
  always @ (ABUS or DBUS or CS or nWE)
  begin : MEM_WRITE
     if (CS && !nWE)
	 begin
       ram[ABUS] = DBUS;
     end
  end

  // Memory Read Block 
  // Read Operation : When nWE = 1, nCE = 0, CS = 1
  always @ (ABUS or CS or nWE or nCE)
  begin : MEM_READ
    if (CS &&  nWE && !nCE)  begin
         data_out = ram[ABUS];
    end
  end
endmodule
