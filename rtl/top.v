`timescale 1ns/1ns
`include "MONT.v"
module TOP;
	reg [2047:0] x;
	reg [2047:0] y;
	reg [2047:0] n;
	reg clk;
	reg sys_rst;

	wire [2047:0] result;

	MONT mont(.x(x),.y(y),.n(n),.clk(clk),.sys_rst(sys_rst),.result(result));

initial begin
	$dumpfile("test.vcd");
    $dumpvars(0,TOP);
	x = 55;
	y = 93;
	n = 33;
	sys_rst = 1;
	#5;
	sys_rst = 0;
	#5;
	#50000;
	$display("result = %d",result);
	$finish;
end

always begin
	clk = 0;
	#5;
	clk = 1;
	#5;
end

endmodule