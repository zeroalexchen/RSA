module MONT_EXPRESS(x,n,n_len,clk,rst,enable,result,finish);

	input 	[2047:0] 	x;			// 输入：x, n, n的长度, 时钟信号, 复位信号
	input 	[2047:0] 	n;
	input 	[10:0] 		n_len;
	input 				clk;
	input 				rst;
	input				enable;

	output reg [2047:0] result;		// 输出：蒙哥马利表达式 result = x * (2 ^ n_len) % n
	output reg 			finish;		//		结束信号

	reg 	[2048:0] 	temp_x;
	reg 	[11:0] 		i;
	reg 	[1:0] 		status;

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
				if(!rst)
					temp_x <= x;
					i <= n_len + 1;
					finish <= 0;
					if(enable)
						status <= judge;
					else
						status <= start;
			end
		
		judge:
			begin
				if(!rst)
					if(temp_x > n || temp_x == n)
						temp_x <= temp_x - n;
					else
						if(temp_x < n && i != 0)
						begin
							temp_x <= temp_x << 1;
							i <= i - 1;
						end
						else
						begin
							result <= temp_x;
							status <= done;
						end
			end

		done:
			begin
				if(!rst)
					finish <= 1;
					status <= done;
			end

		default: 
			status <= start;
	endcase

end

endmodule