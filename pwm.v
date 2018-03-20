module top(
	input clk,
	input en,
	input rst,
	input dir,
	input freq,
	input f_en,
	output d1,
	output d2,
	output d3,
	output d4,
	output d5
);

reg [7:0] sin [0:31];
initial begin
  sin[0] = 8'h97;
  sin[1] = 8'hAF;
  sin[2] = 8'hC5;
  sin[3] = 8'hD8;
  sin[4] = 8'hE8;
  sin[5] = 8'hF4;
  sin[6] = 8'hFB;
  sin[7] = 8'hFE;
  sin[8] = 8'hFB;
  sin[9] = 8'hF4;
  sin[10] = 8'hE8;
  sin[11] = 8'hD8;
  sin[12] = 8'hC5;
  sin[13] = 8'hAF;
  sin[14] = 8'h97;
  sin[15] = 8'h7F;
  sin[16] = 8'h66;
  sin[17] = 8'h4E;
  sin[18] = 8'h38;
  sin[19] = 8'h25;
  sin[20] = 8'h15;
  sin[21] = 8'h09;
  sin[22] = 8'h02;
  sin[23] = 8'h00;
  sin[24] = 8'h02;
  sin[25] = 8'h09;
  sin[26] = 8'h15;
  sin[27] = 8'h25;
  sin[28] = 8'h38;
  sin[29] = 8'h4E;
  sin[30] = 8'h66;
  sin[31] = 8'h7E;
end

wire clk,en,rst,dir,f_en,freq;
localparam BITS = 4;
localparam DELAY = 14; // implement as signal
localparam COUNT = DELAY+BITS;
reg [COUNT-1:0] count;
reg [5:0] inner;
reg [BITS-1:0] speed;
reg [BITS-1:0] buffer;
reg [2:0] bufc;
reg r;

always @ (posedge clk) begin : Pwm
	if (rst == 1'b1) begin : Reset
		d5 <= 1'b0;
		inner <= #1 4'b0000;
	end else begin 
		d5 <= 1'b1;
//		d5 <= f_en;
		if (en == 1'b1) begin : Enable
			count <= #1 count + 1;
			if (count == 1 << DELAY) inner <= #1 inner + 1;
//			if (count*speed == DELAY) inner <= #1 inner + 1;
			r <= dir ? 1 : 0;
			d1 <= (count >> COUNT-8  < sin[inner+1*8*(1-2*r)%32]) ? 1'b1 : 1'b0;
			d2 <= (count >> COUNT-8  < sin[inner+2*8*(1-2*r)%32]) ? 1'b1 : 1'b0;
			d3 <= (count >> COUNT-8  < sin[inner+3*8*(1-2*r)%32]) ? 1'b1 : 1'b0;
			d4 <= (count >> COUNT-8  < sin[inner+4*8*(1-2*r)%32]) ? 1'b1 : 1'b0;
		end
	end
end

always @ (posedge f_en) begin : Receive
	if (rst == 1'b1) begin
		buffer <= #1 4'b0000;
		speed <= #1 4'b0000;
		bufc <= #1 3'b000;
	end else begin 
		if (en == 1'b1) begin
			buffer <= {buffer[2:0], freq};
			bufc <= #1 bufc + 1;
			if (bufc == 3) begin
				speed <= #1 {buffer[2:0], freq};
				bufc <= 3'b000;
			end
		end
	end
end

//assign {d1, d2, d3, d4} = speed;


endmodule
