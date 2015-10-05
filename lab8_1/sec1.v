`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:47:26 08/31/2015 
// Design Name: 
// Module Name:    sec1 
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
module sec1(
    clk_out,
	 reset_n,
	 increase,
	 state,
	 value,
	 over
	 );


input clk_out;
input reset_n;
input increase;
input [2:0] state;
output [3:0] value;
output over;

reg [3:0] value;
reg over;
reg [3:0] value_tmp;



always@(*)
begin
	if(value==4'd5 && increase==1'b1)
	begin
		value_tmp=4'd0;
		over=1'b1;
	end
	else if(value!=4'd5 && increase==1'b1)
	begin
		value_tmp=value+4'd1;
		over=1'b0;
	end
	else
	begin
		value_tmp=value;
		over=1'b0;
	end
end



always@(posedge clk_out or negedge reset_n)
begin
	if(~reset_n)
	begin
		if(state==3'b100)
			value<=4'd0;
		else
			value<=value_tmp;
	end
	else
		value<=value_tmp;
end



endmodule
