module vga_controller (
		input clk,
		input arst,
		output update,
		output HSYNC,
		output VSYNC,
		output VIDEOON,
		output logic [9:0] pixelX,
		output logic [9:0] pixelY
	);
	
	localparam H_DISPLAY    = 8;//640;
	localparam H_FRONT_PORCH = 2;//16;
	localparam H_SYNC_PULSE  = 2;//96;
	localparam H_BACK_PORCH  = 2;//48;
	localparam H_TOTAL       = H_DISPLAY+H_FRONT_PORCH+H_SYNC_PULSE+H_BACK_PORCH;
	
	localparam V_DISPLAY    = 4;//480;
	localparam V_FRONT_PORCH = 1;//10;
	localparam V_SYNC_PULSE  = 1;//2;
	localparam V_BACK_PORCH  = 1;//33;
	localparam V_TOTAL       = V_DISPLAY+V_FRONT_PORCH+V_SYNC_PULSE+V_BACK_PORCH;

	logic ena;
	logic [1:0] cnt;
	
	always_ff @(posedge clk, posedge arst) begin
		if(arst) begin ena<=0; cnt<=0; end
		else begin
			cnt <= cnt+1;
			if(cnt==3) begin
				cnt<=0;
				ena<=1;
			end
			else ena<=0;
		end
	end
	
	logic [9:0] hcount, vcount;
	always_ff @(posedge clk, posedge arst) begin
		if(arst) begin hcount<=0; vcount<=0; end
		else if(ena) begin
			hcount<=hcount+1;
			if(hcount==H_TOTAL-1) begin
				hcount<=0;
				vcount<=vcount+1;
				if(vcount==V_TOTAL-1) 
					vcount<=0;
			end
		end
	end
	
	assign update = ena && (hcount == 0) && (vcount == V_DISPLAY);
	assign pixelX = hcount;
	assign pixelY = vcount;
	assign HSYNC = ~((hcount >= H_DISPLAY+H_FRONT_PORCH)&&(hcount < H_DISPLAY+H_FRONT_PORCH+H_SYNC_PULSE));
	assign VSYNC = ~((vcount >= V_DISPLAY+V_FRONT_PORCH)&&(vcount < V_DISPLAY+V_FRONT_PORCH+V_SYNC_PULSE));
	assign VIDEOON = (hcount<H_DISPLAY)&&(vcount<V_DISPLAY);
	
endmodule