`include "MUL.v"
module MONT(x,y,n,clk,sys_rst,result);
    input   [2047:0]    x;
    input   [2047:0]    y;
    input   [2047:0]    n;
	input	sys_rst;
    input   clk;

    output  reg [2047:0]    result;

    
    reg     [2048:0]    tempx;
    reg     [2048:0]    tempy;
    reg     [2:0]       status;
	reg 				mul_start;
	reg					mul_rst;

    wire    mul_finish;
	wire    [2047:0]    r;
    wire    [2048:0]    temp1;
    wire    [2048:0]    temp2;

    MUL mul_u(.x(tempx),.y(tempy),.n(n),.clk(clk),.mul_rst(mul_rst),.result(r),.mul_start(mul_start),.mul_finish(mul_finish));
					
    assign temp1 = ( x % n ) * ( 2**2048 % n ) % n;		// 预计算 x 的蒙哥马利表达式 x'
    assign temp2 = ( y % n ) * ( 2**2048 % n ) % n;		// 预计算 y 的蒙哥马利表达式 y'

    parameter [2:0] start = 3'b000,mul = 3'b001, redc_start = 3'b010, redc = 3'b011 , done = 3'b100;

	always@(posedge clk or posedge sys_rst) begin
		if(sys_rst) begin
			tempx <= 0;
			tempy <= 0;
			result <= 0;
			status <= start;					// 复位初始化变量
			mul_start <= 0;
			mul_rst <= 0;
		end

		case (status)
			start: 
				begin
					tempx <= temp1;				// 模乘的第一个数为 x'
					tempy <= temp2;				// 模乘的第二个数为 y'
					mul_rst <= 1;				// 打开模乘模块的复位信号
					status <= mul;
				end
			mul:
				begin
					mul_start <= 1;				// 打开模乘计算
					mul_rst <= 0;				// 关闭模乘模块的复位信号
					if(mul_finish)				// 等待模乘完成信号发出
						status <= redc_start;
					else
						status <= mul;
				end

			redc_start:
				begin
					tempx <= r;					// 模乘的第一个数为 r，即 mul 步骤中所得到的结果
					tempy <= 1;					// 模乘的第二个数为 1，蒙哥马利约减可看成是和 1 相乘后的蒙哥马利模乘
					mul_rst <= 1;				// 打开模乘模块的复位信号
					mul_start <= 0;				// 关闭模乘计算
					status <= redc;
				end
			
			redc:
				begin
					mul_start <= 1;				// 打开模乘计算
					mul_rst <= 0;				// 关闭模乘模块的复位信号
					if(mul_finish)				// 等待模乘完成信号发出
						status <= done;
					else
						status <= redc;
				end
			
			done:
				begin
					mul_start <= 0;				// 关闭模乘计算
					result <= r;				// 输出结果
					status <= done;
				end

			default: 
					status <= start;
		endcase
	end

endmodule