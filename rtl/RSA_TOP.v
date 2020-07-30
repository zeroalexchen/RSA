`include "MONT_TOP.v"
`include "MONT_LEN.v"
module RSA_TOP(c,e,n,enable,clk,sys_rst,result,finish);
	input 	[2047:0]	c;
	input	[2047:0]	e;
	input	[2047:0]	n;
	input				enable;
	input				clk;
	input				sys_rst;

	output reg [2047:0]	result;
	output reg  		finish;
	
	reg 	[2047:0]	temp_d1;
	reg 	[2047:0]	temp_d2;
	reg 	[10:0]		n_len;
	reg	 	[2047:0]	temp_len;
	reg		[10:0]		temp_e_len;
	reg 	[2:0]		status;
	reg 				mont_top_enable;
	reg 				mont_top_rst;
	reg					len_enable;
	reg			 		len_rst;
	
	wire 	[2047:0]	mont_top_result;
	wire 	[10:0]		len_result;
	wire 				mont_top_finish;
	wire 				len_finish;

    parameter [2:0] start = 3'b000, n_length = 3'b001, e_length = 3'b010, judge = 3'b011,
					exp_mul1 = 3'b100, exp_mul2 = 3'b101, done = 3'b110;	

	MONT_TOP mont_top_u(.x(temp_d1),.y(temp_d2),.n(n),.n_len(n_len),.clk(clk),.enable(mont_top_enable)
						,.rst(mont_top_rst),.finish(mont_top_finish),.result(mont_top_result));
	MONT_LEN len_u(.n(temp_len),.clk(clk),.rst(len_rst),.enable(len_enable),
						.result(len_result),.finish(len_finish));

	always@(posedge clk or posedge sys_rst)
	begin
		if(sys_rst)
		begin
			temp_d1 <= c;
			temp_d2 <= 0;
			temp_len <= n;
			temp_e_len <= 0;
			n_len <= 0;
			mont_top_enable <= 0;
			mont_top_rst <= 0;
			status <= start;
			result <= 0;
			finish <= 0;
		end

		case (status)
			start:
				begin
					if(!sys_rst)
					begin
						if(enable)
						begin
							len_enable <= 1;
							len_rst <= 1;
							if(n_len != 0)
							begin
								temp_len <= e;
								status <= e_length;
							end
							else
								status <= n_length;
						end
						else
							status <= start;
					end
				end

			n_length:
				begin
					if(!sys_rst)
					begin
						len_rst <= 0;
						if(len_finish)
						begin
							n_len <= len_result;
							status <= start;
						end
						else
							status <= n_length;
					end
				end

			e_length:
				begin
					if(!sys_rst)
					begin
						len_rst <= 0;
						if(len_finish)
						begin
							mont_top_enable <= 1;
							temp_e_len <= len_result;
							status <= judge;
						end
						else
							status <= e_length;
					end
				end

			judge:
				begin
					if(!sys_rst)
					begin
						if(temp_e_len != 0)
						begin
							temp_d2 <= temp_d1;
							mont_top_rst <= 1;
							status <= exp_mul1;
						end
						else
						begin
							result <= mont_top_result;
							status <= done;
						end
					end
				end

			exp_mul1:
				begin
					if(!sys_rst)
					begin
						mont_top_rst <= 0;
						if(mont_top_finish)
						begin
							temp_d1 <= mont_top_result;
							if(e[temp_e_len - 1] != 0)
							begin
								temp_d2 <= c;
								mont_top_rst <= 1;
								status <= exp_mul2;
							end
							else
							begin
								temp_e_len <= temp_e_len - 1;
								status <= judge;
							end
						end
						else
							status <= exp_mul1;
						
					end
				end

			exp_mul2:
				begin
					if(!sys_rst)
					begin
						mont_top_rst <= 0;
						if(mont_top_finish)
						begin
							temp_d1 <= mont_top_result;
							temp_e_len <= temp_e_len - 1;
							status <= judge;
						end
						else
							status <= exp_mul2;
					end
				end

			done:
				begin
					if(!sys_rst)
					begin
						mont_top_enable <= 0;
						len_enable <= 0;
						finish <= 1;
						status <= done;
					end
				end

			default: 
					status <= start;
		endcase
	end

endmodule