`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/02 14:53:36
// Design Name: 
// Module Name: IFetch
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module IFetch(Instruction, PCPlus4, linkAddr, clock, reset, AddrResult, JrAddress, Branch, nBranch, Jmp, Jal, Jr, Zero,upg_rst_i,upg_clk_i,upg_wen_i,upg_adr_i,upg_dat_i,upg_done_i);
output[31:0] Instruction; // the instruction fetched from this module
output reg [31:0] PCPlus4; // (pc+4) to ALU which is used by branch type instruction
output reg [31:0] linkAddr; // (pc+4) to Decoder which is used by jal instruction
input clock, reset; // Clock and reset
// from ALU
input[31:0] AddrResult; // the calculated address from ALU
input Zero; // while Zero is 1, it means the ALUresult is zero
// from Decoder
input[31:0] JrAddress; // the address of instruction used by jr instruction
// from Controller
input Branch; // while Branch is 1,it means current instruction is beq
input nBranch; // while nBranch is 1,it means current instruction is bnq
input Jmp; // while Jmp 1, it means current instruction is jump
input Jal; // while Jal is 1, it means current instruction is jal
input Jr; // while Jr is 1, it means current instruction is j

// UART Programmer Pinouts
input upg_rst_i; // UPG reset (Active High)
input upg_clk_i; // UPG clock (10MHz)
input upg_wen_i; // UPG write enable
input[13:0] upg_adr_i; // UPG write address
input[31:0] upg_dat_i; // UPG write data
input upg_done_i; // 1 if program finishe

wire kickOff = upg_rst_i | (~upg_rst_i & upg_done_i);

reg [31:0] PC,Next_PC;

IRAM instmem (
.clka (kickOff ? clock : upg_clk_i ),
.wea (kickOff ? 1'b0 : upg_wen_i ),
.addra (kickOff ? PC[15:2] : upg_adr_i ),
.dina (kickOff ? 32'h00000000 : upg_dat_i ),
.douta (Instruction)
);

always @* begin
    if (reset) // update
        Next_PC = 32'b0;
    if(((Branch == 1) && (Zero == 1 )) || ((nBranch == 1) && (Zero == 0))) 
    // beq, bne
        Next_PC = AddrResult;// the calculated new value for PC
    else if(Jr == 1)
        Next_PC = JrAddress;// the value of $31 register
    else 
        Next_PC = PC+4;// PC+4
    PCPlus4 = PC+4;
end

always @(negedge clock) begin
    if(reset == 1)
        PC <= 32'h0000_0000;
    else if((Jmp == 1) || (Jal == 1)) begin
        PC <= {PC[31:28],Instruction[25:0],2'b0};
        linkAddr <= PC+4;
    end
    else 
        PC <= Next_PC;
end

endmodule
