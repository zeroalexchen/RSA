`timescale 1ns/1ns
`include "MONT_EXPRESS.v"
module express_top;
	reg 	[2047:0] 	x;
	reg  	[2047:0] 	n;
	reg 	[10:0] 	n_len;
	reg					clk;
	reg					sys_rst;

	wire	 [2047:0]	result;
	wire 				finish;

	MONT_EXPRESS mont_express(.x(x),.n(n),.n_len(n_len),.clk(clk),.rst(sys_rst),.result(result),.finish(finish));

initial begin
	$dumpfile("test.vcd");
	$dumpvars(0,express_top);
	x = 'h161018d2ec6c64b175726b05844a5973cbffbde17ad56ddbdeed1decc249cfed4773033bf3eee49b0b287aed4e63cf04e04008e1470751a9f8618050c6d5185e8b0bd7260deedca880aaaac19622dccfb8a525826294d4e58eb4219c5046f9d56ea39541eaf35ffa5e86d657b0cc70a6f487453fd8a3c47972540eb2b7bc4b9473333cdb94e3d64baf682ed501d809bee3bc6490745bd32dac402e7a0ab811220a1f03d10a81911a38e1f5ee1d31bb97f5706e5608bf0850df9c2766373f9e838bbd7c41c8ee0b1151a4ff15f8892072dfe4d94fce635e11f750121f0d32ac5206ea2d3b2297dfe35d416cec1a5d4187edc58456452ed0a021aa2123d0b83c87;
//	e = 'h2474fe4fb0268a6f2efd9ed7541abde46cbb54e7dbbf16469ec41254266b0e70e6182ba87d07cc039d275fd463f9bf6bb4f311a3c4f72f413a6a768101618dc15454c6df889897b16a402ef1cbcfa23c1bcfca525d2dc49bed3eb268f7579d53e4fa6a7e8db78809ebeb1e4120d60d92b6ae30f821f3f65fb0af5b28b39658b32cbaad6d66da6f325849fcab656d4ddb8a382701d5e15cbd35faa9fa388c91724e696be3d76b4462cd61388e7cc756c8e1d025f79eaa438301ba6363544c80a127a3d79c3c6a0309ae649f55b30c8c4a9a9e358335ec6e2bc01e94938cb1c50bd8aaa30a1238b9c7c1c988f96c8d447a250aa025c493a865bc7169d97d06af71;
	n = 'h81c82370cec71b5cb6bab156013264b841a168eb66b0f6269db9c3c3b758c1bb0946a2ed03c229b550e3572f230b330da90bbe928b5fc1991127b2f4ca63626851f5dda144b900aae5cbe61b9238dfc374c6e0cc591bb26015baa2778e511b2a1c2d44d87bc9ae88b7d850eef07139627b700ba844eabaaa592fa46833c930502c2a09ca601dc5f28821465063643abc67d8df06a84df9805f2eeba760ba7e3e8f3b77ae4f6d0e223c30942228b304c636fbaad770080fa9ebb21a088b0ff370f9dd5b0342a9d44e5183c28ddb0d36aff49a2577a5f1776a66db45247ab309b7879c6fe9c30765d67087111c353c23ef77dc7902d931ec5bef39a8dcf0891a93;

//	x = 'b1001001;
//	n = 'b100001001;
	n_len = 2047;

	sys_rst = 1;
	#5;
	sys_rst = 0;
	#5;
	wait(finish)
	#50;
		$display("result = %h\nfinish = %b",result,finish);
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