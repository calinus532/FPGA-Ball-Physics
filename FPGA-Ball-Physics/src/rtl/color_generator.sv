module color_generator (
		input clk,
		input arst,
		input ena,
		output reg [23:0] color
	);

	localparam RED=0, YELLOW=1, GREEN=2, CYAN=3, BLUE=4, MAGENTA=5;
	logic [2:0] state, next_state;
	
	always @(*) state <= next_state;
		
	always @(posedge clk, posedge arst) begin
		if(arst) begin next_state<=RED; color<=24'hFF0000; end
		else if(ena) begin
			case (state)
				RED: 
					if((color[15:8]+1)==8'd255) begin
						color[15:8] <= 8'd255;
						next_state<=YELLOW;
					end
					else color[15:8] <= color[15:8]+8'd2;
				YELLOW: 
					if((color[23:16]-1)==8'd0) begin
						color[23:16] <= 8'd0;
						next_state<=GREEN;
					end
					else color[23:16] <= color[23:16]-8'd2;
				GREEN: 
					if((color[7:0]+1)==8'd255) begin
						color[7:0] <= 8'd255;
						next_state<=CYAN;
					end
					else color[7:0] <= color[7:0]+8'd2;
				CYAN: 
					if((color[15:8]-1)==8'd0) begin
						color[15:8] <= 8'd0;
						next_state<=BLUE;
					end
					else color[15:8] <= color[15:8]-8'd2;
				BLUE: 
					if((color[23:16]+1)==8'd255) begin
						color[23:16] <= 8'd255;
						next_state<=MAGENTA;
					end
					else color[23:16] <= color[23:16]+8'd2;
				MAGENTA: 
					if((color[7:0]-1)==8'd0) begin
						color[7:0] <= 8'd0;
						next_state<=RED;
					end
					else color[7:0] <= color[7:0]-8'd2;
				default: begin
				    state <= RED;
				    color <= 24'hFF0000;
				end		
			endcase
		end
	end
	
endmodule