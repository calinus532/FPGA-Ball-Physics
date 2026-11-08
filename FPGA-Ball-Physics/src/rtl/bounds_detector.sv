module bounds_detector (
		input ena,
		input [9:0] Bsize,
		input signed [20:0] xI,
		input signed [19:0] yI,
		input signed [14:0] vxI,
		input signed [14:0] vyI,
		output reg [19:0] xO,
		output reg [18:0] yO,
		output reg signed [14:0] vxO,
		output reg signed [14:0] vyO
	);
	
	logic [19:0] radius;
	logic [19:0] xMax;
	logic [18:0] yMax;
	
	assign radius = Bsize * 500;
	assign xMax = 640000 - radius;
	assign yMax = 480000 - radius;

	always_comb begin
		xO = xI[19:0];
		yO = yI[18:0];
		vxO=vxI;
		vyO=vyI;
		
		if(ena) begin
			if(xI <= $signed({1'b0, radius})) begin xO = radius; if(vxI < 0) vxO = -vxI; end
			else if(xI >= $signed({1'b0, xMax}))	begin xO = xMax; if(vxI > 0) vxO = -vxI; end
			else begin xO = xI; vxO = vxI; end
			if(yI <= $signed({1'b0, radius})) begin yO = radius; if(vyI < 0) vyO = -vyI; end
			else if(yI >= $signed({1'b0, yMax}))	begin yO = yMax; if(vyI > 0) vyO = -vyI; end
			else begin yO = yI; vyO = vyI; end 
		end
	end
	
endmodule