`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/02 14:54:17
// Design Name: 
// Module Name: DataMemory
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


module DataMemory(MemWrite,address,writeData,MemReadData,clock);
input MemWrite;
// the address of memory unit which is to be
// read/writen
input[31:0] address;
// data to be wirten to the memory unit
input[31:0] writeData;
/*data to be read from the memory unit, in the left
screenshot its name is 'MemData' */
output[31:0] MemReadData;
input clock; // Clock signal
/* used to determine to write the memory unit or not,
in the left screenshot its name is 'WE' */
wire clk;
assign clk = !clock;

DRAM ram(.clka(clk),.wea(MemWrite),.addra(address[15:2]),.dina(writeData),.douta(MemReadData));

endmodule
