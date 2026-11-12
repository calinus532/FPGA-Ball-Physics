`timescale 1ns / 1ps

module tb_top_module ();
	
	logic clk=0, arst=1; 
	logic [9:0] Bsize=100, Gravity=600, Dampen=999, Bounce=950, Bcount=3;
	
	FPGA_Ball_Physics top_inst(
	    .clk(clk),
	    .arst(arst),
		.Bsize(Bsize),
		.Gravity(Gravity),
		.Dampen(Dampen),
		.Bounce(Bounce),
		.Bcount(Bcount)
	);
	
	always #5 clk=~clk;
		
	initial begin						
		#20 arst=0;
		#100000 $finish;
	end
	
endmodule