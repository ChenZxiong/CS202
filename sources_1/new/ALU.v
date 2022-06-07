`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/04 11:24:40
// Design Name: 
// Module Name: ALU
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


module ALU(reset,Data1,Data2,extendedImmi,Op,Func,Shamt,PCPlus4,ALUOp,ALUSrc,IFormat,Sftmd,Signed,ALUResult,Zero,AddrResult);
input reset;
// from Decoder
input[31:0] Data1; //the source of Ainput
input[31:0] Data2; //one of the sources of Binput
input[31:0] extendedImmi; //one of the sources of Binput
// from IFetch
input[5:0] Op; //instruction[31:26]
input[5:0] Func; //instructions[5:0]
input[4:0] Shamt; //instruction[10:6], the amount of shift bits
input[31:0] PCPlus4; //pc+4
// from Controller
input[1:0] ALUOp; //{ (R_format || I_format) , (Branch || nBranch) }
input ALUSrc; // 1 means the 2nd operand is an immediate (except beq,bne£©
input IFormat; // 1 means I-Type instruction except beq, bne, LW, SW
input Sftmd; // 1 means this is a shift instruction
input Signed;
//output
output reg [31:0] ALUResult; // the ALU calculation result
output reg Zero; // 1 means the ALU_reslut is zero, 0 otherwise
output reg [31:0] AddrResult; // the calculated instruction address

wire[31:0] A,B;
wire signed [31:0] signedA,signedB; // two operands for calculation
wire[5:0] ExeCode; // use to generate ALU_ctrl. (I_format==0) ? Function_opcode : { 3'b000 , Opcode[2:0] };
wire[2:0] ALUCtl; // the control signals which affact operation in ALU directely
//wire[2:0] Sftm; // identify the types of shift instruction, equals to Function_opcode[2:0]
reg[31:0] ShiftResult; // the result of shift operation
reg[31:0] ALUOutputMux; // the result of arithmetic or logic calculation
wire[32:0] BranchAddr; // the calculated address of the instruction, Addr_Result is Branch_Addr[31:0]

assign A = Data1;
assign signedA = Data1;
assign B = (ALUSrc == 0) ? Data2 : extendedImmi;
assign signedB = (ALUSrc == 0) ? Data2 : extendedImmi;
assign ExeCode = (IFormat == 0) ? Func:{ 3'b000,Op[2:0]};
assign ALUCtl[0] = (ExeCode[0] | ExeCode[3]) & ALUOp[1];
assign ALUCtl[1] = ((!ExeCode[2]) | (!ALUOp[1]));
assign ALUCtl[2] = (ExeCode[1] & ALUOp[1]) | ALUOp[0];

always @* begin
    if (!reset) begin
        if (ALUOp == 2'b10) begin // R_format or I_format except beq bne lw sw
            if (Sftmd == 1)
                case(Func[2:0])
                    3'b000: ShiftResult = B << Shamt; //sll
                    3'b010: ShiftResult = B >> Shamt; //srl
                    3'b100: ShiftResult = B << A; //sllv
                    3'b110: ShiftResult = B >> A; //srlv
                    3'b011: ShiftResult = signedB >>> Shamt; //sra
                    3'b111: ShiftResult = signedB >>> A;//srav
                endcase
            else
                case(ALUCtl)
                    3'b000: ALUOutputMux = A & B; //and
                    3'b001: ALUOutputMux = A | B; //or
                    3'b010: ALUOutputMux = signedA + signedB; //add
                    3'b011: ALUOutputMux = signedA + signedB; //addu
                    3'b100: ALUOutputMux = A ^ B; //xor
                    3'b101: ALUOutputMux = ~(A | B); //nor
                    3'b110: ALUOutputMux = signedA - signedB;//sub
                    3'b111: ALUOutputMux = signedA - signedB;//subu
                endcase
        end
        if (ALUOp == 2'b01) begin // beq bne
            Zero = (A - B == 0) ? 1:0;
            AddrResult = PCPlus4 + extendedImmi*4;
        end
        if (ALUOp == 2'b00) //sw lw
            AddrResult = A + B;
    end
end

always @* begin
    if (!reset)
        //set type operation (slt, slti, sltu, sltiu)
        if( (ALUCtl==3'b111) && (ExeCode[3]==1) || Op == 6'b001011 || Op == 6'b001010)
            if (Signed)
                ALUResult = (signedA < signedB) ?1:0;
            else 
                ALUResult = (A < B) ?1:0;
        //lui operation
        else if((ALUCtl==3'b101) && (IFormat==1))
            ALUResult[31:0]= B << 16;
        //shift operation
        else if(Sftmd==1)
            ALUResult = ShiftResult;
        //other types of operation in ALU (arithmatic or logic calculation)
        else
            ALUResult = ALUOutputMux;
end
endmodule
