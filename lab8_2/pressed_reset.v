`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:25:05 08/24/2015 
// Design Name: 
// Module Name:    pressed_reset 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module pressed_reset(
    clk_out,
	 in_trig,
	 reset_n
	 );


input clk_out;
input in_trig;
output reset_n;

reg reset_n;
reg in_trig_delay;
wire reset_n_next;

always@(posedge clk_out)
begin
	in_trig_delay<=in_trig;
end


assign reset_n_next=in_trig_delay & in_trig;


always@(posedge clk_out)
begin
	reset_n<=~reset_n_next;
end


endmodule
