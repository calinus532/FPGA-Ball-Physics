module ball_renderer (
		input ena,
		
		input  logic [19:0] xc,
	    input  logic [18:0] yc,
	    input  logic [9:0] Bsize,
		input  logic [23:0] prevRGB,
		input  logic [23:0] IRGB,
	
	    input  logic [9:0] pixelX,
	    input  logic [9:0] pixelY,
	
	    output logic [23:0] ORGB
	);

	logic [19:0] pixelX_scaled;
	logic [19:0] pixelY_scaled;
	
	logic signed [20:0] dx;
	logic signed [20:0] dy;
	
	logic signed [41:0] dx_squared;
	logic signed [41:0] dy_squared;
	
	logic [42:0] distance_squared;
	
	logic [19:0] radius;
	logic [39:0] radius_squared;
	
	assign pixelX_scaled = pixelX * 20'd1000;
	assign pixelY_scaled = pixelY * 20'd1000;
	
	assign dx = $signed({1'b0, pixelX_scaled})
	          - $signed({1'b0, xc});
	
	assign dy = $signed({1'b0, pixelY_scaled})
	          - $signed({2'b00, yc});
	
	assign dx_squared = dx * dx;
	assign dy_squared = dy * dy;
	
	assign distance_squared =
	    {1'b0, dx_squared} + {1'b0, dy_squared};
	
	assign radius = Bsize * 20'd500;
	assign radius_squared = radius * radius;
	
	always_comb begin
	    
		ORGB = prevRGB;
	
	    if(ena)
			if (distance_squared <= {3'b000, radius_squared})
		        ORGB = IRGB;
	
	end
	
endmodule