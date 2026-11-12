`timescale 1ns / 1ps

module tb_ball ();
	
	logic clk=0, arst=1; 
	logic [9:0] Bsize=100, Gravity=600, Dampen=999, Bounce=950, Bcount=3;
	
	logic [19:0] x [999:0];
	logic [18:0] y [999:0];
	logic signed [14:0] vx [999:0];
	logic signed [14:0] vy [999:0];
	logic [23:0] color [999:0];
	
	ball_manager manager_inst(
	    .clk(clk),
	    .arst(arst),
		.Bsize(Bsize),
		.Gravity(Gravity),
		.Dampen(Dampen),
		.Bounce(Bounce),
		.Bcount(Bcount),
		.X(x),
		.Y(y),
		.VX(vx),
		.VY(vy),
		.COLOR(color)
	);
	
	always #5 clk=~clk;
		
	initial begin						
		#20 arst=0;
		#17000000 $finish;
	end
	
endmodule