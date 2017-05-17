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
    output           CS,
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
    output     [5:0] state
);

    // Ring Counter (rc.v)
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
    parameter T5    = 6'b010000;
    parameter T6    = 6'b100000;
    
    reg CSreg;
    
    // Assign some of our signals out of the door.
    assign    nWE   = (!run) ? 1'bz : 1'b1;
    assign    CS    = (!run) ? 1'bz : CSreg;
    
    initial
    begin
        //nLm   <= 1;
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
            //$display("%t CU RESET", $realtime);
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
            //$display("%t CU IN PROGRAM MODE", $realtime);
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
                    // Ouput the PC, pull data from memory and store in IR.
                    // Clear previous signals
                    Cp    <= 0;
                    nLb   <= 1;
                    nEi   <= 1;
                    Ea    <= 0;
                    nLa   <= 1;
                    Su    <= 0;
                    Eu    <= 0;
                    nLo   <= 1;
                    nHLT  <= 1;             
                       
                    // Set
                    //nLm   <= 0;
                    Ep    <= 1;
                    nCE   <= 0;
                    nLi   <= 0;
                    CSreg <= 1;
                    //$display("%t CU T1: EP=1, nCE=0, nLi=0", $realtime);
                end
                  
                T2:
                begin
                    // Clear previous signals
                    //nLm   <= 1;
                    Ep    <= 0;
                    nCE   <= 1;
                    CSreg <= 0;
                    nLi   <= 1;
                    // Set
                    //$display("%t CU T2", $realtime);
                end
                T3:
                begin
                    // Set
                    Cp    <= 1;
                       
                    case(opcode)
                        4'b0000:
                        begin
                            // LDA (Output from mem based on IR address)
                            nCE   <= 0;
                            //CSreg <= 1;
                            nEi   <= 0;
                            nLa   <= 0;
                            //$display("%t CU T3: LDA - nEi = 0, nCE = 0, nLa = 0", $realtime);
                        end
                        
                        4'b0001:
                        begin
                            // ADD  (Output from mem based on IR address)
                            nCE   <= 0;
                            //CSreg <= 1;
                            nEi   <= 0;
                            nLb   <= 0;
                            //$display("%t CU T3: ADD - nEi = 0, nCE = 0, nLb = 0", $realtime);
                        end
                        
                        4'b0010:
                        begin
                            // SUB (Output from mem based on IR address)
                            nCE   <= 0;
                            //CSreg <= 1;
                            nEi   <= 0;
                            nLb   <= 0;
                            //$display("%t CU T3: SUB - nEi = 0, nCE = 0, nLb = 0", $realtime);
                        end
                        4'b1110:
                        begin
                            // OUT (Output data from Accumulator)
                            Ea  <= 1;
                            nLo <= 0;
                            //$display("%t CU T3: OUT - Ea = 1, nLo = 0", $realtime);
                        end
                        4'b1111:
                        begin
                            // HTL (Stop this crazy thing!)
                            nHLT <= 0;
                            //$display("%t CU T3: HLT - nHLT = 0", $realtime);
                        end
                        default:
                        begin
                            //$display("%t CU T3: Unknow OPCODE", $realtime);
                        end
                    endcase
                end
                  
                T4:
                begin
                    // Clear previous signals
                    //nLm   <= 1;
                    nEi   <= 1;
                    nCE   <= 1;
                    CSreg <= 0;
                    nLa   <= 1;
                    nLb   <= 1;
                    Ea    <= 0;
                    nLo   <= 1;
                    Cp    <= 0;
                
                    case(opcode)
                        4'b0000:
                        begin
                            // LDA
                            //$display("%t CU T4: LDA", $realtime);
                        end
                        
                        4'b0001:
                        begin
                            // ADD  (Load from ALU to Accumlator)
                            Eu  <= 1;
                            nLa <= 0;
                            //$display("%t CU T4: ADD - Eu = 1, nLa = 0", $realtime);
                        end
                        
                        4'b0010:
                        begin
                            // SUB (Load from ALU to Accumlator)
                            Eu  <= 1;
                            Su  <= 1;
                            nLa <= 0;
                            //$display("%t CU T4: SUB - Eu = 1, Su = 1, nLa = 0", $realtime);
                        end
                        4'b1110:
                        begin
                            // OUT
                            //$display("%t CU T4: OUT", $realtime);
                        end
                        4'b1111:
                        begin
                            // HLT
                            //$display("%t CU T4: HLT - Eu = 1, nLa = 0", $realtime);
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
                            //$display("%t CU T4: Unknown OPCODE - Reset", $realtime);
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
                    //$display("%t CU: Unknown State - RESET", $realtime);
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
            //$display("%t CU: Unknown Input state - RESET", $realtime);
        end
    end
endmodule
