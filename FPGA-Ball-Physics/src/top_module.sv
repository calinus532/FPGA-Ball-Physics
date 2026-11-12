module FPGA_Ball_Physics(
		input clk,
		input arst,
		input [9:0] Bsize,
		input [9:0] Gravity,
		input [9:0] Dampen,
		input [9:0] Bounce,
		input [9:0] Bcount,
		output HSYNC,
		output VSYNC,
		output VIDEOON,
		output [23:0] outColor
	);
	
	localparam maxCount = 1000;
	
	logic update;
	
	logic [19:0] x [maxCount-1:0];
	logic [18:0] y [maxCount-1:0];
	logic [23:0] color [maxCount-1:0];
	
	ball_manager manager_inst(
		.clk(clk),
	    .arst(arst),
		.update(update),
		.Bsize(Bsize),
		.Gravity(Gravity),
		.Dampen(Dampen),
		.Bounce(Bounce),
		.Bcount(Bcount),
		.X(x),
		.Y(y),
		.COLOR(color)
	);
	
	logic [9:0] pixelX;
	logic [9:0] pixelY;
	
	vga_controller vga_inst(
		.clk(clk),
	    .arst(arst),
		.update(update),
		.HSYNC(HSYNC),
		.VSYNC(VSYNC),
		.VIDEOON(VIDEOON),
		.pixelX(pixelX),
		.pixelY(pixelY)
	);
	
	logic [23:0] outColors [maxCount:0];
	assign outColors[0] = 24'h000000;
	
	genvar i;
	generate
	    for (i = 0; i < maxCount; i = i + 1) begin
			ball_renderer rend_inst (
				.ena(i<Bcount),
				.xc(x[i]),
	            .yc(y[i]),
	            .Bsize(Bsize),
	            .prevRGB(outColors[i]),
	            .IRGB(color[i]),
	            .pixelX(pixelX),
	            .pixelY(pixelY),
	            .ORGB(outColors[i+1])
	        );
	    end
	endgenerate
	
	assign outColor = VIDEOON ? outColors[Bcount] : 24'h000000;
		
endmodule