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
    //input            CLK,
    //input            nLm,  // Store address (0 = store)
    input      [3:0] ABUS, // Address Bus
    input            nWE,  // Write enable (0 = write)
    input            nCE,  // Read enable (0 = read)
    input            CS,   // Chip Select
    inout      [7:0] DBUS, // Data Bus
    output     [3:0] ma,
    output     [7:0] md
);
  
    reg [7:0] ram [0:15]; // Memory array
    reg [4:0] addr;
    reg [7:0] out;
    
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
    
    assign ma   = ABUS;
    assign md   = ram[ABUS];
    assign DBUS = (!nCE) ? out : 8'bzzzz_zzzz;
    
    /**
    always @(CLK or nLm)
    begin
      if(!nLm)
         begin
          $display("%t MEM SAVING ADDRESS: %b", $realtime, ABUS);
          addr <= ABUS;
       end
    end
    **/
    
    always @(nWE or nCE or DBUS or ABUS)
    begin
        if(!nWE)
        begin
            // Write data from DBUS to memory @ address from ABUS
            //$display("%t MEM LOADING: %b to ADDR: %b", $realtime, DBUS, ABUS);
            ram[ABUS] <= DBUS;
        end
        else if(!nCE)
        begin
            // Ouput the data @ address from ABUS
            //$display("%t MEM OUTPUTTING: %b from ADDR: %b", $realtime, ram[ABUS], ABUS);
            //out <= ram[addr];
            out <= ram[ABUS];
        end
        else
        begin
        end
    end
endmodule
