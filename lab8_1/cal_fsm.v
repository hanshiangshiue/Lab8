`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:52:16 09/02/2015 
// Design Name: 
// Module Name:    cal_fsm 
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
module cal_fsm(
    clk,
	 reset_n,
	 in1,//button1 for stop/start
	 in2,//button2 for lap/reset
	 count_enable,
	 freeze,
	 state
	 );


input clk;
input reset_n;
input in1;
input in2;
output count_enable;
output freeze;
output [2:0] state;

reg count_enable;
reg freeze;
reg [2:0] state;
reg [2:0] next_state;



always@(*)
begin
	case(state)
	3'b100://stop or reset
	begin
		if(in1)
		begin
			next_state=3'b010;
			count_enable=1'b1;
			freeze=1'b0;
		end
		else
		begin
			next_state=3'b100;
			count_enable=1'b0;
			freeze=1'b0;
		end
	end
	3'b010://start
	begin
		if(in1)
		begin
			next_state=3'b100;//stop
			count_enable=1'b0;
			freeze=1'b0;
		end
		else if(in2)
		begin
			next_state=3'b001;//lap
			count_enable=1'b1;
			freeze=1'b1;
		end
		else
		begin
			next_state=3'b010;
			count_enable=1'b1;
			freeze=1'b0;
		end
	end
	3'b001://lap
	begin
		if(in2)
		begin
			next_state=3'b010;
			count_enable=1'b1;
			freeze=1'b0;
		end
		else
		begin
			next_state=3'b001;
			count_enable=1'b1;
			freeze=1'b1;
		end
	end
	3'b000:
	begin
		next_state=3'b100;
		count_enable=1'b0;
		freeze=1'b0;
	end
	default:
	begin
		next_state=3'b000;
		count_enable=1'b0;
		freeze=1'b0;
	end
	endcase
end




always@(posedge clk or negedge reset_n)
begin
	if(~reset_n)
	begin
		if(state==3'b100)
			state<=3'b100;
		else
			state<=next_state;
	end
	else
	begin
		state<=next_state;
	end
end



endmodule
