# sap-1-v2-mojo
A slightly improved SAP-1 CPU in Verilog targeted to the Mojo FPGA board. It has separate address bus, so the WBUS is split up for simplicity. This reduces from a 6 t-state setup to a 4 t-state setup.

## Overview
* 8-bit CPU
  * 8-bit WBUS replaced with the following (Removes the Memory Address Register to make thing simpler):
    * 8-bit Data Bus
    * 4-bit Address Bus
  * 4-bit OPCode (15 Maximum Operation Codes (Instructions) - but only 5 are used)
* 4 T States (4 Clock ticks)
  * 2 for Fetch
  * 2 for Execute
* 16-Bytes of Program Memory
* 2 Registers
* 5 Instructions

## Architecture of the SAP-1 Processor
![Image of architecture](http://i.imgur.com/g4ARuWI.png)

## Instructions / OP Codes
Binary | Mnemonic | Meaning
-------|----------|--------
0000 | LDA | Load data from memory into the Accumulator (Register A)
0001 | ADD | Load data from memory into Register B and perform addition of Accumulator and Register B and output on bus
0010 | SUB | Load data from memory into Register B and perform subtract of Register B from Accumulator and output on bus 
1110 | OUT | Load data from BUS to Output do be displayed 'physically'
1111 | HLT | Stop the running of the program.

## Sample Program

    // Add 10 + 9. 
    0000 0000 1001 // Addr: 0  OPCode: LDA Addr: 9
    0001 0001 1010 // Addr: 1  OPCode: ADD Addr: 10
    0010 1110 0000 // Addr: 2  OPCode: OUT - Output Data
    0011 1111 0000 // Addr: 3  OPCode: HLT - HALT
    1001 0000 1010 // Addr: 9  DATA:   10
    1010 0000 1001 // Addr: 10 DATA:    9

## See Also
https://github.com/ellisgl/SAP-1-CPU
