module random_generator (
		input clk,
		input arst,
		output [19:0] out	
	);
	
	logic [19:0] state;

    assign out = state;

    always_ff @(posedge clk or posedge arst) begin
        if (arst)
            state <= 20'h00001;
        else
            state <= {state[18:0], state[19] ^ state[2]};
    end

	
endmodule