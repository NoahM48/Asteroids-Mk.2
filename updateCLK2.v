module updateCLK2(clk, updatePad);
input clk;
output reg updatePad;
reg[21:0]count;

always @(posedge clk)
begin
	count <= count + 1;
	if(count == 100000)
	begin
		updatePad <= ~updatePad;
		count <= 0;
	end
end
endmodule