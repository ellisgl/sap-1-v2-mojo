`1ns / 1ps
module mojo_top(
    // 50MHz clock input
    input        clk,
    // Our stuff
    input        extrun,
    input        extload,
    input        extauto,
    input        extstep,
    input        extclear,
    input        extstart,
    input  [3:0] extaddr,
    input  [7:0] extdata,
    output [7:0] DBOUT,
    output [3:0] ABOUT,
    output [6:0] ss,
    output       an0,
    output       an1,
    output [7:0] led
);
  
    // Buses and control signals
    wire  [7:0] DBUS; // Data Bus
    wire  [3:0] ABUS; // Address
    wire        CLK;
    wire        nCLK;
    wire        CLR;
    wire        nCLR;
    wire        Cp;
    wire        Ep;
    //wire        nLm;
    wire        nWE;
    wire        nCE;
    wire        CS;
    wire        nLi;
    wire        nEi;
    wire        nLa;
    wire        Ea;
    wire        Su;
    wire        Eu;
    wire        nLb;
    wire        nLo;
    wire [7:0]  alua;
    wire [7:0]  alub;
    wire        run;
    wire        nHLT;
    wire [3:0]  opcode;
    wire [7:0]  OBUS;
    wire [5:0]  state;
    
    assign led[0] = state[0];
    assign led[1] = state[1];
    assign led[2] = state[2];
    assign led[3] = state[3];
    assign led[4] = state[4];
    assign led[5] = state[5];
    assign led[6] = 1'b0;
    assign led[7] = CLK;
    
    in IN(
      .clk(clk),
      .extaddr(extaddr),
      .extdata(extdata),
      .extrun(extrun),
      .extload(extload),
      .extauto(extauto),
      .extstep(extstep),
      .extclear(extclear),
      .extstart(extstart),
      .nHLT(nHLT),
      .ABUS(ABUS),
      .DBUS(DBUS),
      .nWE(nWE),
       .CS(CS),
      .CLR(CLR),
      .nCLR(nCLR),
      .CLK(CLK),
      .nCLK(nCLK),
      .run(run)    
    );
    
    cu CU(
      .CLK(CLK),
      .nCLR(nCLR),
      .run(run),
      .opcode(opcode),
      .Cp(Cp),
      .Ep(Ep),
      .nWE(nWE),
      .nCE(nCE),
      //.nLm(nLm),
      .CS(CS),
      .nLi(nLi),
      .nEi(nEi),
      .nLa(nLa),
      .Ea(Ea),
      .Su(Su),
      .Eu(Eu),
      .nLb(nLb),
      .nLo(nLo),
      .nHLT(nHLT),
      .state(state)
    );
    
    pc PC(
      .Cp(Cp),
      .nCLK(nCLK),
      .nCLR(nCLR),
      .Ep(Ep),
      .ABUS(ABUS)
    );  
    
    ir IR(
      .CLK(CLK),
      .nLi(nLi),
      .nEi(nEi),
      .CLR(CLR),
      .DBUS(DBUS),
      .ABUS(ABUS),
      .opcode(opcode)
    );
    
    mem MEM(
      //.CLK(CLK),
      //.nLm(nLm),
      .nWE(nWE),
      .nCE(nCE),
       .CS(CS),
      .ABUS(ABUS),
      .DBUS(DBUS),
      .ma(ABOUT),
      .md(DBOUT)
    );
    
    accumulator ACCUMULATOR(
      .CLK(CLK),
      .nLa(nLa),
      .Ea(Ea),
      .DBUS(DBUS),
      .ALU(alua)
    );
    
    regb REGB(
      .CLK(CLK),
      .nLb(nLb),
      .DBUS(DBUS),
      .ALU(alub)
    );
    
    alu ALU(
      .ina(alua),
      .inb(alub),
      .Su(Su),
      .Eu(Eu),
      .DBUS(DBUS)
    );
    
    out OUT(
      .CLK(CLK),
      .CLR(CLR),
      .nLo(nLo),
      .DBUS(DBUS),
      .OBUS(OBUS)
    );
    
    sevseg SEVSEG(
      .clk(clk),
      .CLR(CLR),
      .OBUS(OBUS),
      .ss(ss),
      .an0(an0),
      .an1(an1)
    );

endmodule
