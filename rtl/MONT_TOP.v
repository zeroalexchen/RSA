`include "MONT_MUL.v"
`include "MONT_N_LEN.v"
`include "MONT_EXPRESS.v"
module MONT_TOP(x,y,n,clk,enable,rst,finish,result);

	input	[2047:0]	x;
	input	[2047:0]	y;
	input	[2047:0]	n;
	input				enable;
	input				clk;
	input				rst;

	output reg [2047:0] result;
	output reg 			finish;

	reg					mul_enable;
	reg 				n_len_enable;
	reg 				express_enable;
	reg	 				mul_rst;
	reg 				n_len_rst;
	reg					express_rst;
	reg		[2:0]		status;

	wire 				mul_finish;
	wire 				n_len_finish;
	wire 				express_finish;
	wire	[2049:0]	mul_result;
	wire 	[10:0]		n_len_result;
	wire 	[2047:0]	express_result;

	MONT_MUL mul_u(.x(express_result),.y(y),.n(n),.n_len(n_len_result),.clk(clk),.rst(mul_rst),.enable(mul_enable),.result(mul_result),.finish(mul_finish));	
	MONT_N_LEN n_len_u(.n(n),.clk(clk),.rst(n_len_rst),.enable(n_len_enable),.result(n_len_result),.finish(n_len_finish));
	MONT_EXPRESS express_u(.x(x),.n(n),.n_len(n_len_result),.clk(clk),.rst(express_rst),.enable(express_enable),.result(express_result),.finish(express_finish));

	parameter [2:0]  start = 3'b000, n_length = 3'b001, express = 3'b010, mont_mult = 3'b011, done = 3'b100;

	always@(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			mul_enable <= 0;
			n_len_enable <= 0;
			express_enable <= 0;
			mul_rst <= 0;
			n_len_rst <= 0;
			express_rst <= 0;
			result <= 0;
			finish <= 0;
		end

		case (status)
			start:
				begin
					if(!rst)
					begin
						if(enable)
						begin
							n_len_enable <= 1;
							n_len_rst <= 1;
							status <= n_length;
						end
						else
							status <= start;
					end
				end

			n_length:
				begin
					if(!rst)
					begin
						n_len_rst <= 0;
						if(n_len_finish)
						begin
							n_len_enable <= 0;
							express_enable <= 1;
							express_rst <= 1;
							status <= express;
						end
						else
							status <= n_length;
					end
				end

			express:
				begin
					if(!rst)
					begin
						express_rst <= 0;
						if(express_finish)
						begin
							express_enable <= 0;
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
							mul_enable <= 0;
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
							finish <= 1;
							status <= done;
						end
				end

			default: 
					status <= start;
		
		endcase

	end

endmodule
