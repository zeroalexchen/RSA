module MONT_REDC(t,n,clk,redc_start,result,redc_finish);
	input 	[2047:0]	t;
    input   [2047:0]    n;
	input 				clk;
	input				redc_start;
	
	output reg [2047:0] result;
	output reg 			redc_finish;
	
	reg 	[2047:0]	temp;
	reg		[1:0]		status;
	reg 	[10:0]		i;

	parameter [1:0] start = 2'b00,mul = 2'b01,done = 2'b10;

always@(posedge clk) begin

	if(redc_start) begin

		if(temp != t)
		begin
			temp <= t;
			redc_finish <= 0;
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
					result <= (result + t[i] + (result[0] ^ t[i]) * n) << 1;
						
					if(!i)
					begin
						i <= i + 1;      
						status <= mul ;
					end
					else
						status <= done;
				end
						
			done:
				begin
					redc_finish <= 1;
					status <= done;
				end

			default: 
				status = start;
		endcase 	
	end
end

endmodule