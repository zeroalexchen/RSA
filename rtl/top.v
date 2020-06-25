`timescale 1us/1us
`include "MONT_MUL.v"
module TOP;
	reg [2047:0] x;
	reg [2047:0] y;
	reg [2047:0] n;
	reg clk;
	reg sys_rst;

	wire finish;
	wire [2047:0] result;

	MONT_MUL mont_mul(.x(x),.y(y),.n(n),.clk(clk),.mm_rst(sys_rst),.mm_finish(finish),.result(result));

initial begin
	$dumpfile("test.vcd");
    $dumpvars(0,TOP);
	x = 5;
	y = 1;
	n = 3;
	sys_rst = 1;
	#5;
	sys_rst = 0;
	#5;
	wait(finish) 
	#50;
		$display("result = %d\nfinish = %b",result,finish);
	$finish;

end

always begin
	clk = 0;
	#5;
	clk = 1;
	#5;
end

endmodule