module ball_manager (
	    input clk,
	    input arst,
		input [9:0] Bsize,
		input [9:0] Gravity,
		input [9:0] Dampen,
		input [9:0] Bounce,
		input [9:0] Bcount,
		
		output [19:0] x [999:0],
		output [18:0] y [999:0],
		output signed [14:0] vx [999:0],
		output signed [14:0] vy [999:0]
	);
							   
	localparam maxCount = 1000;
	
	logic [19:0] X [maxCount-1:0];
	logic [18:0] Y [maxCount-1:0];
	logic signed [14:0] VX [maxCount-1:0];
	logic signed [14:0] VY [maxCount-1:0];
	
	logic [9:0] ballIdx;
	
	wire [19:0] xO;
    wire [18:0] yO;
    wire signed [14:0] vxO;
    wire signed [14:0] vyO;
	
	ball ballInst (
	    .xI(X[ballIdx]),
	    .yI(X[ballIdx]),
	    .vxI(VX[ballIdx]),	 
	    .vyI(VY[ballIdx]),	
	    .xO(xO),
	    .yO(yO),
	    .vxO(vxO),
	    .vyO(vyO)
	);
	
	logic state, next_state;
	parameter INIT=0, RUN=1;
	always @(*) state<=next_state;
		
	logic [19:0] randomValue;
	random_generator random_inst (clk, arst, randomValue);
	
	always_ff @(posedge clk, posedge arst) begin
        if (arst) begin ballIdx <= 0; next_state<=INIT; end
        else if(Bcount > 0) begin
			case (state)
				INIT: begin
					X[ballIdx]  <= randomValue % 639001;
			        Y[ballIdx]  <= randomValue % 479001;
			        VX[ballIdx] <= (randomValue % 20001) - 10000;
			        VY[ballIdx] <= (randomValue % 10001) - 5000;
				end
				RUN: begin
					X[ballIdx]  <= xO;
		            Y[ballIdx]  <= yO;
		            VX[ballIdx] <= vxO;
		            VY[ballIdx] <= vyO;
				end
			endcase								 
            if (ballIdx >= Bcount - 1) begin
                ballIdx <= 0;
				if(INIT) next_state<=RUN;
			end
            else
                ballIdx <= ballIdx + 1;
        end
    end
	
	assign x = X;
	assign y = Y;
	assign vx = VX;
	assign vy = VY;
	
endmodule