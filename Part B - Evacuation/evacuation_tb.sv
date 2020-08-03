module evacuation_tb;

parameter WIDTH = 64;
parameter HEIGHT = 64;


logic clk;
logic rst;
logic [6:0] people_out;


evacuation test(
 .clk(clk),
 .rst(rst),
 .mem(),
 .weight(),
 .people_out(people_out)
);

always begin
	clk = 0;
	#10ns;
	clk = 1;
	#10ns;
end

initial begin
  @(posedge clk)
  rst<=1;
  @(posedge clk)
  rst<=0;
end




endmodule
