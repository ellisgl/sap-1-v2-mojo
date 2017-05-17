`timescale 1ns / 1ps
/**
* Accumulator / Register A
*
* CLK    = Clock.
* nLa    = Load Register A (Write). 0 - Write
* Ea     = Write to WBUS.
* in     = From the WBUS
* out    = To the WBUS
* ALU    = Data to ALU
*/
module accumulator(
    input        CLK,
    input        nLa,
    input        Ea,
    inout  [7:0] DBUS,
    output [7:0] ALU
  );
  
    reg  [7:0] accreg;
    
    initial
    begin
        accreg <= 8'b0000_0000;
    end
    
    assign DBUS = (Ea) ? accreg : 8'bzzzz_zzzz;
    assign ALU  =  accreg;
    
    always @(posedge CLK)
    begin
        if(!nLa)
        begin
            // Load from DBUS
            //$display("%t ACC - Loading: %b", $realtime, DBUS);
            accreg <= DBUS;
        end
        else if(Ea)
        begin
            //$display("%t ACC - OUTPUTTING: %b", $realtime, accreg);
        end
        /**
        else
        begin
            accreg <= accreg;
        end
        **/
    end
endmodule
