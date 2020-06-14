module MUL(x,y,n,clk,mul_rst,mul_start,result,mul_finish);

    input   [2048:0]    x;
    input   [2048:0]    y;
    input   [2047:0]    n;
    input   			clk;
	input				mul_rst;
	input				mul_start;

    output  reg [2047:0]    result;
	output	reg			mul_finish;

    reg     [10:0]      i;    
    reg     [2047:0]    temp1;
    reg     [2047:0]    temp2;
    reg     [1:0]       status;

    parameter [1:0] start = 2'b00,mul = 2'b01, done = 2'b10;

always@(posedge clk or posedge mul_rst) begin
    if(mul_rst)
    begin
        result <= 0;                                // 初始化变量
        mul_finish <= 0;
        status <= start;
    end

    case (status)
        start:
            begin
                if(!mul_rst) 
                begin   
                    i <= 0;
                    if(mul_start)                   // 等待模乘计算开启信号
                        status <= mul;
                    else
                        status <= start;
                end
            end           
        mul:
            begin
                if(!mul_rst) 
                begin
                    result <= (result + x[i]*y + (result[0]^(x[i] && y[0])) * n) >> 1;
                                                    // 蒙哥马利模乘
                    if( i < 2047 )                  // 最高有2048位，计算2048次，计算完后跳出循环
                    begin
                        i <= i + 1;      
                        status <= mul;
                    end
                    else
                        status <= done;
                end
			end
					
        done:
			begin
                if(!mul_rst) 
                begin
                    if(result > n || result == n)
                    begin
                        result <= result - n ;
                    end
                    mul_finish <= 1;  
                    status <= done;
                end
			end
            
        default: 
            status <= start;
    endcase 
end

endmodule
