`timescale 1ns / 1ps

module tb_ball ();
	
	logic clk=0, arst=1; 
	parameter Bsize=100, Gravity=0, Dampen=0, Bounce=0, Bcount=1000;
	
	logic [19:0] x [999:0];
	logic [18:0] y [999:0];
	logic signed [14:0] vx [999:0];
	logic signed [14:0] vy [999:0];
	
	ball_manager manager_inst(
	    .clk(clk),
	    .arst(arst),
		.Bsize(Bsize),
		.Gravity(Gravity),
		.Dampen(Dampen),
		.Bounce(Bounce),
		.Bcount(Bcount),
		.x(x),
		.y(y),
		.vx(vx),
		.vy(vy)
	);
	
	always #5 clk=~clk;
		
	initial begin						
		#20 arst=0;
		#10000 $finish;
	end
	
endmodule