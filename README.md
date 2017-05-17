# sap-1-v2-mojo
SAP-1 CPU in Verilog for the Mojo FPGA board - has seperate address bus, so the WBUS is split up for simplicity. Also reduced from 6 t-states to 4.

## Overview
* 8-bit CPU
  * 8-bit WBUS replaced with the following (Removes the Memory Address Register to make thing simplier):
    * 8-bit Data Bus
    * 4-bit Address Bus
  * 4-bit OPCode (15 Maxium Operation Codes (Instructions) - but only 5 are used)
* 4 T States (4 Clock ticks)
  * 2 for Fetch
  * 2 for Execute
* 16-Bytes of Program Memory
* 2 Registers
* 5 Instructions

## Archectecture of the SAP-1 Processor
![Image of architecture](http://i.imgur.com/g4ARuWI.png)
