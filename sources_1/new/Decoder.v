`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/29 13:32:43
// Design Name: 
// Module Name: Decoder
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


module Decoder(reset,clock,confirm,index,RegWrite,Jal,MemOrIOtoReg,RegDST,Signed,rs,rt,Jr,rd,linkAddr,immi,valueALU,RegWriteData,Data1,Data2,extendedImmi);
input reset;
input clock;
input confirm;
input [2:0] index; //clock signal generated by CPUClock module
//controller
input RegWrite; // 1 indicate write register(R,I(lw)), otherwise it's not
input Jal; // 1 indicate the instruction is "jal", otherwise it's not
input MemOrIOtoReg; // 1 indicate write data memory, otherwise it's not
input RegDST; // 1 indicate destination register is "rd"(R),otherwise it's "rt"(I)
input Signed;
//read address
input [4:0] rs; // R-format's source or I-format's source
input [4:0] rt; // R-format's source or I-format's destination
input Jr; // get the return address in register[31], 1 indicates the instruction is "jr", otherwise it's not "jr" output Jmp;
//write address
input [4:0] rd; // R-format's destination
//write data
input[31:0] linkAddr; // store the address into ra register
input [15:0] immi; // the immediate in instruction[15:0] in I-format 
input[31:0] valueALU; // value comes from ALU
input[31:0] RegWriteData; // value comes from Memory or IO
//outputs
output reg [31:0] Data1; // output value 1, which goes to ALU directly or be the offset of jump
output reg [31:0] Data2; // output value 2, which can go to ALU or MemWriteData or extended immediate
output [31:0] extendedImmi;

reg [31:0] register[0:31];
reg start = 1'b0; // 1 indicate the program start,so that avoid adding value into register in the first posedge

assign extendedImmi = (Signed)?{{16{immi[15]}},immi}:{{16'b0},immi};

// execute the write back to regiter, register[27] used to control the choose of caseIndex, register[26] used to confirm the input
always @(posedge clock) begin
    if (reset) begin // initial the register memory
        register[0] <= 31'b0; register[1] <= 31'b0; register[2] <= 31'b0;
        register[3] <= 31'b0; register[4] <= 31'b0; register[5] <= 31'b0;
        register[6] <= 31'b0; register[7] <= 31'b0; register[8] <= 31'b0;
        register[9] <= 31'b0; register[10] <= 31'b0; register[11] <= 31'b0;
        register[12] <= 31'b0; register[13] <= 31'b0; register[14] <= 31'b0;
        register[15] <= 31'b0; register[16] <= 31'b0; register[17] <= 31'b0;
        register[18] <= 31'b0; register[19] <= 31'b0; register[20] <= 31'b0;
        register[21] <= 31'b0; register[22] <= 31'b0; register[23] <= 31'b0;
        register[24] <= 31'b0; register[25] <= 31'b0; register[26] <= 31'b0;
        register[27] <= 31'b0; register[28] <= 31'b0; register[29] <= 31'b0;
        register[30] <= 31'b0; register[31] <= 31'b0; start <= 1'b0;        //update
    end
    else begin
        register[27] <= index;
        if (register[26] != confirm)
            register[26] <= confirm; //used to confirm the input if finished
        if(!start)
            start <= 1'b1;
        else begin //update
            if (RegWrite) begin
                case(RegDST)
                    1'b1: register[rd] <= valueALU;
                    1'b0: register[rt] <= valueALU;
                endcase
            end 
            if (Jal) begin
                register[31] <= linkAddr;
            end    
            if (MemOrIOtoReg) begin
                register[rt] <= RegWriteData;
            end
        end
    end
end

// execute get value from regiter and tranmit the output to ALU or memory
always @* begin
    if (!reset)
        if(Jr) 
            Data1 <= register[31];
        else begin
            Data1 <= register[rs];
            Data2 <= register[rt];
        end
end
endmodule
