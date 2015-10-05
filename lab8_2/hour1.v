`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:47:38 09/03/2015 
// Design Name: 
// Module Name:    hour1 
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
module hour1(
    clk_out,
	 reset_n,
	 decrease,
	 increase,
	 state,
	 value,
	 over,
	 borrow,
	 re
	 );

input clk_out;
input reset_n;
input decrease;
input increase;
input [2:0] state;
output [3:0] value;
output over;
output borrow;
output re;//§ó·shour0 23:00 -> 00:00

reg [3:0] value;
reg [3:0] value_tmp;
reg over;
reg borrow;
reg re;
reg re_next;

always@(*)
begin
	if(value==4'd0 && decrease==1'b1)
	begin
		value_tmp=4'd2;
		borrow=1'b1;
		over=1'b0;
	end
	else if(value!=4'd0 && decrease==1'b1)
	begin
		value_tmp=value-4'd1;
		borrow=1'b0;
		over=1'b0;
	end
	else if(value==4'd2 && increase==1'b1)
	begin
		value_tmp=4'd0;
		borrow=1'b0;
		over=1'b1;
	end
	else if(value!=4'd2 && increase==1'b1)
	begin
		value_tmp=value+4'd1;
		borrow=1'b0;
		over=1'b0;
	end
	else
	begin
		value_tmp=value;
		borrow=1'b0;
		over=1'b0;
	end
end



always@(*)
begin
	if(value==4'd2)
		re_next=1'b1;
	else
		re_next=1'b0;
end




always@(posedge clk_out or negedge reset_n)
begin
	if(~reset_n)
	begin
		if(state==3'b100)
		begin
			value<=4'd0;
			re<=1'b0;
		end
		else
		begin
			value<=value_tmp;
			re<=re_next;
		end
	end
	else
	begin
		value<=value_tmp;
		re<=re_next;
	end
end



endmodule
