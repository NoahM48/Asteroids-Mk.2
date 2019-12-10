module VGAclk(clk, VGA_clk); // VGA runs at 25MHz, DE2-115 clk runs at 50MHz. This fixes that.

	input clk;
	output reg VGA_clk;
	reg a;

	always @(posedge clk)
	begin
		a <= ~a; 
		VGA_clk <= a;
	end
endmodule