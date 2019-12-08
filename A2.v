module A2(clk, rst, cont1, cont2, cont3, key0, key1, key2, key3, start_game, fire, DAC_clk, VGA_R, VGA_G, VGA_B, VGA_Hsync, 
					VGA_Vsync, blank_n, KB_clk, data);
input clk, rst, fire;
input KB_clk, data;
input key0, key1, key2, key3;
input cont1, cont2, cont3;
input start_game;

wire [2:0]direction;

output reg [7:0]VGA_R;
output reg [7:0]VGA_G;
output reg [7:0]VGA_B;

output VGA_Hsync;
output VGA_Vsync;
output DAC_clk;
output blank_n;

wire [10:0]xCounter;
wire [10:0]yCounter;

wire R;
wire G; 
wire B; 


wire update;
wire updatePad;
wire VGA_clk;
wire displayArea;

wire paddle, stripe, stripe2, wing, wing2, sting, head, tank, hive,leaves, hive1, hive2, hive3, rout, rin, rin2, rin3, deaded, wout, win, win2;
wire e2in1, e2out, e2in2, redstart, onswitch, onbase, gin, gout, gin2, aout, ain, ain2, mout, min, min2, eout, vin, vin2, vout, ein, ein2, oout, oin, nout, nin, nin2, health1, health2, health3, health4, health5, health6, health7, health8, health9, health10;
wire missile, topb, midb, botb, outb, leftb, middleb, rightb, outrb, farright, outmostr, bot1b, bot2b, top2b, tealwin, iout, iin, iin2, return1, return2, return3;
wire block1,block2,block3,block4,block5,block6,block7,block8,block9, beebar, beecominhome, beebar2, hit_me;

wire screen_border;

reg border;
reg game_over;
reg win_game;
reg [10:0]score1;
reg [10:0] grumbles, grumbles2, grumbles3, grumbles4, grumbles5, grumbles6, grumbles7, grumbles8, grumbles9;
reg [10:0]life;
	reg [10:0]x_pad, y_pad; //the top left point of the bee
reg [10:0]x_stripe,y_stripe;//left stripe of the bee hopefully
reg [10:0]x_stripe2,y_stripe2;//right stripe of the bee hopefully
reg [10:0]x_wing,y_wing;
reg [10:0]x_head,y_head;
reg [10:0]x_tank,y_tank;
reg [10:0]x_wing2,y_wing2;
reg [10:0]x_sting,y_sting;
	reg [10:0]x_redstart,y_redstart; // magenta start screen

reg [10:0]x_onswitch,y_onswitch;
reg [10:0]x_onbase,y_onbase;
reg [10:0]x_gin, y_gin;
reg [10:0]x_gin2, y_gin2;
reg [10:0]x_gout,y_gout;
reg [10:0]x_ain, y_ain;
reg [10:0]x_ain2, y_ain2;
reg [10:0]x_aout,y_aout;
reg [10:0]x_min, y_min;
reg [10:0]x_min2, y_min2;
reg [10:0]x_mout,y_mout;
reg [10:0]x_ein, y_ein;
reg [10:0]x_ein2, y_ein2;
reg [10:0]x_eout,y_eout;
reg [10:0]x_e2in1, y_e2in1;
reg [10:0]x_e2in2, y_e2in2;
reg [10:0]x_e2out,y_e2out;
reg [10:0]x_oin, y_oin;
reg [10:0]x_oout,y_oout;
reg [10:0]x_vin, y_vin;
reg [10:0]x_vin2, y_vin2;
reg [10:0]x_vout,y_vout;
reg [10:0]x_nin, y_nin;
reg [10:0]x_nin2, y_nin2;
reg [10:0]x_nout,y_nout;
reg [10:0]x_rin, y_rin;
reg [10:0]x_rin2, y_rin2;
reg [10:0]x_rout,y_rout;
reg [10:0]x_rin3, y_rin3;
reg [10:0]x_deaded,y_deaded;
reg [10:0]x_hive,y_hive;
reg [10:0]x_hive1,y_hive1;
reg [10:0]x_hive2,y_hive2;
reg [10:0]x_hive3,y_hive3;
reg [10:0]x_topb,y_topb;
reg [10:0]x_midb,y_midb;
reg [10:0]x_botb,y_botb;
reg [10:0]x_outb,y_outb;
reg [10:0]x_leftb,y_leftb;
reg [10:0]x_middleb,y_middleb;
reg [10:0]x_rightb,y_rightb;
reg [10:0]x_outrb,y_outrb;
reg [10:0]x_farright,y_farright;
reg [10:0]x_outmostr,y_outmostr;
reg [10:0]x_leaves,y_leaves;
reg [10:0]x_bot1b,y_bot1b;
reg [10:0]x_bot2b,y_bot2b;
reg [10:0]x_top2b,y_top2b;
reg [10:0]x_health1,y_health1;
reg [10:0]x_health2,y_health2;
reg [10:0]x_health3,y_health3;
reg [10:0]x_health4,y_health4;
reg [10:0]x_health5,y_health5;
reg [10:0]x_health6,y_health6;
reg [10:0]x_health7,y_health7;
reg [10:0]x_health8,y_health8;
reg [10:0]x_health9,y_health9;
reg [10:0]x_health10,y_health10;
reg [10:0]x_missile,y_missile; //the top right of the missile
reg [10:0]x_tealwin, y_tealwin;
reg [10:0]x_iin2,y_iin2;
reg [10:0]x_iout, y_iout;
reg [10:0]x_iin, y_iin;
reg [10:0]x_win, y_win;
reg [10:0]x_win2, y_win2;
reg [10:0]x_wout,y_wout;
reg [10:0]x_beebar,y_beebar;
reg [10:0]x_beecominhome,y_beecominhome;
reg [10:0]x_beebar2,y_beebar2;
reg [10:0]x_return1,y_return1;
reg [10:0]x_return2,y_return2;
reg [10:0]x_return3,y_return3;

reg [10:0] x_block1,x_block2,x_block3,x_block4,x_block5,x_block6,x_block7,x_block8,x_block9; //top right corner of block
reg [10:0] y_block1,y_block2,y_block3,y_block4,y_block5,y_block6,y_block7,y_block8,y_block9;


reg [10:0] x_screen_border, y_screen_border;

//Modules N' Stuff
	keybored keyboard(KB_clk, key0, key1, key2, key3, direction, cont1, cont2, cont3); //PS2 keyboard input. called it keybored because I'm bored.
updateCLK clk_updateCLK(clk, update); // missile clock
updatePaddleCLK clk_updatePaddleCLK(clk, updatePad); // asteroid speed clock. Higher vals = faster asteroids
VGAclk reduce(clk, VGA_clk);
VGA_generator generator(VGA_clk, VGA_Hsync, VGA_Vsync, DisplayArea, xCounter, yCounter, blank_n);

assign DAC_clk = VGA_clk;

assign paddle = (xCounter >= x_pad && xCounter <= x_pad + 8'd20 && yCounter >= y_pad && yCounter <= y_pad + 8'd20); // sets the size of the paddle
assign missile = (xCounter >= x_missile && xCounter <= x_missile + 8'd20 && yCounter >= y_missile && yCounter <= y_missile + 8'd6); // sets the size of the missile
//assign stripe = (xCounter >= x_stripe && xCounter <= x_stripe + 8'd3 && yCounter >= y_stripe && yCounter <= y_stripe + 8'd20); // sets the size of the left stripe
//assign stripe2 = (xCounter >= x_stripe2 && xCounter <= x_stripe2 + 8'd3 && yCounter >= y_stripe2 && yCounter <= y_stripe2 + 8'd20); // sets the size of the right stripe
assign wing = (xCounter >= x_wing && xCounter <= x_wing + 8'd14 && yCounter >= y_wing && yCounter <= y_wing + 8'd4); // sets the size of the top wing
assign wing2 = (xCounter >= x_wing2 && xCounter <= x_wing2 + 8'd14 && yCounter >= y_wing2 && yCounter <= y_wing2 + 8'd4); // sets the size of the bottom wing
//assign sting = (xCounter >= x_sting && xCounter <= x_sting + 8'd5 && yCounter >= y_sting && yCounter <= y_sting + 8'd2); // sets the size of the stinger
assign tank = (xCounter >= x_tank && xCounter <= x_tank + 8'd20 && yCounter >= y_tank && yCounter <= y_tank + 8'd6); // sets the size of the tank
assign head = (xCounter >= x_head && xCounter <= x_head + 8'd10 && yCounter >= y_head && yCounter <= y_head + 8'd10); // sets the size of the head
assign screen_border = (xCounter >= x_screen_border && xCounter <= x_screen_border + 11'd600 && yCounter >= y_screen_border && yCounter <= y_screen_border + 11'd440);
assign redstart = (xCounter >= x_redstart && xCounter <= x_redstart + 11'd640 && yCounter >= y_redstart && yCounter <= y_redstart + 11'd460); //big red screen
assign onswitch = (xCounter >= x_onswitch && xCounter <= x_onswitch + 11'd12 && yCounter >= y_onswitch && yCounter <= y_onswitch + 11'd12); //switchmovingup
assign onbase = (xCounter >= x_onbase && xCounter <= x_onbase + 11'd14 && yCounter >= y_onbase && yCounter <= y_onbase + 11'd28);
assign gout = (xCounter >= x_gout && xCounter <= x_gout + 11'd14 && yCounter >= y_gout && yCounter <= y_gout + 11'd28);
assign gin = (xCounter >= x_gin && xCounter <= x_gin + 11'd11 && yCounter >= y_gin && yCounter <= y_gin + 11'd10);
assign gin2 = (xCounter >= x_gin2 && xCounter <= x_gin2 + 11'd8 && yCounter >= y_gin2 && yCounter <= y_gin2 + 11'd20);
assign aout = (xCounter >= x_aout && xCounter <= x_aout + 11'd14 && yCounter >= y_aout && yCounter <= y_aout + 11'd28);
assign ain = (xCounter >= x_ain && xCounter <= x_ain + 11'd10 && yCounter >= y_ain && yCounter <= y_ain + 11'd10);
assign ain2 = (xCounter >= x_ain2 && xCounter <= x_ain2 + 11'd10 && yCounter >= y_ain2 && yCounter <= y_ain2 + 11'd12);
assign mout = (xCounter >= x_mout && xCounter <= x_mout + 11'd14 && yCounter >= y_mout && yCounter <= y_mout + 11'd28);
assign min = (xCounter >= x_min && xCounter <= x_min + 11'd3 && yCounter >= y_min && yCounter <= y_min + 11'd26);
assign min2 = (xCounter >= x_min2 && xCounter <= x_min2 + 11'd3 && yCounter >= y_min2 && yCounter <= y_min2 + 11'd26);
assign eout = (xCounter >= x_eout && xCounter <= x_eout + 11'd14 && yCounter >= y_eout && yCounter <= y_eout + 11'd28);
assign ein = (xCounter >= x_ein && xCounter <= x_ein + 11'd12 && yCounter >= y_ein && yCounter <= y_ein + 11'd10);
assign ein2 = (xCounter >= x_ein2 && xCounter <= x_ein2 + 11'd12 && yCounter >= y_ein2 && yCounter <= y_ein2 + 11'd10);
assign oout = (xCounter >= x_oout && xCounter <= x_oout + 11'd14 && yCounter >= y_oout && yCounter <= y_oout + 11'd28);
assign oin = (xCounter >= x_oin && xCounter <= x_oin + 11'd10 && yCounter >= y_oin && yCounter <= y_oin + 11'd24);
assign nout = (xCounter >= x_nout && xCounter <= x_nout + 11'd14 && yCounter >= y_nout && yCounter <= y_nout + 11'd28);
assign nin = (xCounter >= x_nin && xCounter <= x_nin + 11'd3 && yCounter >= y_nin && yCounter <= y_nin + 11'd26);
assign nin2 = (xCounter >= x_nin2 && xCounter <= x_nin2 + 11'd3 && yCounter >= y_nin2 && yCounter <= y_nin2 + 11'd26);
assign hive = (xCounter >= x_hive && xCounter <= x_hive + 11'd60 && yCounter >= y_hive && yCounter <= y_hive + 11'd60);
assign leaves = (xCounter >= x_leaves && xCounter <= x_leaves + 11'd60 && yCounter >= y_leaves && yCounter <= y_leaves + 11'd90);
assign hive1 = (xCounter >= x_hive1 && xCounter <= x_hive1 + 11'd60 && yCounter >= y_hive1 && yCounter <= y_hive1 + 11'd8);
assign hive2 = (xCounter >= x_hive2 && xCounter <= x_hive2 + 11'd60 && yCounter >= y_hive2 && yCounter <= y_hive2 + 11'd8);
assign hive3 = (xCounter >= x_hive3 && xCounter <= x_hive3 + 11'd10 && yCounter >= y_hive3 && yCounter <= y_hive3 + 11'd10);
assign deaded = (xCounter >= x_deaded && xCounter <= x_deaded + 11'd20 && yCounter >= y_deaded && yCounter <= y_deaded + 11'd20);
assign health1 = (xCounter >= x_health1 && xCounter <= x_health1 + 11'd60 && yCounter >= y_health1 && yCounter <= y_health1 + 11'd9);
assign health2 = (xCounter >= x_health2 && xCounter <= x_health2 + 11'd60 && yCounter >= y_health2 && yCounter <= y_health2 + 11'd9);
assign health3 = (xCounter >= x_health3 && xCounter <= x_health3 + 11'd60 && yCounter >= y_health3 && yCounter <= y_health3 + 11'd9);
assign health4 = (xCounter >= x_health4 && xCounter <= x_health4 + 11'd60 && yCounter >= y_health4 && yCounter <= y_health4 + 11'd9);
assign health5 = (xCounter >= x_health5 && xCounter <= x_health5 + 11'd60 && yCounter >= y_health5 && yCounter <= y_health5 + 11'd9);
assign health6 = (xCounter >= x_health6 && xCounter <= x_health6 + 11'd60 && yCounter >= y_health6 && yCounter <= y_health6 + 11'd9);
assign health7 = (xCounter >= x_health7 && xCounter <= x_health7 + 11'd60 && yCounter >= y_health7 && yCounter <= y_health7 + 11'd9);
assign health8 = (xCounter >= x_health8 && xCounter <= x_health8 + 11'd60 && yCounter >= y_health8 && yCounter <= y_health8 + 11'd9);
assign health9 = (xCounter >= x_health9 && xCounter <= x_health9 + 11'd60 && yCounter >= y_health9 && yCounter <= y_health9 + 11'd9);
assign health10 = (xCounter >= x_health10 && xCounter <= x_health10 + 11'd60 && yCounter >= y_health10 && yCounter <= y_health10 + 11'd9);
assign e2out = (xCounter >= x_e2out && xCounter <= x_e2out + 11'd14 && yCounter >= y_e2out && yCounter <= y_e2out + 11'd28);
assign e2in1 = (xCounter >= x_e2in1 && xCounter <= x_e2in1 + 11'd12 && yCounter >= y_e2in1 && yCounter <= y_e2in1 + 11'd10);
assign e2in2 = (xCounter >= x_e2in2 && xCounter <= x_e2in2 + 11'd12 && yCounter >= y_e2in2 && yCounter <= y_e2in2 + 11'd10);
assign vout = (xCounter >= x_vout && xCounter <= x_vout + 11'd14 && yCounter >= y_vout && yCounter <= y_vout + 11'd28);
assign vin = (xCounter >= x_vin && xCounter <= x_vin + 11'd10 && yCounter >= y_vin && yCounter <= y_vin + 11'd23);
assign vin2 = (xCounter >= x_vin2 && xCounter <= x_vin2 + 11'd6 && yCounter >= y_vin2 && yCounter <= y_vin2 + 11'd23);
assign rout = (xCounter >= x_rout && xCounter <= x_rout + 11'd14 && yCounter >= y_rout && yCounter <= y_rout + 11'd28);
assign rin = (xCounter >= x_rin && xCounter <= x_rin + 11'd10 && yCounter >= y_rin && yCounter <= y_rin + 11'd10);
assign rin2 = (xCounter >= x_rin2 && xCounter <= x_rin2 + 11'd7 && yCounter >= y_rin2 && yCounter <= y_rin2 + 11'd12);
assign rin3 = (xCounter >= x_rin3 && xCounter <= x_rin3 + 11'd3 && yCounter >= y_rin3 && yCounter <= y_rin3 + 11'd6);
assign topb = (xCounter >= x_topb && xCounter <= x_topb + 11'd74 && yCounter >= y_topb && yCounter <= y_topb + 11'd2);
assign midb = (xCounter >= x_midb && xCounter <= x_midb + 11'd74 && yCounter >= y_midb && yCounter <= y_midb + 11'd3);
assign botb = (xCounter >= x_botb && xCounter <= x_botb + 11'd38 && yCounter >= y_botb && yCounter <= y_botb + 11'd2);
assign outb = (xCounter >= x_outb && xCounter <= x_outb + 11'd2 && yCounter >= y_outb && yCounter <= y_outb + 11'd28);
assign leftb = (xCounter >= x_leftb && xCounter <= x_leftb + 11'd2 && yCounter >= y_leftb && yCounter <= y_leftb + 11'd28);
assign middleb = (xCounter >= x_middleb && xCounter <= x_middleb + 11'd2 && yCounter >= y_middleb && yCounter <= y_middleb + 11'd61);
assign rightb = (xCounter >= x_rightb && xCounter <= x_rightb + 11'd2 && yCounter >= y_rightb && yCounter <= y_rightb + 11'd61);
assign outrb = (xCounter >= x_outrb && xCounter <= x_outrb + 11'd2 && yCounter >= y_outrb && yCounter <= y_outrb + 11'd61);
assign farright = (xCounter >= x_farright && xCounter <= x_farright + 11'd2 && yCounter >= y_farright && yCounter <= y_farright + 11'd28);
assign outmostr = (xCounter >= x_outmostr && xCounter <= x_outmostr + 11'd2 && yCounter >= y_outmostr && yCounter <= y_outmostr + 11'd28);
assign bot2b = (xCounter >= x_bot2b && xCounter <= x_bot2b + 11'd38 && yCounter >= y_bot2b && yCounter <= y_bot2b + 11'd2);
assign top2b = (xCounter >= x_top2b && xCounter <= x_top2b + 11'd38 && yCounter >= y_top2b && yCounter <= y_top2b + 11'd2);
assign bot1b = (xCounter >= x_bot1b && xCounter <= x_bot1b + 11'd20 && yCounter >= y_bot1b && yCounter <= y_bot1b + 11'd2);
assign iout = (xCounter >= x_iout && xCounter <= x_iout + 11'd14 && yCounter >= y_iout && yCounter <= y_iout + 11'd28);
assign iin = (xCounter >= x_iin && xCounter <= x_iin + 11'd5 && yCounter >= y_iin && yCounter <= y_iin + 11'd24);
assign iin2 = (xCounter >= x_iin2 && xCounter <= x_iin2 + 11'd5 && yCounter >= y_iin2 && yCounter <= y_iin2 + 11'd24);
assign tealwin = (xCounter >= x_tealwin && xCounter <= x_tealwin + 11'd640 && yCounter >= y_tealwin && yCounter <= y_tealwin + 11'd460); //big red screen
assign wout = (xCounter >= x_wout && xCounter <= x_wout + 11'd14 && yCounter >= y_wout && yCounter <= y_wout + 11'd28);
assign win = (xCounter >= x_win && xCounter <= x_win + 11'd3 && yCounter >= y_win && yCounter <= y_win + 11'd26);
assign win2 = (xCounter >= x_win2 && xCounter <= x_win2 + 11'd3 && yCounter >= y_win2 && yCounter <= y_win2 + 11'd26);
assign beebar = (xCounter >= x_beebar && xCounter <= x_beebar + 11'd2 && yCounter >= y_beebar && yCounter <= y_beebar + 11'd84);
assign beecominhome = (xCounter >= x_beecominhome && xCounter <= x_beecominhome + 11'd4 && yCounter >= y_beecominhome && yCounter <= y_beecominhome + 11'd4);
assign beebar2 = (xCounter >= x_beebar2 && xCounter <= x_beebar2 + 11'd7 && yCounter >= y_beebar2 && yCounter <= y_beebar2 + 11'd2);
assign return1 = (xCounter >= x_return1 && xCounter <= x_return1 + 11'd10 && yCounter >= y_return1 && yCounter <= y_return1 + 11'd10);
assign return2 = (xCounter >= x_return2 && xCounter <= x_return2 + 11'd10 && yCounter >= y_return2 && yCounter <= y_return2 + 11'd10);
assign return3 = (xCounter >= x_return3 && xCounter <= x_return3 + 11'd10 && yCounter >= y_return3 && yCounter <= y_return3 + 11'd10);
//theesee are the beeesss
assign block1 = (xCounter >= x_block1 && xCounter <= x_block1 + 8'd20 && yCounter >= y_block1 && yCounter <= y_block1 + 8'd20);
assign block2 = (xCounter >= x_block2 && xCounter <= x_block2 + 8'd20 && yCounter >= y_block2 && yCounter <= y_block2 + 8'd20);
assign block3 = (xCounter >= x_block3 && xCounter <= x_block3 + 8'd20 && yCounter >= y_block3 && yCounter <= y_block3 + 8'd20);
assign block4 = (xCounter >= x_block4 && xCounter <= x_block4 + 8'd20 && yCounter >= y_block4 && yCounter <= y_block4 + 8'd20);
assign block5 = (xCounter >= x_block5 && xCounter <= x_block5 + 8'd20 && yCounter >= y_block5 && yCounter <= y_block5 + 8'd20);
assign block6 = (xCounter >= x_block6 && xCounter <= x_block6 + 8'd20 && yCounter >= y_block6 && yCounter <= y_block6 + 8'd20);
assign block7 = (xCounter >= x_block7 && xCounter <= x_block7 + 8'd20 && yCounter >= y_block7 && yCounter <= y_block7 + 8'd20);
assign block8 = (xCounter >= x_block8 && xCounter <= x_block8 + 8'd20 && yCounter >= y_block8 && yCounter <= y_block8 + 8'd20);
assign block9 = (xCounter >= x_block9 && xCounter <= x_block9 + 8'd20 && yCounter >= y_block9 && yCounter <= y_block9 + 8'd20);


//FSM. Game win states removed. There is no victory in the void of space.
reg [10:0]S;
reg [10:0]NS;
reg [10:0]S1; //these are for moving blocks
reg [10:0]NS1;
reg [10:0]S2;
reg [10:0]NS2;
reg [10:0]S3;
reg [10:0]NS3;
reg [10:0]S4;
reg [10:0]NS4;
reg [10:0]S5;
reg [10:0]NS5;
reg [10:0]S6;
reg [10:0]NS6;
reg [10:0]S7;
reg [10:0]NS7;
reg [10:0]S8;
reg [10:0]NS8;
reg [10:0]S9;
reg [10:0]NS9;
parameter before = 11'd0, start = 11'd1, missile_move_left = 11'd2, collision = 11'd3, missile_reload = 11'd4, end_game = 11'd5, missile_move_45 = 11'd6, missile_move_135 = 11'd7, missile_move_225 = 11'd8, missile_move_315 = 11'd9, missile_reload1 = 11'd14; //according to an error, "before" is a systemVerilog keyword. Too bad this isn't systemVerilog.
parameter stinkyboi = 11'd1000, block1_move_225 = 11'd2, block1_move_315 = 11'd3, block1_move_45 = 11'd4, block1_move_135 = 11'd5, block1_been_shot = 11'd6, start_anim = 11'd50;

// Check if the missile hits a brick fully
wire hit_block1;
assign hit_block1 = ((y_missile + 8'd6 >= y_block1) && (y_missile < y_block1 +8'd20) && (x_missile + 8'd20 > x_block1) && (x_missile < x_block1 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_block2;
assign hit_block2 = ((y_missile + 8'd6 >= y_block2) && (y_missile < y_block2 +8'd20) && (x_missile + 8'd20 > x_block2) && (x_missile < x_block2 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_block3;
assign hit_block3 = ((y_missile + 8'd6 >= y_block3) && (y_missile < y_block3 +8'd20) && (x_missile + 8'd20 > x_block3) && (x_missile < x_block3 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_block4;
assign hit_block4 = ((y_missile + 8'd6 >= y_block4) && (y_missile < y_block4 +8'd20) && (x_missile + 8'd20 > x_block4) && (x_missile < x_block4 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_block5;
assign hit_block5 = ((y_missile + 8'd6 >= y_block5) && (y_missile < y_block5 +8'd20) && (x_missile + 8'd20 > x_block5) && (x_missile < x_block5 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_block6;
assign hit_block6 = ((y_missile + 8'd6 >= y_block6) && (y_missile < y_block6 +8'd20) && (x_missile + 8'd20 > x_block6) && (x_missile < x_block6 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_block7;
assign hit_block7 = ((y_missile + 8'd6 >= y_block7) && (y_missile < y_block7 +8'd20) && (x_missile + 8'd20 > x_block7) && (x_missile < x_block7 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_block8;
assign hit_block8 = ((y_missile + 8'd6 >= y_block8) && (y_missile < y_block8 +8'd20) && (x_missile + 8'd20 > x_block8) && (x_missile < x_block8 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_block9;
assign hit_block9 = ((y_missile + 8'd6 >= y_block9) && (y_missile < y_block9 +8'd20) && (x_missile + 8'd20 > x_block9) && (x_missile < x_block9 + 8'd20)) ? 1'b1 : 1'b0;


//hit detection for block1 hitting blocks on its top
wire hit_b1_b2t;
assign hit_b1_b2t = ((y_block1 + 8'd20 == y_block2) && (x_block1 + 8'd20 > x_block2) && (x_block1 < x_block2 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b1_b3t;
assign hit_b1_b3t = ((y_block1 + 8'd20 == y_block3) && (x_block1 + 8'd20 > x_block3) && (x_block1 < x_block3 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b1_b4t;
assign hit_b1_b4t = ((y_block1 + 8'd20 == y_block4) && (x_block1 + 8'd20 > x_block4) && (x_block1 < x_block4 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b1_b5t;
assign hit_b1_b5t = ((y_block1 + 8'd20 == y_block5) && (x_block1 + 8'd20 > x_block5) && (x_block1 < x_block5 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b1_b6t;
assign hit_b1_b6t = ((y_block1 + 8'd20 == y_block6) && (x_block1 + 8'd20 > x_block6) && (x_block1 < x_block6 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b1_b7t;
assign hit_b1_b7t = ((y_block1 + 8'd20 == y_block7) && (x_block1 + 8'd20 > x_block7) && (x_block1 < x_block7 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b1_b8t;
assign hit_b1_b8t = ((y_block1 + 8'd20 == y_block8) && (x_block1 + 8'd20 > x_block8) && (x_block1 < x_block8 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b1_b9t;
assign hit_b1_b9t = ((y_block1 + 8'd20 == y_block9) && (x_block1 + 8'd20 > x_block9) && (x_block1 < x_block9 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b1_pt;
assign hit_b1_pt = ((y_block1 + 8'd20 == y_pad) && (x_block1 + 8'd20 > x_pad) && (x_block1 < x_pad + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b1_ht;
assign hit_b1_ht = ((y_block1 + 8'd20 == y_hive) && (x_block1 + 8'd20 > x_hive) && (x_block1 < x_hive + 8'd60)) ? 1'b1 : 1'b0;
wire hit_b1_let;
assign hit_b1_let = ((y_block1 + 8'd20 == y_leaves) && (x_block1 + 8'd20 > x_leaves) && (x_block1 < x_leaves + 8'd60)) ? 1'b1 : 1'b0;


//box 1 hit blox on bottom 
wire hit_b1_b2b;
assign hit_b1_b2b = ((y_block1 == y_block2 + 8'd20) && (x_block1 + 8'd20 > x_block2) && (x_block1 < x_block2 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b1_b3b;
assign hit_b1_b3b = ((y_block1 == y_block3 + 8'd20) && (x_block1 + 8'd20 > x_block3) && (x_block1 < x_block3 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b1_b4b;
assign hit_b1_b4b = ((y_block1 == y_block4 + 8'd20) && (x_block1 + 8'd20 > x_block4) && (x_block1 < x_block4 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b1_b5b;
assign hit_b1_b5b = ((y_block1 == y_block5 + 8'd20) && (x_block1 + 8'd20 > x_block5) && (x_block1 < x_block5 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b1_b6b;
assign hit_b1_b6b = ((y_block1 == y_block6 + 8'd20) && (x_block1 + 8'd20 > x_block6) && (x_block1 < x_block6 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b1_b7b;
assign hit_b1_b7b = ((y_block1 == y_block7 + 8'd20) && (x_block1 + 8'd20 > x_block7) && (x_block1 < x_block7 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b1_b8b;
assign hit_b1_b8b = ((y_block1 == y_block8 + 8'd20) && (x_block1 + 8'd20 > x_block8) && (x_block1 < x_block8 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b1_b9b;
assign hit_b1_b9b = ((y_block1 == y_block9 + 8'd20) && (x_block1 + 8'd20 > x_block9) && (x_block1 < x_block9 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b1_pb;
assign hit_b1_pb = ((y_block1 == y_pad + 8'd20) && (x_block1 + 8'd20 > x_pad) && (x_block1 < x_pad + 8'd20)) ? 1'b1 : 1'b0;

//box 1 hit blox on left 
wire hit_b1_b2l;
assign hit_b1_b2l = ((x_block1 + 8'd20 == x_block2) && (y_block1 + 8'd20 > y_block2) && (y_block1 < y_block2 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b1_b3l;
assign hit_b1_b3l = ((x_block1 + 8'd20 == x_block3) && (y_block1 + 8'd20 > y_block3) && (y_block1 < y_block3 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b1_b4l;
assign hit_b1_b4l = ((x_block1 + 8'd20 == x_block4) && (y_block1 + 8'd20 > y_block4) && (y_block1 < y_block4 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b1_b5l;
assign hit_b1_b5l = ((x_block1 + 8'd20 == x_block5) && (y_block1 + 8'd20 > y_block5) && (y_block1 < y_block5 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b1_b6l;
assign hit_b1_b6l = ((x_block1 + 8'd20 == x_block6) && (y_block1 + 8'd20 > y_block6) && (y_block1 < y_block6 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b1_b7l;
assign hit_b1_b7l = ((x_block1 + 8'd20 == x_block7) && (y_block1 + 8'd20 > y_block7) && (y_block1 < y_block7 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b1_b8l;
assign hit_b1_b8l = ((x_block1 + 8'd20 == x_block8) && (y_block1 + 8'd20 > y_block8) && (y_block1 < y_block8 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b1_b9l;
assign hit_b1_b9l = ((x_block1 + 8'd20 == x_block9) && (y_block1 + 8'd20 > y_block9) && (y_block1 < y_block9 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b1_pl;
assign hit_b1_pl = ((x_block1 + 8'd20 == x_pad) && (y_block1 + 8'd20 > y_pad) && (y_block1 < y_pad + 8'd20)) ? 1'b1 : 1'b0;

//box 1 hit blox on right 
wire hit_b1_b2r;
assign hit_b1_b2r = ((x_block1 == x_block2 + 8'd20) && (y_block1 + 8'd20 > y_block2) && (y_block1 < y_block2 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b1_b3r;
assign hit_b1_b3r = ((x_block1 == x_block3 + 8'd20) && (y_block1 + 8'd20 > y_block3) && (y_block1 < y_block3 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b1_b4r;
assign hit_b1_b4r = ((x_block1 == x_block4 + 8'd20) && (y_block1 + 8'd20 > y_block4) && (y_block1 < y_block4 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b1_b5r;
assign hit_b1_b5r = ((x_block1 == x_block5 + 8'd20) && (y_block1 + 8'd20 > y_block5) && (y_block1 < y_block5 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b1_b6r;
assign hit_b1_b6r = ((x_block1 == x_block6 + 8'd20) && (y_block1 + 8'd20 > y_block6) && (y_block1 < y_block6 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b1_b7r;
assign hit_b1_b7r = ((x_block1 == x_block7 + 8'd20) && (y_block1 + 8'd20 > y_block7) && (y_block1 < y_block7 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b1_b8r;
assign hit_b1_b8r = ((x_block1 == x_block8 + 8'd20) && (y_block1 + 8'd20 > y_block8) && (y_block1 < y_block8 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b1_b9r;
assign hit_b1_b9r = ((x_block1 == x_block9 + 8'd20) && (y_block1 + 8'd20 > y_block9) && (y_block1 < y_block9 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b1_pr;
assign hit_b1_pr = ((x_block1 == x_pad + 8'd20) && (y_block1 + 8'd20 > y_pad) && (y_block1 < y_pad + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b1_hr;
assign hit_b1_hr = ((x_block9 == x_hive + 8'd60) && (y_block9 + 8'd20 > y_hive) && (y_block9 < y_hive + 8'd60)) ? 1'b1 : 1'b0;
wire hit_b1_ler;
assign hit_b1_ler = ((x_block1 == x_leaves + 8'd60) && (y_block1 + 8'd20 > y_leaves) && (y_block1 < y_leaves + 8'd90)) ? 1'b1 : 1'b0;


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Hang on to your hats, we've got a long way to go, hit detection for block2 hitting blocks on its top
wire hit_b2_b1t;
assign hit_b2_b1t = ((y_block2 + 8'd20 == y_block1) && (x_block2 + 8'd20 > x_block1) && (x_block2 < x_block1 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b2_b3t;
assign hit_b2_b3t = ((y_block2 + 8'd20 == y_block3) && (x_block2 + 8'd20 > x_block3) && (x_block2 < x_block3 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b2_b4t;
assign hit_b2_b4t = ((y_block2 + 8'd20 == y_block4) && (x_block2 + 8'd20 > x_block4) && (x_block2 < x_block4 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b2_b5t;
assign hit_b2_b5t = ((y_block2 + 8'd20 == y_block5) && (x_block2 + 8'd20 > x_block5) && (x_block2 < x_block5 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b2_b6t;
assign hit_b2_b6t = ((y_block2 + 8'd20 == y_block6) && (x_block2 + 8'd20 > x_block6) && (x_block2 < x_block6 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b2_b7t;
assign hit_b2_b7t = ((y_block2 + 8'd20 == y_block7) && (x_block2 + 8'd20 > x_block7) && (x_block2 < x_block7 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b2_b8t;
assign hit_b2_b8t = ((y_block2 + 8'd20 == y_block8) && (x_block2 + 8'd20 > x_block8) && (x_block2 < x_block8 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b2_b9t;
assign hit_b2_b9t = ((y_block2 + 8'd20 == y_block9) && (x_block2 + 8'd20 > x_block9) && (x_block2 < x_block9 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b2_pt;
assign hit_b2_pt = ((y_block2 + 8'd20 == y_pad) && (x_block2 + 8'd20 > x_pad) && (x_block2 < x_pad + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b2_ht;
assign hit_b2_ht = ((y_block2 + 8'd20 == y_hive) && (x_block2 + 8'd20 > x_hive) && (x_block2 < x_hive + 8'd60)) ? 1'b1 : 1'b0;
wire hit_b2_let;
assign hit_b2_let = ((y_block2 + 8'd20 == y_leaves) && (x_block2 + 8'd20 > x_leaves) && (x_block2 < x_leaves + 8'd60)) ? 1'b1 : 1'b0;

//box 2 hit blox on bottom 
wire hit_b2_b1b;
assign hit_b2_b1b = ((y_block2 == y_block1 + 8'd20) && (x_block2 + 8'd20 > x_block1) && (x_block2 < x_block1 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b2_b3b;
assign hit_b2_b3b = ((y_block2 == y_block3 + 8'd20) && (x_block2 + 8'd20 > x_block3) && (x_block2 < x_block3 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b2_b4b;
assign hit_b2_b4b = ((y_block2 == y_block4 + 8'd20) && (x_block2 + 8'd20 > x_block4) && (x_block2 < x_block4 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b2_b5b;
assign hit_b2_b5b = ((y_block2 == y_block5 + 8'd20) && (x_block2 + 8'd20 > x_block5) && (x_block2 < x_block5 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b2_b6b;
assign hit_b2_b6b = ((y_block2 == y_block6 + 8'd20) && (x_block2 + 8'd20 > x_block6) && (x_block2 < x_block6 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b2_b7b;
assign hit_b2_b7b = ((y_block2 == y_block7 + 8'd20) && (x_block2 + 8'd20 > x_block7) && (x_block2 < x_block7 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b2_b8b;
assign hit_b2_b8b = ((y_block2 == y_block8 + 8'd20) && (x_block2 + 8'd20 > x_block8) && (x_block2 < x_block8 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b2_b9b;
assign hit_b2_b9b = ((y_block2 == y_block9 + 8'd20) && (x_block2 + 8'd20 > x_block9) && (x_block2 < x_block9 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b2_pb;
assign hit_b2_pb = ((y_block2 == y_pad + 8'd20) && (x_block2 + 8'd20 > x_pad) && (x_block2 < x_pad + 8'd20)) ? 1'b1 : 1'b0;

//box 2 hit blox on left 
wire hit_b2_b1l;
assign hit_b2_b1l = ((x_block2 + 8'd20 == x_block1) && (y_block2 + 8'd20 > y_block1) && (y_block2 < y_block1 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b2_b3l;
assign hit_b2_b3l = ((x_block2 + 8'd20 == x_block3) && (y_block2 + 8'd20 > y_block3) && (y_block2 < y_block3 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b2_b4l;
assign hit_b2_b4l = ((x_block2 + 8'd20 == x_block4) && (y_block2 + 8'd20 > y_block4) && (y_block2 < y_block4 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b2_b5l;
assign hit_b2_b5l = ((x_block2 + 8'd20 == x_block5) && (y_block2 + 8'd20 > y_block5) && (y_block2 < y_block5 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b2_b6l;
assign hit_b2_b6l = ((x_block2 + 8'd20 == x_block6) && (y_block2 + 8'd20 > y_block6) && (y_block2 < y_block6 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b2_b7l;
assign hit_b2_b7l = ((x_block2 + 8'd20 == x_block7) && (y_block2 + 8'd20 > y_block7) && (y_block2 < y_block7 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b2_b8l;
assign hit_b2_b8l = ((x_block2 + 8'd20 == x_block8) && (y_block2 + 8'd20 > y_block8) && (y_block2 < y_block8 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b2_b9l;
assign hit_b2_b9l = ((x_block2 + 8'd20 == x_block9) && (y_block2 + 8'd20 > y_block9) && (y_block2 < y_block9 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b2_pl;
assign hit_b2_pl = ((x_block2 + 8'd20 == x_pad) && (y_block2 + 8'd20 > y_pad) && (y_block2 < y_pad + 8'd20)) ? 1'b1 : 1'b0;

//box 2 hit blox on right 
wire hit_b2_b1r;
assign hit_b2_b1r = ((x_block2 == x_block1 + 8'd20) && (y_block2 + 8'd20 > y_block1) && (y_block2 < y_block1 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b2_b3r;
assign hit_b2_b3r = ((x_block2 == x_block3 + 8'd20) && (y_block2 + 8'd20 > y_block3) && (y_block2 < y_block3 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b2_b4r;
assign hit_b2_b4r = ((x_block2 == x_block4 + 8'd20) && (y_block2 + 8'd20 > y_block4) && (y_block2 < y_block4 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b2_b5r;
assign hit_b2_b5r = ((x_block2 == x_block5 + 8'd20) && (y_block2 + 8'd20 > y_block5) && (y_block2 < y_block5 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b2_b6r;
assign hit_b2_b6r = ((x_block2 == x_block6 + 8'd20) && (y_block2 + 8'd20 > y_block6) && (y_block2 < y_block6 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b2_b7r;
assign hit_b2_b7r = ((x_block2 == x_block7 + 8'd20) && (y_block2 + 8'd20 > y_block7) && (y_block2 < y_block7 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b2_b8r;
assign hit_b2_b8r = ((x_block2 == x_block8 + 8'd20) && (y_block2 + 8'd20 > y_block8) && (y_block2 < y_block8 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b2_b9r;
assign hit_b2_b9r = ((x_block2 == x_block9 + 8'd20) && (y_block2 + 8'd20 > y_block9) && (y_block2 < y_block9 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b2_pr;
assign hit_b2_pr = ((x_block2 == x_pad + 8'd20) && (y_block2 + 8'd20 > y_pad) && (y_block2 < y_pad + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b2_hr;
assign hit_b2_hr = ((x_block2 == x_hive + 8'd60) && (y_block2 + 8'd20 > y_hive) && (y_block2 < y_hive + 8'd60)) ? 1'b1 : 1'b0;
wire hit_b2_ler;
assign hit_b2_ler = ((x_block2 == x_leaves + 8'd60) && (y_block2 + 8'd20 > y_leaves) && (y_block2 < y_leaves + 8'd90)) ? 1'b1 : 1'b0;


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Hang on to your hats, we've got a long way to go, hit detection for block3 hitting blocks on its top
wire hit_b3_b1t;
assign hit_b3_b1t = ((y_block3 + 8'd20 == y_block1) && (x_block3 + 8'd20 > x_block1) && (x_block3 < x_block1 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b3_b2t;
assign hit_b3_b2t = ((y_block3 + 8'd20 == y_block2) && (x_block3 + 8'd20 > x_block2) && (x_block3 < x_block2 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b3_b4t;
assign hit_b3_b4t = ((y_block3 + 8'd20 == y_block4) && (x_block3 + 8'd20 > x_block4) && (x_block3 < x_block4 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b3_b5t;
assign hit_b3_b5t = ((y_block3 + 8'd20 == y_block5) && (x_block3 + 8'd20 > x_block5) && (x_block3 < x_block5 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b3_b6t;
assign hit_b3_b6t = ((y_block3 + 8'd20 == y_block6) && (x_block3 + 8'd20 > x_block6) && (x_block3 < x_block6 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b3_b7t;
assign hit_b3_b7t = ((y_block3 + 8'd20 == y_block7) && (x_block3 + 8'd20 > x_block7) && (x_block3 < x_block7 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b3_b8t;
assign hit_b3_b8t = ((y_block3 + 8'd20 == y_block8) && (x_block3 + 8'd20 > x_block8) && (x_block3 < x_block8 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b3_b9t;
assign hit_b3_b9t = ((y_block3 + 8'd20 == y_block9) && (x_block3 + 8'd20 > x_block9) && (x_block3 < x_block9 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b3_pt;
assign hit_b3_pt = ((y_block3 + 8'd20 == y_pad) && (x_block3 + 8'd20 > x_pad) && (x_block3 < x_pad + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b3_ht;
assign hit_b3_ht = ((y_block3 + 8'd20 == y_hive) && (x_block3 + 8'd20 > x_hive) && (x_block3 < x_hive + 8'd60)) ? 1'b1 : 1'b0;
wire hit_b3_let;
assign hit_b3_let = ((y_block3 + 8'd20 == y_leaves) && (x_block3 + 8'd20 > x_leaves) && (x_block3 < x_leaves + 8'd60)) ? 1'b1 : 1'b0;


//box 3 hit blox on bottom 
wire hit_b3_b1b;
assign hit_b3_b1b = ((y_block3 == y_block1 + 8'd20) && (x_block3 + 8'd20 > x_block1) && (x_block3 < x_block1 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b3_b2b;
assign hit_b3_b2b = ((y_block3 == y_block2 + 8'd20) && (x_block2 + 8'd20 > x_block2) && (x_block3 < x_block2 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b3_b4b;
assign hit_b3_b4b = ((y_block3 == y_block4 + 8'd20) && (x_block3 + 8'd20 > x_block4) && (x_block3 < x_block4 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b3_b5b;
assign hit_b3_b5b = ((y_block3 == y_block5 + 8'd20) && (x_block3 + 8'd20 > x_block5) && (x_block3 < x_block5 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b3_b6b;
assign hit_b3_b6b = ((y_block3 == y_block6 + 8'd20) && (x_block3 + 8'd20 > x_block6) && (x_block3 < x_block6 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b3_b7b;
assign hit_b3_b7b = ((y_block3 == y_block7 + 8'd20) && (x_block3 + 8'd20 > x_block7) && (x_block3 < x_block7 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b3_b8b;
assign hit_b3_b8b = ((y_block3 == y_block8 + 8'd20) && (x_block3 + 8'd20 > x_block8) && (x_block3 < x_block8 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b3_b9b;
assign hit_b3_b9b = ((y_block3 == y_block9 + 8'd20) && (x_block3 + 8'd20 > x_block9) && (x_block3 < x_block9 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b3_pb;
assign hit_b3_pb = ((y_block3 == y_pad + 8'd20) && (x_block3 + 8'd20 > x_pad) && (x_block3 < x_pad + 8'd20)) ? 1'b1 : 1'b0;

//box 3 hit blox on left 
wire hit_b3_b1l;
assign hit_b3_b1l = ((x_block3 + 8'd20 == x_block1) && (y_block3 + 8'd20 > y_block1) && (y_block3 < y_block1 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b3_b2l;
assign hit_b3_b2l = ((x_block3 + 8'd20 == x_block2) && (y_block3 + 8'd20 > y_block2) && (y_block3 < y_block2 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b3_b4l;
assign hit_b3_b4l = ((x_block3 + 8'd20 == x_block4) && (y_block3 + 8'd20 > y_block4) && (y_block3 < y_block4 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b3_b5l;
assign hit_b3_b5l = ((x_block3 + 8'd20 == x_block5) && (y_block3 + 8'd20 > y_block5) && (y_block3 < y_block5 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b3_b6l;
assign hit_b3_b6l = ((x_block3 + 8'd20 == x_block6) && (y_block3 + 8'd20 > y_block6) && (y_block3 < y_block6 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b3_b7l;
assign hit_b3_b7l = ((x_block3 + 8'd20 == x_block7) && (y_block3 + 8'd20 > y_block7) && (y_block3 < y_block7 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b3_b8l;
assign hit_b3_b8l = ((x_block3 + 8'd20 == x_block8) && (y_block3 + 8'd20 > y_block8) && (y_block3 < y_block8 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b3_b9l;
assign hit_b3_b9l = ((x_block3 + 8'd20 == x_block9) && (y_block3 + 8'd20 > y_block9) && (y_block3 < y_block9 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b3_pl;
assign hit_b3_pl = ((x_block3 + 8'd20 == x_pad) && (y_block3 + 8'd20 > y_pad) && (y_block3 < y_pad + 8'd20)) ? 1'b1 : 1'b0;

//box 3 hit blox on right 
wire hit_b3_b1r;
assign hit_b3_b1r = ((x_block3 == x_block1 + 8'd20) && (y_block3 + 8'd20 > y_block1) && (y_block3 < y_block1 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b3_b2r;
assign hit_b3_b2r = ((x_block3 == x_block2 + 8'd20) && (y_block3 + 8'd20 > y_block2) && (y_block3 < y_block2 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b3_b4r;
assign hit_b3_b4r = ((x_block3 == x_block4 + 8'd20) && (y_block3 + 8'd20 > y_block4) && (y_block3 < y_block4 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b3_b5r;
assign hit_b3_b5r = ((x_block3 == x_block5 + 8'd20) && (y_block3 + 8'd20 > y_block5) && (y_block3 < y_block5 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b3_b6r;
assign hit_b3_b6r = ((x_block3 == x_block6 + 8'd20) && (y_block3 + 8'd20 > y_block6) && (y_block3 < y_block6 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b3_b7r;
assign hit_b3_b7r = ((x_block3 == x_block7 + 8'd20) && (y_block3 + 8'd20 > y_block7) && (y_block3 < y_block7 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b3_b8r;
assign hit_b3_b8r = ((x_block3 == x_block8 + 8'd20) && (y_block3 + 8'd20 > y_block8) && (y_block3 < y_block8 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b3_b9r;
assign hit_b3_b9r = ((x_block3 == x_block9 + 8'd20) && (y_block3 + 8'd20 > y_block9) && (y_block3 < y_block9 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b3_pr;
assign hit_b3_pr = ((x_block3 == x_pad + 8'd20) && (y_block3 + 8'd20 > y_pad) && (y_block3 < y_pad + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b3_hr;
assign hit_b3_hr = ((x_block3 == x_hive + 8'd60) && (y_block3 + 8'd20 > y_hive) && (y_block3 < y_hive + 8'd60)) ? 1'b1 : 1'b0;
wire hit_b3_ler;
assign hit_b3_ler = ((x_block3 == x_leaves + 8'd60) && (y_block3 + 8'd20 > y_leaves) && (y_block3 < y_leaves + 8'd90)) ? 1'b1 : 1'b0;


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Hang on to your hats, we've got a long way to go, hit detection for block4 hitting blocks on its top
wire hit_b4_b1t;
assign hit_b4_b1t = ((y_block4 + 8'd20 == y_block1) && (x_block4 + 8'd20 > x_block1) && (x_block4 < x_block1 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b4_b2t;
assign hit_b4_b2t = ((y_block4 + 8'd20 == y_block2) && (x_block4 + 8'd20 > x_block2) && (x_block4 < x_block2 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b4_b3t;
assign hit_b4_b3t = ((y_block4 + 8'd20 == y_block3) && (x_block4 + 8'd20 > x_block3) && (x_block4 < x_block3 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b4_b5t;
assign hit_b4_b5t = ((y_block4 + 8'd20 == y_block5) && (x_block4 + 8'd20 > x_block5) && (x_block4 < x_block5 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b4_b6t;
assign hit_b4_b6t = ((y_block4 + 8'd20 == y_block6) && (x_block4 + 8'd20 > x_block6) && (x_block4 < x_block6 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b4_b7t;
assign hit_b4_b7t = ((y_block4 + 8'd20 == y_block7) && (x_block4 + 8'd20 > x_block7) && (x_block4 < x_block7 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b4_b8t;
assign hit_b4_b8t = ((y_block4 + 8'd20 == y_block8) && (x_block4 + 8'd20 > x_block8) && (x_block4 < x_block8 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b4_b9t;
assign hit_b4_b9t = ((y_block4 + 8'd20 == y_block9) && (x_block4 + 8'd20 > x_block9) && (x_block4 < x_block9 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b4_pt;
assign hit_b4_pt = ((y_block4 + 8'd20 == y_pad) && (x_block4 + 8'd20 > x_pad) && (x_block4 < x_pad + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b4_ht;
assign hit_b4_ht = ((y_block4 + 8'd20 == y_hive) && (x_block4 + 8'd20 > x_hive) && (x_block4 < x_hive + 8'd60)) ? 1'b1 : 1'b0;
wire hit_b4_let;
assign hit_b4_let = ((y_block4 + 8'd20 == y_leaves) && (x_block4 + 8'd20 > x_leaves) && (x_block4 < x_leaves + 8'd60)) ? 1'b1 : 1'b0;


//box 4 hit blox on bottom 
wire hit_b4_b1b;
assign hit_b4_b1b = ((y_block4 == y_block1 + 8'd20) && (x_block4 + 8'd20 > x_block1) && (x_block4 < x_block1 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b4_b2b;
assign hit_b4_b2b = ((y_block4 == y_block2 + 8'd20) && (x_block2 + 8'd20 > x_block2) && (x_block4 < x_block2 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b4_b3b;
assign hit_b4_b3b = ((y_block4 == y_block3 + 8'd20) && (x_block4 + 8'd20 > x_block3) && (x_block4 < x_block3 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b4_b5b;
assign hit_b4_b5b = ((y_block4 == y_block5 + 8'd20) && (x_block4 + 8'd20 > x_block5) && (x_block4 < x_block5 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b4_b6b;
assign hit_b4_b6b = ((y_block4 == y_block6 + 8'd20) && (x_block4 + 8'd20 > x_block6) && (x_block4 < x_block6 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b4_b7b;
assign hit_b4_b7b = ((y_block4 == y_block7 + 8'd20) && (x_block4 + 8'd20 > x_block7) && (x_block4 < x_block7 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b4_b8b;
assign hit_b4_b8b = ((y_block4 == y_block8 + 8'd20) && (x_block4 + 8'd20 > x_block8) && (x_block4 < x_block8 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b4_b9b;
assign hit_b4_b9b = ((y_block4 == y_block9 + 8'd20) && (x_block4 + 8'd20 > x_block9) && (x_block4 < x_block9 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b4_pb;
assign hit_b4_pb = ((y_block4 == y_pad + 8'd20) && (x_block4 + 8'd20 > x_pad) && (x_block4 < x_pad + 8'd20)) ? 1'b1 : 1'b0;

//box 4 hit blox on left 
wire hit_b4_b1l;
assign hit_b4_b1l = ((x_block4 + 8'd20 == x_block1) && (y_block4 + 8'd20 > y_block1) && (y_block4 < y_block1 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b4_b2l;
assign hit_b4_b2l = ((x_block4 + 8'd20 == x_block2) && (y_block4 + 8'd20 > y_block2) && (y_block4 < y_block2 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b4_b3l;
assign hit_b4_b3l = ((x_block4 + 8'd20 == x_block3) && (y_block4 + 8'd20 > y_block3) && (y_block4 < y_block3 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b4_b5l;
assign hit_b4_b5l = ((x_block4 + 8'd20 == x_block5) && (y_block4 + 8'd20 > y_block5) && (y_block4 < y_block5 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b4_b6l;
assign hit_b4_b6l = ((x_block4 + 8'd20 == x_block6) && (y_block4 + 8'd20 > y_block6) && (y_block4 < y_block6 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b4_b7l;
assign hit_b4_b7l = ((x_block4 + 8'd20 == x_block7) && (y_block4 + 8'd20 > y_block7) && (y_block4 < y_block7 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b4_b8l;
assign hit_b4_b8l = ((x_block4 + 8'd20 == x_block8) && (y_block4 + 8'd20 > y_block8) && (y_block4 < y_block8 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b4_b9l;
assign hit_b4_b9l = ((x_block4 + 8'd20 == x_block9) && (y_block4 + 8'd20 > y_block9) && (y_block4 < y_block9 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b4_pl;
assign hit_b4_pl = ((x_block4 + 8'd20 == x_pad) && (y_block4 + 8'd20 > y_pad) && (y_block4 < y_pad + 8'd20)) ? 1'b1 : 1'b0;

//box 4 hit blox on right 
wire hit_b4_b1r;
assign hit_b4_b1r = ((x_block4 == x_block1 + 8'd20) && (y_block4 + 8'd20 > y_block1) && (y_block4 < y_block1 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b4_b2r;
assign hit_b4_b2r = ((x_block4 == x_block2 + 8'd20) && (y_block4 + 8'd20 > y_block2) && (y_block4 < y_block2 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b4_b3r;
assign hit_b4_b3r = ((x_block4 == x_block3 + 8'd20) && (y_block3 + 8'd20 > y_block4) && (y_block4 < y_block3 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b4_b5r;
assign hit_b4_b5r = ((x_block4 == x_block5 + 8'd20) && (y_block4 + 8'd20 > y_block5) && (y_block4 < y_block5 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b4_b6r;
assign hit_b4_b6r = ((x_block4 == x_block6 + 8'd20) && (y_block4 + 8'd20 > y_block6) && (y_block4 < y_block6 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b4_b7r;
assign hit_b4_b7r = ((x_block4 == x_block7 + 8'd20) && (y_block4 + 8'd20 > y_block7) && (y_block4 < y_block7 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b4_b8r;
assign hit_b4_b8r = ((x_block4 == x_block8 + 8'd20) && (y_block4 + 8'd20 > y_block8) && (y_block4 < y_block8 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b4_b9r;
assign hit_b4_b9r = ((x_block4 == x_block9 + 8'd20) && (y_block4 + 8'd20 > y_block9) && (y_block4 < y_block9 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b4_pr;
assign hit_b4_pr = ((x_block4 == x_pad + 8'd20) && (y_block4 + 8'd20 > y_pad) && (y_block4 < y_pad + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b4_hr;
assign hit_b4_hr = ((x_block4 == x_hive + 8'd60) && (y_block4 + 8'd20 > y_hive) && (y_block4 < y_hive + 8'd60)) ? 1'b1 : 1'b0;
wire hit_b4_ler;
assign hit_b4_ler = ((x_block4 == x_leaves + 8'd60) && (y_block4 + 8'd20 > y_leaves) && (y_block4 < y_leaves + 8'd90)) ? 1'b1 : 1'b0;


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Hang on to your hats, we've got a long way to go, hit detection for block5 hitting blocks on its top
wire hit_b5_b1t;
assign hit_b5_b1t = ((y_block5 + 8'd20 == y_block1) && (x_block5 + 8'd20 > x_block1) && (x_block5 < x_block1 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b5_b2t;
assign hit_b5_b2t = ((y_block5 + 8'd20 == y_block2) && (x_block5 + 8'd20 > x_block2) && (x_block5 < x_block2 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b5_b3t;
assign hit_b5_b3t = ((y_block5 + 8'd20 == y_block3) && (x_block5 + 8'd20 > x_block3) && (x_block5 < x_block3 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b5_b4t;
assign hit_b5_b4t = ((y_block5 + 8'd20 == y_block4) && (x_block5 + 8'd20 > x_block4) && (x_block5 < x_block4 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b5_b6t;
assign hit_b5_b6t = ((y_block5 + 8'd20 == y_block6) && (x_block5 + 8'd20 > x_block6) && (x_block5 < x_block6 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b5_b7t;
assign hit_b5_b7t = ((y_block5 + 8'd20 == y_block7) && (x_block5 + 8'd20 > x_block7) && (x_block5 < x_block7 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b5_b8t;
assign hit_b5_b8t = ((y_block5 + 8'd20 == y_block8) && (x_block5 + 8'd20 > x_block8) && (x_block5 < x_block8 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b5_b9t;
assign hit_b5_b9t = ((y_block5 + 8'd20 == y_block9) && (x_block5 + 8'd20 > x_block9) && (x_block5 < x_block9 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b5_pt;
assign hit_b5_pt = ((y_block5 + 8'd20 == y_pad) && (x_block5 + 8'd20 > x_pad) && (x_block5 < x_pad + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b5_ht;
assign hit_b5_ht = ((y_block5 + 8'd20 == y_hive) && (x_block5 + 8'd20 > x_hive) && (x_block5 < x_hive + 8'd60)) ? 1'b1 : 1'b0;
wire hit_b5_let;
assign hit_b5_let = ((y_block5 + 8'd20 == y_leaves) && (x_block5 + 8'd20 > x_leaves) && (x_block5 < x_leaves + 8'd60)) ? 1'b1 : 1'b0;

//box 5 hit blox on bottom 
wire hit_b5_b1b;
assign hit_b5_b1b = ((y_block5 == y_block1 + 8'd20) && (x_block5 + 8'd20 > x_block1) && (x_block5 < x_block1 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b5_b2b;
assign hit_b5_b2b = ((y_block5 == y_block2 + 8'd20) && (x_block2 + 8'd20 > x_block2) && (x_block5 < x_block2 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b5_b3b;
assign hit_b5_b3b = ((y_block5 == y_block3 + 8'd20) && (x_block5 + 8'd20 > x_block3) && (x_block5 < x_block3 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b5_b4b;
assign hit_b5_b4b = ((y_block5 == y_block4 + 8'd20) && (x_block5 + 8'd20 > x_block4) && (x_block5 < x_block4 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b5_b6b;
assign hit_b5_b6b = ((y_block5 == y_block6 + 8'd20) && (x_block5 + 8'd20 > x_block6) && (x_block5 < x_block6 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b5_b7b;
assign hit_b5_b7b = ((y_block5 == y_block7 + 8'd20) && (x_block5 + 8'd20 > x_block7) && (x_block5 < x_block7 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b5_b8b;
assign hit_b5_b8b = ((y_block5 == y_block8 + 8'd20) && (x_block5 + 8'd20 > x_block8) && (x_block5 < x_block8 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b5_b9b;
assign hit_b5_b9b = ((y_block5 == y_block9 + 8'd20) && (x_block5 + 8'd20 > x_block9) && (x_block5 < x_block9 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b5_pb;
assign hit_b5_pb = ((y_block5 == y_pad + 8'd20) && (x_block5 + 8'd20 > x_pad) && (x_block5 < x_pad + 8'd20)) ? 1'b1 : 1'b0;

//box 5 hit blox on left 
wire hit_b5_b1l;
assign hit_b5_b1l = ((x_block5 + 8'd20 == x_block1) && (y_block5 + 8'd20 > y_block1) && (y_block5 < y_block1 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b5_b2l;
assign hit_b5_b2l = ((x_block5 + 8'd20 == x_block2) && (y_block5 + 8'd20 > y_block2) && (y_block5 < y_block2 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b5_b3l;
assign hit_b5_b3l = ((x_block5 + 8'd20 == x_block3) && (y_block5 + 8'd20 > y_block3) && (y_block5 < y_block3 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b5_b4l;
assign hit_b5_b4l = ((x_block5 + 8'd20 == x_block4) && (y_block5 + 8'd20 > y_block4) && (y_block5 < y_block4 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b5_b6l;
assign hit_b5_b6l = ((x_block5 + 8'd20 == x_block6) && (y_block5 + 8'd20 > y_block6) && (y_block5 < y_block6 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b5_b7l;
assign hit_b5_b7l = ((x_block5 + 8'd20 == x_block7) && (y_block5 + 8'd20 > y_block7) && (y_block5 < y_block7 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b5_b8l;
assign hit_b5_b8l = ((x_block5 + 8'd20 == x_block8) && (y_block5 + 8'd20 > y_block8) && (y_block5 < y_block8 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b5_b9l;
assign hit_b5_b9l = ((x_block5 + 8'd20 == x_block9) && (y_block5 + 8'd20 > y_block9) && (y_block5 < y_block9 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b5_pl;
assign hit_b5_pl = ((x_block5 + 8'd20 == x_pad) && (y_block5 + 8'd20 > y_pad) && (y_block5 < y_pad + 8'd20)) ? 1'b1 : 1'b0;

//box 5 hit blox on right 
wire hit_b5_b1r;
assign hit_b5_b1r = ((x_block5 == x_block1 + 8'd20) && (y_block5 + 8'd20 > y_block1) && (y_block5 < y_block1 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b5_b2r;
assign hit_b5_b2r = ((x_block5 == x_block2 + 8'd20) && (y_block5 + 8'd20 > y_block2) && (y_block5 < y_block2 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b5_b3r;
assign hit_b5_b3r = ((x_block5 == x_block3 + 8'd20) && (y_block3 + 8'd20 > y_block5) && (y_block5 < y_block3 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b5_b4r;
assign hit_b5_b4r = ((x_block5 == x_block4 + 8'd20) && (y_block5 + 8'd20 > y_block4) && (y_block5 < y_block4 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b5_b6r;
assign hit_b5_b6r = ((x_block5 == x_block6 + 8'd20) && (y_block5 + 8'd20 > y_block6) && (y_block5 < y_block6 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b5_b7r;
assign hit_b5_b7r = ((x_block5 == x_block7 + 8'd20) && (y_block5 + 8'd20 > y_block7) && (y_block5 < y_block7 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b5_b8r;
assign hit_b5_b8r = ((x_block5 == x_block8 + 8'd20) && (y_block5 + 8'd20 > y_block8) && (y_block5 < y_block8 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b5_b9r;
assign hit_b5_b9r = ((x_block5 == x_block9 + 8'd20) && (y_block5 + 8'd20 > y_block9) && (y_block5 < y_block9 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b5_pr;
assign hit_b5_pr = ((x_block5 == x_pad + 8'd20) && (y_block5 + 8'd20 > y_pad) && (y_block5 < y_pad + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b5_hr;
assign hit_b5_hr = ((x_block5 == x_hive + 8'd60) && (y_block5 + 8'd20 > y_hive) && (y_block5 < y_hive + 8'd60)) ? 1'b1 : 1'b0;
wire hit_b5_ler;
assign hit_b5_ler = ((x_block5 == x_leaves + 8'd60) && (y_block5 + 8'd20 > y_leaves) && (y_block5 < y_leaves + 8'd90)) ? 1'b1 : 1'b0;


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Hang on to your hats, we've got a long way to go, hit detection for block6 hitting blocks on its top
wire hit_b6_b1t;
assign hit_b6_b1t = ((y_block6 + 8'd20 == y_block1) && (x_block6 + 8'd20 > x_block1) && (x_block6 < x_block1 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b6_b2t;
assign hit_b6_b2t = ((y_block6 + 8'd20 == y_block2) && (x_block6 + 8'd20 > x_block2) && (x_block6 < x_block2 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b6_b3t;
assign hit_b6_b3t = ((y_block6 + 8'd20 == y_block3) && (x_block6 + 8'd20 > x_block3) && (x_block6 < x_block3 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b6_b4t;
assign hit_b6_b4t = ((y_block6 + 8'd20 == y_block4) && (x_block6 + 8'd20 > x_block4) && (x_block6 < x_block4 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b6_b5t;
assign hit_b6_b5t = ((y_block6 + 8'd20 == y_block5) && (x_block6 + 8'd20 > x_block5) && (x_block6 < x_block5 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b6_b7t;
assign hit_b6_b7t = ((y_block6 + 8'd20 == y_block7) && (x_block6 + 8'd20 > x_block7) && (x_block6 < x_block7 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b6_b8t;
assign hit_b6_b8t = ((y_block6 + 8'd20 == y_block8) && (x_block6 + 8'd20 > x_block8) && (x_block6 < x_block8 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b6_b9t;
assign hit_b6_b9t = ((y_block6 + 8'd20 == y_block9) && (x_block6 + 8'd20 > x_block9) && (x_block6 < x_block9 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b6_pt;
assign hit_b6_pt = ((y_block6 + 8'd20 == y_pad) && (x_block6 + 8'd20 > x_pad) && (x_block6 < x_pad + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b6_ht;
assign hit_b6_ht = ((y_block6 + 8'd20 == y_hive) && (x_block6 + 8'd20 > x_hive) && (x_block6 < x_hive + 8'd60)) ? 1'b1 : 1'b0;
wire hit_b6_let;
assign hit_b6_let = ((y_block6 + 8'd20 == y_leaves) && (x_block6 + 8'd20 > x_leaves) && (x_block6 < x_leaves + 8'd60)) ? 1'b1 : 1'b0;

//box 6 hit blox on bottom 
wire hit_b6_b1b;
assign hit_b6_b1b = ((y_block6 == y_block1 + 8'd20) && (x_block6 + 8'd20 > x_block1) && (x_block6 < x_block1 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b6_b2b;
assign hit_b6_b2b = ((y_block6 == y_block2 + 8'd20) && (x_block2 + 8'd20 > x_block2) && (x_block6 < x_block2 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b6_b3b;
assign hit_b6_b3b = ((y_block6 == y_block3 + 8'd20) && (x_block6 + 8'd20 > x_block3) && (x_block6 < x_block3 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b6_b4b;
assign hit_b6_b4b = ((y_block6 == y_block4 + 8'd20) && (x_block6 + 8'd20 > x_block4) && (x_block6 < x_block4 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b6_b5b;
assign hit_b6_b5b = ((y_block6 == y_block5 + 8'd20) && (x_block6 + 8'd20 > x_block5) && (x_block6 < x_block5 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b6_b7b;
assign hit_b6_b7b = ((y_block6 == y_block7 + 8'd20) && (x_block6 + 8'd20 > x_block7) && (x_block6 < x_block7 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b6_b8b;
assign hit_b6_b8b = ((y_block6 == y_block8 + 8'd20) && (x_block6 + 8'd20 > x_block8) && (x_block6 < x_block8 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b6_b9b;
assign hit_b6_b9b = ((y_block6 == y_block9 + 8'd20) && (x_block6 + 8'd20 > x_block9) && (x_block6 < x_block9 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b6_pb;
assign hit_b6_pb = ((y_block6 == y_pad + 8'd20) && (x_block6 + 8'd20 > x_pad) && (x_block6 < x_pad + 8'd20)) ? 1'b1 : 1'b0;

//box 6 hit blox on left 
wire hit_b6_b1l;
assign hit_b6_b1l = ((x_block6 + 8'd20 == x_block1) && (y_block6 + 8'd20 > y_block1) && (y_block6 < y_block1 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b6_b2l;
assign hit_b6_b2l = ((x_block6 + 8'd20 == x_block2) && (y_block6 + 8'd20 > y_block2) && (y_block6 < y_block2 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b6_b3l;
assign hit_b6_b3l = ((x_block6 + 8'd20 == x_block3) && (y_block6 + 8'd20 > y_block3) && (y_block6 < y_block3 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b6_b4l;
assign hit_b6_b4l = ((x_block6 + 8'd20 == x_block4) && (y_block6 + 8'd20 > y_block4) && (y_block6 < y_block4 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b6_b5l;
assign hit_b6_b5l = ((x_block6 + 8'd20 == x_block5) && (y_block6 + 8'd20 > y_block5) && (y_block6 < y_block5 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b6_b7l;
assign hit_b6_b7l = ((x_block6 + 8'd20 == x_block7) && (y_block6 + 8'd20 > y_block7) && (y_block6 < y_block7 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b6_b8l;
assign hit_b6_b8l = ((x_block6 + 8'd20 == x_block8) && (y_block6 + 8'd20 > y_block8) && (y_block6 < y_block8 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b6_b9l;
assign hit_b6_b9l = ((x_block6 + 8'd20 == x_block9) && (y_block6 + 8'd20 > y_block9) && (y_block6 < y_block9 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b6_pl;
assign hit_b6_pl = ((x_block6 + 8'd20 == x_pad) && (y_block6 + 8'd20 > y_pad) && (y_block6 < y_pad + 8'd20)) ? 1'b1 : 1'b0;

//box 6 hit blox on right 
wire hit_b6_b1r;
assign hit_b6_b1r = ((x_block6 == x_block1 + 8'd20) && (y_block6 + 8'd20 > y_block1) && (y_block6 < y_block1 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b6_b2r;
assign hit_b6_b2r = ((x_block6 == x_block2 + 8'd20) && (y_block6 + 8'd20 > y_block2) && (y_block6 < y_block2 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b6_b3r;
assign hit_b6_b3r = ((x_block6 == x_block3 + 8'd20) && (y_block3 + 8'd20 > y_block6) && (y_block6 < y_block3 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b6_b4r;
assign hit_b6_b4r = ((x_block6 == x_block4 + 8'd20) && (y_block6 + 8'd20 > y_block4) && (y_block6 < y_block4 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b6_b5r;
assign hit_b6_b5r = ((x_block6 == x_block5 + 8'd20) && (y_block6 + 8'd20 > y_block5) && (y_block6 < y_block5 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b6_b7r;
assign hit_b6_b7r = ((x_block6 == x_block7 + 8'd20) && (y_block6 + 8'd20 > y_block7) && (y_block6 < y_block7 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b6_b8r;
assign hit_b6_b8r = ((x_block6 == x_block8 + 8'd20) && (y_block6 + 8'd20 > y_block8) && (y_block6 < y_block8 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b6_b9r;
assign hit_b6_b9r = ((x_block6 == x_block9 + 8'd20) && (y_block6 + 8'd20 > y_block9) && (y_block6 < y_block9 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b6_pr;
assign hit_b6_pr = ((x_block6 == x_pad + 8'd20) && (y_block6 + 8'd20 > y_pad) && (y_block6 < y_pad + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b6_hr;
assign hit_b6_hr = ((x_block6 == x_hive + 8'd60) && (y_block6 + 8'd20 > y_hive) && (y_block6 < y_hive + 8'd60)) ? 1'b1 : 1'b0;
wire hit_b6_ler;
assign hit_b6_ler = ((x_block6 == x_leaves + 8'd60) && (y_block6 + 8'd20 > y_leaves) && (y_block6 < y_leaves + 8'd90)) ? 1'b1 : 1'b0;


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Hang on to your hats, we've got a long way to go, hit detection for block7 hitting blocks on its top
wire hit_b7_b1t;
assign hit_b7_b1t = ((y_block7 + 8'd20 == y_block1) && (x_block7 + 8'd20 > x_block1) && (x_block7 < x_block1 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b7_b2t;
assign hit_b7_b2t = ((y_block7 + 8'd20 == y_block2) && (x_block7 + 8'd20 > x_block2) && (x_block7 < x_block2 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b7_b3t;
assign hit_b7_b3t = ((y_block7 + 8'd20 == y_block3) && (x_block7 + 8'd20 > x_block3) && (x_block7 < x_block3 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b7_b4t;
assign hit_b7_b4t = ((y_block7 + 8'd20 == y_block4) && (x_block7 + 8'd20 > x_block4) && (x_block7 < x_block4 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b7_b5t;
assign hit_b7_b5t = ((y_block7 + 8'd20 == y_block5) && (x_block7 + 8'd20 > x_block5) && (x_block7 < x_block5 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b7_b6t;
assign hit_b7_b6t = ((y_block7 + 8'd20 == y_block6) && (x_block7 + 8'd20 > x_block6) && (x_block7 < x_block6 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b7_b8t;
assign hit_b7_b8t = ((y_block7 + 8'd20 == y_block8) && (x_block7 + 8'd20 > x_block8) && (x_block7 < x_block8 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b7_b9t;
assign hit_b7_b9t = ((y_block7 + 8'd20 == y_block9) && (x_block7 + 8'd20 > x_block9) && (x_block7 < x_block9 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b7_pt;
assign hit_b7_pt = ((y_block7 + 8'd20 == y_pad) && (x_block7 + 8'd20 > x_pad) && (x_block7 < x_pad + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b7_ht;
assign hit_b7_ht = ((y_block7 + 8'd20 == y_hive) && (x_block7 + 8'd20 > x_hive) && (x_block7 < x_hive + 8'd60)) ? 1'b1 : 1'b0;
wire hit_b7_let;
assign hit_b7_let = ((y_block7 + 8'd20 == y_leaves) && (x_block7 + 8'd20 > x_leaves) && (x_block7 < x_leaves + 8'd60)) ? 1'b1 : 1'b0;

//box 7 hit blox on bottom 
wire hit_b7_b1b;
assign hit_b7_b1b = ((y_block7 == y_block1 + 8'd20) && (x_block7 + 8'd20 > x_block1) && (x_block7 < x_block1 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b7_b2b;
assign hit_b7_b2b = ((y_block7 == y_block2 + 8'd20) && (x_block2 + 8'd20 > x_block2) && (x_block7 < x_block2 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b7_b3b;
assign hit_b7_b3b = ((y_block7 == y_block3 + 8'd20) && (x_block7 + 8'd20 > x_block3) && (x_block7 < x_block3 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b7_b4b;
assign hit_b7_b4b = ((y_block7 == y_block4 + 8'd20) && (x_block7 + 8'd20 > x_block4) && (x_block7 < x_block4 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b7_b5b;
assign hit_b7_b5b = ((y_block7 == y_block5 + 8'd20) && (x_block7 + 8'd20 > x_block5) && (x_block7 < x_block5 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b7_b6b;
assign hit_b7_b6b = ((y_block7 == y_block6 + 8'd20) && (x_block7 + 8'd20 > x_block6) && (x_block7 < x_block6 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b7_b8b;
assign hit_b7_b8b = ((y_block7 == y_block8 + 8'd20) && (x_block7 + 8'd20 > x_block8) && (x_block7 < x_block8 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b7_b9b;
assign hit_b7_b9b = ((y_block7 == y_block9 + 8'd20) && (x_block7 + 8'd20 > x_block9) && (x_block7 < x_block9 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b7_pb;
assign hit_b7_pb = ((y_block7 == y_pad + 8'd20) && (x_block7 + 8'd20 > x_pad) && (x_block7 < x_pad + 8'd20)) ? 1'b1 : 1'b0;

//box 7 hit blox on left 
wire hit_b7_b1l;
assign hit_b7_b1l = ((x_block7 + 8'd20 == x_block1) && (y_block7 + 8'd20 > y_block1) && (y_block7 < y_block1 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b7_b2l;
assign hit_b7_b2l = ((x_block7 + 8'd20 == x_block2) && (y_block7 + 8'd20 > y_block2) && (y_block7 < y_block2 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b7_b3l;
assign hit_b7_b3l = ((x_block7 + 8'd20 == x_block3) && (y_block7 + 8'd20 > y_block3) && (y_block7 < y_block3 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b7_b4l;
assign hit_b7_b4l = ((x_block7 + 8'd20 == x_block4) && (y_block7 + 8'd20 > y_block4) && (y_block7 < y_block4 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b7_b5l;
assign hit_b7_b5l = ((x_block7 + 8'd20 == x_block5) && (y_block7 + 8'd20 > y_block5) && (y_block7 < y_block5 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b7_b6l;
assign hit_b7_b6l = ((x_block7 + 8'd20 == x_block6) && (y_block7 + 8'd20 > y_block6) && (y_block7 < y_block6 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b7_b8l;
assign hit_b7_b8l = ((x_block7 + 8'd20 == x_block8) && (y_block7 + 8'd20 > y_block8) && (y_block7 < y_block8 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b7_b9l;
assign hit_b7_b9l = ((x_block7 + 8'd20 == x_block9) && (y_block7 + 8'd20 > y_block9) && (y_block7 < y_block9 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b7_pl;
assign hit_b7_pl = ((x_block7 + 8'd20 == x_pad) && (y_block7 + 8'd20 > y_pad) && (y_block7 < y_pad + 8'd20)) ? 1'b1 : 1'b0;

//box 7 hit blox on right 
wire hit_b7_b1r;
assign hit_b7_b1r = ((x_block7 == x_block1 + 8'd20) && (y_block7 + 8'd20 > y_block1) && (y_block7 < y_block1 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b7_b2r;
assign hit_b7_b2r = ((x_block7 == x_block2 + 8'd20) && (y_block7 + 8'd20 > y_block2) && (y_block7 < y_block2 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b7_b3r;
assign hit_b7_b3r = ((x_block7 == x_block3 + 8'd20) && (y_block3 + 8'd20 > y_block7) && (y_block7 < y_block3 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b7_b4r;
assign hit_b7_b4r = ((x_block7 == x_block4 + 8'd20) && (y_block7 + 8'd20 > y_block4) && (y_block7 < y_block4 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b7_b5r;
assign hit_b7_b5r = ((x_block7 == x_block5 + 8'd20) && (y_block7 + 8'd20 > y_block5) && (y_block7 < y_block5 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b7_b6r;
assign hit_b7_b6r = ((x_block7 == x_block6 + 8'd20) && (y_block7 + 8'd20 > y_block6) && (y_block7 < y_block6 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b7_b8r;
assign hit_b7_b8r = ((x_block7 == x_block8 + 8'd20) && (y_block7 + 8'd20 > y_block8) && (y_block7 < y_block8 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b7_b9r;
assign hit_b7_b9r = ((x_block7 == x_block9 + 8'd20) && (y_block7 + 8'd20 > y_block9) && (y_block7 < y_block9 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b7_pr;
assign hit_b7_pr = ((x_block7 == x_pad + 8'd20) && (y_block7 + 8'd20 > y_pad) && (y_block7 < y_pad + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b7_hr;
assign hit_b7_hr = ((x_block7 == x_hive + 8'd60) && (y_block7 + 8'd20 > y_hive) && (y_block7 < y_hive + 8'd60)) ? 1'b1 : 1'b0;
wire hit_b7_ler;
assign hit_b7_ler = ((x_block7 == x_leaves + 8'd60) && (y_block7 + 8'd20 > y_leaves) && (y_block7 < y_leaves + 8'd90)) ? 1'b1 : 1'b0;


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Hang on to your hats, we've got a long way to go, hit detection for block8 hitting blocks on its top
wire hit_b8_b1t;
assign hit_b8_b1t = ((y_block8 + 8'd20 == y_block1) && (x_block8 + 8'd20 > x_block1) && (x_block8 < x_block1 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b8_b2t;
assign hit_b8_b2t = ((y_block8 + 8'd20 == y_block2) && (x_block8 + 8'd20 > x_block2) && (x_block8 < x_block2 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b8_b3t;
assign hit_b8_b3t = ((y_block8 + 8'd20 == y_block3) && (x_block8 + 8'd20 > x_block3) && (x_block8 < x_block3 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b8_b4t;
assign hit_b8_b4t = ((y_block8 + 8'd20 == y_block4) && (x_block8 + 8'd20 > x_block4) && (x_block8 < x_block4 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b8_b5t;
assign hit_b8_b5t = ((y_block8 + 8'd20 == y_block5) && (x_block8 + 8'd20 > x_block5) && (x_block8 < x_block5 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b8_b6t;
assign hit_b8_b6t = ((y_block8 + 8'd20 == y_block6) && (x_block8 + 8'd20 > x_block6) && (x_block8 < x_block6 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b8_b7t;
assign hit_b8_b7t = ((y_block8 + 8'd20 == y_block7) && (x_block8 + 8'd20 > x_block7) && (x_block8 < x_block7 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b8_b9t;
assign hit_b8_b9t = ((y_block8 + 8'd20 == y_block9) && (x_block8 + 8'd20 > x_block9) && (x_block8 < x_block9 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b8_pt;
assign hit_b8_pt = ((y_block8 + 8'd20 == y_pad) && (x_block8 + 8'd20 > x_pad) && (x_block8 < x_pad + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b8_ht;
assign hit_b8_ht = ((y_block8 + 8'd20 == y_hive) && (x_block8 + 8'd20 > x_hive) && (x_block8 < x_hive + 8'd60)) ? 1'b1 : 1'b0;
wire hit_b8_let;
assign hit_b8_let = ((y_block8 + 8'd20 == y_leaves) && (x_block8 + 8'd20 > x_leaves) && (x_block8 < x_leaves + 8'd60)) ? 1'b1 : 1'b0;

//box 8 hit blox on bottom 
wire hit_b8_b1b;
assign hit_b8_b1b = ((y_block8 == y_block1 + 8'd20) && (x_block8 + 8'd20 > x_block1) && (x_block8 < x_block1 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b8_b2b;
assign hit_b8_b2b = ((y_block8 == y_block2 + 8'd20) && (x_block2 + 8'd20 > x_block2) && (x_block8 < x_block2 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b8_b3b;
assign hit_b8_b3b = ((y_block8 == y_block3 + 8'd20) && (x_block8 + 8'd20 > x_block3) && (x_block8 < x_block3 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b8_b4b;
assign hit_b8_b4b = ((y_block8 == y_block4 + 8'd20) && (x_block8 + 8'd20 > x_block4) && (x_block8 < x_block4 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b8_b5b;
assign hit_b8_b5b = ((y_block8 == y_block5 + 8'd20) && (x_block8 + 8'd20 > x_block5) && (x_block8 < x_block5 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b8_b6b;
assign hit_b8_b6b = ((y_block8 == y_block6 + 8'd20) && (x_block8 + 8'd20 > x_block6) && (x_block8 < x_block6 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b8_b7b;
assign hit_b8_b7b = ((y_block8 == y_block7 + 8'd20) && (x_block8 + 8'd20 > x_block7) && (x_block8 < x_block7 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b8_b9b;
assign hit_b8_b9b = ((y_block8 == y_block9 + 8'd20) && (x_block8 + 8'd20 > x_block9) && (x_block8 < x_block9 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b8_pb;
assign hit_b8_pb = ((y_block8 == y_pad + 8'd20) && (x_block8 + 8'd20 > x_pad) && (x_block8 < x_pad + 8'd20)) ? 1'b1 : 1'b0;

//box 8 hit blox on left 
wire hit_b8_b1l;
assign hit_b8_b1l = ((x_block8 + 8'd20 == x_block1) && (y_block8 + 8'd20 > y_block1) && (y_block8 < y_block1 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b8_b2l;
assign hit_b8_b2l = ((x_block8 + 8'd20 == x_block2) && (y_block8 + 8'd20 > y_block2) && (y_block8 < y_block2 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b8_b3l;
assign hit_b8_b3l = ((x_block8 + 8'd20 == x_block3) && (y_block8 + 8'd20 > y_block3) && (y_block8 < y_block3 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b8_b4l;
assign hit_b8_b4l = ((x_block8 + 8'd20 == x_block4) && (y_block8 + 8'd20 > y_block4) && (y_block8 < y_block4 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b8_b5l;
assign hit_b8_b5l = ((x_block8 + 8'd20 == x_block5) && (y_block8 + 8'd20 > y_block5) && (y_block8 < y_block5 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b8_b6l;
assign hit_b8_b6l = ((x_block8 + 8'd20 == x_block6) && (y_block8 + 8'd20 > y_block6) && (y_block8 < y_block6 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b8_b7l;
assign hit_b8_b7l = ((x_block8 + 8'd20 == x_block7) && (y_block8 + 8'd20 > y_block7) && (y_block8 < y_block7 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b8_b9l;
assign hit_b8_b9l = ((x_block8 + 8'd20 == x_block9) && (y_block8 + 8'd20 > y_block9) && (y_block8 < y_block9 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b8_pl;
assign hit_b8_pl = ((x_block8 + 8'd20 == x_pad) && (y_block8 + 8'd20 > y_pad) && (y_block8 < y_pad + 8'd20)) ? 1'b1 : 1'b0;

//box 8 hit blox on right 
wire hit_b8_b1r;
assign hit_b8_b1r = ((x_block8 == x_block1 + 8'd20) && (y_block8 + 8'd20 > y_block1) && (y_block8 < y_block1 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b8_b2r;
assign hit_b8_b2r = ((x_block8 == x_block2 + 8'd20) && (y_block8 + 8'd20 > y_block2) && (y_block8 < y_block2 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b8_b3r;
assign hit_b8_b3r = ((x_block8 == x_block3 + 8'd20) && (y_block3 + 8'd20 > y_block8) && (y_block8 < y_block3 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b8_b4r;
assign hit_b8_b4r = ((x_block8 == x_block4 + 8'd20) && (y_block8 + 8'd20 > y_block4) && (y_block8 < y_block4 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b8_b5r;
assign hit_b8_b5r = ((x_block8 == x_block5 + 8'd20) && (y_block8 + 8'd20 > y_block5) && (y_block8 < y_block5 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b8_b6r;
assign hit_b8_b6r = ((x_block8 == x_block6 + 8'd20) && (y_block8 + 8'd20 > y_block6) && (y_block8 < y_block6 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b8_b7r;
assign hit_b8_b7r = ((x_block8 == x_block7 + 8'd20) && (y_block8 + 8'd20 > y_block7) && (y_block8 < y_block7 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b8_b9r;
assign hit_b8_b9r = ((x_block8 == x_block9 + 8'd20) && (y_block8 + 8'd20 > y_block9) && (y_block8 < y_block9 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b8_pr;
assign hit_b8_pr = ((x_block8 == x_pad + 8'd20) && (y_block8 + 8'd20 > y_pad) && (y_block8 < y_pad + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b8_hr;
assign hit_b8_hr = ((x_block8 == x_hive + 8'd60) && (y_block8 + 8'd20 > y_hive) && (y_block8 < y_hive + 8'd60)) ? 1'b1 : 1'b0;
wire hit_b8_ler;
assign hit_b8_ler = ((x_block8 == x_leaves + 8'd60) && (y_block8 + 8'd20 > y_leaves) && (y_block8 < y_leaves + 8'd90)) ? 1'b1 : 1'b0;


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Hang on to your hats, we've got a long way to go, hit detection for block9 hitting blocks on its top
wire hit_b9_b1t;
assign hit_b9_b1t = ((y_block9 + 8'd20 == y_block1) && (x_block9 + 8'd20 > x_block1) && (x_block9 < x_block1 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b9_b2t;
assign hit_b9_b2t = ((y_block9 + 8'd20 == y_block2) && (x_block9 + 8'd20 > x_block2) && (x_block9 < x_block2 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b9_b3t;
assign hit_b9_b3t = ((y_block9 + 8'd20 == y_block3) && (x_block9 + 8'd20 > x_block3) && (x_block9 < x_block3 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b9_b4t;
assign hit_b9_b4t = ((y_block9 + 8'd20 == y_block4) && (x_block9 + 8'd20 > x_block4) && (x_block9 < x_block4 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b9_b5t;
assign hit_b9_b5t = ((y_block9 + 8'd20 == y_block5) && (x_block9 + 8'd20 > x_block5) && (x_block9 < x_block5 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b9_b6t;
assign hit_b9_b6t = ((y_block9 + 8'd20 == y_block6) && (x_block9 + 8'd20 > x_block6) && (x_block9 < x_block6 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b9_b8t;
assign hit_b9_b8t = ((y_block9 + 8'd20 == y_block8) && (x_block9 + 8'd20 > x_block8) && (x_block9 < x_block8 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b9_b7t;
assign hit_b9_b7t = ((y_block9 + 8'd20 == y_block7) && (x_block9 + 8'd20 > x_block7) && (x_block9 < x_block7 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b9_pt;
assign hit_b9_pt = ((y_block9 + 8'd20 == y_pad) && (x_block9 + 8'd20 > x_pad) && (x_block9 < x_pad + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b9_ht;
assign hit_b9_ht = ((y_block9 + 8'd20 == y_hive) && (x_block9 + 8'd20 > x_hive) && (x_block9 < x_hive + 8'd60)) ? 1'b1 : 1'b0;
wire hit_b9_let;
assign hit_b9_let = ((y_block9 + 8'd20 == y_leaves) && (x_block9 + 8'd20 > x_leaves) && (x_block9 < x_leaves + 8'd60)) ? 1'b1 : 1'b0;

//box 9 hit blox on bottom 
wire hit_b9_b1b;
assign hit_b9_b1b = ((y_block9 == y_block1 + 8'd20) && (x_block9 + 8'd20 > x_block1) && (x_block9 < x_block1 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b9_b2b;
assign hit_b9_b2b = ((y_block9 == y_block2 + 8'd20) && (x_block2 + 8'd20 > x_block2) && (x_block9 < x_block2 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b9_b3b;
assign hit_b9_b3b = ((y_block9 == y_block3 + 8'd20) && (x_block9 + 8'd20 > x_block3) && (x_block9 < x_block3 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b9_b4b;
assign hit_b9_b4b = ((y_block9 == y_block4 + 8'd20) && (x_block9 + 8'd20 > x_block4) && (x_block9 < x_block4 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b9_b5b;
assign hit_b9_b5b = ((y_block9 == y_block5 + 8'd20) && (x_block9 + 8'd20 > x_block5) && (x_block9 < x_block5 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b9_b6b;
assign hit_b9_b6b = ((y_block9 == y_block6 + 8'd20) && (x_block9 + 8'd20 > x_block6) && (x_block9 < x_block6 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b9_b8b;
assign hit_b9_b8b = ((y_block9 == y_block8 + 8'd20) && (x_block9 + 8'd20 > x_block8) && (x_block9 < x_block8 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b9_b7b;
assign hit_b9_b7b = ((y_block9 == y_block7 + 8'd20) && (x_block9 + 8'd20 > x_block7) && (x_block9 < x_block7 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b9_pb;
assign hit_b9_pb = ((y_block9 == y_pad + 8'd20) && (x_block9 + 8'd20 > x_pad) && (x_block9 < x_pad + 8'd20)) ? 1'b1 : 1'b0;

//box 9 hit blox on left 
wire hit_b9_b1l;
assign hit_b9_b1l = ((x_block9 + 8'd20 == x_block1) && (y_block9 + 8'd20 > y_block1) && (y_block9 < y_block1 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b9_b2l;
assign hit_b9_b2l = ((x_block9 + 8'd20 == x_block2) && (y_block9 + 8'd20 > y_block2) && (y_block9 < y_block2 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b9_b3l;
assign hit_b9_b3l = ((x_block9 + 8'd20 == x_block3) && (y_block9 + 8'd20 > y_block3) && (y_block9 < y_block3 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b9_b4l;
assign hit_b9_b4l = ((x_block9 + 8'd20 == x_block4) && (y_block9 + 8'd20 > y_block4) && (y_block9 < y_block4 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b9_b5l;
assign hit_b9_b5l = ((x_block9 + 8'd20 == x_block5) && (y_block9 + 8'd20 > y_block5) && (y_block9 < y_block5 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b9_b6l;
assign hit_b9_b6l = ((x_block9 + 8'd20 == x_block6) && (y_block9 + 8'd20 > y_block6) && (y_block9 < y_block6 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b9_b8l;
assign hit_b9_b8l = ((x_block9 + 8'd20 == x_block8) && (y_block9 + 8'd20 > y_block8) && (y_block9 < y_block8 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b9_b7l;
assign hit_b9_b7l = ((x_block9 + 8'd20 == x_block7) && (y_block9 + 8'd20 > y_block7) && (y_block9 < y_block7 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b9_pl;
assign hit_b9_pl = ((x_block9 + 8'd20 == x_pad) && (y_block9 + 8'd20 > y_pad) && (y_block9 < y_pad + 8'd20)) ? 1'b1 : 1'b0;

//box 9 hit blox on right 
wire hit_b9_b1r;
assign hit_b9_b1r = ((x_block9 == x_block1 + 8'd20) && (y_block9 + 8'd20 > y_block1) && (y_block9 < y_block1 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b9_b2r;
assign hit_b9_b2r = ((x_block9 == x_block2 + 8'd20) && (y_block9 + 8'd20 > y_block2) && (y_block9 < y_block2 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b9_b3r;
assign hit_b9_b3r = ((x_block9 == x_block3 + 8'd20) && (y_block3 + 8'd20 > y_block9) && (y_block9 < y_block3 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b9_b4r;
assign hit_b9_b4r = ((x_block9 == x_block4 + 8'd20) && (y_block9 + 8'd20 > y_block4) && (y_block9 < y_block4 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b9_b5r;
assign hit_b9_b5r = ((x_block9 == x_block5 + 8'd20) && (y_block9 + 8'd20 > y_block5) && (y_block9 < y_block5 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b9_b6r;
assign hit_b9_b6r = ((x_block9 == x_block6 + 8'd20) && (y_block9 + 8'd20 > y_block6) && (y_block9 < y_block6 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b9_b8r;
assign hit_b9_b8r = ((x_block9 == x_block8 + 8'd20) && (y_block9 + 8'd20 > y_block8) && (y_block9 < y_block8 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b9_b7r;
assign hit_b9_b7r = ((x_block9 == x_block7 + 8'd20) && (y_block9 + 8'd20 > y_block7) && (y_block9 < y_block7 + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b9_pr;
assign hit_b9_pr = ((x_block9 == x_pad + 8'd20) && (y_block9 + 8'd20 > y_pad) && (y_block9 < y_pad + 8'd20)) ? 1'b1 : 1'b0;
wire hit_b9_hr;
assign hit_b9_hr = ((x_block9 == x_hive + 8'd60) && (y_block9 + 8'd20 > y_hive) && (y_block9 < y_hive + 8'd60)) ? 1'b1 : 1'b0;
wire hit_b9_ler;
assign hit_b9_ler = ((x_block9 == x_leaves + 8'd60) && (y_block9 + 8'd20 > y_leaves) && (y_block9 < y_leaves + 8'd90)) ? 1'b1 : 1'b0;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Hang on to your hats, we've got a long way to go, hit detection for BEE hitting blocks on its top
wire hit_bee_b1t;
assign hit_bee_b1t = ((y_pad + 8'd21 == y_block1) && (x_pad + 8'd21 > x_block1) && (x_pad < x_block1 + 8'd21)) ? 1'b1 : 1'b0;
wire hit_bee_b2t;
assign hit_bee_b2t = ((y_pad + 8'd21 == y_block2) && (x_pad + 8'd21 > x_block2) && (x_pad < x_block2 + 8'd21)) ? 1'b1 : 1'b0;
wire hit_bee_b3t;
assign hit_bee_b3t = ((y_pad + 8'd21 == y_block3) && (x_pad + 8'd21 > x_block3) && (x_pad < x_block3 + 8'd21)) ? 1'b1 : 1'b0;
wire hit_bee_b4t;
assign hit_bee_b4t = ((y_pad + 8'd21 == y_block4) && (x_pad + 8'd21 > x_block4) && (x_pad < x_block4 + 8'd21)) ? 1'b1 : 1'b0;
wire hit_bee_b5t;
assign hit_bee_b5t = ((y_pad + 8'd21 == y_block5) && (x_pad + 8'd21 > x_block5) && (x_pad < x_block5 + 8'd21)) ? 1'b1 : 1'b0;
wire hit_bee_b6t;
assign hit_bee_b6t = ((y_pad + 8'd21 == y_block6) && (x_pad + 8'd21 > x_block6) && (x_pad < x_block6 + 8'd21)) ? 1'b1 : 1'b0;
wire hit_bee_b8t;
assign hit_bee_b8t = ((y_pad + 8'd21 == y_block8) && (x_pad + 8'd21 > x_block8) && (x_pad < x_block8 + 8'd21)) ? 1'b1 : 1'b0;
wire hit_bee_b7t;
assign hit_bee_b7t = ((y_pad + 8'd21 == y_block7) && (x_pad + 8'd21 > x_block7) && (x_pad < x_block7 + 8'd21)) ? 1'b1 : 1'b0;
wire hit_bee_b9t;
assign hit_bee_b9t = ((y_pad + 8'd21 == y_block9) && (x_pad + 8'd21 > x_block9) && (x_pad < x_block9 + 8'd21)) ? 1'b1 : 1'b0;
wire hit_bee_ht;
assign hit_bee_ht = ((y_pad + 8'd24 == y_hive) && (x_pad + 8'd30 > x_hive) && (x_pad < x_hive + 8'd60)) ? 1'b1 : 1'b0;
wire hit_bee_let;
assign hit_bee_let = ((y_pad + 8'd24 == y_leaves) && (x_pad + 8'd30 > x_leaves) && (x_pad < x_leaves + 8'd60)) ? 1'b1 : 1'b0;

//box 9 hit blox on bottom 
wire hit_bee_b1b;
assign hit_bee_b1b = ((y_pad == y_block1 + 8'd21) && (x_pad + 8'd21 > x_block1) && (x_pad < x_block1 + 8'd21)) ? 1'b1 : 1'b0;
wire hit_bee_b2b;
assign hit_bee_b2b = ((y_pad == y_block2 + 8'd21) && (x_pad + 8'd21 > x_block2) && (x_pad < x_block2 + 8'd21)) ? 1'b1 : 1'b0;
wire hit_bee_b3b;
assign hit_bee_b3b = ((y_pad == y_block3 + 8'd21) && (x_pad + 8'd21 > x_block3) && (x_pad < x_block3 + 8'd21)) ? 1'b1 : 1'b0;
wire hit_bee_b4b;
assign hit_bee_b4b = ((y_pad == y_block4 + 8'd21) && (x_pad + 8'd21 > x_block4) && (x_pad < x_block4 + 8'd21)) ? 1'b1 : 1'b0;
wire hit_bee_b5b;
assign hit_bee_b5b = ((y_pad == y_block5 + 8'd21) && (x_pad + 8'd21 > x_block5) && (x_pad < x_block5 + 8'd21)) ? 1'b1 : 1'b0;
wire hit_bee_b6b;
assign hit_bee_b6b = ((y_pad == y_block6 + 8'd21) && (x_pad + 8'd21 > x_block6) && (x_pad < x_block6 + 8'd21)) ? 1'b1 : 1'b0;
wire hit_bee_b8b;
assign hit_bee_b8b = ((y_pad == y_block8 + 8'd21) && (x_pad + 8'd21 > x_block8) && (x_pad < x_block8 + 8'd21)) ? 1'b1 : 1'b0;
wire hit_bee_b7b;
assign hit_bee_b7b = ((y_pad == y_block7 + 8'd21) && (x_pad + 8'd21 > x_block7) && (x_pad < x_block7 + 8'd21)) ? 1'b1 : 1'b0;
wire hit_bee_b9b;
assign hit_bee_b9b = ((y_pad == y_block9 + 8'd21) && (x_pad + 8'd21 > x_block9) && (x_pad < x_block9 + 8'd21)) ? 1'b1 : 1'b0;

//box 9 hit blox on left 
wire hit_bee_b1l;
assign hit_bee_b1l = ((x_pad + 8'd21 == x_block1) && (y_pad + 8'd21 > y_block1) && (y_pad < y_block1 + 8'd21)) ? 1'b1 : 1'b0;
wire hit_bee_b2l;
assign hit_bee_b2l = ((x_pad + 8'd21 == x_block2) && (y_pad + 8'd21 > y_block2) && (y_pad < y_block2 + 8'd21)) ? 1'b1 : 1'b0;
wire hit_bee_b3l;
assign hit_bee_b3l = ((x_pad + 8'd21 == x_block3) && (y_pad + 8'd21 > y_block3) && (y_pad < y_block3 + 8'd21)) ? 1'b1 : 1'b0;
wire hit_bee_b4l;
assign hit_bee_b4l = ((x_pad + 8'd21 == x_block4) && (y_pad + 8'd21 > y_block4) && (y_pad < y_block4 + 8'd21)) ? 1'b1 : 1'b0;
wire hit_bee_b5l;
assign hit_bee_b5l = ((x_pad + 8'd21 == x_block5) && (y_pad + 8'd21 > y_block5) && (y_pad < y_block5 + 8'd21)) ? 1'b1 : 1'b0;
wire hit_bee_b6l;
assign hit_bee_b6l = ((x_pad + 8'd21 == x_block6) && (y_pad + 8'd21 > y_block6) && (y_pad < y_block6 + 8'd21)) ? 1'b1 : 1'b0;
wire hit_bee_b8l;
assign hit_bee_b8l = ((x_pad + 8'd21 == x_block8) && (y_pad + 8'd21 > y_block8) && (y_pad < y_block8 + 8'd21)) ? 1'b1 : 1'b0;
wire hit_bee_b7l;
assign hit_bee_b7l = ((x_pad + 8'd21 == x_block7) && (y_pad + 8'd21 > y_block7) && (y_pad < y_block7 + 8'd21)) ? 1'b1 : 1'b0;
wire hit_bee_b9l;
assign hit_bee_b9l = ((x_pad + 8'd21 == x_block9) && (y_pad + 8'd21 > y_block9) && (y_pad < y_block9 + 8'd21)) ? 1'b1 : 1'b0;

//box 9 hit blox on right 
wire hit_bee_b1r;
assign hit_bee_b1r = ((x_pad == x_block1 + 8'd21) && (y_pad + 8'd21 > y_block1) && (y_pad < y_block1 + 8'd21)) ? 1'b1 : 1'b0;
wire hit_bee_b2r;
assign hit_bee_b2r = ((x_pad == x_block2 + 8'd21) && (y_pad + 8'd21 > y_block2) && (y_pad < y_block2 + 8'd21)) ? 1'b1 : 1'b0;
wire hit_bee_b3r;
assign hit_bee_b3r = ((x_pad == x_block3 + 8'd21) && (y_block3 + 8'd21 > y_pad) && (y_pad < y_block3 + 8'd21)) ? 1'b1 : 1'b0;
wire hit_bee_b4r;
assign hit_bee_b4r = ((x_pad == x_block4 + 8'd21) && (y_pad + 8'd21 > y_block4) && (y_pad < y_block4 + 8'd21)) ? 1'b1 : 1'b0;
wire hit_bee_b5r;
assign hit_bee_b5r = ((x_pad == x_block5 + 8'd21) && (y_pad + 8'd21 > y_block5) && (y_pad < y_block5 + 8'd21)) ? 1'b1 : 1'b0;
wire hit_bee_b6r;
assign hit_bee_b6r = ((x_pad == x_block6 + 8'd21) && (y_pad + 8'd21 > y_block6) && (y_pad < y_block6 + 8'd21)) ? 1'b1 : 1'b0;
wire hit_bee_b8r;
assign hit_bee_b8r = ((x_pad == x_block8 + 8'd21) && (y_pad + 8'd21 > y_block8) && (y_pad < y_block8 + 8'd21)) ? 1'b1 : 1'b0;
wire hit_bee_b7r;
assign hit_bee_b7r = ((x_pad == x_block7 + 8'd21) && (y_pad + 8'd21 > y_block7) && (y_pad < y_block7 + 8'd21)) ? 1'b1 : 1'b0;
wire hit_bee_b9r;
assign hit_bee_b9r = ((x_pad == x_block9 + 8'd21) && (y_pad + 8'd21 > y_block9) && (y_pad < y_block9 + 8'd21)) ? 1'b1 : 1'b0;
wire hit_bee_hr;
assign hit_bee_hr = ((x_pad == x_hive + 8'd60) && (y_pad + 8'd24 > y_hive) && (y_pad < y_hive + 8'd60)) ? 1'b1 : 1'b0;
wire hit_bee_ler;
assign hit_bee_ler = ((x_pad == x_leaves + 8'd60) && (y_pad + 8'd24 > y_leaves) && (y_pad < y_leaves + 8'd90)) ? 1'b1 : 1'b0;

//////////////////////////////////////////reset
always @ (posedge update or negedge rst)
begin
	if (rst == 1'd0)
	begin
		S <= 11'd0;
		S1 <= 11'd0;
		S2 <= 11'd0;
		S3 <= 11'd0;
		S4 <= 11'd0;
		S5 <= 11'd0;
		S6 <= 11'd0;
		S7 <= 11'd0;
		S8 <= 11'd0;
		S9 <= 11'd0;
	end
	else
	begin
		S <= NS;
		S1 <= NS1;
		S2 <= NS2;
		S3 <= NS3;
		S4 <= NS4;
		S5 <= NS5;
		S6 <= NS6;
		S7 <= NS7;
		S8 <= NS8;
		S9 <= NS9;
	end
end

////////////////////////////////////////state transitions
always @ (posedge update or negedge rst)
begin
	case (S)
		before: 
		begin
			if (rst == 1'd0)
				NS = before;
			else
				NS = start;
		end

		start:
		begin
			if (start_game == 1'd0)
				NS = start;
			else 
				NS = start_anim;
		end		
		start_anim:
		begin
			if (y_redstart >= 11'd499)
				NS = missile_reload;
			else
				NS = start_anim;
		end
		missile_move_left:
		begin 
			
			if((x_missile < 11'd622 && hit_block1 == 1'd0 && hit_block2 == 1'd0 && hit_block3 == 1'd0 && hit_block4 == 1'd0 && hit_block5 == 1'd0 && hit_block6 == 1'd0 && hit_block7 == 1'd0 && hit_block8 == 1'd0 && hit_block9 == 1'd0) && hit_me == 1'd0)
				NS = missile_move_left;
			else if(hit_block1 == 1'd1 || hit_block2 == 1'd1 || hit_block3 == 1'd1 || hit_block4 == 1'd1 || hit_block5 == 1'd1 || hit_block6 == 1'd1 || hit_block7 == 1'd1 || hit_block8 == 1'd1 || hit_block9 == 1'd1)
				NS = missile_reload1; 
			else if( x_missile >= 11'd622)
				NS = missile_reload; 
			if (life == 11'd0)
				NS = end_game;
		end
			
		missile_reload: //this will bee the st8 for returning the missile and it his a bee!
		begin	
			
			if(fire == 1'd1)
				NS = missile_move_left;
			else
				NS = missile_reload;
			if (life == 11'd0)
				NS = end_game;
		end
		
		missile_reload1: //this will bee the st8 for returning the missile 
		begin	
			
			if(fire == 1'd1) // add user input to launch the missile
				NS = missile_move_left;
			else
				NS = missile_reload;
			if (life == 11'd0)
				NS = end_game;
		end
		
		end_game:
			NS = end_game;
	endcase	
	
	case(S1)
		before: 
		begin
			if (rst == 1'd0)
				NS1 = before;
			else
				NS1 = start;
		end

		start:
		begin
			if (start_game == 1'd0)
				NS1 = start;
			else 
				NS1 = start_anim;
		end
		start_anim:
		begin
			if (y_redstart >= 11'd499)
				NS1 = block1_move_45;
			else
				NS1 = start_anim;
		end
		block1_move_225:
		begin
			if( x_block1 <= 11'd20 || hit_b1_ler == 1'd1 || hit_b1_hr == 1'd1 || hit_b1_pr == 1'd1  || hit_b1_b2r == 1'd1 || hit_b1_b3r == 1'd1 || hit_b1_b4r == 1'd1 || hit_b1_b5r == 1'd1 || hit_b1_b6r == 1'd1 || hit_b1_b7r == 1'd1 || hit_b1_b8r == 1'd1 || hit_b1_b9r == 1'd1)
				NS1 = block1_move_315;
			else if( y_block1 >= 11'd439 || hit_b1_let == 1'd1 || hit_b1_ht == 1'd1 || hit_b1_pt == 1'd1 || hit_b1_b2t == 1'd1 || hit_b1_b3t == 1'd1 || hit_b1_b4t == 1'd1 || hit_b1_b5t == 1'd1 || hit_b1_b6t == 1'd1 || hit_b1_b7t == 1'd1 || hit_b1_b8t == 1'd1 || hit_b1_b9t == 1'd1)
				NS1 = block1_move_135;
			else if(x_block1 >= 11'd650)	
				NS1 = block1_been_shot;
			else
				NS1 = block1_move_225;
			end
		block1_move_315:
		begin
			if( x_block1 >=  11'd600 || hit_b1_pl == 1'd1 || hit_b1_b2l == 1'd1 || hit_b1_b3l == 1'd1 || hit_b1_b4l == 1'd1 || hit_b1_b5l == 1'd1 || hit_b1_b6l == 1'd1 || hit_b1_b7l == 1'd1 || hit_b1_b8l == 1'd1 || hit_b1_b9l == 1'd1)
				NS1 = block1_move_225;
			else if( y_block1 >= 11'd439 || hit_b1_let == 1'd1 || hit_b1_ht == 1'd1 || hit_b1_pt == 1'd1 || hit_b1_b2t == 1'd1 || hit_b1_b3t == 1'd1 || hit_b1_b4t == 1'd1 || hit_b1_b5t == 1'd1 || hit_b1_b6t == 1'd1 || hit_b1_b7t == 1'd1 || hit_b1_b8t == 1'd1 || hit_b1_b9t == 1'd1)
				NS1 = block1_move_45;
			else if(x_block1 >= 11'd650)	
				NS1 = block1_been_shot;
			else
				NS1 = block1_move_315;
		end
		block1_move_135:
		begin
			if( x_block1 <= 11'd20 || hit_b1_ler == 1'd1 || hit_b1_hr == 1'd1 || hit_b1_pr == 1'd1 || hit_b1_b2r == 1'd1 || hit_b1_b3r == 1'd1 || hit_b1_b4r == 1'd1 || hit_b1_b5r == 1'd1 || hit_b1_b6r == 1'd1 || hit_b1_b7r == 1'd1 || hit_b1_b8r == 1'd1 || hit_b1_b9r == 1'd1)
				NS1 = block1_move_45;
			else if(y_block1 <= 11'd20 || hit_b1_pb == 1'd1 || hit_b1_b2b == 1'd1 || hit_b1_b3b == 1'd1 || hit_b1_b4b == 1'd1 || hit_b1_b5b == 1'd1 || hit_b1_b6b == 1'd1 || hit_b1_b7b == 1'd1 || hit_b1_b8b == 1'd1 || hit_b1_b9b == 1'd1)
				NS1 = block1_move_225;
			else if(x_block1 >= 11'd650)	
				NS1 = block1_been_shot;
			else
				NS1 = block1_move_135;
		end
		block1_move_45:
		begin
			if( x_block1 >=  11'd600 || hit_b1_pl == 1'd1 || hit_b1_b2l == 1'd1 || hit_b1_b3l == 1'd1 || hit_b1_b4l == 1'd1 || hit_b1_b5l == 1'd1 || hit_b1_b6l == 1'd1 || hit_b1_b7l == 1'd1 || hit_b1_b8l == 1'd1 || hit_b1_b9l == 1'd1)
				NS1 = block1_move_135;
			else if( y_block1 <= 11'd20 || hit_b1_pb == 1'd1 || hit_b1_b2b == 1'd1 || hit_b1_b3b == 1'd1 || hit_b1_b4b == 1'd1 || hit_b1_b5b == 1'd1 || hit_b1_b6b == 1'd1 || hit_b1_b7b == 1'd1 || hit_b1_b8b == 1'd1 || hit_b1_b9b == 1'd1)
				NS1 = block1_move_315;
			else if(x_block1 >= 11'd650)	
				NS1 = block1_been_shot;
			else
				NS1 = block1_move_45;
		end
		block1_been_shot:
		begin
		if (grumbles >= 32'd1000)
		NS1 = stinkyboi;
		else
		NS1 = block1_been_shot;
		end
		
		stinkyboi:
		begin
			if (grumbles >= 32'd1005)
				NS1 = block1_move_225;
			else
				NS1 = stinkyboi;
		end
	endcase
	
	case(S2)
		before: 
		begin
			if (rst == 1'd0)
				NS2 = before;
			else
				NS2 = start;
		end

		start:
		begin
			if (start_game == 1'd0)
				NS2 = start;
			else 
				NS2 = start_anim;
		end
		
		start_anim:
		begin
			if (y_redstart >= 11'd499)
				NS2 = block1_move_315;
			else
				NS2 = start_anim;
		end
		block1_move_225:
		begin
			if( x_block2 <= 11'd20 || hit_b2_ler == 1'd1 || hit_b2_hr == 1'd1 || hit_b2_pr == 1'd1 || hit_b2_b1r == 1'd1 || hit_b2_b3r == 1'd1 || hit_b2_b4r == 1'd1 || hit_b2_b5r == 1'd1 || hit_b2_b6r == 1'd1 || hit_b2_b7r == 1'd1 || hit_b2_b8r == 1'd1 || hit_b2_b9r == 1'd1)
				NS2 = block1_move_315;
			else if( y_block2 >= 11'd439 || hit_b2_let == 1'd1 || hit_b2_ht == 1'd1 || hit_b2_pt == 1'd1 || hit_b2_b1t == 1'd1 || hit_b2_b3t == 1'd1 || hit_b2_b4t == 1'd1 || hit_b2_b5t == 1'd1 || hit_b2_b6t == 1'd1 || hit_b2_b7t == 1'd1 || hit_b2_b8t == 1'd1 || hit_b2_b9t == 1'd1)
				NS2 = block1_move_135;
			else if(x_block2 >= 11'd650)	
				NS2 = block1_been_shot;
			else
				NS2 = block1_move_225;
			end
		block1_move_315:
		begin
			if( x_block2 >=  11'd600 || hit_b2_pl == 1'd1 || hit_b2_b1l == 1'd1 || hit_b2_b3l == 1'd1 || hit_b2_b4l == 1'd1 || hit_b2_b5l == 1'd1 || hit_b2_b6l == 1'd1 || hit_b2_b7l == 1'd1 || hit_b2_b8l == 1'd1 || hit_b2_b9l == 1'd1)
				NS2 = block1_move_225;
			else if( y_block2 >= 11'd439 || hit_b2_let == 1'd1 || hit_b2_ht == 1'd1 || hit_b2_pt == 1'd1 || hit_b2_b1t == 1'd1 || hit_b2_b3t == 1'd1 || hit_b2_b4t == 1'd1 || hit_b2_b5t == 1'd1 || hit_b2_b6t == 1'd1 || hit_b2_b7t == 1'd1 || hit_b2_b8t == 1'd1 || hit_b2_b9t == 1'd1)
				NS2 = block1_move_45;
			else if(x_block2 >= 11'd650)	
				NS2 = block1_been_shot;
			else
				NS2 = block1_move_315;
		end
		block1_move_135:
		begin
			if( x_block2 <= 11'd20 || hit_b2_ler == 1'd1 || hit_b2_hr == 1'd1|| hit_b2_pr == 1'd1 || hit_b2_b1r == 1'd1 || hit_b2_b3r == 1'd1 || hit_b2_b4r == 1'd1 || hit_b2_b5r == 1'd1 || hit_b2_b6r == 1'd1 || hit_b2_b7r == 1'd1 || hit_b2_b8r == 1'd1 || hit_b2_b9r == 1'd1)
				NS2 = block1_move_45;
			else if(y_block2 <= 11'd20 || hit_b2_pb == 1'd1 || hit_b2_b1b == 1'd1 || hit_b2_b3b == 1'd1 || hit_b2_b4b == 1'd1 || hit_b2_b5b == 1'd1 || hit_b2_b6b == 1'd1 || hit_b2_b7b == 1'd1 || hit_b2_b8b == 1'd1 || hit_b2_b9b == 1'd1)
				NS2 = block1_move_225;
			else if(x_block2 >= 11'd650)	
				NS2 = block1_been_shot;
			else
				NS2 = block1_move_135;
		end
		block1_move_45:
		begin
			if( x_block2 >=  11'd600 || hit_b2_pl == 1'd1 || hit_b2_b1l == 1'd1 || hit_b2_b3l == 1'd1 || hit_b2_b4l == 1'd1 || hit_b2_b5l == 1'd1 || hit_b2_b6l == 1'd1 || hit_b2_b7l == 1'd1 || hit_b2_b8l == 1'd1 || hit_b2_b9l == 1'd1)
				NS2 = block1_move_135;
			else if( y_block2 <= 11'd20 || hit_b2_pb == 1'd1 || hit_b2_b1b == 1'd1 || hit_b2_b3b == 1'd1 || hit_b2_b4b == 1'd1 || hit_b2_b5b == 1'd1 || hit_b2_b6b == 1'd1 || hit_b2_b7b == 1'd1 || hit_b2_b8b == 1'd1 || hit_b2_b9b == 1'd1)
				NS2 = block1_move_315;
			else if(x_block2 >= 11'd650)	
				NS2 = block1_been_shot;
			else
				NS2 = block1_move_45;
		end
		block1_been_shot:
		begin
		if (grumbles2 >= 32'd1000)
		NS2 = stinkyboi;
		else
		NS2 = block1_been_shot;
		end
		stinkyboi:
		begin
			if (grumbles2 >= 32'd1005)
				NS2 = block1_move_225;
			else
				NS2 = stinkyboi;
		end
	endcase
	
		case(S3)
		before: 
		begin
			if (rst == 1'd0)
				NS3 = before;
			else
				NS3 = start;
		end

		start:
		begin
			if (start_game == 1'd0)
				NS3 = start;
			else 
				NS3 = start_anim;
		end
		start_anim:
		begin
			if (y_redstart >= 11'd499)
				NS3 = block1_move_315;
			else
				NS3 = start_anim;
		end
		block1_move_225:
		begin
			if( x_block3 <= 11'd20 || hit_b3_ler == 1'd1 || hit_b3_hr == 1'd1 || hit_b3_pr == 1'd1 || hit_b3_b1r == 1'd1 || hit_b3_b2r == 1'd1 || hit_b3_b4r == 1'd1 || hit_b3_b5r == 1'd1 || hit_b3_b6r == 1'd1 || hit_b3_b7r == 1'd1 || hit_b3_b8r == 1'd1 || hit_b3_b9r == 1'd1)
				NS3 = block1_move_315;
			else if( y_block3 >= 11'd439 || hit_b3_let == 1'd1 || hit_b3_ht == 1'd1 || hit_b3_pt == 1'd1 || hit_b3_b1t == 1'd1 || hit_b3_b2t == 1'd1 || hit_b3_b4t == 1'd1 || hit_b3_b5t == 1'd1 || hit_b3_b6t == 1'd1 || hit_b3_b7t == 1'd1 || hit_b3_b8t == 1'd1 || hit_b3_b9t == 1'd1)
				NS3 = block1_move_135;
			else if(x_block3 >= 11'd650)	
				NS3 = block1_been_shot;
			else
				NS3 = block1_move_225;
			end
		block1_move_315:
		begin
			if(x_block3 >=  11'd600 || hit_b3_pl == 1'd1 || hit_b3_b1l == 1'd1 || hit_b3_b2l == 1'd1 || hit_b3_b4l == 1'd1 || hit_b3_b5l == 1'd1 || hit_b3_b6l == 1'd1 || hit_b3_b7l == 1'd1 || hit_b3_b8l == 1'd1 || hit_b3_b9l == 1'd1)
				NS3 = block1_move_225;
			else if( y_block3 >= 11'd439 || hit_b3_let == 1'd1 || hit_b3_ht == 1'd1 || hit_b3_pt == 1'd1 || hit_b3_b1t == 1'd1 || hit_b3_b2t == 1'd1 || hit_b3_b4t == 1'd1 || hit_b3_b5t == 1'd1 || hit_b3_b6t == 1'd1 || hit_b3_b7t == 1'd1 || hit_b3_b8t == 1'd1 || hit_b3_b9t == 1'd1)
				NS3 = block1_move_45;
			else if(x_block3 >= 11'd650)	
				NS3 = block1_been_shot;
			else
				NS3 = block1_move_315;
		end
		block1_move_135:
		begin
			if( x_block3 <= 11'd20 || hit_b3_ler == 1'd1 || hit_b3_hr == 1'd1 || hit_b3_pr == 1'd1 || hit_b3_b1r == 1'd1 || hit_b3_b2r == 1'd1 || hit_b3_b4r == 1'd1 || hit_b3_b5r == 1'd1 || hit_b3_b6r == 1'd1 || hit_b3_b7r == 1'd1 || hit_b3_b8r == 1'd1 || hit_b3_b9r == 1'd1)
				NS3 = block1_move_45;
			else if(y_block3 <= 11'd20 || hit_b3_pb == 1'd1 || hit_b3_b1b == 1'd1 || hit_b3_b2b == 1'd1 || hit_b3_b4b == 1'd1 || hit_b3_b5b == 1'd1 || hit_b3_b6b == 1'd1 || hit_b3_b7b == 1'd1 || hit_b3_b8b == 1'd1 || hit_b3_b9b == 1'd1)
				NS3 = block1_move_225;
			else if(x_block3 >= 11'd650)	
				NS3 = block1_been_shot;
			else
				NS3 = block1_move_135;
		end
		block1_move_45:
		begin
			if( x_block3 >=  11'd600 || hit_b3_pl == 1'd1 || hit_b3_b1l == 1'd1 || hit_b3_b2l == 1'd1 || hit_b3_b4l == 1'd1 || hit_b3_b5l == 1'd1 || hit_b3_b6l == 1'd1 || hit_b3_b7l == 1'd1 || hit_b3_b8l == 1'd1 || hit_b3_b9l == 1'd1)
				NS3 = block1_move_135;
			else if( y_block3 <= 11'd20 || hit_b3_pb == 1'd1 || hit_b3_b1b == 1'd1 || hit_b3_b2b == 1'd1 || hit_b3_b4b == 1'd1 || hit_b3_b5b == 1'd1 || hit_b3_b6b == 1'd1 || hit_b3_b7b == 1'd1 || hit_b3_b8b == 1'd1 || hit_b3_b9b == 1'd1)
				NS3 = block1_move_315;
			else if(x_block3 >= 11'd650)	
				NS3 = block1_been_shot;
			else
				NS3 = block1_move_45;
		end
		block1_been_shot:
		begin
		if (grumbles3 >= 32'd1000)
		NS3 = stinkyboi;
		else
		NS3 = block1_been_shot;
		end
		
		stinkyboi:
		begin
			if (grumbles3 >= 32'd1005)
				NS3 = block1_move_135;
			else
				NS3 = stinkyboi;
		end
	endcase
	
		case(S4)
		before: 
		begin
			if (rst == 1'd0)
				NS4 = before;
			else
				NS4 = start;
		end

		start:
		begin
			if (start_game == 1'd0)
				NS4 = start;
			else 
				NS4 =  start_anim;
		end
		start_anim:
		begin
			if (y_redstart >= 11'd499)
				NS4 = block1_move_225;
			else
				NS4 = start_anim;
		end
		block1_move_225:
		begin
			if( x_block4 <= 11'd20 || hit_b4_ler == 1'd1 || hit_b4_hr == 1'd1 || hit_b4_pr == 1'd1 || hit_b4_b1r == 1'd1 || hit_b4_b2r == 1'd1 || hit_b4_b3r == 1'd1 || hit_b4_b5r == 1'd1 || hit_b4_b6r == 1'd1 || hit_b4_b7r == 1'd1 || hit_b4_b8r == 1'd1 || hit_b4_b9r == 1'd1)
				NS4 = block1_move_315;
			else if( y_block4 >= 11'd439 || hit_b4_let == 1'd1 || hit_b4_ht == 1'd1 || hit_b4_pt == 1'd1 || hit_b4_b1t == 1'd1 || hit_b4_b2t == 1'd1 || hit_b4_b3t == 1'd1 || hit_b4_b5t == 1'd1 || hit_b4_b6t == 1'd1 || hit_b4_b7t == 1'd1 || hit_b4_b8t == 1'd1 || hit_b4_b9t == 1'd1)
				NS4 = block1_move_135;
			else if(x_block4 >= 11'd650)	
				NS4 = block1_been_shot;
			else
				NS4 = block1_move_225;
			end
		block1_move_315:
		begin
			if(x_block4 >=  11'd600 || hit_b4_pl == 1'd1 || hit_b4_b1l == 1'd1 || hit_b4_b2l == 1'd1 || hit_b4_b3l == 1'd1 || hit_b4_b5l == 1'd1 || hit_b4_b6l == 1'd1 || hit_b4_b7l == 1'd1 || hit_b4_b8l == 1'd1 || hit_b4_b9l == 1'd1)
				NS4 = block1_move_225;
			else if( y_block4 >= 11'd439 || hit_b4_let == 1'd1 || hit_b4_ht == 1'd1 || hit_b4_pt == 1'd1 || hit_b4_b1t == 1'd1 || hit_b4_b2t == 1'd1 || hit_b4_b3t == 1'd1 || hit_b4_b5t == 1'd1 || hit_b4_b6t == 1'd1 || hit_b4_b7t == 1'd1 || hit_b4_b8t == 1'd1 || hit_b4_b9t == 1'd1)
				NS4 = block1_move_45;
			else if(x_block4 >= 11'd650)	
				NS4 = block1_been_shot;
			else
				NS4 = block1_move_315;
		end
		block1_move_135:
		begin
			if( x_block4 <= 11'd20 || hit_b4_ler == 1'd1 || hit_b4_hr == 1'd1 || hit_b4_pr == 1'd1 || hit_b4_b1r == 1'd1 || hit_b4_b2r == 1'd1 || hit_b4_b3r == 1'd1 || hit_b4_b5r == 1'd1 || hit_b4_b6r == 1'd1 || hit_b4_b7r == 1'd1 || hit_b4_b8r == 1'd1 || hit_b4_b9r == 1'd1)
				NS4 = block1_move_45;
			else if(y_block4 <= 11'd20 || hit_b4_pb == 1'd1 || hit_b4_b1b == 1'd1 || hit_b4_b2b == 1'd1 || hit_b4_b3b == 1'd1 || hit_b4_b5b == 1'd1 || hit_b4_b6b == 1'd1 || hit_b4_b7b == 1'd1 || hit_b4_b8b == 1'd1 || hit_b4_b9b == 1'd1)
				NS4 = block1_move_225;
			else if(x_block4 >= 11'd650)	
				NS4 = block1_been_shot;
			else
				NS4 = block1_move_135;
		end
		block1_move_45:
		begin
			if( x_block4 >=  11'd600 || hit_b4_pl == 1'd1 || hit_b4_b1l == 1'd1 || hit_b4_b2l == 1'd1 || hit_b4_b3l == 1'd1 || hit_b4_b5l == 1'd1 || hit_b4_b6l == 1'd1 || hit_b4_b7l == 1'd1 || hit_b4_b8l == 1'd1 || hit_b4_b9l == 1'd1)
				NS4 = block1_move_135;
			else if( y_block4 <= 11'd20 || hit_b4_pb == 1'd1 || hit_b4_b1b == 1'd1 || hit_b4_b2b == 1'd1 || hit_b4_b3b == 1'd1 || hit_b4_b5b == 1'd1 || hit_b4_b6b == 1'd1 || hit_b4_b7b == 1'd1 || hit_b4_b8b == 1'd1 || hit_b4_b9b == 1'd1)
				NS4 = block1_move_315;
			else if(x_block4 >= 11'd650)	
				NS4 = block1_been_shot;
			else
				NS4 = block1_move_45;
		end
		block1_been_shot:
		begin
		if (grumbles4 >= 32'd1000)
		NS4 = stinkyboi;
		else
		NS4 = block1_been_shot;
		end
		stinkyboi:
		begin
			if (grumbles4 >= 32'd1005)
				NS4 = block1_move_225;
			else
				NS4 = stinkyboi;
		end
	endcase
	
	case(S5)
		before: 
		begin
			if (rst == 1'd0)
				NS5 = before;
			else
				NS5 = start;
		end

		start:
		begin
			if (start_game == 1'd0)
				NS5 = start;
			else 
				NS5 =  start_anim;
		end
		start_anim:
		begin
			if (y_redstart >= 11'd499)
				NS5 = block1_move_45;
			else
				NS5 = start_anim;
		end
		block1_move_225:
		begin
			if( x_block5 <= 11'd20 || hit_b5_ler == 1'd1 || hit_b5_hr == 1'd1 || hit_b5_pr == 1'd1 || hit_b5_b1r == 1'd1 || hit_b5_b2r == 1'd1 || hit_b5_b3r == 1'd1 || hit_b5_b4r == 1'd1 || hit_b5_b6r == 1'd1 || hit_b5_b7r == 1'd1 || hit_b5_b8r == 1'd1 || hit_b5_b9r == 1'd1)
				NS5 = block1_move_315;
			else if( y_block5 >= 11'd439 || hit_b5_let == 1'd1 || hit_b5_ht == 1'd1 || hit_b5_pt == 1'd1 || hit_b5_b1t == 1'd1 || hit_b5_b2t == 1'd1 || hit_b5_b3t == 1'd1 || hit_b5_b4t == 1'd1 || hit_b5_b6t == 1'd1 || hit_b5_b7t == 1'd1 || hit_b5_b8t == 1'd1 || hit_b5_b9t == 1'd1)
				NS5 = block1_move_135;
			else if(x_block5 >= 11'd650)	
				NS5 = block1_been_shot;
			else
				NS5 = block1_move_225;
			end
		block1_move_315:
		begin
			if(x_block5 >=  11'd600 || hit_b5_pl == 1'd1 || hit_b5_b1l == 1'd1 || hit_b5_b2l == 1'd1 || hit_b5_b3l == 1'd1 || hit_b5_b4l == 1'd1 || hit_b5_b6l == 1'd1 || hit_b5_b7l == 1'd1 || hit_b5_b8l == 1'd1 || hit_b5_b9l == 1'd1)
				NS5 = block1_move_225;
			else if( y_block5 >= 11'd439 || hit_b5_let == 1'd1 || hit_b5_ht == 1'd1 || hit_b5_pt == 1'd1 || hit_b5_b1t == 1'd1 || hit_b5_b2t == 1'd1 || hit_b5_b3t == 1'd1 || hit_b5_b4t == 1'd1 || hit_b5_b6t == 1'd1 || hit_b5_b7t == 1'd1 || hit_b5_b8t == 1'd1 || hit_b5_b9t == 1'd1)
				NS5 = block1_move_45;
			else if(x_block5 >= 11'd650)	
				NS5 = block1_been_shot;
			else
				NS5 = block1_move_315;
		end
		block1_move_135:
		begin
			if( x_block5 <= 11'd20 || hit_b5_ler == 1'd1 || hit_b5_hr == 1'd1 || hit_b5_pr == 1'd1 || hit_b5_b1r == 1'd1 || hit_b5_b2r == 1'd1 || hit_b5_b3r == 1'd1 || hit_b5_b4r == 1'd1 || hit_b5_b6r == 1'd1 || hit_b5_b7r == 1'd1 || hit_b5_b8r == 1'd1 || hit_b5_b9r == 1'd1)
				NS5 = block1_move_45;
			else if(y_block5 <= 11'd20 || hit_b5_pb == 1'd1 || hit_b5_b1b == 1'd1 || hit_b5_b2b == 1'd1 || hit_b5_b3b == 1'd1 || hit_b5_b4b == 1'd1 || hit_b5_b6b == 1'd1 || hit_b5_b7b == 1'd1 || hit_b5_b8b == 1'd1 || hit_b5_b9b == 1'd1)
				NS5 = block1_move_225;
			else if(x_block5 >= 11'd650)	
				NS5 = block1_been_shot;
			else
				NS5 = block1_move_135;
		end
		block1_move_45:
		begin
			if( x_block5 >=  11'd600 || hit_b5_pl == 1'd1 || hit_b5_b1l == 1'd1 || hit_b5_b2l == 1'd1 || hit_b5_b3l == 1'd1 || hit_b5_b4l == 1'd1 || hit_b5_b6l == 1'd1 || hit_b5_b7l == 1'd1 || hit_b5_b8l == 1'd1 || hit_b5_b9l == 1'd1)
				NS5 = block1_move_135;
			else if( y_block5 <= 11'd20 || hit_b5_pb == 1'd1 || hit_b5_b1b == 1'd1 || hit_b5_b2b == 1'd1 || hit_b5_b3b == 1'd1 || hit_b5_b4b == 1'd1 || hit_b5_b6b == 1'd1 || hit_b5_b7b == 1'd1 || hit_b5_b8b == 1'd1 || hit_b5_b9b == 1'd1)
				NS5 = block1_move_315;
			else if(x_block5 >= 11'd650)	
				NS5 = block1_been_shot;
			else
				NS5 = block1_move_45;
		end
		block1_been_shot:
		begin
		if (grumbles5 >= 32'd1000)
		NS5 = stinkyboi;
		else
		NS5 = block1_been_shot;
		end
		stinkyboi:
		begin
			if (grumbles5 >= 32'd1005)
				NS5 = block1_move_225;
			else
				NS5 = stinkyboi;
		end
	endcase
	
	case(S6)
		before: 
		begin
			if (rst == 1'd0)
				NS6 = before;
			else
				NS6 = start;
		end

		start:
		begin
			if (start_game == 1'd0)
				NS6 = start;
			else 
				NS6 =  start_anim;
		end
		start_anim:
		begin
			if (y_redstart >= 11'd499)
				NS6 = block1_move_315;
			else
				NS6 = start_anim;
		end
		block1_move_225:
		begin
			if( x_block6 <= 11'd20 || hit_b6_ler == 1'd1 || hit_b6_hr == 1'd1 || hit_b6_pr == 1'd1 || hit_b6_b1r == 1'd1 || hit_b6_b2r == 1'd1 || hit_b6_b3r == 1'd1 || hit_b6_b4r == 1'd1 || hit_b6_b5r == 1'd1 || hit_b6_b7r == 1'd1 || hit_b6_b8r == 1'd1 || hit_b6_b9r == 1'd1)
				NS6 = block1_move_315;
			else if( y_block6 >= 11'd439 || hit_b6_let == 1'd1 || hit_b6_ht == 1'd1 || hit_b6_pt == 1'd1 || hit_b6_b1t == 1'd1 || hit_b6_b2t == 1'd1 || hit_b6_b3t == 1'd1 || hit_b6_b4t == 1'd1 || hit_b6_b5t == 1'd1 || hit_b6_b7t == 1'd1 || hit_b6_b8t == 1'd1 || hit_b6_b9t == 1'd1)
				NS6 = block1_move_135;
			else if(x_block6 >= 11'd650)	
				NS6 = block1_been_shot;
			else
				NS6 = block1_move_225;
			end
		block1_move_315:
		begin
			if(x_block6 >=  11'd600 || hit_b6_pl == 1'd1 || hit_b6_b1l == 1'd1 || hit_b6_b2l == 1'd1 || hit_b6_b3l == 1'd1 || hit_b6_b4l == 1'd1 || hit_b6_b5l == 1'd1 || hit_b6_b7l == 1'd1 || hit_b6_b8l == 1'd1 || hit_b6_b9l == 1'd1)
				NS6 = block1_move_225;
			else if( y_block6 >= 11'd439 || hit_b6_let == 1'd1 || hit_b6_ht == 1'd1 || hit_b6_pt == 1'd1 || hit_b6_b1t == 1'd1 || hit_b6_b2t == 1'd1 || hit_b6_b3t == 1'd1 || hit_b6_b4t == 1'd1 || hit_b6_b5t == 1'd1 || hit_b6_b7t == 1'd1 || hit_b6_b8t == 1'd1 || hit_b6_b9t == 1'd1)
				NS6 = block1_move_45;
			else if(x_block6 >= 11'd650)	
				NS6 = block1_been_shot;
			else
				NS6 = block1_move_315;
		end
		block1_move_135:
		begin
			if( x_block6 <= 11'd20 || hit_b6_ler == 1'd1 || hit_b6_hr == 1'd1 || hit_b6_pr == 1'd1 || hit_b6_b1r == 1'd1 || hit_b6_b2r == 1'd1 || hit_b6_b3r == 1'd1 || hit_b6_b4r == 1'd1 || hit_b6_b5r == 1'd1 || hit_b6_b7r == 1'd1 || hit_b6_b8r == 1'd1 || hit_b6_b9r == 1'd1)
				NS6 = block1_move_45;
			else if(y_block6 <= 11'd20 || hit_b6_pb == 1'd1 || hit_b6_b1b == 1'd1 || hit_b6_b2b == 1'd1 || hit_b6_b3b == 1'd1 || hit_b6_b4b == 1'd1 || hit_b6_b5b == 1'd1 || hit_b6_b7b == 1'd1 || hit_b6_b8b == 1'd1 || hit_b6_b9b == 1'd1)
				NS6 = block1_move_225;
			else if(x_block6 >= 11'd650)	
				NS6 = block1_been_shot;
			else
				NS6 = block1_move_135;
		end
		block1_move_45:
		begin
			if( x_block6 >=  11'd600 || hit_b6_pl == 1'd1 || hit_b6_b1l == 1'd1 || hit_b6_b2l == 1'd1 || hit_b6_b3l == 1'd1 || hit_b6_b4l == 1'd1 || hit_b6_b5l == 1'd1 || hit_b6_b7l == 1'd1 || hit_b6_b8l == 1'd1 || hit_b6_b9l == 1'd1)
				NS6 = block1_move_135;
			else if( y_block6 <= 11'd20 || hit_b6_pb == 1'd1 || hit_b6_b1b == 1'd1 || hit_b6_b2b == 1'd1 || hit_b6_b3b == 1'd1 || hit_b6_b4b == 1'd1 || hit_b6_b5b == 1'd1 || hit_b6_b7b == 1'd1 || hit_b6_b8b == 1'd1 || hit_b6_b9b == 1'd1)
				NS6 = block1_move_315;
			else if(x_block6 >= 11'd650)	
				NS6 = block1_been_shot;
			else
				NS6 = block1_move_45;
		end
		block1_been_shot:
		begin
		if (grumbles6 >= 32'd1000)
		NS6 = stinkyboi;
		else
		NS6 = block1_been_shot;
		end
		stinkyboi:
		begin
			if (grumbles6 >= 32'd1005)
				NS6 = block1_move_225;
			else
				NS6 = stinkyboi;
		end
	endcase	
	
	case(S7)
		before: 
		begin
			if (rst == 1'd0)
				NS7 = before;
			else
				NS7 = start;
		end

		start:
		begin
			if (start_game == 1'd0)
				NS7 = start;
			else 
				NS7 =  start_anim;
		end
		start_anim:
		begin
			if (y_redstart >= 11'd499)
				NS7 = block1_move_45;
			else
				NS7 = start_anim;
		end
		block1_move_225:
		begin
			if( x_block7 <= 11'd20 || hit_b7_ler == 1'd1 || hit_b7_hr == 1'd1 || hit_b7_pr == 1'd1 || hit_b7_b1r == 1'd1 || hit_b7_b2r == 1'd1 || hit_b7_b3r == 1'd1 || hit_b7_b4r == 1'd1 || hit_b7_b5r == 1'd1 || hit_b7_b6r == 1'd1 || hit_b7_b8r == 1'd1 || hit_b7_b9r == 1'd1)
				NS7 = block1_move_315;
			else if( y_block7 >= 11'd439 || hit_b7_let == 1'd1 || hit_b7_ht == 1'd1 || hit_b7_pt == 1'd1 || hit_b7_b1t == 1'd1 || hit_b7_b2t == 1'd1 || hit_b7_b3t == 1'd1 || hit_b7_b4t == 1'd1 || hit_b7_b5t == 1'd1 || hit_b7_b6t == 1'd1 || hit_b7_b8t == 1'd1 || hit_b7_b9t == 1'd1)
				NS7 = block1_move_135;
			else if(x_block7 >= 11'd650)	
				NS7 = block1_been_shot;
			else
				NS7 = block1_move_225;
			end
		block1_move_315:
		begin
			if(x_block7 >=  11'd600 || hit_b7_pl == 1'd1 || hit_b7_b1l == 1'd1 || hit_b7_b2l == 1'd1 || hit_b7_b3l == 1'd1 || hit_b7_b4l == 1'd1 || hit_b7_b5l == 1'd1 || hit_b7_b6l == 1'd1 || hit_b7_b8l == 1'd1 || hit_b7_b9l == 1'd1)
				NS7 = block1_move_225;
			else if( y_block7 >= 11'd439 || hit_b7_let == 1'd1 || hit_b7_ht == 1'd1 || hit_b7_pt == 1'd1 || hit_b7_b1t == 1'd1 || hit_b7_b2t == 1'd1 || hit_b7_b3t == 1'd1 || hit_b7_b4t == 1'd1 || hit_b7_b5t == 1'd1 || hit_b7_b6t == 1'd1 || hit_b7_b8t == 1'd1 || hit_b7_b9t == 1'd1)
				NS7 = block1_move_45;
			else if(x_block7 >= 11'd650)	
				NS7 = block1_been_shot;
			else
				NS7 = block1_move_315;
		end
		block1_move_135:
		begin
			if( x_block7 <= 11'd20 || hit_b7_ler == 1'd1 || hit_b7_hr == 1'd1 || hit_b7_pr == 1'd1 || hit_b7_b1r == 1'd1 || hit_b7_b2r == 1'd1 || hit_b7_b3r == 1'd1 || hit_b7_b4r == 1'd1 || hit_b7_b5r == 1'd1 || hit_b7_b6r == 1'd1 || hit_b7_b8r == 1'd1 || hit_b7_b9r == 1'd1)
				NS7 = block1_move_45;
			else if(y_block7 <= 11'd20 || hit_b7_pb == 1'd1 || hit_b7_b1b == 1'd1 || hit_b7_b2b == 1'd1 || hit_b7_b3b == 1'd1 || hit_b7_b4b == 1'd1 || hit_b7_b5b == 1'd1 || hit_b7_b6b == 1'd1 || hit_b7_b8b == 1'd1 || hit_b7_b9b == 1'd1)
				NS7 = block1_move_225;
			else if(x_block7 >= 11'd650)	
				NS7 = block1_been_shot;
			else
				NS7 = block1_move_135;
		end
		block1_move_45:
		begin
			if( x_block7 >=  11'd600 || hit_b7_pl == 1'd1 || hit_b7_b1l == 1'd1 || hit_b7_b2l == 1'd1 || hit_b7_b3l == 1'd1 || hit_b7_b4l == 1'd1 || hit_b7_b5l == 1'd1 || hit_b7_b6l == 1'd1 || hit_b7_b8l == 1'd1 || hit_b7_b9l == 1'd1)
				NS7 = block1_move_135;
			else if( y_block7 <= 11'd20 || hit_b7_pb == 1'd1 || hit_b7_b1b == 1'd1 || hit_b7_b2b == 1'd1 || hit_b7_b3b == 1'd1 || hit_b7_b4b == 1'd1 || hit_b7_b5b == 1'd1 || hit_b7_b6b == 1'd1 || hit_b7_b8b == 1'd1 || hit_b7_b9b == 1'd1)
				NS7 = block1_move_315;
			else if(x_block7 >= 11'd650)	
				NS7 = block1_been_shot;
			else
				NS7 = block1_move_45;
		end
		block1_been_shot:
		begin
		if (grumbles7 >= 32'd1000)
		NS7 = stinkyboi;
		else
		NS7 = block1_been_shot;
		end
		stinkyboi:
		begin
			if (grumbles7 >= 32'd1005)
				NS7 = block1_move_135;
			else
				NS7 = stinkyboi;
		end
	endcase	
	
		case(S8)
		before: 
		begin
			if (rst == 1'd0)
				NS8 = before;
			else
				NS8 = start;
		end

		start:
		begin
			if (start_game == 1'd0)
				NS8 = start;
			else 
				NS8 =  start_anim;
		end
		start_anim:
		begin
			if (y_redstart >= 11'd499)
				NS8 = block1_move_315;
			else
				NS8 = start_anim;
		end
		block1_move_225:
		begin
			if( x_block8 <= 11'd20 || hit_b8_ler == 1'd1 || hit_b8_hr == 1'd1|| hit_b8_pr == 1'd1 || hit_b8_b1r == 1'd1 || hit_b8_b2r == 1'd1 || hit_b8_b3r == 1'd1 || hit_b8_b4r == 1'd1 || hit_b8_b5r == 1'd1 || hit_b8_b6r == 1'd1 || hit_b8_b7r == 1'd1 || hit_b8_b9r == 1'd1)
				NS8 = block1_move_315;
			else if( y_block8 >= 11'd439 || hit_b8_let == 1'd1 || hit_b8_ht == 1'd1|| hit_b8_pt == 1'd1 || hit_b8_b1t == 1'd1 || hit_b8_b2t == 1'd1 || hit_b8_b3t == 1'd1 || hit_b8_b4t == 1'd1 || hit_b8_b5t == 1'd1 || hit_b8_b6t == 1'd1 || hit_b8_b7t == 1'd1 || hit_b8_b9t == 1'd1)
				NS8 = block1_move_135;
			else if(x_block8 >= 11'd650)	
				NS8 = block1_been_shot;
			else
				NS8 = block1_move_225;
			end
		block1_move_315:
		begin
			if(x_block8 >=  11'd600 || hit_b8_pl == 1'd1 || hit_b8_b1l == 1'd1 || hit_b8_b2l == 1'd1 || hit_b8_b3l == 1'd1 || hit_b8_b4l == 1'd1 || hit_b8_b5l == 1'd1 || hit_b8_b6l == 1'd1 || hit_b8_b7l == 1'd1 || hit_b8_b9l == 1'd1)
				NS8 = block1_move_225;
			else if( y_block8 >= 11'd439 || hit_b8_let == 1'd1 || hit_b8_ht == 1'd1 || hit_b8_pt == 1'd1 || hit_b8_b1t == 1'd1 || hit_b8_b2t == 1'd1 || hit_b8_b3t == 1'd1 || hit_b8_b4t == 1'd1 || hit_b8_b5t == 1'd1 || hit_b8_b6t == 1'd1 || hit_b8_b7t == 1'd1 || hit_b8_b9t == 1'd1)
				NS8 = block1_move_45;
			else if(x_block8 >= 11'd650)	
				NS8 = block1_been_shot;
			else
				NS8 = block1_move_315;
		end
		block1_move_135:
		begin
			if( x_block8 <= 11'd20 || hit_b8_ler == 1'd1 || hit_b8_hr == 1'd1 || hit_b8_pr == 1'd1 || hit_b8_b1r == 1'd1 || hit_b8_b2r == 1'd1 || hit_b8_b3r == 1'd1 || hit_b8_b4r == 1'd1 || hit_b8_b5r == 1'd1 || hit_b8_b6r == 1'd1 || hit_b8_b7r == 1'd1 || hit_b8_b9r == 1'd1)
				NS8 = block1_move_45;
			else if(y_block8 <= 11'd20 || hit_b8_pb == 1'd1 || hit_b8_b1b == 1'd1 || hit_b8_b2b == 1'd1 || hit_b8_b3b == 1'd1 || hit_b8_b4b == 1'd1 || hit_b8_b5b == 1'd1 || hit_b8_b6b == 1'd1 || hit_b8_b7b == 1'd1 || hit_b8_b9b == 1'd1)
				NS8 = block1_move_225;
			else if(x_block8 >= 11'd650)	
				NS8 = block1_been_shot;
			else
				NS8 = block1_move_135;
		end
		block1_move_45:
		begin
			if( x_block8 >=  11'd600 || hit_b8_pl == 1'd1 || hit_b8_b1l == 1'd1 || hit_b8_b2l == 1'd1 || hit_b8_b3l == 1'd1 || hit_b8_b4l == 1'd1 || hit_b8_b5l == 1'd1 || hit_b8_b6l == 1'd1 || hit_b8_b7l == 1'd1 || hit_b8_b9l == 1'd1)
				NS8 = block1_move_135;
			else if( y_block8 <= 11'd20 || hit_b8_pb == 1'd1 || hit_b8_b1b == 1'd1 || hit_b8_b2b == 1'd1 || hit_b8_b3b == 1'd1 || hit_b8_b4b == 1'd1 || hit_b8_b5b == 1'd1 || hit_b8_b6b == 1'd1 || hit_b8_b7b == 1'd1 || hit_b8_b9b == 1'd1)
				NS8 = block1_move_315;
			else if(x_block8 >= 11'd650)	
				NS8 = block1_been_shot;
			else
				NS8 = block1_move_45;
		end
		block1_been_shot:
		begin
		if (grumbles8 >= 32'd1000)
		NS8 = stinkyboi;
		else
		NS8 = block1_been_shot;
		end
		stinkyboi:
		begin
			if (grumbles8 >= 32'd1005)
				NS8 = block1_move_225;
			else
				NS8 = stinkyboi;
		end
	endcase

		case(S9)
		before: 
		begin
			if (rst == 1'd0)
				NS9 = before;
			else
				NS9 = start;
		end
		start:
		begin
			if (start_game == 1'd0)
				NS9 = start;
			else 
				NS9 =  start_anim;
		end
		start_anim:
		begin
			if (y_redstart >= 11'd499)
				NS9 = block1_move_315;
			else
				NS9 = start_anim;
		end
		block1_move_225:
		begin
			if( x_block9 <= 11'd20 || hit_b9_ler == 1'd1 || hit_b9_hr == 1'd1 || hit_b9_pr == 1'd1 || hit_b9_b1r == 1'd1 || hit_b9_b2r == 1'd1 || hit_b9_b3r == 1'd1 || hit_b9_b4r == 1'd1 || hit_b9_b5r == 1'd1 || hit_b9_b6r == 1'd1 || hit_b9_b7r == 1'd1 || hit_b9_b7r == 1'd1)
				NS9 = block1_move_315;
			else if( y_block9 >= 11'd439 || hit_b9_let == 1'd1 || hit_b9_ht == 1'd1 || hit_b9_pt == 1'd1 || hit_b9_b1t == 1'd1 || hit_b9_b2t == 1'd1 || hit_b9_b3t == 1'd1 || hit_b9_b4t == 1'd1 || hit_b9_b5t == 1'd1 || hit_b9_b6t == 1'd1 || hit_b9_b7t == 1'd1 || hit_b9_b7t == 1'd1)
				NS9 = block1_move_135;
			else if(x_block9 >= 11'd650)	
				NS9 = block1_been_shot;
			else
				NS9 = block1_move_225;
			end
		block1_move_315:
		begin
			if(x_block9 >=  11'd600 || hit_b9_pl == 1'd1 || hit_b9_b1l == 1'd1 || hit_b9_b2l == 1'd1 || hit_b9_b3l == 1'd1 || hit_b9_b4l == 1'd1 || hit_b9_b5l == 1'd1 || hit_b9_b6l == 1'd1 || hit_b9_b7l == 1'd1 || hit_b9_b7l == 1'd1)
				NS9 = block1_move_225;
			else if( y_block9 >= 11'd439 || hit_b9_let == 1'd1 || hit_b9_ht == 1'd1 || hit_b9_pt == 1'd1 || hit_b9_b1t == 1'd1 || hit_b9_b2t == 1'd1 || hit_b9_b3t == 1'd1 || hit_b9_b4t == 1'd1 || hit_b9_b5t == 1'd1 || hit_b9_b6t == 1'd1 || hit_b9_b7t == 1'd1 || hit_b9_b7t == 1'd1)
				NS9 = block1_move_45;
			else if(x_block9 >= 11'd650)	
				NS9 = block1_been_shot;
			else
				NS9 = block1_move_315;
		end
		block1_move_135:
		begin
			if( x_block9 <= 11'd20 || hit_b9_ler == 1'd1 || hit_b9_hr == 1'd1 || hit_b9_pr == 1'd1 || hit_b9_b1r == 1'd1 || hit_b9_b2r == 1'd1 || hit_b9_b3r == 1'd1 || hit_b9_b4r == 1'd1 || hit_b9_b5r == 1'd1 || hit_b9_b6r == 1'd1 || hit_b9_b7r == 1'd1 || hit_b9_b7r == 1'd1)
				NS9 = block1_move_45;
			else if(y_block9 <= 11'd20 || hit_b9_pb == 1'd1 || hit_b9_b1b == 1'd1 || hit_b9_b2b == 1'd1 || hit_b9_b3b == 1'd1 || hit_b9_b4b == 1'd1 || hit_b9_b5b == 1'd1 || hit_b9_b6b == 1'd1 || hit_b9_b7b == 1'd1 || hit_b9_b7b == 1'd1)
				NS9 = block1_move_225;
			else if(x_block9 >= 11'd650)	
				NS9 = block1_been_shot;
			else
				NS9 = block1_move_135;
		end
		block1_move_45:
		begin
			if( x_block9 >=  11'd600 || hit_b9_pl == 1'd1 || hit_b9_b1l == 1'd1 || hit_b9_b2l == 1'd1 || hit_b9_b3l == 1'd1 || hit_b9_b4l == 1'd1 || hit_b9_b5l == 1'd1 || hit_b9_b6l == 1'd1 || hit_b9_b7l == 1'd1 || hit_b9_b7l == 1'd1)
				NS9 = block1_move_135;
			else if( y_block9 <= 11'd20 || hit_b9_pb == 1'd1 || hit_b9_b1b == 1'd1 || hit_b9_b2b == 1'd1 || hit_b9_b3b == 1'd1 || hit_b9_b4b == 1'd1 || hit_b9_b5b == 1'd1 || hit_b9_b6b == 1'd1 || hit_b9_b7b == 1'd1 || hit_b9_b7b == 1'd1)
				NS9 = block1_move_315;
			else if(x_block9 >= 11'd650)	
				NS9 = block1_been_shot;
			else
				NS9 = block1_move_45;
		end
		block1_been_shot:
		begin
		if (grumbles9 >= 32'd1000)
		NS9 = stinkyboi;
		else
		NS9 = block1_been_shot;
		end
		stinkyboi:
		begin
			if (grumbles9 >= 32'd1005)
				NS9 = block1_move_135;
			else
				NS9 = stinkyboi;
		end
	endcase
end


////////////////////////////////////////////state definitions
always @(posedge update or negedge rst)
begin
	if (rst==1'd0)
	begin	
		// Positions the missles and cosmetics on the screen following the player
				y_missile = y_pad + 8'd7;
				x_missile = x_pad;
				y_tank = y_pad + 8'd7;
				x_tank = x_pad;
				y_stripe = y_pad;
				x_stripe = x_pad + 8'd4;
				y_stripe2 = y_pad;
				x_stripe2 = x_pad + 8'd12;
				y_sting = y_pad + 8'd9;
				x_sting = x_pad - 8'd6;
				y_wing = y_pad - 8'd5;
				x_wing = x_pad + 8'd3;
				y_wing2 = y_pad + 8'd21;
				x_wing2 = x_pad + 8'd3;
				y_head = y_pad + 8'd5;
				x_head = x_pad + 8'd21;
				x_redstart = 1'b0;
				y_redstart = 1'b0;
				x_onbase = 11'd141;
				y_onbase = 11'd245;
				x_onswitch = 11'd142;
				y_onswitch = 11'd260;
				x_gout = 11'd141;
				y_gout = 11'd212;
				x_gin = 11'd144;
				y_gin = 11'd214; 
				x_gin2 = 11'd144;
				y_gin2 = 11'd218; 
				x_aout = 11'd159;
				y_aout = 11'd212;
				x_ain2 = 11'd161;
				y_ain2 = 11'd228;
				x_ain = 11'd161;
				y_ain = 11'd214;
				x_mout = 11'd177;
				y_mout = 11'd212;
				x_min = 11'd179;
				y_min = 11'd214;
				x_min2 = 11'd186;
				y_min2 = 11'd214;
				x_eout = 11'd195;
				y_eout = 11'd212;
				x_ein = 11'd197;
				y_ein = 11'd214;
				x_ein2 = 11'd197;
				y_ein2 = 11'd228;
				x_oout = 11'd177;
				y_oout = 11'd245;
				x_oin = 11'd179;
				y_oin = 11'd247;
				x_nout = 11'd195;
				y_nout = 11'd245;
				x_nin = 11'd198;
				y_nin = 11'd247;
				x_nin2 = 11'd204;
				y_nin2 = 11'd245;
				x_hive = 11'd61;
				y_hive = 11'd400;
				x_leaves = 11'd0;
				y_leaves = 11'd361;
				x_health1 = 11'd0;
				y_health1 = 11'd361;
				x_health2 = 11'd0;
				y_health2 = 11'd371;
				x_health3 = 11'd0;
				y_health3 = 11'd381;
				x_health4 = 11'd0;
				y_health4 = 11'd391;
				x_health5 = 11'd0;
				y_health5 = 11'd401;
				x_health6 = 11'd0;
				y_health6 = 11'd411;
				x_health7 = 11'd0;
				y_health7 = 11'd421;
				x_health8 = 11'd0;
				y_health8 = 11'd431;
				x_health9 = 11'd0;
				y_health9 = 11'd441;
				x_health10 = 11'd0;
				y_health10 = 11'd451;
				x_hive1 = 11'd61;
				y_hive1 = 11'd410;
				x_hive2 = 11'd61;
				y_hive2 = 11'd445;
				x_hive3 = 11'd100;
				y_hive3 = 11'd425;
				x_deaded = 11'd700;
				y_deaded = 11'd500;
				x_e2out = 11'd700;
				y_e2out = 11'd500;
				x_e2in1 = 11'd700;
				y_e2in1 = 11'd500;
				x_e2in2 = 11'd700;
				y_e2in2 = 11'd500;
				x_vout = 11'd700;
				y_vout = 11'd500;
				x_vin = 11'd700;
				y_vin = 11'd500;
				x_vin2 = 11'd700;
				y_vin2 = 11'd500;
				x_iout = 11'd700;
				y_iout = 11'd500;
				x_iin = 11'd700;
				y_iin = 11'd500;
				x_iin2 = 11'd700;
				y_iin2 = 11'd500;
				x_wout = 11'd700;
				y_wout = 11'd500;
				x_win = 11'd700;
				y_win = 11'd500;
				x_win2 = 11'd700;
				y_win2 = 11'd500;
				x_rout = 11'd700;
				y_rout = 11'd500;
				x_rin = 11'd700;
				y_rin = 11'd500;
				x_rin2 = 11'd700;
				y_rin2 = 11'd500;
				x_rin3 = 11'd700;
				y_rin3 = 11'd500;
				x_topb = 11'd138;
				y_topb = 11'd209;
				x_midb = 11'd138;
				y_midb = 11'd241;
				x_botb = 11'd174;
				y_botb = 11'd274;
				x_outb = 11'd138;
				y_outb = 11'd212;
				x_leftb = 11'd156;
				y_leftb = 11'd212;
				x_middleb = 11'd174;
				y_middleb = 11'd212;
				x_rightb = 11'd192;
				y_rightb = 11'd212;
				x_outrb = 11'd210;
				y_outrb = 11'd212;
				x_outmostr = 11'd138;
				y_outmostr = 11'd245;
				x_farright = 11'd156;
				y_farright = 11'd245;
				x_bot1b = 11'd138;
				y_bot1b = 11'd274;
				x_top2b = 11'd700;
				y_top2b = 11'd500;
				x_bot2b = 11'd700;
				y_bot2b = 11'd500;
				x_tealwin = 11'd1;
				y_tealwin = 11'd500;
				score1 = 11'd0;
				x_beebar = 11'd613;
				y_beebar = 11'd376;
				x_beebar2 = 11'd613;
				y_beebar2 = 11'd373;
				x_beecominhome = 11'd616;
				y_beecominhome = 11'd376;
				y_return1 = 11'd425;
				y_return2 = 11'd430;
				y_return3 = 11'd420;
				x_return1 = 11'd660;
				x_return2 = 11'd680;
				x_return3 = 11'd700;
		// Position the zombees on the screen
		x_block1 = 11'd177;
		y_block1 = 11'd45;
		x_block2 = 11'd259;
		y_block2 = 11'd68;
		x_block3 = 11'd340;
		y_block3 = 11'd245;
		x_block4 = 11'd382;
		y_block4 = 11'd27;
		x_block5 = 11'd365;
		y_block5 = 11'd380;
		x_block6 = 11'd420;
		y_block6 = 11'd230;
		x_block7 = 11'd474;
		y_block7 = 11'd100;
		x_block8 = 11'd590;
		y_block8 = 11'd420;
		x_block9 = 11'd260;
		y_block9 = 11'd360;
		
		x_screen_border = 11'd20;
		y_screen_border = 11'd20;
	end
	else
	begin
		case(S)
			start:
			begin //this is just the game starting, same as reset, in case of potential bug
				y_missile = y_pad + 8'd7;
				x_missile = x_pad;
				y_tank = y_pad + 8'd7;
				x_tank = x_pad;
				y_stripe = y_pad;
				x_stripe = x_pad + 8'd4;
				y_stripe2 = y_pad;
				x_stripe2 = x_pad + 8'd12;
				y_sting = y_pad + 8'd9;
				x_sting = x_pad - 8'd6;
				y_wing = y_pad - 8'd5;
				x_wing = x_pad + 8'd3;
				y_wing2 = y_pad + 8'd21;
				x_wing2 = x_pad + 8'd3;
				y_head = y_pad + 8'd5;
				x_head = x_pad + 8'd21;
				life = 11'd10;
			end
			start_anim:
			begin
			y_missile = y_pad + 8'd7;
				x_missile = x_pad;
				y_tank = y_pad + 8'd7;
				x_tank = x_pad;
				y_stripe = y_pad;
				x_stripe = x_pad + 8'd4;
				y_stripe2 = y_pad;
				x_stripe2 = x_pad + 8'd12;
				y_sting = y_pad + 8'd9;
				x_sting = x_pad - 8'd6;
				y_wing = y_pad - 8'd5;
				x_wing = x_pad + 8'd3;
				y_wing2 = y_pad + 8'd21;
				x_wing2 = x_pad + 8'd3;
				y_head = y_pad + 8'd5;
				x_head = x_pad + 8'd21;
			if (y_onswitch <= 11'd246)
				begin
					y_redstart = y_redstart + 11'd1;
					if (y_redstart >= 11'd500)
						begin
							y_redstart = 11'd500;
							y_onbase = 11'd500;
							y_onswitch = 11'd500;
							y_gout = 11'd500;
							y_gin = 11'd500;
							y_gin2 = 11'd500;
							y_aout = 11'd500;
							y_ain = 11'd500;
							y_ain2 = 11'd500;
							y_mout = 11'd500;
							y_min = 11'd500;
							y_min2 = 11'd500;
							y_eout = 11'd500;
							y_ein = 11'd500;
							y_ein2 = 11'd500;
							y_nout = 11'd500;
							y_nin = 11'd500;
							y_nin2 = 11'd500;
							y_oout = 11'd500;
							y_oin = 11'd500;
							x_topb = 11'd700;
							y_topb = 11'd500;
							x_midb = 11'd700;
							y_midb = 11'd500;
							x_botb = 11'd700;
							y_botb = 11'd500;
							x_outb = 11'd700;
							y_outb = 11'd500;
							x_leftb = 11'd700;
							y_leftb = 11'd500;
							x_middleb = 11'd700;
							y_middleb = 11'd500;
							x_rightb = 11'd700;
							y_rightb = 11'd500;
							x_outrb = 11'd700;
							y_outrb = 11'd500;
							x_outmostr = 11'd700;
							y_outmostr = 11'd500;
							x_farright = 11'd700;
							y_farright = 11'd500;
							x_top2b = 11'd700;
							y_top2b = 11'd500;
							x_bot2b = 11'd700;
							y_bot2b = 11'd500;
							x_bot1b = 11'd700;
							y_bot1b = 11'd500;
						end
				end
			else
			begin
				y_onswitch = y_onswitch - 11'd1;
			end
			end
			missile_move_left:
			begin
				// so this is when a zombeee is hit by the missile which i just realized i was supposed to be calling laser... 
				if(hit_block1 == 1'b1) // Delete block 1
				begin
					score1 <= score1 + 11'd1;
					y_beecominhome = y_beecominhome + 11'd4;
					x_block1 = 11'd700;
					y_block1 = 11'd0;
				end
				if(hit_block2 == 1'b1) // Delete block 2
				begin
					score1 <= score1 + 11'd1;
					y_beecominhome = y_beecominhome + 11'd4;
					x_block2 = 11'd700;
					y_block2 = 11'd30;
				end
				if(hit_block3 == 1'b1) // Delete block 3
				begin
					score1 <= score1 + 11'd1;
					y_beecominhome = y_beecominhome + 11'd4;
					x_block3 = 11'd700;
					y_block3 = 11'd60;
				end
				if(hit_block4 == 1'b1) // Delete block 4
				begin
					score1 <= score1 + 11'd1;
					y_beecominhome = y_beecominhome + 11'd4;
					x_block4 = 11'd700;
					y_block4 = 11'd90;
				end
				if(hit_block5 == 1'b1) // Delete block 5
				begin
					score1 <= score1 + 11'd1;
					y_beecominhome = y_beecominhome + 11'd4;
					x_block5 = 11'd700;
					y_block5 = 11'd120;
				end
				if(hit_block6 == 1'b1) // Delete block 6
				begin
					score1 <= score1 + 11'd1;
					y_beecominhome = y_beecominhome + 11'd4;
					x_block6 = 11'd700;
					y_block6 = 11'd150;
				end
				if(hit_block7 == 1'b1) // Delete block 7
				begin
					score1 <= score1 + 11'd1;
					y_beecominhome = y_beecominhome + 11'd4;
					x_block7 = 11'd700;
					y_block7 = 11'd180;
				end
				if(hit_block8 == 1'b1) // Delete block 8
				begin
					score1 <= score1 + 11'd1;
					y_beecominhome = y_beecominhome + 11'd4;
					x_block8 = 11'd700;
					y_block8 = 11'd210;
				end
				if(hit_block9 == 1'b1) // Delete block 9
				begin
					score1 <= score1 + 11'd1;
					y_beecominhome = y_beecominhome + 11'd4;
					x_block9 = 11'd700;
					y_block9 = 11'd240;
				end
				// missile moving!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
				//this makes it so that when the missile is moving, the cosmetics location is constantly set to the player location! teehee
				x_missile = x_missile + 11'd4;
				y_stripe = y_pad;
				x_stripe = x_pad + 8'd4;
				y_stripe2 = y_pad;
				x_stripe2 = x_pad + 8'd12;
				y_sting = y_pad + 8'd9;
				x_sting = x_pad - 8'd6;
				y_wing = y_pad - 8'd5;
				x_wing = x_pad + 8'd3;
				y_wing2 = y_pad + 8'd21;
				x_wing2 = x_pad + 8'd3;
				y_head = y_pad + 8'd5;
				x_head = x_pad + 8'd21;
				y_tank = y_pad + 8'd7;
				x_tank = x_pad;
				if (hit_bee_b2t == 1'd1 || hit_bee_b1t == 1'd1 || hit_bee_b3t == 1'd1 || hit_bee_b4t == 1'd1 || hit_bee_b5t == 1'd1 || hit_bee_b6t == 1'd1 || hit_bee_b7t == 1'd1 || hit_bee_b8t == 1'd1 || hit_bee_b9t == 1'd1 || hit_bee_b2b == 1'd1 || hit_bee_b1b == 1'd1 || hit_bee_b3b == 1'd1 || hit_bee_b4b == 1'd1 || hit_bee_b5b == 1'd1 || hit_bee_b6b == 1'd1 || hit_bee_b7b == 1'd1 || hit_bee_b8b == 1'd1 || hit_bee_b9b == 1'd1 || hit_bee_b2l == 1'd1 || hit_bee_b1l == 1'd1 || hit_bee_b3l == 1'd1 || hit_bee_b4l == 1'd1 || hit_bee_b5l == 1'd1 || hit_bee_b6l == 1'd1 || hit_bee_b7l == 1'd1 || hit_bee_b8l == 1'd1 || hit_bee_b9l == 1'd1 || hit_bee_b2r == 1'd1 || hit_bee_b1r == 1'd1 || hit_bee_b3r == 1'd1 || hit_bee_b4r == 1'd1 || hit_bee_b5r == 1'd1 || hit_bee_b6r == 1'd1 || hit_bee_b7r == 1'd1 || hit_bee_b8r == 1'd1 || hit_bee_b9r == 1'd1)
					life = life - 11'd1;
				if (life == 11'd9)
				begin
					x_health1 = 11'd700;
					y_health1 = 11'd500;
				end
				if (life == 11'd8)
				begin
					x_health2 = 11'd700;
					y_health2 = 11'd500;
				end
				if (life == 11'd7)
				begin
					x_health3 = 11'd700;
					y_health3 = 11'd500;
				end
				if (life == 11'd6)
				begin
					x_health4 = 11'd700;
					y_health4 = 11'd500;
				end
				if (life == 11'd5)
				begin
					x_health5 = 11'd700;
					y_health5 = 11'd500;
				end
				if (life == 11'd4)
				begin
					x_health6 = 11'd700;
					y_health6 = 11'd500;
				end
				if (life == 11'd3)
				begin
					x_health7 = 11'd700;
					y_health7 = 11'd500;
				end
				if (life == 11'd2)
				begin
					x_health8 = 11'd700;
					y_health8 = 11'd500;
				end
				if (life == 11'd1)
				begin
					x_health9 = 11'd700;
					y_health9 = 11'd500;
				end
			end
			
			missile_reload: //this makes all cosmetics follow the player and returns the missle to the tank and player
			begin
				y_missile = y_pad + 8'd7;
				x_missile = x_pad;
				y_tank = y_pad + 8'd7;
				x_tank = x_pad;
				y_stripe = y_pad;
				x_stripe = x_pad + 8'd4;
				y_stripe2 = y_pad;
				x_stripe2 = x_pad + 8'd12;
				y_sting = y_pad + 8'd9;
				x_sting = x_pad - 8'd6;
				y_wing = y_pad - 8'd5;
				x_wing = x_pad + 8'd3;
				y_wing2 = y_pad + 8'd21;
				x_wing2 = x_pad + 8'd3;
				y_head = y_pad + 8'd5;
				x_head = x_pad + 8'd21;
				if (hit_bee_b2t == 1'd1 || hit_bee_b1t == 1'd1 || hit_bee_b3t == 1'd1 || hit_bee_b4t == 1'd1 || hit_bee_b5t == 1'd1 || hit_bee_b6t == 1'd1 || hit_bee_b7t == 1'd1 || hit_bee_b8t == 1'd1 || hit_bee_b9t == 1'd1 || hit_bee_b2b == 1'd1 || hit_bee_b1b == 1'd1 || hit_bee_b3b == 1'd1 || hit_bee_b4b == 1'd1 || hit_bee_b5b == 1'd1 || hit_bee_b6b == 1'd1 || hit_bee_b7b == 1'd1 || hit_bee_b8b == 1'd1 || hit_bee_b9b == 1'd1 || hit_bee_b2l == 1'd1 || hit_bee_b1l == 1'd1 || hit_bee_b3l == 1'd1 || hit_bee_b4l == 1'd1 || hit_bee_b5l == 1'd1 || hit_bee_b6l == 1'd1 || hit_bee_b7l == 1'd1 || hit_bee_b8l == 1'd1 || hit_bee_b9l == 1'd1 || hit_bee_b2r == 1'd1 || hit_bee_b1r == 1'd1 || hit_bee_b3r == 1'd1 || hit_bee_b4r == 1'd1 || hit_bee_b5r == 1'd1 || hit_bee_b6r == 1'd1 || hit_bee_b7r == 1'd1 || hit_bee_b8r == 1'd1 || hit_bee_b9r == 1'd1)
					life = life - 11'd1;
				if (life == 11'd9)
				begin
					x_health1 = 11'd700;
					y_health1 = 11'd500;
				end
				if (life == 11'd8)
				begin
					x_health2 = 11'd700;
					y_health2 = 11'd500;
				end
				if (life == 11'd7)
				begin
					x_health3 = 11'd700;
					y_health3 = 11'd500;
				end
				if (life == 11'd6)
				begin
					x_health4 = 11'd700;
					y_health4 = 11'd500;
				end
				if (life == 11'd5)
				begin
					x_health5 = 11'd700;
					y_health5 = 11'd500;
				end
				if (life == 11'd4)
				begin
					x_health6 = 11'd700;
					y_health6 = 11'd500;
				end
				if (life == 11'd3)
				begin
					x_health7 = 11'd700;
					y_health7 = 11'd500;
				end
				if (life == 11'd2)
				begin
					x_health8 = 11'd700;
					y_health8 = 11'd500;
				end
				if (life == 11'd1)
				begin
					x_health9 = 11'd700;
					y_health9 = 11'd500;
				end
			end
			
			missile_reload1: //this makes all cosmetics follow the player and returns the missle to the tank and player
			begin
				y_missile = y_pad + 8'd7;
				x_missile = x_pad;
				y_tank = y_pad + 8'd7;
				x_tank = x_pad;
				y_stripe = y_pad;
				x_stripe = x_pad + 8'd4;
				y_stripe2 = y_pad;
				x_stripe2 = x_pad + 8'd12;
				y_sting = y_pad + 8'd9;
				x_sting = x_pad - 8'd6;
				y_wing = y_pad - 8'd5;
				x_wing = x_pad + 8'd3;
				y_wing2 = y_pad + 8'd21;
				x_wing2 = x_pad + 8'd3;
				y_head = y_pad + 8'd5;
				x_head = x_pad + 8'd21;
				if (hit_bee_b2t == 1'd1 || hit_bee_b1t == 1'd1 || hit_bee_b3t == 1'd1 || hit_bee_b4t == 1'd1 || hit_bee_b5t == 1'd1 || hit_bee_b6t == 1'd1 || hit_bee_b7t == 1'd1 || hit_bee_b8t == 1'd1 || hit_bee_b9t == 1'd1 || hit_bee_b2b == 1'd1 || hit_bee_b1b == 1'd1 || hit_bee_b3b == 1'd1 || hit_bee_b4b == 1'd1 || hit_bee_b5b == 1'd1 || hit_bee_b6b == 1'd1 || hit_bee_b7b == 1'd1 || hit_bee_b8b == 1'd1 || hit_bee_b9b == 1'd1 || hit_bee_b2l == 1'd1 || hit_bee_b1l == 1'd1 || hit_bee_b3l == 1'd1 || hit_bee_b4l == 1'd1 || hit_bee_b5l == 1'd1 || hit_bee_b6l == 1'd1 || hit_bee_b7l == 1'd1 || hit_bee_b8l == 1'd1 || hit_bee_b9l == 1'd1 || hit_bee_b2r == 1'd1 || hit_bee_b1r == 1'd1 || hit_bee_b3r == 1'd1 || hit_bee_b4r == 1'd1 || hit_bee_b5r == 1'd1 || hit_bee_b6r == 1'd1 || hit_bee_b7r == 1'd1 || hit_bee_b8r == 1'd1 || hit_bee_b9r == 1'd1)
					life = life - 11'd1;
				if (life == 11'd9)
				begin
					x_health1 = 11'd700;
					y_health1 = 11'd500;
				end
				if (life == 11'd8)
				begin
					x_health2 = 11'd700;
					y_health2 = 11'd500;
				end
				if (life == 11'd7)
				begin
					x_health3 = 11'd700;
					y_health3 = 11'd500;
				end
				if (life == 11'd6)
				begin
					x_health4 = 11'd700;
					y_health4 = 11'd500;
				end
				if (life == 11'd5)
				begin
					x_health5 = 11'd700;
					y_health5 = 11'd500;
				end
				if (life == 11'd4)
				begin
					x_health6 = 11'd700;
					y_health6 = 11'd500;
				end
				if (life == 11'd3)
				begin
					x_health7 = 11'd700;
					y_health7 = 11'd500;
				end
				if (life == 11'd2)
				begin
					x_health8 = 11'd700;
					y_health8 = 11'd500;
				end
				if (life == 11'd1)
				begin
					x_health9 = 11'd700;
					y_health9 = 11'd500;
				end
			end
				
			end_game: // this is the part where you LOSE
			begin
				x_hive = 11'd700;
				y_hive = 11'd500;
				x_leaves = 11'd700;
				y_leaves = 11'd500;
				x_hive1 = 11'd700;
				y_hive1 = 11'd500;
				x_hive2 = 11'd700;
				y_hive2 = 11'd500;
				x_hive3 = 11'd700;
				y_hive3 = 11'd500;
				x_health10 = 11'd700;
				y_health10 = 11'd500;
				y_missile = 11'd500;
				x_missile =  11'd700;
				y_tank = 11'd500;
				x_tank =  11'd700;
				y_stripe = 11'd500;
				x_stripe =  11'd700;
				y_stripe2 = 11'd500;
				x_stripe2 =  11'd700;
				y_sting = 11'd500;
				x_sting =  11'd700;
				y_wing = 11'd500;
				x_wing =  11'd700;
				y_wing2 = 11'd500;
				x_wing2 =  11'd700;
				y_head =  11'd500;
				x_head =  11'd700;
				y_deaded =  y_pad;
				x_deaded =  x_pad;
				x_redstart = 1'b0;
				y_redstart = y_redstart - 11'd1;
				x_beebar = 11'd700;
				y_beebar = 11'd500;
				x_beebar2 = 11'd700;
				y_beebar2 = 11'd500;
				x_beecominhome = 11'd700;
				y_beecominhome = 11'd500;
					if (y_redstart <= 11'd1)
						begin
							x_hive = 11'd700;
							y_hive = 11'd500;
							x_leaves = 11'd700;
							y_leaves = 11'd500;
							x_hive1 = 11'd700;
							y_hive1 = 11'd500;
							x_hive2 = 11'd700;
							y_hive2 = 11'd500;
							x_hive3 = 11'd700;
							y_hive3 = 11'd500;
							x_health10 = 11'd700;
							y_health10 = 11'd500;
							y_missile = 11'd500;
							x_missile =  11'd700;
							y_tank = 11'd500;
							x_tank =  11'd700;
							y_stripe = 11'd500;
							x_stripe =  11'd700;
							y_stripe2 = 11'd500;
							x_stripe2 =  11'd700;
							y_sting = 11'd500;
							x_sting =  11'd700;
							y_wing = 11'd500;
							x_wing =  11'd700;
							y_wing2 = 11'd500;
							x_wing2 =  11'd700;
							y_head =  11'd500;
							x_head =  11'd700;
							y_deaded =  y_pad;
							x_deaded =  x_pad;
							x_gout = 11'd141;
							y_gout = 11'd212;
							x_gin = 11'd144;
							y_gin = 11'd214; 
							x_gin2 = 11'd144;
							y_gin2 = 11'd218; 
							x_aout = 11'd159;
							y_aout = 11'd212;
							x_ain2 = 11'd161;
							y_ain2 = 11'd228;
							x_ain = 11'd161;
							y_ain = 11'd214;
							x_mout = 11'd177;
							y_mout = 11'd212;
							x_min = 11'd179;
							y_min = 11'd214;
							x_min2 = 11'd186;
							y_min2 = 11'd214;
							x_eout = 11'd195;
							y_eout = 11'd212;
							x_ein = 11'd197;
							y_ein = 11'd214;
							x_ein2 = 11'd197;
							y_ein2 = 11'd228;
							x_oout = 11'd177;
							y_oout = 11'd245;
							x_oin = 11'd179;
							y_oin = 11'd247;
							x_vout = 11'd195;
							y_vout = 11'd245;
							x_vin = 11'd197;
							y_vin = 11'd245;
							x_vin2 = 11'd199;
							y_vin2 = 11'd248;
							x_e2out = 11'd213;
							y_e2out = 11'd245;
							x_e2in1 = 11'd215;
							y_e2in1 = 11'd247;
							x_e2in2 = 11'd215;
							y_e2in2 = 11'd261;
							x_rout = 11'd231;
							y_rout = 11'd245;
							x_rin2 = 11'd233;
							y_rin2 = 11'd261;
							x_rin = 11'd233;
							y_rin = 11'd247;
							x_rin3 = 11'd242;
							y_rin3 = 11'd261;
							x_topb = 11'd138;
							y_topb = 11'd209;
							x_midb = 11'd138;
							y_midb = 11'd241;
							x_botb = 11'd174;
							y_botb = 11'd274;
							x_outb = 11'd138;
							y_outb = 11'd212;
							x_leftb = 11'd156;
							y_leftb = 11'd212;
							x_middleb = 11'd174;
							y_middleb = 11'd212;
							x_rightb = 11'd192;
							y_rightb = 11'd212;
							x_outrb = 11'd210;
							y_outrb = 11'd212;			
							x_outmostr = 11'd228;
							y_outmostr = 11'd245;
							x_farright = 11'd246;
							y_farright = 11'd245;
							x_bot2b = 11'd210;
							y_bot2b = 11'd274;
							x_top2b = 11'd210;
							y_top2b = 11'd242;
							y_redstart = 11'd1;
							
						end
						end
			
		endcase
		case(S1)
		start:
		begin
			x_block1 = 11'd177;
			y_block1 = 11'd45;
		end
		start_anim:
		begin
			x_block1 = 11'd177;
			y_block1 = 11'd45;
		end
		block1_move_45:
		begin
			y_block1 = y_block1 - 11'd1;
			x_block1 = x_block1 + 11'd1;
		end
		block1_move_135:
		begin
			y_block1 = y_block1 - 11'd1;
			x_block1 = x_block1 - 11'd1;
		if (grumbles>= 32'd1005)
				grumbles <= 32'd0;
			
		end
		block1_move_315:
		begin
			y_block1 = y_block1 + 11'd1;
			x_block1 = x_block1 + 11'd1;
		end
		block1_move_225:
		begin
			y_block1 = y_block1 + 11'd1;
			x_block1 = x_block1 - 11'd1;
		if (grumbles >= 32'd1005)
				grumbles <= 32'd0;
		end
		block1_been_shot:
		begin
			x_block1 = 11'd700;
			y_block1 = 11'd0;
			if (update == 1'b1)
				grumbles <= grumbles + 11'd1;
			else
				grumbles <= grumbles;
		end
		stinkyboi:
		begin
			x_block1 = 11'd599;
			if (update == 1'b1)
				grumbles <= grumbles + 11'd1;
			else
				grumbles <= grumbles;
		end
		endcase
		
		case(S2)
		start:
		begin
			x_block2 = 11'd259;
			y_block2 = 11'd68;
		end
		start_anim:
		begin
			x_block2 = 11'd259;
			y_block2 = 11'd68;
		end
		block1_move_45:
		begin
			y_block2 = y_block2 - 11'd1;
			x_block2 = x_block2 + 11'd1;
		end
		block1_move_135:
		begin
			y_block2 = y_block2 - 11'd1;
			x_block2 = x_block2 - 11'd1;
		if (grumbles2>= 32'd1005)
				grumbles2 <= 32'd0;
		end
		block1_move_315:
		begin
			y_block2 = y_block2 + 11'd1;
			x_block2 = x_block2 + 11'd1;
		end
		block1_move_225:
		begin
			y_block2 = y_block2 + 11'd1;
			x_block2 = x_block2 - 11'd1;
		if (grumbles2 >= 32'd1005)
				grumbles2 <= 32'd0;
		end
		block1_been_shot:
		begin
			x_block2 = 11'd700;
			y_block2 = 11'd50;
			if (update == 1'b1)
				grumbles2 <= grumbles2 + 11'd1;
			else
				grumbles2 <= grumbles2;
		end
		stinkyboi:
		begin
			x_block2 = 11'd599;
			if (update == 1'b1)
				grumbles2 <= grumbles2 + 11'd1;
			else
				grumbles2 <= grumbles2;
			if (grumbles2 >= 32'd1005)
				grumbles2 <= 32'd0;
		end
		endcase	
		
		case(S3)
		start:
		begin
			x_block3 = 11'd340;
			y_block3 = 11'd245;
		end
		start_anim:
		begin
			x_block3 = 11'd340;
			y_block3 = 11'd245;
		end
		block1_move_45:
		begin
			y_block3 = y_block3 - 11'd1;
			x_block3 = x_block3 + 11'd1;
		end
		block1_move_135:
		begin
			y_block3 = y_block3 - 11'd1;
			x_block3 = x_block3 - 11'd1;
			if (grumbles3 >= 32'd1005)
				grumbles3 <= 32'd0;
		end
		block1_move_315:
		begin
			y_block3 = y_block3 + 11'd1;
			x_block3 = x_block3 + 11'd1;
		end
		block1_move_225:
		begin
			y_block3 = y_block3 + 11'd1;
			x_block3 = x_block3 - 11'd1;
			if (grumbles3 >= 32'd1005)
				grumbles3 <= 32'd0;
		end
		block1_been_shot:
		begin
			x_block3 = 11'd700;
			y_block3 = 11'd100;
			if (update == 1'b1)
				grumbles3 <= grumbles3 + 11'd1;
			else
				grumbles3 <= grumbles3;
		end
		stinkyboi:
		begin
			x_block3 = 11'd599;
			if (update == 1'b1)
				grumbles3 <= grumbles3 + 11'd1;
			else
				grumbles3 <= grumbles3;
				if (grumbles3 >= 32'd1005)
				grumbles3 <= 32'd0;
		end
		endcase
		
		case(S4)
		start:
		begin
			x_block4 = 11'd382;
			y_block4 = 11'd27;
		end
		start_anim:
		begin
			x_block4 = 11'd382;
			y_block4 = 11'd27;
		end
		block1_move_45:
		begin
			y_block4 = y_block4 - 11'd1;
			x_block4 = x_block4 + 11'd1;
		end
		block1_move_135:
		begin
			y_block4 = y_block4 - 11'd1;
			x_block4 = x_block4 - 11'd1;
		if (grumbles4>= 32'd1005)
				grumbles4 <= 32'd0;
		end
		block1_move_315:
		begin
			y_block4 = y_block4 + 11'd1;
			x_block4 = x_block4 + 11'd1;
		end
		block1_move_225:
		begin
			y_block4 = y_block4 + 11'd1;
			x_block4 = x_block4 - 11'd1;
		if (grumbles4>= 32'd1005)
				grumbles4 <= 32'd0;
		end
		block1_been_shot:
		begin
			x_block4 = 11'd700;
			y_block4 = 11'd1500;
			if (update == 1'b1)
				grumbles4 <= grumbles4 + 11'd1;
			else
				grumbles4 <= grumbles4;
		end
		stinkyboi:
		begin
			x_block4 = 11'd599;
			if (update == 1'b1)
				grumbles4 <= grumbles4 + 11'd1;
			else
				grumbles4 <= grumbles4;
				if (grumbles4 >= 32'd1005)
				grumbles4 <= 32'd0;
		end
		endcase
		
		case(S5)
		start:
		begin
			x_block5 = 11'd365;
			y_block5 = 11'd380;
		end
		start_anim:
		begin
			x_block5 = 11'd365;
			y_block5 = 11'd380;
		end
		block1_move_45:
		begin
			y_block5 = y_block5 - 11'd1;
			x_block5 = x_block5 + 11'd1;
		end
		block1_move_135:
		begin
			y_block5 = y_block5 - 11'd1;
			x_block5 = x_block5 - 11'd1;
			if (grumbles5 >= 32'd1005)
				grumbles5 <= 32'd0;
		end
		block1_move_315:
		begin
			y_block5 = y_block5 + 11'd1;
			x_block5 = x_block5 + 11'd1;
		end
		block1_move_225:
		begin
			y_block5 = y_block5 + 11'd1;
			x_block5 = x_block5 - 11'd1;
		if (grumbles5>= 32'd1005)
				grumbles5 <= 32'd0;
		end
		block1_been_shot:
		begin
			x_block5 = 11'd700;
			y_block5 = 11'd200;
			if (update == 1'b1)
				grumbles5 <= grumbles5 + 11'd1;
			else
				grumbles5 <= grumbles5;
		end
		stinkyboi:
		begin
			x_block5 = 11'd599;
			if (update == 1'b1)
				grumbles5 <= grumbles5 + 11'd1;
			else
				grumbles5 <= grumbles5;
		end
		endcase
		case(S6)
		start:
		begin
			x_block6 = 11'd420;
			y_block6 = 11'd230;
		end
		start_anim:
		begin
			x_block6 = 11'd420;
			y_block6 = 11'd230;
		end
		block1_move_45:
		begin
			y_block6 = y_block6 - 11'd1;
			x_block6 = x_block6 + 11'd1;
		end
		block1_move_135:
		begin
			y_block6 = y_block6 - 11'd1;
			x_block6 = x_block6 - 11'd1;
		if (grumbles6>= 32'd1005)
				grumbles6 <= 32'd0;
		end
		block1_move_315:
		begin
			y_block6 = y_block6 + 11'd1;
			x_block6 = x_block6 + 11'd1;
		end
		block1_move_225:
		begin
			y_block6 = y_block6 + 11'd1;
			x_block6 = x_block6 - 11'd1;
			if (grumbles6 >= 32'd1005)
				grumbles6 <= 32'd0;
		end
		block1_been_shot:
		begin
			x_block6 = 11'd700;
			y_block6 = 11'd250;
			if (update == 1'b1)
				grumbles6 <= grumbles6 + 11'd1;
			else
				grumbles6 <= grumbles6;
		end
		stinkyboi:
		begin
			x_block6 = 11'd599;
			if (update == 1'b1)
				grumbles6 <= grumbles6 + 11'd1;
			else
				grumbles6 <= grumbles6;
				if (grumbles6 >= 32'd1005)
				grumbles6 <= 32'd0;
		end
		endcase		
		case(S7)
		start:
		begin
			x_block7 = 11'd474;
			y_block7 = 11'd100;
		end
		start_anim:
		begin
			x_block7 = 11'd474;
			y_block7 = 11'd100;
		end
		block1_move_45:
		begin
			y_block7 = y_block7 - 11'd1;
			x_block7 = x_block7 + 11'd1;
		end
		block1_move_135:
		begin
			y_block7 = y_block7 - 11'd1;
			x_block7 = x_block7 - 11'd1;
			if (grumbles7 >= 32'd1005)
				grumbles7 <= 32'd0;
		end
		block1_move_315:
		begin
			y_block7 = y_block7 + 11'd1;
			x_block7 = x_block7 + 11'd1;
		end
		block1_move_225:
		begin
			y_block7 = y_block7 + 11'd1;
			x_block7 = x_block7 - 11'd1;
		if (grumbles7>= 32'd1005)
				grumbles7 <= 32'd0;
		end
		block1_been_shot:
		begin
			x_block7 = 11'd700;
			y_block7 = 11'd300;
			if (update == 1'b1)
				grumbles7 <= grumbles7 + 11'd1;
			else
				grumbles7 <= grumbles7;
		end
		stinkyboi:
		begin
			x_block7 = 11'd599;
			if (update == 1'b1)
				grumbles7 <= grumbles7 + 11'd1;
			else
				grumbles7 <= grumbles7;
				if (grumbles7 >= 32'd1005)
				grumbles7 <= 32'd0;
		end
		endcase
		case(S8)
		start:
		begin
			x_block8 = 11'd590;
			y_block8 = 11'd420;
		end
		start_anim:
		begin
			x_block8 = 11'd590;
			y_block8 = 11'd420;
		end
		block1_move_45:
		begin
			y_block8 = y_block8 - 11'd1;
			x_block8 = x_block8 + 11'd1;
		end
		block1_move_135:
		begin
			y_block8 = y_block8 - 11'd1;
			x_block8 = x_block8 - 11'd1;		
		if (grumbles8>= 32'd1005)
				grumbles8 <= 32'd0;
		end
		block1_move_315:
		begin
			y_block8 = y_block8 + 11'd1;
			x_block8 = x_block8 + 11'd1;
		end
		block1_move_225:
		begin
			y_block8 = y_block8 + 11'd1;
			x_block8 = x_block8 - 11'd1;
			if (grumbles8 >= 32'd1005)
				grumbles8 <= 32'd0;
		end
		block1_been_shot:
		begin
			x_block8 = 11'd700;
			y_block8 = 11'd350;
			if (update == 1'b1)
				grumbles8 <= grumbles8 + 11'd1;
			else
				grumbles8 <= grumbles8;
		end
		stinkyboi:
		begin
			x_block8 = 11'd599;
			if (update == 1'b1)
				grumbles8 <= grumbles8 + 11'd1;
			else
				grumbles8 <= grumbles8;
				if (grumbles8 >= 32'd1005)
				grumbles8 <= 32'd0;
		end
		endcase
		case(S9)
		start:
		begin
			x_block9 = 11'd260;
			y_block9 = 11'd360;
		end
		start_anim:
		begin
			x_block9 = 11'd260;
			y_block9 = 11'd360;
		end
		block1_move_45:
		begin
			y_block9 = y_block9 - 11'd1;
			x_block9 = x_block9 + 11'd1;
		end
		block1_move_135:
		begin
			y_block9 = y_block9 - 11'd1;
			x_block9 = x_block9 - 11'd1;
			if (grumbles9 >= 32'd1005)
				grumbles9 <= 32'd0;
		end
		block1_move_315:
		begin
			y_block9 = y_block9 + 11'd1;
			x_block9 = x_block9 + 11'd1;
		end
		block1_move_225:
		begin
			y_block9 = y_block9 + 11'd1;
			x_block9 = x_block9 - 11'd1;
		if (grumbles9>= 32'd1005)
				grumbles9 <= 32'd0;
		end
		block1_been_shot:
		begin
			x_block9 = 11'd700;
			y_block9 = 11'd400;
			if (update == 1'b1)
				grumbles9 <= grumbles9 + 11'd1;
			else
				grumbles9 <= grumbles9;
		end
		stinkyboi:
		begin
			x_block9 = 11'd599;
			if (update == 1'b1)
				grumbles9 <= grumbles9 + 11'd1;
			else
				grumbles9 <= grumbles9;
				if (grumbles9 >= 32'd1005)
				grumbles9 <= 32'd0;
		end
		endcase
	end	
end

always @(posedge updatePad or negedge rst)
begin
	if (rst == 1'd0) //FSM for the bee moving up left down and right some of this was from Lucy and Michaela, i changed it up a bit tho.
	begin	
		x_pad <= 11'd70; 
		y_pad <= 11'd220;
	end
	else
	begin
		case(direction) //push buttons 
			3'b100:
			begin
				if (x_wout == 11'd177 && y_wout == 11'd245 && x_pad < 11'd640)
				begin
					x_pad <= x_pad + 11'd1; 
				end
				else if (x_pad >= 11'd640)
				begin
						x_pad = 11'd700;
						y_pad = 11'd495;
						end
				else
				begin
					x_pad <= x_pad;
				end
			end
			3'b000: 
			begin
				if(hit_bee_b2r == 1'd1 || hit_bee_b1r == 1'd1 || hit_bee_b3r == 1'd1 || hit_bee_b4r == 1'd1 || hit_bee_b5r == 1'd1 || hit_bee_b6r == 1'd1 || hit_bee_b7r == 1'd1 || hit_bee_b8r == 1'd1 || hit_bee_b9r == 1'd1)
					x_pad <= x_pad;
				else if(hit_bee_hr == 1'd1)
					x_pad <= 11'd121;
				else if(hit_bee_ler == 1'd1)
					x_pad <= 11'd61;
				else if(x_pad > 11'd25) // prevents teleportation
					x_pad <= x_pad - 11'd2; //Mvmt spd. to the left. Higher val = higher movement, although I wouldn't advise it, the ship is already pretty quick.
				else
					x_pad <= 11'd25;
			end
			3'b001: 
			begin
				if(x_pad < 11'd590) // Warp drives don't exist yet. This is so the ship doesn't instantly jump across the map
					x_pad <= x_pad + 11'd2; //Mvmt spd. to the right. Higher val = higher movement, although I wouldn't advise it.
				else if(hit_bee_b2l == 1'd1 || hit_bee_b1l == 1'd1 || hit_bee_b3l == 1'd1 || hit_bee_b4l == 1'd1 || hit_bee_b5l == 1'd1 || hit_bee_b6l == 1'd1 || hit_bee_b7l == 1'd1 || hit_bee_b8l == 1'd1 || hit_bee_b9l == 1'd1)
					x_pad <= x_pad;
				else
					x_pad <= 11'd590;
			end
			3'b010: 
			begin
				if(y_pad > 11'd25) // You're not Han Solo. You can't make the Kessel Run in 12 parsecs. This is so the ship doesn't instantly jump across the map
					y_pad <= y_pad - 11'd2; //Mvmt spd. up. Higher val = higher movement, although I wouldn't advise it.
				else if(hit_bee_b2b == 1'd1 || hit_bee_b1b == 1'd1 || hit_bee_b3b == 1'd1 || hit_bee_b4b == 1'd1 || hit_bee_b5b == 1'd1 || hit_bee_b6b == 1'd1 || hit_bee_b7b == 1'd1 || hit_bee_b8b == 1'd1 || hit_bee_b9b == 1'd1)
					y_pad <= y_pad;
				else
					y_pad <= 11'd25;
			end
			3'b011: 
			begin
				if(hit_bee_b2t == 1'd1 || hit_bee_b1t == 1'd1 || hit_bee_b3t == 1'd1 || hit_bee_b4t == 1'd1 || hit_bee_b5t == 1'd1 || hit_bee_b6t == 1'd1 || hit_bee_b7t == 1'd1 || hit_bee_b8t == 1'd1 || hit_bee_b9t == 1'd1)
					y_pad <= y_pad;
				else if(hit_bee_ht == 1'd1)
					y_pad <= 11'd370;
				else if(hit_bee_let == 1'd1)
					y_pad <= 11'd330;
				else if(y_pad < 11'd435) // I am speed. No you aren't. This is so the ship doesn't instantly jump across the map
					y_pad <= y_pad + 11'd2; //Mvmt spd. downwards. Higher val = higher movement, although I wouldn't advise it.
				else
					y_pad <= 11'd435;
			end
			default: 
				begin
				x_pad <= x_pad;
				y_pad <= y_pad;
				end
		endcase
	end
end

	always @(posedge VGA_clk) //border and color some of this was from Lucy and Michaela, i changed it up a bit tho. 
begin 
	/*border <= (((xCounter >= 0) && (xCounter < 11) || (xCounter >= 630) && (xCounter < 641)) 
				|| ((yCounter >= 0) && (yCounter < 11) || (yCounter >= 470) && (yCounter < 481))); */
	VGA_R = {8{R}};
	VGA_G = {8{G}};
	VGA_B = {8{B}};
end 

assign R = 1'b1 && screen_border && ~block1 && ~block2 && ~block3 && ~block4 && ~block5 && ~block6 && ~block7 && ~block8 && ~block9 && ~tank && ~stripe && ~stripe2 && ~sting && ~wing && ~wing2 && ~tealwin && ~beebar && ~beebar2 
				&& ~onbase && ~gout &&~gin && ~onswitch && ~gin2 && ~ain2 && ~ain && ~aout && ~min2 && ~min && ~mout && ~e2in2 && ~e2in1 && ~e2out && ~ein2 && ~ein && ~eout && ~nin2 && ~nin && ~nout && ~oin && ~oout
				&& ~leaves && ~hive1 && ~hive2 && ~hive3 && ~deaded && ~vin2 && ~vin && ~vout && ~rin3 && ~rin2 && ~rin && ~rout && ~outmostr && ~farright && ~bot1b && ~bot2b && ~top2b && ~iout && ~iin && ~iin2 && ~wout && ~win && ~win2
				&& ~health1 && ~outb && ~leftb && ~middleb && ~rightb && ~outrb && ~topb && ~midb && ~botb&& ~health2 && ~health3 && ~health4 && ~health5 && ~health6 && ~health7 && ~health8 && ~health9 && ~health10;
assign B = 1'b1 && screen_border && ~head && ~paddle && ~block1 && ~block2 && ~block3 && ~block4 && ~block5 && ~block6 && ~block7 && ~block8 && ~block9&& ~tank && ~missile && ~stripe && ~stripe2 && ~sting
				&& ~onswitch && ~gin && ~gin2 && ~ain2 && ~ain && ~min2 && ~min && ~e2in2 && ~e2in1 && ~ein2 && ~ein && ~vin2 && ~vin && ~nin && ~nin2 && ~oin && ~hive&& ~iin && ~iin2 && ~win && ~win2 && ~return1 && ~return2 && ~return3
				/*&& ~leaves*/ && ~hive1 && ~hive2 && ~hive3 && ~rin3 && ~rin2 && ~rin && ~topb && ~midb && ~botb  && ~outmostr && ~farright && ~bot1b && ~bot2b && ~top2b && ~beecominhome && ~beebar && ~beebar2
				&& ~health1 && ~outb && ~leftb && ~middleb && ~rightb && ~outrb && ~health2 && ~health3 && ~health4 && ~health5 && ~health6 && ~health7 && ~health8 && ~health9 && ~health10;
assign G = 1'b1 && screen_border && ~tank && ~missile && ~stripe && ~stripe2 && ~sting && ~redstart && ~vin2 && ~vin && ~vout && ~beebar && ~beebar2
				&& ~onbase && ~onswitch && ~gin && ~gin2 && ~ain2 && ~ain && ~aout && ~gout && ~min2 && ~min && ~mout && ~ein2 && ~ein && ~bot1b && ~bot2b && ~top2b
				&& ~rin3 && ~rin2 && ~rin && ~rout && ~topb && ~midb && ~botb && ~outb && ~leftb && ~middleb && ~rightb && ~outrb && ~outmostr && ~farright && ~wout && ~iout  
				&& ~eout && ~e2in2 && ~e2in1 && ~e2out && ~nin2 && ~nin && ~nout && ~oin && ~oout && ~hive1 && ~hive2 && ~hive3 && ~iin && ~iin2 && ~win && ~win2;

	
endmodule
