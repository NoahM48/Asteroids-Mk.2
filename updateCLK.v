module updateCLK(clk, update);
input clk;
output reg update;
reg[21:0]count;

always @(posedge clk)
begin
	count <= count + 1; //Changing this affects the speed of the weapon. Higher val = faster shoot.
	if(count == 150000)
	begin
		update <= ~update;
		count <= 0;
	end
end
endmodule
