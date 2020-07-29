module MONT_MUL(x,y,n,n_len,clk,rst,enable,result,finish);

    input   [2047:0]    x;
    input   [2047:0]    y;
    input   [2047:0]    n;
    input   [10:0]      n_len;
    input   			clk;
	input				rst;
	input				enable;

    output reg [2049:0] result;
	output reg		    finish;

    reg     [10:0]      i;    
    reg     [1:0]       status;

    parameter [1:0] start = 2'b00,mul = 2'b01, done = 2'b10;

always@(posedge clk or posedge rst) begin
    if(rst)
    begin
        result <= 0;                                // 初始化变量
        finish <= 0;
        status <= start;
    end

    case (status)
        start:
            begin
                if(!rst) 
                begin   
                    i <= 0;
                    if(enable)                   // 等待模乘计算开启信号
                        status <= mul;
                    else
                        status <= start;
                end
            end           
        mul:
            begin
                if(!rst) 
                begin
                    result <= (result + x[i]*y + (result[0]^(x[i] && y[0])) * n) >> 1;
                                                    // 蒙哥马利模乘
                    if( i != n_len )                  // 有 n_len + 1 位，计算 n_len + 1 次，计算完后跳出循环
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
                if(!rst) 
                begin
                    if(result > n || result == n)
                    begin
                        result <= result - n ;
                    end
                    finish <= 1;  
                    status <= done;
                end
			end
            
        default: 
            status <= start;
    endcase 
end

endmodule
