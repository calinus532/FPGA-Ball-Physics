module physics_engine (
		input ena,
		input [9:0] dampen,
		input [9:0] gravity,
		input [19:0] xI,
		input [18:0] yI,
		input signed [14:0] vxI,
		input signed [14:0] vyI,
		output reg signed [20:0] xO,
		output reg signed [19:0] yO,
		output reg signed [14:0] vxO,
		output reg signed [14:0] vyO
	);
	
	logic signed [25:0] vxProduct;
	logic signed [25:0] vyProduct;
	
	always_comb begin
		xO = xI;
	    yO = yI;
	    vxO = vxI;
	    vyO = vyI;
		
		vxProduct = 26'sd0;
    	vyProduct = 26'sd0;
	
	    if (ena) begin
			vxProduct = $signed({{11{vxI[14]}}, vxI}) *
                    $signed({16'b0, dampen});

	        vyProduct = $signed({{11{vyI[14]}}, vyI}) *
	                    $signed({16'b0, dampen});
	
	        vxO = vxProduct / 26'sd1000;
	        vyO = vyProduct / 26'sd1000 + $signed({16'b0, gravity});
	        xO = $signed({1'b0, xI}) + $signed({{6{vxO[14]}}, vxO});
	        yO = $signed({1'b0, yI}) + $signed({{5{vyO[14]}}, vyO});
    	end
	end
	
endmodule