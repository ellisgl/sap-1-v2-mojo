`timescale 1ns / 1ps
/**
* Control Unit (CU)
*
* CLK    = Clock
* nCLR   = Clear (inversed)
* run    = From in
* state  = T-State from RC
* opcode = From IR
*
* Control Signals:
* Cp     = Increment PC
* Ep     = Enable PC ouput to WBUS (1 = Enable)
* nWE    = Write Enable (load) to RAM (0 = load)
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
    output           nWE,
    output reg       nCE,
    output           CS,
    output reg       nLi,
    output reg       nEi,
    output reg       nLa,
    output reg       Ea,
    output reg       Su,
    output reg       Eu,
    output reg       nLb,
    output reg       nLo,
    output reg       nHLT,
    output     [3:0] state);

  // Ring Counter
  rc RC(
    .CLK(CLK),
    .nCLR(nCLR),
    .state(state)
  );  

  // T-States
  parameter T1    = 6'b000001;
  parameter T2    = 6'b000010;
  parameter T3    = 6'b000100;
  parameter T4    = 6'b001000;
  
  reg CSreg;

  // Assign some of our signals out of the door.
  assign    nWE   = (!run) ? 1'bz : 1'b1;
  assign    CS    = (!run) ? 1'bz : CSreg;

  initial
  begin
    Cp    <= 0;
    Ep    <= 0;
    nLb   <= 1;
    nCE   <= 1;
    CSreg <= 0;
    nLi   <= 1;
    nEi   <= 1;
    Ea    <= 0;
    nLa   <= 1;
    Su    <= 0;
    Eu    <= 0;
    nLo   <= 1;
    nHLT  <= 1;
  end

  always @(negedge CLK)
  begin
    if(!nCLR)
      begin
      // Reset out values
      //$display("CU RESET");
      Cp    <= 0;
      Ep    <= 0;
      nLb   <= 1;
      nCE   <= 1;
      CSreg <= 0;
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
      nLb   <= 1;
      nCE   <= 1;
      CSreg <= 0;      
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
          // Clear previous signals
          // Set
          Ep    <= 1;
          nCE   <= 0;
          CSreg <= 1;
          nLi   <= 0;
        end
        T2:
        begin
          // Clear previous signals
          Ep    <= 0;
          nCE   <= 1;
          CSreg <= 0;
          nLi   <= 1;
          
          // Set
          Cp    <= 1;
        end
        T3:
        begin
          // Clear previous signals
          Cp    <= 0;
          
          case(opcode)
            4'b0000:
            begin
              // LDA (Load from mem to Accumulator)
              nEi   <= 0;
              nCE   <= 0;
              CSreg <= 1;
              nLa   <= 0;
            end
            
            4'b0001:
            begin
              // ADD  (Load from mem to Register B)
              nEi   <= 0;
              nCE   <= 0;
              CSreg <= 1;
              nLb   <= 0;
            end
            
            4'b0010:
            begin
              // SUB (Load from mem to Register B)
              nEi   <= 0;
              nCE   <= 0;
              CSreg <= 1;
              nLb   <= 0;
            end
            4'b1110:
            begin
              // OUT (Output data from Accumulator)
              Ea  <= 1;
              nLo <= 0;
            end
            4'b1111:
            begin
              // HTL (Stop this crazy thing!)
              nHLT <= 0;
            end
            default:
            begin
            end
          endcase
        end
        T4:
        begin
          // Clear previous signals
          nEi <= 1;
          nCE <= 1;
          nLa <= 1;
          nLb <= 1;
          Ea  <= 0;
          nLo <= 1;
          
          case(opcode)
            4'b0000:
            begin
            // LDA
            end
            
            4'b0001:
            begin
              // ADD  (Load from ALU to Accumlator)
              Eu  <= 1;
              nLa <= 0;
            end
            
            4'b0010:
            begin
              // SUB (Load from ALU to Accumlator)
              Eu  <= 1;
              Su  <= 1;
              nLa <= 0;
            end
            4'b1110:
            begin
              // OUT
            end
            4'b1111:
            begin
              // HTL
            end
            default:
            begin
              Cp    <= 0;
              Ep    <= 0;
              nLb   <= 1;
              nCE   <= 1;
              CSreg <= 0;
              nLi   <= 1;
              nEi   <= 1;
              Ea    <= 0;
              nLa   <= 1;
              Su    <= 0;
              Eu    <= 0;
              nLo   <= 1;
              nHLT  <= 1;
            end
          endcase
        end
        
        default:
        begin
          Cp    <= 0;
          Ep    <= 0;
          nLb   <= 1;
          nCE   <= 1;
          CSreg <= 0;
          nLi   <= 1;
          nEi   <= 1;
          Ea    <= 0;
          nLa   <= 1;
          Su    <= 0;
          Eu    <= 0;
          nLo   <= 1;
          nHLT  <= 1;
        end
      endcase
    end
    else
      begin
      Cp    <= 0;
      Ep    <= 0;
      nLb   <= 1;
      nCE   <= 1;
      CSreg <= 0;
      nLi   <= 1;
      nEi   <= 1;
      Ea    <= 0;
      nLa   <= 1;
      Su    <= 0;
      Eu    <= 0;
      nLo   <= 1;
      nHLT  <= 1;
    end
  end
endmodule
