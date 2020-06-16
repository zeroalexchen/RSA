`include "MONT_MUL.v"
module MONT_EXP(c,e,n,clk,sys_rst,result,finish);
	input 	[2047:0] 	c;
	input 	[2047:0] 	e;
	input 	[2047:0] 	n;
	input				clk;
	input				sys_rst;

	output	reg [2047:0]	result;
	output  reg 			finish;

	reg 	[2047:0]	temp_d1;
	reg 	[2047:0]	temp_d2;
	reg 	[2047:0]	temp_e;
	reg 				mm_rst;
	reg 	[2:0]		status;
	reg 	[10:0]		i;
	reg 	[2047:0]	e_top;
	wire	[2047:0]	mm_result;
	wire 				mm_finish;

    parameter [2:0] start = 3'b000, judge = 3'b001, exp_mul1 = 3'b010, exp_mul2 = 3'b011 , done = 3'b100;	

	MONT_MUL mont_mul(.x(temp_d1),.y(temp_d2),.n(n),.clk(clk),.mm_rst(mm_rst),.mm_finish(mm_finish),.result(mm_result));

always@(posedge clk or posedge sys_rst) begin
	if(sys_rst) begin
		temp_d1 <= c;
		temp_d2 <= 0;
		temp_e <= e;
		result <= 0;
		e_top <= 0;
		i      <= 0;
		finish <= 0;
		mm_rst <= 0;
		status <= start;
	end
	case (status)
		start: begin
			if (!sys_rst) 
			mm_rst <= 1;
			begin
				if(i < 11)
				begin
					temp_e <= (temp_e | (temp_e >> ( 2**i )));
					i <= i + 1;
					status <= start;
				end
				else
				begin
					temp_d1 <= c;
					e_top = (temp_e + 1) >> 2;
					temp_e <= e;
					status <= judge;	
				end
					
			end	
		end

		judge: begin
			if(!sys_rst)
			begin
				if(e_top != 0)
				begin
					temp_d2 <= temp_d1;
					mm_rst <= 1;
					status <= exp_mul1;					
				end
				else
					status <= done;
			end
		end

		exp_mul1: begin
			if(!sys_rst)
			begin
				mm_rst <= 0;
				if(mm_finish) begin
					temp_d1 <= mm_result;
					if((e & e_top) != 0) begin
						temp_d2 <= c;
						mm_rst <= 1;
						status <= exp_mul2;
					end
					else begin
						e_top = e_top >> 1;
						status <= judge;
					end
				end
				else
					status <= exp_mul1;
			end		
		end

		exp_mul2: begin
			if(!sys_rst)
			mm_rst <= 0;
			begin
				if(mm_finish) begin
					temp_d1 <= mm_result;
					e_top = e_top >> 1;
					status <= judge; 
				end
				else
					status <= exp_mul2;
			end
		end

		done: begin
			if(!sys_rst)
			begin
				result <= mm_result;
				finish <= 1;
				status <= done;
			end
		end

		default: 
				status <= start;
	endcase
end

endmodule
