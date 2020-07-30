`include "MONT_MUL.v"
`include "MONT_EXPRESS.v"
module MONT_TOP(x,y,n,n_len,clk,enable,rst,finish,result);

	input	[2047:0]	x;
	input	[2047:0]	y;
	input	[2047:0]	n;
	input	[10:0]		n_len;
	input				enable;
	input				clk;
	input				rst;

	output reg [2047:0] result;
	output reg 			finish;

	reg					mul_enable;
	reg 				express_enable;
	reg	 				mul_rst;
	reg					express_rst;
	reg		[1:0]		status;

	wire 				mul_finish;
	wire 				express_finish;
	wire	[2049:0]	mul_result;
	wire 	[2047:0]	express_result;

	MONT_MUL mul_u(.x(express_result),.y(y),.n(n),.n_len(n_len),.clk(clk),.rst(mul_rst),
					.enable(mul_enable),.result(mul_result),.finish(mul_finish));	
	MONT_EXPRESS express_u(.x(x),.n(n),.n_len(n_len),.clk(clk),.rst(express_rst),
							.enable(express_enable),.result(express_result),.finish(express_finish));

	parameter [2:0]  start = 2'b00, express = 2'b01, mont_mult = 2'b10, done = 2'b11;

	always@(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			mul_enable <= 0;
			express_enable <= 0;
			mul_rst <= 0;
			express_rst <= 0;
			result <= 0;
			finish <= 0;
			status <= start;
		end

		case (status)
			start:
				begin
					if(!rst)
					begin
						if(enable)
						begin
							express_enable <= 1;
							express_rst <= 1;
							status <= express;
						end
						else
							status <= start;
					end
				end

			express:
				begin
					if(!rst)
					begin
						express_rst <= 0;
						if(express_finish)
						begin
							mul_enable <= 1;
							mul_rst <= 1;
							status <= mont_mult;
						end
						else
							status <= express;
					end
				end

			mont_mult:
				begin
					if(!rst)
					begin
						mul_rst <= 0;
						if(mul_finish)
						begin
							result <= mul_result;
							status <= done;
						end
						else
							status <= mont_mult;
					end
				end

			done:
				begin
					if(!rst)
						begin
							express_enable <= 0;
							mul_enable <= 0;
							finish <= 1;
							status <= done;
						end
				end

			default: 
					status <= start;
		
		endcase

	end

endmodule
