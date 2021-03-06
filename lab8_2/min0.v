`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:55:03 09/02/2015 
// Design Name: 
// Module Name:    min0 
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
module min0(
    clk_out,
	 reset_n,
	 decrease,//要不要-1
	 increase,//要不要+1
	 state,
	 value,
	 over,//+算完了沒 準備進位
	 borrow//-算完了沒 準備借上一位的
	 );

input clk_out;
input reset_n;
input decrease;
input increase;
input [2:0] state;
output [3:0] value;
output over;
output borrow;


reg [3:0] value;
reg [3:0] value_tmp;
reg over;
reg borrow;


always@(*)
begin
	if(value==4'd0 && decrease==1'b1)
	begin
		value_tmp=4'd9;
		over=1'b0;
		borrow=1'b1;
	end
	else if(value!=4'd0 && decrease==1'b1)
	begin
		value_tmp=value-4'd1;
		over=1'b0;
		borrow=1'b0;
	end
	else if(value==4'd9 && increase==1'b1)
	begin
		value_tmp=4'd0;
		over=1'b1;
		borrow=1'b0;
	end
	else if(value!=4'd9 && increase==1'b1)
	begin
		value_tmp=value+4'd1;
		over=1'b0;
		borrow=1'b0;
	end
	else
	begin
		value_tmp=value;
		over=1'b0;
		borrow=1'b0;
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
