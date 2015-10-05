`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:17:26 09/02/2015 
// Design Name: 
// Module Name:    stop_watch 
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
module stop_watch(
    clk,
	 button1,// for start/stop
	 button2,// for lap/reset
	 ftsd_ctl,
	 display,
	 state
	 );


input clk;
input button1;
input button2;
output [3:0] ftsd_ctl;
output [14:0] display;
output [2:0] state;

wire [1:0] clk_ctl;
wire clk_150;
wire clk_out;
wire pb_debounced1;
wire pb_debounced2;
wire reset_n;
wire out_pulse1;
wire out_pulse2;
wire en;
wire [3:0] second0;
wire sec1_en;
wire [3:0] second1;
wire min0_en;
wire [3:0] minute0;
wire min1_en;
wire [3:0] minute1;
wire [3:0] ftsd_in;
reg [3:0] in0;
reg [3:0] in1;
reg [3:0] in2;
reg [3:0] in3;
reg lock;
reg [3:0] sec0_tmp;
reg [3:0] sec1_tmp;
reg [3:0] min0_tmp;
reg [3:0] min1_tmp;
wire freeze;


always@(*)
begin
	if(freeze==1'b0)
	begin
		sec0_tmp=second0;
		sec1_tmp=second1;
		min0_tmp=minute0;
		min1_tmp=minute1;
	end
	else//freeze==1'b1
	begin
		sec0_tmp=sec0_tmp;
		sec1_tmp=sec1_tmp;
		min0_tmp=min0_tmp;
		min1_tmp=min1_tmp;
	end
end




always@(*)
begin
	if(state==3'b001)
	begin
		in0=min1_tmp;
		in1=min0_tmp;
		in2=sec1_tmp;
		in3=sec0_tmp;
	end
	else
	begin
		in0=minute1;
		in1=minute0;
		in2=second1;
		in3=second0;
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
	 .in1(out_pulse1),//button1 for stop/start
	 .in2(out_pulse2),//button2 for lap/reset
	 .count_enable(en),
	 .freeze(freeze),
	 .state(state)
	 );



sec0 u_sec0(
    .clk_out(clk_out),
	 .reset_n(reset_n),
	 .increase(en),//要不要+1
	 .state(state),
	 .value(second0),
	 .over(sec1_en)//算完了沒
	 );



sec1 u_sec1(
    .clk_out(clk_out),
	 .reset_n(reset_n),
	 .increase(sec1_en),
	 .state(state),
	 .value(second1),
	 .over(min0_en)
	 );



min0 u_min0(
    .clk_out(clk_out),
	 .reset_n(reset_n),
	 .increase(min0_en),
	 .state(state),
	 .value(minute0),
	 .over(min1_en)
	 );



min1 u_min1(
    .clk_out(clk_out),
	 .reset_n(reset_n),
	 .increase(min1_en),
	 .state(state),
	 .value(minute1)
	 );



scan_ctl sc1(
	.ftsd_ctl(ftsd_ctl),
	.ftsd_in(ftsd_in),
	.in0(in0),
	.in1(in1),
	.in2(in2),
	.in3(in3),
	.ftsd_ctl_en(clk_ctl)
    );



bcd2ftsegdec b1(
	.display(display),
	.bcd(ftsd_in)
    );



endmodule
