`include ".\rtl\MONT_REDC.v"

module MONT_MUL(x,y,n,clk,result);

    input   [2047:0]    x;
    input   [2047:0]    y;
    input   [2047:0]    n;
    input   clk;

    output  [2047:0]    result;

    reg     [10:0]      i;    
    reg     [2047:0]    r;
    reg     [2047:0]    temp1;
    reg     [2047:0]    temp2;
    reg     [1:0]       status;
    reg     redc_start;

    wire    redc_finish;
    wire    [2047:0]    temp3;
    wire    [2047:0]    temp4;

    MONT_REDC mont_redc(.t(r) , .n(n) , .clk(clk) , .redc_start(redc_start), .result(result),.redc_finish(redc_finish));

    assign temp3 = ( x % n ) * ( 2**2048 % n) % n;
    assign temp4 = ( y % n ) * ( 2**2048 % n) % n;

    parameter [1:0] start = 2'b00,mul = 2'b01, redc = 2'b10, done = 2'b11;

always@(posedge clk) begin
    
    if((temp1 != temp3) || (temp2 != temp4))
    begin
        temp1 <= temp3;
        temp2 <= temp4;
        redc_start <= 0;
        status <= start;
    end

    case (status)
        start:
            begin
                i <= 0;
                status <= mul;
            end           
        mul:
            begin
                r <= (r + temp2[i]*temp1 + (result[0]^(temp2[i] && temp1[0])) * n) << 1;
					 
                if(!i)
                begin
                    i <= i + 1;      
                    status <= mul;
                end
                else
                    status <= redc;
			end

        redc:
            begin
                if(redc_finish) begin
                    redc_start <= 0;
                    status <= done;
                end
            end
					
        done:
            status <= done;

        default: 
            status <= start;
    endcase 
end

endmodule
