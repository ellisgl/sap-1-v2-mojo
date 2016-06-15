`timescale 1ns / 1ps
/**
* Control Unit (CU)
*
* CLK    =
* nCLR   = Clear (inversed)
* run    =
* state  = T-State from RC
* opcode =
*
* Control Signals:
* Cp     = Increment PC
* Ep     = Enable PC ouput to WBUS (1 = Enable)
* nWE = Write Enable (load) to RAM (0 = load)
* nCE    = Enable output of RAM data to WBUS (0 = enable)
* nLi    = Load Instruction Register from WBUS (0 = load)
* nEi    = Enable ouput of address from Instruction Register to lower 4 bits of WBUS (0 = enable)
* nLa    = Load data into the accumulator from WBUS (0 = load)
* Ea     = Enable ouput of accumulator to WBUS (1 = enable)
* Su     = ALU operation (0 = Add, 1 = Subtract)
* Eu     = Enable output of ALU to WBUS (1 = enable)
* nLb    = Load data into Register B from WBUS (0 = load)
* nLo    = Load data into Output Register (0 = load)
* enio   = Enable output from Input Register (1 = enable)
* nHLT   = Inverse Halt operation. (0 = HALT)
*/

module cu(
    input            CLK,
    input            nCLR,
    input            run,
    input      [3:0] opcode,
    output reg       Cp,
    output reg       Ep,
    output reg       nLm,
    output           nWE,
    output reg       nCE,
    output reg       nLi,
    output reg       nEi,
    output reg       nLa,
    output reg       Ea,
    output reg       Su,
    output reg       Eu,
    output reg       nLb,
    output reg       nLo,
    output reg       nHLT,
    output [5:0]     state);
  
  // T-States
  parameter T1    = 6'b000001;
  parameter T2    = 6'b000010;
  parameter T3    = 6'b000100;
  parameter T4    = 6'b001000;
  parameter T5    = 6'b010000;
  parameter T6    = 6'b100000;
  
  // Assign some of our signals out of the door.
  assign    nWE    = (!run) ? 1'bz : 1'b1;
  
  // Ring Counters
  rc RC(
    .CLK(CLK),
    .nCLR(nCLR),
    .state(state)
  );
    
  always @(*)
  begin
    if(!nCLR)
      begin
      // Reset out values
      //$display("CU RESET");
      Cp    <= 0;
      Ep    <= 0;
      nLm   <= 1;
      nLb   <= 1;
      nCE   <= 1;
      nLi   <= 1;
      nEi   <= 1;
      Ea    <= 0;
      nLa   <= 1;
      Su    <= 0;
      Eu    <= 0;
      nLo   <= 1;
      nHLT  <= 1;
    end
    else if(!run)
      begin
      // Program mode
      //$display("CU IN PROGRAM MODE");
      Cp    <= 0;
      Ep    <= 0;
      nLm   <= 1;
      nLb   <= 1;
      nCE   <= 1;
      nLi   <= 1;
      nEi   <= 1;
      Ea    <= 0;
      nLa   <= 1;
      Su    <= 0;
      Eu    <= 0;
      nLo   <= 1;
      nHLT  <= 1;
    end
    else if(run && nHLT)
      begin
      // Running mode
      //$display("CU IN RUNNING MODE");
      case (state)
        T1:
        begin
          //$display("CU: T1");
          // Clear out Previous T6 Signals / Program mode.
          nLa   <= 1;
          nCE   <= 1;
          Eu    <= 0;
          nLo   <= 1;

          // Load PC to ABUS and store address in ramaddr reg
          // in mem
          Ep    <= 1;
          nLm   <= 0;
        end
        T2:
        begin
          //$display("CU: T2");
          // Clear T1 Signals
          Ep    <= 0;
          nLm   <= 1;
          
          // Increment PC
          Cp    <= 1;
        end
        T3:
        begin
          //$display("CU: T3");
          // Clear T2 Signals
          Cp    <= 0;
          
          // Output ram to IR
          nCE   <= 0;
          nLi   <= 0;
        end
        
        T4:
        begin
          //$display("CU: T4");
          //#1;
          // Clear T3 Signals
          nCE   <= 1;
          nLi   <= 1;
          
          // Execute what IR decoded for use
          // 4'b0000 - 4'b0010
          // Load Instruction Register from WBUS
          // Load address from WBUS or ABUS
          // Simple: Load memory from address outputted from the IR.
          case(opcode)
            4'b0000:
            begin
              // LDA (Load in to Accumulator)
              //$display("OPCODE: LDA (0000)");
              nEi <= 0;
              nLm <= 0;
            end
            4'b0001:
            begin
              // ADD (Add Accumlator to Register B)
              //$display("OPCODE: ADD (0001)");
              nEi <= 0;
              nLm <= 0;
            end
            4'b0010:
            begin
              // SUB (Subtract Register B from Accumulator)
              //$display("OPCODE: SUB (0010)");
              nEi <= 0;
              nLm <= 0;
            end
            // Skip a few
            4'b1110:
            begin
              // OUT (Output to display)
              //$display("OPCODE: OUT (1110)");
              // Ouput Accumulator to DBUS
              // Load WBUS into Output Register
              Ea  <= 1;
              nLo <= 0;
            end
            4'b1111:
            begin
              // HLT (HALT! Stop everything!)
              //$display("OPCODE: HLT (1111)");
              nHLT <= 0; // Stop it!
            end
          endcase
        end
        T5:
        begin
          //$display("CU: T5");
          // Rest t4 Signals
          nEi   <= 1;
          Ea    <= 0;
          nLo   <= 1;
          nLm   <= 1;          
          case(opcode)
            4'b0000:
            begin
              // LDA
              // Output data from RAM to WBUS
              // Load data from WBUS to Accumulator
              nCE <= 0;
              nLa <= 0;
            end
            4'b0001:
            begin
              // ADD
              // Output data from RAM to WBUS
              // Load data from WBUS to Register B
              nCE <= 0;
              nLb <= 0;
            end
            4'b0010:
            begin
              // SUB
              // Output data from RAM to WBUS
              // Load data from WBUS to Register B
              nCE <= 0;
              nLb <= 0;
            end
            // Skip a few
            4'b1110:
            begin
              // OUT
            end
            4'b1111:
            begin
              // HLT
            end
          endcase
        end
        T6:
        begin
          //$display("CU: T6");
          // Clear T5 Signals
          nLa <= 1;
          nCE <= 1;
          nLb <= 1;
          
          case(opcode)
            4'b0000:
            begin
            // LDA
            end
            4'b0001:
            begin
              // ADD
              // Set ALU to Addition
              // Enable ALU output to WBUS
              // Load data from WBUS to Accumulator
              Su  <= 0;
              Eu  <= 1;
              nLa <= 0;
            end
            4'b0010:
            begin
              // SUB
              // Set ALU to Subtraction
              // Enable ALU output to WBUS
              // Load data from WBUS to Accumulator
              Su  <= 1;
              Eu  <= 1;
              nLa <= 0;
            end
            // Skip a few
            4'b1110:
            begin
              // OUT
            end
            4'b1111:
            begin
              // HLT
            end
          endcase
        end
      endcase
    end
  end
endmodule