`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/06 10:31:04
// Design Name: 
// Module Name: MemoryOrIO
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


module MemOrIO( MemRead, MemWrite, IORead, IOWrite,AddrResult, address, MemReadData, IOReadData, RegWriteData, RegReadData, writeData, LEDCtrl, SwitchCtrl);
//controller
input MemRead; // read memory, from Controller, data from register
input MemWrite; // write memory, from Controller, data from register or IO
input IORead; // read IO, from Controller
input IOWrite; // write IO, from Controller, data from register or memory
//data and output
input[31:0] AddrResult; // from alu_result in ALU
output[31:0] address; // address to Data-Memory
input[31:0] MemReadData; // data read from Data-Memory
input[15:0] IOReadData; // data read from IO,16 bits
output reg [31:0] RegWriteData; // data to Decoder(register file)
input[31:0] RegReadData; // data read from Decoder(register file)
output reg[31:0] writeData; // data to memory or I/O£¨m_wdata, io_wdata£©
output LEDCtrl; // LED Chip Select
output SwitchCtrl; // Switch Chip Select

assign address = AddrResult;
// The data wirte to register file may be from memory or io. 
// While the data is from io, it should be the lower 16bit of RegWriteData. assign RegWriteData = £¿£¿£¿
// Chip select signal of Led and Switch are all active high;
assign LEDCtrl= (AddrResult == 32'hffff_fc60||AddrResult == 32'hffff_fc62) ? 1 : 0;
assign SwitchCtrl= (AddrResult == 32'hffff_fc70||AddrResult == 32'hffff_fc72) ? 1 : 0;
always @* begin
    if((MemWrite==1)||(IOWrite==1)) //the data to IO or memory just can come from register 
        writeData = RegReadData;
    else
        writeData = 32'hZZZZZZZZ;
    // Write data from memory or IO to register
    if (MemRead == 1)
        RegWriteData = MemReadData;
    else if (IORead)
        RegWriteData = {16'b0,IOReadData}; //update
end
endmodule
