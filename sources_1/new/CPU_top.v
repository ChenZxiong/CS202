`timescale 1ns / 1ps

module CPU_top(clock_in,FPGAReset,start_pg,rx,tx,confirm,index,IOReadData,IOData,control_led);
input clock_in;
input FPGAReset;
input start_pg;
input rx;
output tx;
input confirm; // switch
input [2:0] index; //switch
input [15:0] IOReadData; //switch
output [15:0] IOData; //led
output [5:0] control_led;

assign control_led = {confirm,start_pg,FPGAReset,index};

wire clock_out,clock_uart;
wire[31:0] Instruction, PCPlus4, linkAddr,AddrResult,Data1,Data2
            ,extendedImmi,ALUResult,RegWriteData,address,MemReadData
            ,writeData;
wire Jr,Jmp,Jal,Branch,nBranch,RegDST,MemOrIOtoReg,RegWrite,MemWrite,MemRead,IORead,IOWrite,ALUSrc,Sftmd,IFormat,Zero,LEDCtrl, SwitchCtrl,Signed;
wire[1:0] ALUOp;
wire reset;
// UART Programmer Pinouts
wire upg_clk_o;
wire upg_wen_o; //Uart write out enable
wire upg_done_o; //Uart rx data have done
//data to which memory unit of program_rom/dmemory32
wire [14:0] upg_adr_o;
//data to program_rom or dmemory32
wire [31:0] upg_dat_o;

wire spg_bufg;
BUFG U1(.I(start_pg), .O(spg_bufg)); // de-twitter
// Generate UART Programmer reset signal
reg upg_rst;
always @ (posedge clock_in) begin
if (spg_bufg) upg_rst = 0;
if (FPGAReset) upg_rst = 1;
end
//used for other modules which don't relate to UART
assign reset = FPGAReset|!upg_rst;

uart_bmpg_0 uart(.upg_clk_i(clock_uart),.upg_rst_i(upg_rst),.upg_rx_i(rx),.upg_clk_o(upg_clk_o),.upg_wen_o(upg_wen_o),.upg_adr_o(upg_adr_o),.upg_dat_o(upg_dat_o),.upg_done_o(upg_done_o),.upg_tx_o(tx));

led LED(reset,IOWrite,writeData,IOData);
CPUClock clock(.clk_in1(clock_in), .clk_out1(clock_out),.clk_out2(clock_uart));
IFetch ifetch(Instruction, PCPlus4, linkAddr, clock_out, reset, AddrResult,linkAddr, Branch, nBranch, Jmp, Jal, Jr, Zero,upg_rst,upg_clk_o,upg_wen_o&(!upg_adr_o[14]),upg_adr_o[13:0],upg_dat_o,upg_done_o);
ALU alu(reset,Data1,Data2,extendedImmi,Instruction[31:26],Instruction[5:0],Instruction[10:6],PCPlus4,ALUOp,ALUSrc,IFormat,Sftmd,Signed,ALUResult,Zero,AddrResult);
Decoder decoder(reset,clock_out,confirm,index,RegWrite,Jal,MemOrIOtoReg,RegDST,Signed,Instruction[25:21],Instruction[20:16],Jr,Instruction[15:11],linkAddr,Instruction[15:0],ALUResult,RegWriteData,Data1,Data2,extendedImmi);
DataMemory DRAM(MemWrite,address,writeData,MemReadData,clock_out);//update
MemOrIO MOR( MemRead, MemWrite, IORead, IOWrite,AddrResult, address, MemReadData, IOReadData, RegWriteData, Data2, writeData, LEDCtrl, SwitchCtrl);
controller control(Instruction[31:26],Instruction[5:0],AddrResult[31:10],Jr,Jmp,Jal,Branch,nBranch,RegDST,MemOrIOtoReg,RegWrite,MemWrite,MemRead,IORead,IOWrite,ALUSrc,Sftmd,IFormat,Signed,ALUOp);
endmodule
