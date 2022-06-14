`timescale 1ns / 1ps

module controller(Op,Func,AddrResultHigh,Jr,Jmp,Jal,Branch,nBranch,RegDST,MemOrIOtoReg,RegWrite,MemWrite,MemRead,IORead,IOWrite,ALUSrc,Sftmd,IFormat,Signed,ALUOp);
input[5:0] Op; // instruction[31..26], opcode
input[5:0] Func; // instructions[5..0], functionCode
input[21:0] AddrResultHigh; // From the execution unit Alu_Result[31..10]
output Jr ; // 1 indicates the instruction is "jr", otherwise it's not "jr" output Jmp;
output Jmp; // 1 indicates the instruction is "j"
output Jal; // 1 indicate the instruction is "jal", otherwise it's not
output Branch; // 1 indicate the instruction is "beq" , otherwise it's not
output nBranch; // 1 indicate the instruction is "bne", otherwise it's not
output RegDST; // 1 indicate destination register is "rd"(R),otherwise it's "rt"(I)
output MemOrIOtoReg; // 1 indicate read data from memory or IO and write it into register
output RegWrite; // 1 indicate write register(R,I(lw)), otherwise it's not
output MemWrite; // 1 indicate write data memory, otherwise it's not
output MemRead; // 1 indicates that the instruction needs to read from the
output IORead; // 1 indicates I/O read
output IOWrite; // 1 indicates I/O write
output ALUSrc; // 1 indicate the 2nd data is immidiate (I-format except "beq","bne")
output Sftmd; // 1 indicate the instruction is shift instruction
output IFormat;/* 1 indicate the instruction is I-type but isn't “beq","bne","LW" or "SW" */
output Signed; // 1 indicate the instruction use the signed value like add,sub,addi,slti,slt
output reg [1:0] ALUOp;/* if the instruction is R-type or I_format, ALUOp is 2'b10;
                    if the instruction is“beq” or “bne“, ALUOp is 2'b01；
                    if the instruction is“lw” or “sw“, ALUOp is 2'b00；*/
 
assign Jr = (Op == 6'b000000&&Func == 6'b001000)?1:0;
assign Jmp = (Op == 6'b000010)?1:0;        
assign Jal = (Op == 6'b000011)?1:0;
assign Branch = (Op == 6'b000100)?1:0;            
assign nBranch = (Op == 6'b000101)?1:0;          
assign RegDST = (Op == 6'b000000)?1:0;  
assign RegWrite = ((Op == 6'b100011)||Op[5:3]==3'b001||(Op == 6'b000000&&Func!=6'b001000))?1:0;
assign MemWrite = (Op == 6'b101011 && AddrResultHigh != 22'h3fffff)?1:0;
assign MemRead = (Op == 6'b100011 && AddrResultHigh != 22'h3fffff)?1:0;
assign IORead = (Op == 6'b100011 && AddrResultHigh == 22'h3fffff)?1:0;
assign IOWrite = (Op == 6'b101011 && AddrResultHigh == 22'h3fffff)?1:0; //update
assign ALUSrc = (Op != 6'b000000 && Op[5:1] != 5'b00001 && Op[5:1] != 5'b00010)?1:0;
assign Sftmd = (Op == 6'b000000&&Func[5:3] == 3'b000)?1:0;
assign IFormat = (Op[5:3] == 3'b001)?1:0;
assign Signed = ((Op == 6'b000000&& Func[5:2] == 4'b1001)|| Op[5:2] == 4'b0011)?0:1; //only logic operations are unsigned
assign MemOrIOtoReg = IORead||MemRead;//update

always @(*) begin
    if (Op == 6'b000000) 
        ALUOp = 2'b10; //R-format
    else begin
        case(Op)
            6'b100011:ALUOp = 2'b00; //lw
            6'b101011:ALUOp = 2'b00; //sw update
            6'b000100:ALUOp = 2'b01; //beq
            6'b000101:ALUOp = 2'b01; //bne
            default: ALUOp = 2'b10; //I-format
        endcase
    end
end
endmodule
