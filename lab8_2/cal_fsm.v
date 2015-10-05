`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:14:54 09/03/2015 
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
	 set,//switch 決定有沒有進入setting
	 in1,//button1 for setting hour or start/stop
	 in2,//button2 for setting minute or lap
	 state,
	 countupmin_enable,
	 countuphr_enable,
	 countdown_enable,
	 freeze//for lap鎖值
	 );

input clk;
input reset_n;
input set;
input in1;
input in2;
output [2:0] state;
output countupmin_enable;
output countuphr_enable;
output countdown_enable;
output freeze;

reg [2:0] state;
reg [2:0] next_state;
reg countupmin_enable;
reg countuphr_enable;
reg countdown_enable;
reg freeze;




always@(*)
begin
	if(~set)//set==1'b0
	begin
		case(state)
		3'b000://inital
		begin
			next_state=3'b100;//stop or reset
			countupmin_enable=1'b0;
			countuphr_enable=1'b0;
			countdown_enable=1'b0;
			freeze=1'b0;
		end
		3'b100://stop or reset
		begin
			if(in1)
			begin
				next_state=3'b010;//start
				countupmin_enable=1'b0;
				countuphr_enable=1'b0;
				countdown_enable=1'b1;
				freeze=1'b0;
			end
			else
			begin
				next_state=3'b100;
				countupmin_enable=1'b0;
				countuphr_enable=1'b0;
				countdown_enable=1'b0;
				freeze=1'b0;
			end
		end
		3'b010://start
		begin
			if(in1)
			begin
				next_state=3'b100;
				countupmin_enable=1'b0;
				countuphr_enable=1'b0;
				countdown_enable=1'b0;
				freeze=1'b0;
			end
			else if(in2)
			begin
				next_state=3'b001;//lap
				countupmin_enable=1'b0;
				countuphr_enable=1'b0;
				countdown_enable=1'b1;
				freeze=1'b1;
			end
			else
			begin
				next_state=3'b010;
				countupmin_enable=1'b0;
				countuphr_enable=1'b0;
				countdown_enable=1'b1;
				freeze=1'b0;
			end
		end
		3'b001://lap
		begin
			if(in2)
			begin
				next_state=3'b010;
				countupmin_enable=1'b0;
				countuphr_enable=1'b0;
				countdown_enable=1'b1;
				freeze=1'b0;
			end
			else
			begin
				next_state=3'b001;
				countupmin_enable=1'b0;
				countuphr_enable=1'b0;
				countdown_enable=1'b1;
				freeze=1'b1;
			end
		end
		default:
		begin
			next_state=3'b000;
			countupmin_enable=1'b0;
			countuphr_enable=1'b0;
			countdown_enable=1'b0;
			freeze=1'b0;
		end
		endcase
	end
	else
	begin
		case(state)
		3'b000://inital
		begin
			next_state=3'b100;//stop or reset
			countupmin_enable=1'b0;
			countuphr_enable=1'b0;
			countdown_enable=1'b0;
			freeze=1'b0;
		end
		3'b100://stop or reset
		begin
			if(in1)
			begin
				next_state=3'b110;//set hour
				countupmin_enable=1'b0;
				countuphr_enable=1'b1;
				countdown_enable=1'b0;
				freeze=1'b0;
			end
			else if(in2)
			begin
				next_state=3'b101;//set minute
				countupmin_enable=1'b1;
				countuphr_enable=1'b0;
				countdown_enable=1'b0;
				freeze=1'b0;
			end
			else
			begin
				next_state=3'b100;
				countupmin_enable=1'b0;
				countuphr_enable=1'b0;
				countdown_enable=1'b0;
				freeze=1'b0;
			end
		end
		3'b110://set hour
		begin
			if(in1)
			begin
				next_state=3'b100;
				countupmin_enable=1'b0;
				countuphr_enable=1'b0;
				countdown_enable=1'b0;
				freeze=1'b0;
			end
			else
			begin
				next_state=3'b110;
				countupmin_enable=1'b0;
				countuphr_enable=1'b1;
				countdown_enable=1'b0;
				freeze=1'b0;
			end
		end
		3'b101://set minute
		begin
			if(in2)
			begin
				next_state=3'b100;
				countupmin_enable=1'b0;
				countuphr_enable=1'b0;
				countdown_enable=1'b0;
				freeze=1'b0;
			end
			else
			begin
				next_state=3'b101;
				countupmin_enable=1'b1;
				countuphr_enable=1'b0;
				countdown_enable=1'b0;
				freeze=1'b0;
			end
		end
		default:
		begin
			next_state=3'b000;
			countupmin_enable=1'b0;
			countuphr_enable=1'b0;
			countdown_enable=1'b0;
			freeze=1'b0;
		end
		endcase	
	end
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
