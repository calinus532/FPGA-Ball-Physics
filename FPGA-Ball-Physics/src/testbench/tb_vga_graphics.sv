`timescale 1ns / 1ps

module tb_vga_graphics ();
	
	logic clk=0, arst=1;
	
	logic HSYNC, VSYNC, VIDEOON;
	logic [9:0] pixelX, pixelY;
	
	vga_controller vga_inst (
		.clk(clk),
		.arst(arst),
		.HSYNC(HSYNC),
		.VSYNC(VSYNC),
		.VIDEOON(VIDEOON),
		.pixelX(pixelX),
		.pixelY(pixelY)
	);
	
	always #5 clk=~clk;
		
	initial begin						
		#20 arst=0;
		#17000000 $finish;
	end
	
endmodule