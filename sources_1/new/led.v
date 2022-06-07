`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/20 11:33:08
// Design Name: 
// Module Name: led
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


module led(reset,IOWrite,writeData,IOData);
input reset;
input IOWrite;
input [31:0] writeData;
output reg [15:0] IOData;

always @* begin
    if(reset)
        IOData = 16'bZZZZZZZZ;
    if(IOWrite)
        IOData = writeData[15:0];
    else
        IOData = IOData;
end
endmodule
