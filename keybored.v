module keybored(KB_clk, key0, key1, key2, key3, direction, cont1, cont2, cont3);
	input KB_clk;
	input key0,key1,key2,key3;
	input cont1, cont2, cont3;
	output reg [2:0]direction;

	always @(KB_clk)
	begin
	if (cont1 == 1'b1)
	begin // Beefender has options for multiple control schemes. I'm deciding whether to keep it or not.
		if(key3 == 1'b1 & key2 == 1'b1 & key1 == 1'b0 & key0 == 1'b1)
			direction = 3'b000;//left
		else if(key3 == 1'b1 & key2 == 1'b1 & key0 == 1'b0 & key1 == 1'b1)
			direction = 3'b001;//right
		else if(key2 == 1'b1 & key3 == 1'b0 & key1 == 1'b1 & key0 == 1'b1)
			direction = 3'b010;//up
		else if(key3 == 1'b1 & key2 == 1'b0 & key1 == 1'b1 & key0 == 1'b1)
			direction = 3'b011;//down
		else 	direction = 3'b100;//stationary
	end
	else if (cont2 == 1'b1)
	begin
		if(key3 == 1'b1 & key2 == 1'b1 & key1 == 1'b1 & key0 == 1'b0)
			direction = 3'b000;//left
		else if(key3 == 1'b1 & key2 == 1'b0 & key0 == 1'b1 & key1 == 1'b1)
			direction = 3'b001;//right
		else if(key2 == 1'b1 & key3 == 1'b0 & key1 == 1'b1 & key0 == 1'b1)
			direction = 3'b010;//up
		else if(key3 == 1'b1 & key2 == 1'b1 & key1 == 1'b0 & key0 == 1'b1)
			direction = 3'b011;//down
		else 	direction = 3'b100;//stationary
	end
	else if (cont3 == 1'b1)
	begin
		if(key3 == 1'b0 & key2 == 1'b1 & key1 == 1'b1 & key0 == 1'b1)
			direction = 3'b000;//left
		else if(key3 == 1'b1 & key2 == 1'b1 & key0 == 1'b1 & key1 == 1'b0)
			direction = 3'b001;//right
		else if(key2 == 1'b1 & key3 == 1'b1 & key1 == 1'b1 & key0 == 1'b0)
			direction = 3'b010;//up
		else if(key3 == 1'b1 & key2 == 1'b0 & key1 == 1'b1 & key0 == 1'b1)
			direction = 3'b011;//down
		else 	direction = 3'b100;//stationary
	end
	end
endmodule