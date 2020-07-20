module MONT_N_LEN(N,clk,rst,n_len,finish);
	input [2047:0] N;
	input clk;
	input rst;

	output reg [10:0] n_len;
	output reg finish;

	reg [2047:0] temp_n;
	reg [11:0] i;
	reg [1:0] status;

parameter [1:0] start = 2'b00, length1 = 2'b01, length2 = 2'b10, done = 2'b11;

assign p = i;

always@(posedge clk or posedge rst)
begin
	if(rst)
	begin
		status <= start;
	end

	case(status)
		start:
			begin
				i <= 1;
				temp_n <= N;
				n_len <= 0;
				finish <= 0;
				status <= length1;
			end
		
		length1:													//获取N的最高位
			begin
				if(i != 2048)
				begin
					temp_n <= (temp_n | (temp_n >> i));
					i <= (i << 1);
					status <= length1;
				end
				else
				begin
					temp_n <= ((temp_n >> 1) + 1);
					i <= 2048;
					status <= length2;
				end
			end

		length2:
			begin
				if(i != 0)
				begin
					if(temp_n[i-1] != 0)
					begin
						n_len <= i-1;
						status <= done;
					end

					if(temp_n[i-2] != 0)
					begin
						n_len <= i-2;
						status <= done;
					end

					if(temp_n[i-3] != 0)
					begin
						n_len <= i-3;
						status <= done;
					end

					if(temp_n[i-4] != 0)
					begin
						n_len <= i-4;
						status <= done;
					end

					i <= i - 4;

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