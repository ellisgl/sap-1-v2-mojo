`timescale 1ns / 1ps
module in (
    input        clk,
    input  [3:0] extaddr,
    input  [7:0] extdata,
    input        extrun,
    input        extload,
    input        extauto,
    input        extstep,
    input        extclear,
    input        extstart,
    input        nHLT,
    inout [3:0] ABUS,
    inout [7:0] DBUS,
    output       nWE,
    output       CS,
    output       CLR,
    output       nCLR,
    output       CLK,
    output       nCLK,
    output       run  
  );
  
  reg         creg   = 1'b0;
  reg  [24:0] ccnt   = 25'd0;
  reg         start  = 1'b0;
  reg         sprev  = 1'b0;
  
  debounce stepclean (clk, extstep,  step);
  debounce startclean(clk, extstart, startc);

  assign      load         = extload;
  assign      CLR          = extclear;
  assign      nCLR         = ~extclear;
  assign      run          = extrun;
  assign      auto         = extauto;
  assign      CLK          = (run && !auto) ? step : (run && auto) ? creg :  1'b0;
  assign      nCLK         = ~CLK;
  assign {ABUS, DBUS, nWE, CS} = (!run) ? {extaddr, extdata, ~load, load} : {4'bzzzz, 8'bzzzz_zzzz, 1'bz, 1'bz};
  
  // Clock generator and stuff
  always @(posedge clk or posedge CLR)
  begin
    if(CLR)
      begin
      // CLEAR
      start <= 1'b0;
      sprev <= 1'b0;
      ccnt  <= 3'b000;
      creg  <= 1'b0;
    end
    else
      begin
      if(!nHLT)
        begin
        creg <= 1'b0;
      end
      else if(run && auto)
        begin
        if(start)
          begin
          // 1Hz Clock
          {ccnt, creg} <= (ccnt == 25'd24_999_999) ? {25'd0, ~creg} : { ccnt + 1'b1, creg};
          //{ccnt, creg} <= (ccnt == 25'd4) ? {25'd0, ~creg} : { ccnt + 1'b1, creg};
        end
        if(startc)
          begin
          // Stop the spamming of start
          if(!sprev)
            begin
            sprev <= 1'b1;
            start <= ~start;
          end
        end
        else
          begin
          if(sprev)
            begin
            sprev <= 1'b0;
          end
        end
      end
    end
  end
endmodule
