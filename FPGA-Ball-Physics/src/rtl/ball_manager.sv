module ball_manager #(parameter maxCount = 1000)(
	    input clk,
	    input arst,
		input update, 
		input [9:0] Bsize,
		input [9:0] Gravity,
		input [9:0] Dampen,
		input [9:0] Bounce,
		input [9:0] Bcount,
		
		output reg [19:0] X [maxCount-1:0],
		output reg [18:0] Y [maxCount-1:0],
		output reg signed [14:0] VX [maxCount-1:0],
		output reg signed [14:0] VY [maxCount-1:0],
		output reg [23:0] COLOR [maxCount-1:0]
	);
	
	
	logic [9:0] ballIdx;
	logic [23:0] colorCounter;
	
	parameter INIT=0, IDLE=1, RUN=2;
	logic[1:0] state;
	
	logic colorEna;
	assign colorEna = state==INIT;
	
	logic physicsEna;
	assign physicsEna = state==RUN;
		
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
        if (arst) begin ballIdx <= 0; state<=INIT; end
        else if(Bcount > 0) begin
			case (state)
				INIT: begin
					X[ballIdx] <= radius + (randomValue % xRange);
					Y[ballIdx] <= radius[18:0] + (randomValue % yRange);
			        VX[ballIdx] <= (randomValue % 20001) - 10000;
			        VY[ballIdx] <= (randomValue % 10001) - 5000;
					COLOR[ballIdx] <= colorCounter;
				end
				IDLE: state<=update?RUN:IDLE;
				RUN: begin
					X[ballIdx]  <= xO[1];
		            Y[ballIdx]  <= yO[1];
		            VX[ballIdx] <= vxO[1];
		            VY[ballIdx] <= vyO[1];
				end
				default: begin
				    ballIdx <= 0;
				    state <= INIT;
				end
			endcase								 
            if(state!=IDLE) begin
				if (ballIdx == Bcount - 1) begin
	                ballIdx <= 0;
					state <= IDLE;
				end
	            else
	                ballIdx <= ballIdx + 1;
			end
        end
    end
	
endmodule