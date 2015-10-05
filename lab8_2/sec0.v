`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:45:13 09/02/2015 
// Design Name: 
// Module Name:    sec0 
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
module sec0(
	 clk_out,
	 reset_n,
	 decrease,//要不要-1
	 state,
	 second1,
	 minute0,
	 minute1,
	 hour0,
	 hour1,
	 value,
	 over,//-算完了沒,準備跟sec1借
	 LED
	 );

input clk_out;
input reset_n;
input decrease;
input [2:0] state;
input [3:0] second1;
input [3:0] minute0;
input [3:0] minute1;
input [3:0] hour0;
input [3:0] hour1;
output [3:0] value;
output over;
output [15:0] LED;

reg over;
reg [15:0] LED;
reg [3:0] value;
reg [3:0] value_tmp;
reg unable;//全部倒數完了沒




always@(*)
begin
	if(hour1==4'd0 && hour0==4'd0 && minute0==4'd0 && minute1==4'd0 && second1==4'd0)
	begin
		unable=1'b1;
	end
	else
	begin
		unable=1'b0;
	end
end






always@(*)
begin
	if(value==4'd0 && decrease==1'b1 && unable==1'b1)
	begin
		value_tmp=4'd0;
		over=1'b0;
		LED=16'b1111_1111_1111_1111;
	end
	else if(value==4'd0 && decrease==1'b1)
	begin
		value_tmp=4'd9;
		over=1'b1;
		LED=16'b0000_0000_0000_0000;
	end
	else if(value!=4'd0 && decrease==1'b1)
	begin
		value_tmp=value-4'd1;
		over=1'b0;
		LED=16'b0000_0000_0000_0000;
	end
	else
	begin
		value_tmp=value;
		over=1'b0;
		LED=16'b0000_0000_0000_0000;
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
