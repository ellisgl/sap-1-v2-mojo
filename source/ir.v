`timescale 1ns / 1ps
/**
* Instruction Registor (IR)
*
* CLK       = Clock.
* nLi       = Load Load from WBUS (8-bit). 0 = load.
*             Bits 7 - 4 = opcode
*             Bits 7 - 0 = address
* nEi       = Output Address. 0 = Output to lower part of WBUS (4-bit).
* CLR       = Clear.
* WBUS      = 8-Bit data bus.
*
* ABUS   = Address is put back on ABUS.
* opcode    = OP Code is sent to CU.
*/
module ir(
    input            CLK,
    input            nLi,
    input            nEi,
    input            CLR,
    input      [7:0] DBUS,
    output reg [3:0] ABUS,
    output     [3:0] opcode
);
  
    // Some registers
    reg    [3:0] OPCODEreg;
    reg    [3:0] ADDRreg;
    
    assign opcode = OPCODEreg;
    
    initial
    begin
      OPCODEreg <= 4'b0000;
      ADDRreg   <= 4'b0000;
      ABUS      <= 4'bzzzz;
    end
    
    always @(CLR or nLi or nEi or DBUS)
    begin
        if(CLR)
        begin
            OPCODEreg <= 4'b0000;
            ADDRreg   <= 4'b0000;
            ABUS      <= 4'bzzzz;
            //$display("%t IR: CLR - RESET", $realtime);
        end
        else if(!nLi)
        begin
            // Load our data
            //$display("%t IR LOADING: %b", $realtime, DBUS);
            OPCODEreg <= DBUS[7:4];
            ADDRreg   <= DBUS[3:0];
            ABUS      <= 4'bzzzz;
        end
        else if(!nEi)
        begin
            ABUS <= ADDRreg;
        end
        else
        begin
            // Stop the latch warnings.
            OPCODEreg <= OPCODEreg;
            ADDRreg   <= ADDRreg;
            ABUS      <= 4'bzzzz;
        end
    end
endmodule