module moutmul(x,y,n,clk,result);
    input   [2047:0]    x;
    input   [2047:0]    y;
    input   [2047:0]    n;
    input   clk;

    output  reg [2047:0]    result;

    reg     [2047:0]    i;    
    reg     [2047:0]    temp1;
    reg     [2047:0]    temp2;
    reg     [1:0]       status;

    wire    [2047:0]    temp3;
    wire    [2047:0]    temp4;

    assign temp3 = ( x * 2**11 ) % n;
    assign temp4 = ( y * 2**11 ) % n;

    parameter [1:0] start = 2'b00,mul=2'b01, done=2'b10;

always@(posedge clk) 

    case (status)
        start:
            begin
                i = 0;
                status = mul;
            end           
        mul:
            begin
                result = (result + temp4[i]*temp3 + (result[0]^(temp4[i] && temp3[0])) * n) << 1;
					 
                if(!i)
                begin
                    i = i + 1;      
                    status = mul ;
                end
                else
                    status = done;
			end
					
        done:
            status = done;
        default: 
            status = start;
    endcase 


endmodule