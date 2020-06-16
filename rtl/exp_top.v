`timescale 1ns/1ns
`include "MONT_EXP.V"
module exp_top;
	reg 	[2047:0] 	c;
	reg  	[2047:0] 	e;
	reg 	[2047:0] 	n;
	reg					clk;
	reg					sys_rst;

	wire	 [2047:0]	result;
	wire 				finish;

	MONT_EXP mont_exp(.c(c),.e(e),.n(n),.clk(clk),.sys_rst(sys_rst),.result(result),.finish(finish));

initial begin
	$dumpfile("test.vcd");
    $dumpvars(0,exp_top);
	c = 52497845;
	e = 1246872;
	n = 93141;
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