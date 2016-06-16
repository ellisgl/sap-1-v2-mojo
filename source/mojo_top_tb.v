`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:10:53 06/13/2016
// Design Name:   mojo_top
// Module Name:   C:/Users/xelli/Documents/sap-1-v2-ise/mojo_top_tb.v
// Project Name:  sap-1-v2-ise
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mojo_top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module mojo_top_tb;

	// Inputs
	reg        clk;
	reg        extrun;
	reg        extload;
	reg        extauto;
	reg        extstep;
	reg        extclear;
	reg        extstart;
   reg  [3:0] extaddr;
   reg  [7:0] extdata;


	// Outputs
	wire [7:0] led;
   wire [7:0] DBOUT;
   wire [3:0] ABOUT;
	wire [6:0] ss;
	wire       an0;
	wire       an1;

	// Instantiate the Unit Under Test (UUT)
	mojo_top uut (
		.clk(clk), 
		.extrun(extrun), 
		.extload(extload), 
		.extauto(extauto), 
		.extstep(extstep), 
		.extclear(extclear), 
		.extstart(extstart),
		.extaddr(extaddr),
		.extdata(extdata),
		.led(led),
		.ABOUT(ABOUT),
		.DBOUT(DBOUT),
		.ss(ss),
		.an0(an0),
		.an1(an1)
	);

   always @(*)
	begin
	    #1 clk <= ~clk;
   end

	initial begin
		// Formating time for display
      $timeformat(-9, 1, " ns", 8);
      
      // Dump waves
      $dumpfile("mojo_top.vcd");
      $dumpvars;

      // Initialize Inputs
		clk      = 0;
		extrun   = 0;
		extload  = 0;
		extauto  = 0;
		extstep  = 0;
		extclear = 0;
		extstart = 0;
		extaddr  = 4'b0000;
		extdata  = 8'b0000_0000;
	
	
	    // Program
		#10
		extaddr  = 4'b0000;
		extdata  = 8'b0000_1010;
		extload  = 1;
		
		#10
		extload  = 0;

		#10
		extaddr  = 4'b0001;
		extdata  = 8'b0001_1011;
		extload  = 1;
		
		#10
		extload  = 0;

		#10
		extaddr  = 4'b0010;
		extdata  = 8'b1110_0000;
		extload  = 1;
		
		#10
		extload  = 0;


		#10
		extaddr  = 4'b0011;
		extdata  = 8'b1111_0000;
		extload  = 1;
		
		#10
		extload  = 0;


		#10
		extaddr  = 4'b1010;
		extdata  = 8'b0000_0001;
		extload  = 1;
		
		#10
		extload  = 0;

		#10
		extaddr  = 4'b1011;
		extdata  = 8'b0000_0010;
		extload  = 1;
		
		#10
		extload  = 0;
		
		// Run
        #10
		extrun   = 1;
		extauto = 1;
		extstart = 1;

		#10
        extstart = 0;
		
		#320;
      $finish;
	end
      
endmodule
