`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:47:12 09/02/2015 
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
	 rst_n,
	 decrease,//�˼ƭp�ɾ��n���n-1
	 increase,//�X��n���n+1
	 value,
	 borrow,//-�⧹�F�S,�ǳƸ�min0��
	 over//�X��+�⧹�F�S,�ǳƶi��
	 );

input clk_out;
input rst_n;
input decrease;
input increase;
output [3:0] value;
output borrow;
output over;

reg borrow;
reg over;
reg [3:0] value;
reg [3:0] value_tmp;




always@(*)
begin
	if(value==4'd0 && decrease==1'b1)
	begin
		value_tmp=4'd5;
		borrow=1'b1;
		over=1'b0;
	end
	else if(value!=4'd0 && decrease==1'b1)
	begin
		value_tmp=value-4'd1;
		borrow=1'b0;
		over=1'b0;
	end
	else if(value==4'd5 && increase==1'b1)
	begin
		value_tmp=4'd0;
		borrow=1'b0;
		over=1'b1;
	end
	else if(value!=4'd5 && increase==1'b1)
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



always@(posedge clk_out or negedge rst_n)
begin
	if(~rst_n)
		value<=4'd0;

	else
		value<=value_tmp;
end


endmodule
