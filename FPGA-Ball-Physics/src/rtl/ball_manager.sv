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
		output signed [14:0] vy [999:0],
		output [23:0] color [999:0]
	);
							   
	localparam maxCount = 1000;
	
	logic [19:0] X [maxCount-1:0];
	logic [18:0] Y [maxCount-1:0];
	logic signed [14:0] VX [maxCount-1:0];
	logic signed [14:0] VY [maxCount-1:0];
	logic [23:0] COLOR [maxCount-1:0];
	
	logic [9:0] ballIdx;
	logic [23:0] colorCounter;
	
	parameter INIT=0, RUN=1;
	logic state, next_state;
	
	logic colorEna;
	assign colorEna = state==INIT;
	
	logic physicsEna;
	assign physicsEna = state==RUN;
	
	always @(*) state<=next_state;
		
	logic [19:0] randomValue;
	random_generator random_inst (clk, arst, randomValue);
	
	color_generator colorInst (
		.clk(clk),
		.arst(arst),
		.ena(colorEna),
		.color(colorCounter)
	);
	
	logic signed [20:0] xO [1:0];
	logic signed [19:0] yO [1:0];
	logic signed [14:0] vxO [1:0];
	logic signed [14:0] vyO [1:0];
	
	physics_engine physicsInst (
		.ena(physicsEna),
		.dampen(Dampen),
		.gravity(Gravity),
		.xI(X[ballIdx]),
		.yI(Y[ballIdx]),
		.vxI(VX[ballIdx]),
		.vyI(VY[ballIdx]),
		.xO(xO[0]),
		.yO(yO[0]),
		.vxO(vxO[0]),
		.vyO(vyO[0])
	);
	
	bounds_detector boundsInst (
		.ena(physicsEna),
		.Bsize(Bsize),
		.xI(xO[0]),
		.yI(yO[0]),
		.vxI(vxO[0]),
		.vyI(vyO[0]),
		.xO(xO[1]),
		.yO(yO[1]),
		.vxO(vxO[1]),
		.vyO(vyO[1])
	);
	
	logic [19:0] radius;
	logic [19:0] xRange;
	logic [18:0] yRange;
	
	assign radius = Bsize * 500;
	assign xRange = 640001 - 2*radius;
	assign yRange = 480001 - 2*radius;
	
	always_ff @(posedge clk, posedge arst) begin
        if (arst) begin ballIdx <= 0; next_state<=INIT; end
        else if(Bcount > 0) begin
			case (state)
				INIT: begin
					X[ballIdx] <= radius + (randomValue % xRange);
					Y[ballIdx] <= radius[18:0] + (randomValue % yRange);
			        VX[ballIdx] <= (randomValue % 20001) - 10000;
			        VY[ballIdx] <= (randomValue % 10001) - 5000;
					COLOR[ballIdx] <= colorCounter;
				end
				RUN: begin
					X[ballIdx]  <= xO[1];
		            Y[ballIdx]  <= yO[1];
		            VX[ballIdx] <= vxO[1];
		            VY[ballIdx] <= vyO[1];
				end
			endcase								 
            if (ballIdx >= Bcount - 1) begin
                ballIdx <= 0;
				if(state==INIT) next_state<=RUN;
			end
            else
                ballIdx <= ballIdx + 1;
        end
    end
	
	assign x = X;
	assign y = Y;
	assign vx = VX;
	assign vy = VY;
	assign color = COLOR;
	
endmodule