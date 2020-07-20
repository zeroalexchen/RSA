module MONT_EXPRESS(x,n,n_len,clk,rst,result,finish);
	input [2047:0] x;
	input [2047:0] n;
	input [10:0] n_len;
	input clk;
	input rst;

	output reg [2047:0] result;
	output reg finish;

	reg [2047:0] temp_x;
	reg [10:0] i;
	reg [1:0] status;

    parameter [1:0] start = 2'b00, judge = 2'b01, done = 2'b10;	

always@(posedge clk or posedge rst)
begin
	if(rst != 0)
	begin
		temp_x <= x;
		i <= n_len + 1;
		status <= start;
	end

	case (status)
		start:
			begin
				temp_x <= x;
				i <= n_len + 1;
				finish <= 0;
				status <= judge;
			end

		judge:
			begin
				if(i != 0)
				begin
					if(temp_x[n_len] == 0)
					begin
						temp_x <= (temp_x << 1); 
						i <= i - 1;
						status <= judge;
					end
					else
					begin
						if(temp_x < n)
						begin
							temp_x <= (temp_x << 1)
							i <= i - 1;
							status <= judge;
						end
						else
						begin
							result <= temp_x - n;
							status <= judge;
						end
					end
				else
					status <= done;
				end
			end
		
		done:
			begin
				finish <= 1;
				status <= done;
			end

		default: 
			status <= start;
	endcase

end

endmodule