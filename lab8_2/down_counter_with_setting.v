`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:10:09 09/03/2015 
// Design Name: 
// Module Name:    down_counter_with_setting 
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
module down_counter_with_setting(
    clk,
	 button1,
	 button2,
	 show,//switch for display 小時:分 or --:秒
	 set,
	 ftsd_ctl,
	 display,
	 LED
	 );


input clk;
input button1;
input button2;
input show;
input set;
output [3:0] ftsd_ctl;
output [14:0] display;
output [15:0] LED;

wire [1:0] clk_ctl;
wire clk_150;
wire clk_out;
wire pb_debounced1;
wire pb_debounced2;
wire reset_n;
wire out_pulse1;
wire out_pulse2;
wire [2:0] state;
wire cupmin_en;
wire cuphr_en;
wire cdown_en;
wire freeze;
wire [3:0] second0;
wire [3:0] second1;
wire [3:0] minute0;
wire [3:0] minute1;
wire [3:0] hour0;
wire [3:0] hour1;
wire sec1de;
wire min0de;
wire min1in;
wire min1de;
wire hr0de;
wire re;
wire hr1in;
wire hr1de;
wire [3:0] ftsd_in;
reg [3:0] in0;
reg [3:0] in1;
reg [3:0] in2;
reg [3:0] in3;
reg [3:0] sec0_tmp;
reg [3:0] sec1_tmp;
reg [3:0] min0_tmp;
reg [3:0] min1_tmp;
reg [3:0] hour0_tmp;
reg [3:0] hour1_tmp;



always@(*)//lap
begin
	if(freeze==1'b0)
	begin
		sec0_tmp=second0;
		sec1_tmp=second1;
		min0_tmp=minute0;
		min1_tmp=minute1;
		hour0_tmp=hour0;
		hour1_tmp=hour1;
	end
	else//freeze==1'b1
	begin
		sec0_tmp=sec0_tmp;
		sec1_tmp=sec1_tmp;
		min0_tmp=min0_tmp;
		min1_tmp=min1_tmp;
		hour0_tmp=hour0_tmp;
		hour1_tmp=hour1_tmp;
	end
end




always@(*)//14 segment displays
begin
	if(show==1'b0)//顯示小時:分
	begin
		if(state==3'b001)
		begin
			in0=hour1_tmp;
			in1=hour0_tmp;
			in2=min1_tmp;
			in3=min0_tmp;
		end
		else
		begin
			in0=hour1;
			in1=hour0;
			in2=minute1;
			in3=minute0;
		end
	end
	else//show==1'b1 顯示--:秒
	begin
		if(state==3'b001)
		begin
			in0=4'd13;
			in1=4'd13;
			in2=sec1_tmp;
			in3=sec0_tmp;
		end
		else
		begin
			in0=4'd13;
			in1=4'd13;
			in2=second1;
			in3=second0;
		end
	end
		
end




freq_div f1(
	.clk_ctl(clk_ctl),
	.clk(clk),
	.clk_150(clk_150),
	.clk_out(clk_out)
	);


debounce d1(
	.clk_150(clk_150),
	.pb_in(button1),
	.pb_debounced(pb_debounced1)
	);


debounce d2(
	.clk_150(clk_150),
	.pb_in(button2),
	.pb_debounced(pb_debounced2)
	);



pressed_reset p1(
    .clk_out(clk_out),
	 .in_trig(pb_debounced2),
	 .reset_n(reset_n)
	 );


one_pulse o1(
	.clk(clk),
	.reset_n(reset_n),
	.in_trig(pb_debounced1),
	.out_pulse(out_pulse1)
	);



one_pulse o2(
	.clk(clk),
	.reset_n(reset_n),
	.in_trig(pb_debounced2),
	.out_pulse(out_pulse2)
	);
	
cal_fsm cfsm(
    .clk(clk),
	 .reset_n(reset_n),
	 .set(set),//switch 決定有沒有進入setting
	 .in1(out_pulse1),//button1 for setting hour or start/stop
	 .in2(out_pulse2),//button2 for setting minute or lap
	 .state(state),
	 .countupmin_enable(cupmin_en),
	 .countuphr_enable(cuphr_en),
	 .countdown_enable(cdown_en),
	 .freeze(freeze)//for lap鎖值
	 );	


sec0 u_sec0(
	 .clk_out(clk_out),
	 .reset_n(reset_n),
	 .decrease(cdown_en),//要不要-1
	 .state(state),
	 .second1(second1),
	 .minute0(minute0),
	 .minute1(minute1),
	 .hour0(hour0),
	 .hour1(hour1),
	 .value(second0),
	 .over(sec1de),//-算完了沒,準備跟sec1借
	 .LED(LED)
	 );




sec1 u_sec1(
    .clk_out(clk_out),
	 .reset_n(reset_n),
	 .decrease(sec1de),//要不要-1
	 .state(state),
	 .value(second1),
	 .over(min0de)//-算完了沒
	 );


min0 u_min0(
    .clk_out(clk_out),
	 .reset_n(reset_n),
	 .decrease(min0de),//要不要-1
	 .increase(cupmin_en),//要不要+1
	 .state(state),
	 .value(minute0),
	 .over(min1in),//+算完了沒 準備進位
	 .borrow(min1de)//-算完了沒 準備借上一位的
	 );



min1 u_min1(
    .clk_out(clk_out),
	 .reset_n(reset_n),
	 .decrease(min1de),
	 .increase(min1in),
	 .state(state),
	 .value(minute1),
	 .borrow(hr0de)
	 );



hour0 u_hour0(
    .clk_out(clk_out),
	 .reset_n(reset_n),
	 .decrease(hr0de),
	 .increase(cuphr_en),
	 .re(re),
	 .state(state),
	 .value(hour0),
	 .over(hr1in),
	 .borrow(hr1de)
	 );
	 



hour1 u_hour1(
    .clk_out(clk_out),
	 .reset_n(reset_n),
	 .decrease(hr1de),
	 .increase(hr1in),
	 .state(state),
	 .value(hour1),
	 .re(re)
	 );


scan_ctl sc1(
	.ftsd_ctl(ftsd_ctl), // ftsd display control signal 
	.ftsd_in(ftsd_in), // output to ftsd display
	.in0(in0), // 1st input
	.in1(in1), // 2nd input
	.in2(in2), // 3rd input
	.in3(in3), // 4th input
	.ftsd_ctl_en(clk_ctl) // divided clock for scan control
    );



bcd2ftsegdec b1(
	.display(display), // 14-segment display output
	.bcd(ftsd_in) // BCD input
    );
	 

endmodule
