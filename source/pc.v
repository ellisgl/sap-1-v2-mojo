`timescale 1ns / 1ps
/**
* 4-Bit Program Counter - Increment or Clear operation
*
* Cp   = Increment Count
* nCLK = Clock - Triggered on negative edge of CLK.
* nCLR = Clear - 0 = Clear
* Ep   = Enable output to ABUS.
*/
module pc(
    input        Cp,
    input        nCLK,
    input        nCLR,
    input        Ep,
    output [3:0] ABUS
);
  
    reg    [3:0] cnt;

    initial
    begin
      cnt <= 4'b0000;
    end
      
    assign ABUS = (Ep) ? cnt : 4'bzzzz;
    
    always @(negedge nCLK or negedge nCLR)
    begin
        if(!nCLR)
        begin
            cnt <= 4'b0000;
        end  
        else if(Cp)
        begin
            //$display("%t Incrementing the PC", $realtime);
            cnt <= (cnt == 4'd15) ? 4'b0 : cnt + 1'b1;
        end
        else if(Ep)
        begin
            //$display("%t Ouputting the PC", $realtime);
        end
        else 
        begin
            cnt <= cnt;
        end
    end
endmodule
