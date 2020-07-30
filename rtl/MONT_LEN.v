module MONT_LEN(n,clk,rst,enable,result,finish);
	input 	[2047:0] 	n;			// 输入：n, 时钟信号, 复位信号
	input 				clk;
	input 				rst;
	input				enable;

	output reg [10:0] 	result;		// 输出：result = n 的长度 - 1, 结束信号
	output reg 			finish;

	reg 	[2047:0] 	temp_n;
	reg 	[11:0] 		i;
	reg 	[1:0] 		status;
	reg 	[15:0]		temp;

parameter [1:0] start = 2'b00, length1 = 2'b01, length2 = 2'b10, done = 2'b11;

always@(posedge clk or posedge rst)
begin
	if(rst)
	begin
		temp_n <= 0;
		i <= 0;
		temp <= 0;
		status <= start;
		result <= 0;
		finish <= 0;
	end

	case(status)
		start:
			begin
				if(!rst)
				begin
					i <= 1;
					temp <= 0;
					temp_n <= n;
					result <= 0;
					finish <= 0;
					if(enable)
						status <= length1;
					else
						status <= start;
				end
				
			end
		
		length1:
			begin
				if(!rst)
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
						i <= 0;
						status <= length2;
					end
				end
			end
		
		length2:
			begin
				if(!rst)
				begin
					if(temp == 0)
					begin
						temp[0] <= temp_n[i];
						temp[1] <= temp_n[i+1];
						temp[2] <= temp_n[i+2];
						temp[3] <= temp_n[i+3];
						temp[4] <= temp_n[i+4];
						temp[5] <= temp_n[i+5];
						temp[6] <= temp_n[i+6];
						temp[7] <= temp_n[i+7];
						temp[8] <= temp_n[i+8];
						temp[9] <= temp_n[i+9];
						temp[10] <= temp_n[i+10];
						temp[11] <= temp_n[i+11];
						temp[12] <= temp_n[i+12];
						temp[13] <= temp_n[i+13];
						temp[14] <= temp_n[i+14];
						temp[15] <= temp_n[i+15];

						i <= i + 16; 
					end
					else
					begin
						case (temp)
							16'h0001: 	result <= i - 16;
							16'h0002: 	result <= i - 15;
							16'h0004: 	result <= i - 14;
							16'h0008: 	result <= i - 13;
							16'h0010: 	result <= i - 12;
							16'h0020: 	result <= i - 11;
							16'h0040: 	result <= i - 10;
							16'h0080: 	result <= i - 9;
							16'h0100: 	result <= i - 8;
							16'h0200: 	result <= i - 7;
							16'h0400: 	result <= i - 6;
							16'h0800: 	result <= i - 5;
							16'h1000: 	result <= i - 4;
							16'h2000: 	result <= i - 3;
							16'h4000: 	result <= i - 2;
							16'h8000: 	result <= i - 1;

						default: 	status <= start;
						endcase

					status <= done;
					end
				end
			end

		done:
			if(!rst)
			begin
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
