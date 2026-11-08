module ball (				   
		input [19:0] xI,
		input [18:0] yI,
		input signed [14:0] vxI,
		input signed [14:0] vyI,				   
		output reg [19:0] xO,
		output reg [18:0] yO,
		output reg signed [14:0] vxO,
		output reg signed [14:0] vyO
	); 
	
	always_ff @(*) begin
		xO <= xI;
		yO <= yI;
		vxO <= vxI;
		vyO <= vyI;	
	end
	
endmodule