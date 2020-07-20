`timescale 1ns/1ns
`include "MONT_N_LEN.v"
module N_LEN_TOP;
	reg 	[2047:0] 	n;
	reg					clk;
	reg					sys_rst;
	wire  	[10:0]		N_LEN;

	wire	 [2047:0]	result;
	wire 				finish;

	MONT_N_LEN n_len(.N(n),.clk(clk),.rst(sys_rst),.N_LEN(N_LEN),.finish(finish));

initial begin

//	$dumpfile("test.vcd");
//	$dumpvars(0,N_LEN_TOP);

//	n = 'h81c82370cec71b5cb6bab156013264b841a168eb66b0f6269db9c3c3b758c1bb0946a2ed03c229b550e3572f230b330da90bbe928b5fc1991127b2f4ca63626851f5dda144b900aae5cbe61b9238dfc374c6e0cc591bb26015baa2778e511b2a1c2d44d87bc9ae88b7d850eef07139627b700ba844eabaaa592fa46833c930502c2a09ca601dc5f28821465063643abc67d8df06a84df9805f2eeba760ba7e3e8f3b77ae4f6d0e223c30942228b304c636fbaad770080fa9ebb21a088b0ff370f9dd5b0342a9d44e5183c28ddb0d36aff49a2577a5f1776a66db45247ab309b7879c6fe9c30765d67087111c353c23ef77dc7902d931ec5bef39a8dcf0891a93;

	sys_rst = 1;
	#5;
	sys_rst = 0;
	#5;
	wait(finish)
	#50;
		$display("result = %d\nfinish = %b",N_LEN,finish);
		$display("time = %d ns",$realtime);
	$finish;

end

always begin
	clk = 0;
	#5;
	clk = 1;
	#5;
end

endmodule