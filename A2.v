module A2(clk, rst, key0, key1, key2, key3, SG, fire, DAC_clk, VGA_R, VGA_G, VGA_B, VGA_Hsync,
					VGA_Vsync, blank_n, KB_clk, PS2data, o1, o2, o3, o4, o5, o6, o7, o12, o22, o32, o42, o52, o62, o72, o13, o23, o33, o43, o53, o63, o73, o14, o24, o34, o44, o54, o64, o74);
					
input clk, rst, fire;
input KB_clk;//keyboard declarations
input wire PS2data; 
input key0, key1, key2, key3; //To be removed once keyboard works
input SG; //manual start switch. Inspired by Beefender, but not copied.


output o1, o2, o3, o4, o5, o6, o7, o12, o22, o32, o42, o52, o62, o72, o13, o23, o33, o43, o53, o63, o73, o14, o24, o34, o44, o54, o64, o74;
sevenSeg scoreboard (score[0], score[1], score[2], score[3], score[4], score[5], score[6], score[7], score[8], score[9], score[10], score[11], score[12], score[13], score[14], score[15], o1, o2, o3, o4, o5, o6, o7, o12, o22, o32, o42, o52, o62, o72, o13, o23, o33, o43, o53, o63, o73, o14, o24, o34, o44, o54, o64, o74);

reg [4:0]direction;

output reg [7:0]VGA_R; //VGA stuff
output reg [7:0]VGA_G;
output reg [7:0]VGA_B;
output VGA_Hsync;
output VGA_Vsync;								
output DAC_clk;
output blank_n;
wire [10:0]xCnt;
wire [10:0]yCnt;
wire R;
wire G; 
wire B; 
wire update; 
wire UPD;
wire VGA_clk;
wire displayArea;

wire shipBody, wing, wing2, cockpit, body, laser; //Ship stuff, misc. below
wire leaves, deaded, wout; 
wire e2in1, BGoE2, e2in2, startScreen, onswitch, BGofOnSw, gin, BGofG, gin2, BGoA, ain, ain2, BGoM, min, min2, BGoE, vin, vin2, BGoV, ein, ein2, BGoO, oin, BGoN, nin, nin2, BGoR, rin, rin2, rin3;
wire health1, health2, health3, health4, health5, health6, health7, health8, health9, health10;
wire topb, midb, botb, outb, leftb, middleb, rightb, outrb, RightSideOfOnSw, LeftSideOfOnSw, bot1b, bot2b, top2b, iout, iin, iin2, return1, return2, return3;
wire rock1, rock2, rock3, rock4, rock5, rock6, rock7, rock8, rock9, rock10, rock11, rock12, rock13, goodbye, hit_me;

wire screen_border;

reg border;
reg game_over;

reg [15:0]score = 12'd0; //scores are recorded. 1 point per rock shot.
reg [10:0] etc, etc2, etc3, etc4, etc5, etc6, etc7, etc8, etc9, etc10, etc11, etc12, etc13, etc14;
reg [10:0]life; //health
reg [10:0]xPos, yPos; //top left of the ship
reg [10:0]x_wing,y_wing; //top wing of the ship
reg [10:0]x_cockpit,y_cockpit; //"head" of the ship, where the pilot sits
reg [10:0]x_body,y_body; //body of the ship
reg [10:0]x_wing2,y_wing2; //lower wing
reg [10:0]x_startScreen,y_startScreen; // red start screen & game over screen

reg [10:0]x_onswitch,y_onswitch; //animated on switch when starting game
reg [10:0]x_BGofOnSw,y_BGofOnSw; //Backgroung of on switch
reg [10:0]x_gin, y_gin;
reg [10:0]x_gin2, y_gin2;
reg [10:0]x_BGofG,y_BGofG; //background of the G
reg [10:0]x_ain, y_ain;
reg [10:0]x_ain2, y_ain2;
reg [10:0]x_BGoA,y_BGoA;
reg [10:0]x_min, y_min;
reg [10:0]x_min2, y_min2;
reg [10:0]x_BGoM,y_BGoM;
reg [10:0]x_ein, y_ein;
reg [10:0]x_ein2, y_ein2;
reg [10:0]x_BGoE,y_BGoE;
reg [10:0]x_e2in1, y_e2in1;
reg [10:0]x_e2in2, y_e2in2;
reg [10:0]x_BGoE2,y_BGoE2;
reg [10:0]x_oin, y_oin;
reg [10:0]x_BGoO,y_BGoO;
reg [10:0]x_vin, y_vin;
reg [10:0]x_vin2, y_vin2;
reg [10:0]x_BGoV,y_BGoV;
reg [10:0]x_nin, y_nin;
reg [10:0]x_nin2, y_nin2;
reg [10:0]x_BGoN,y_BGoN;
reg [10:0]x_rin, y_rin;
reg [10:0]x_rin2, y_rin2;
reg [10:0]x_BGoR,y_BGoR;
reg [10:0]x_rin3, y_rin3;
reg [10:0]x_deaded,y_deaded;
reg [10:0]x_ZZZ,y_ZZZ;
reg [10:0]x_topb,y_topb;
reg [10:0]x_midb,y_midb;
reg [10:0]x_botb,y_botb;
reg [10:0]x_outb,y_outb;
reg [10:0]x_leftb,y_leftb;
reg [10:0]x_middleb,y_middleb;
reg [10:0]x_rightb,y_rightb;
reg [10:0]x_outrb,y_outrb;
reg [10:0]x_RightSideOfOnSw,y_RightSideOfOnSw;
reg [10:0]x_LeftSideOfOnSw,y_LeftSideOfOnSw;
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
reg [10:0]xShot,yShot; //the top right of the laser
reg [10:0]x_iin2,y_iin2;
reg [10:0]x_iout, y_iout;
reg [10:0]x_iin, y_iin;
reg [10:0]x_wout,y_wout;
reg [10:0]x_goodbye,y_goodbye;
reg [10:0]x_return1,y_return1;
reg [10:0]x_return2,y_return2;
reg [10:0]x_return3,y_return3;

reg [10:0] xPosRock1,xPosRock2,xPosRock3,xPosRock4,xPosRock5,xPosRock6,xPosRock7,xPosRock8,xPosRock9, xPosRock10, xPosRock11, xPosRock12, xPosRock13, xPosRock14; //top right corner of rock
reg [10:0] yPosRock1,yPosRock2,yPosRock3,yPosRock4,yPosRock5,yPosRock6,yPosRock7,yPosRock8,yPosRock9, yPosRock10, yPosRock11, yPosRock12, yPosRock13, yPosRock14;


reg [10:0] x_screen_border, y_screen_border;


//Modules N' Stuff
keybored kb(PS2clk, key0, key1, key2, key3, direction);
updateCLK clk_updateCLK(clk, update); // laser clock
updateCLK2 clk_updateshipBodyCLK(clk, UPD); // asteroid speed clock. Higher vals = faster asteroids
VGAclk reduce(clk, VGA_clk);
VGA_generator generator(VGA_clk, VGA_Hsync, VGA_Vsync, DisplayArea, xCnt, yCnt, blank_n);

assign DAC_clk = VGA_clk;
	
assign shipBody = (xCnt >= xPos && xCnt <= xPos + 8'd20 && yCnt >= yPos && yCnt <= yPos + 8'd20); // sets the size of the ship's body
assign laser = (xCnt >= xShot && xCnt <= xShot + 8'd20 && yCnt >= yShot && yCnt <= yShot + 8'd6); // sets the size of the laser
assign wing = (xCnt >= x_wing && xCnt <= x_wing + 8'd14 && yCnt >= y_wing && yCnt <= y_wing + 8'd6); // sets the size of the top wing
assign wing2 = (xCnt >= x_wing2 && xCnt <= x_wing2 + 8'd14 && yCnt >= y_wing2 && yCnt <= y_wing2 + 8'd6); // sets the size of the bottom wing
assign body = (xCnt >= x_body && xCnt <= x_body + 8'd20 && yCnt >= y_body && yCnt <= y_body + 8'd6); // sets the size of the body
assign cockpit = (xCnt >= x_cockpit && xCnt <= x_cockpit + 8'd10 && yCnt >= y_cockpit && yCnt <= y_cockpit + 8'd10); // sets the size of the cockpit
assign screen_border = (xCnt >= x_screen_border && xCnt <= x_screen_border + 11'd600 && yCnt >= y_screen_border && yCnt <= y_screen_border + 11'd440);
assign startScreen = (xCnt >= x_startScreen && xCnt <= x_startScreen + 11'd640 && yCnt >= y_startScreen && yCnt <= y_startScreen + 11'd460); //big red screen
assign onswitch = (xCnt >= x_onswitch && xCnt <= x_onswitch + 11'd12 && yCnt >= y_onswitch && yCnt <= y_onswitch + 11'd12); //Everything from here down handles the letters of Game On & Game Over
assign BGofOnSw = (xCnt >= x_BGofOnSw && xCnt <= x_BGofOnSw + 11'd14 && yCnt >= y_BGofOnSw && yCnt <= y_BGofOnSw + 11'd28);
assign BGofG = (xCnt >= x_BGofG && xCnt <= x_BGofG + 11'd14 && yCnt >= y_BGofG && yCnt <= y_BGofG + 11'd28);
assign gin = (xCnt >= x_gin && xCnt <= x_gin + 11'd11 && yCnt >= y_gin && yCnt <= y_gin + 11'd10);
assign gin2 = (xCnt >= x_gin2 && xCnt <= x_gin2 + 11'd8 && yCnt >= y_gin2 && yCnt <= y_gin2 + 11'd20);
assign BGoA = (xCnt >= x_BGoA && xCnt <= x_BGoA + 11'd14 && yCnt >= y_BGoA && yCnt <= y_BGoA + 11'd28);
assign ain = (xCnt >= x_ain && xCnt <= x_ain + 11'd10 && yCnt >= y_ain && yCnt <= y_ain + 11'd10);
assign ain2 = (xCnt >= x_ain2 && xCnt <= x_ain2 + 11'd10 && yCnt >= y_ain2 && yCnt <= y_ain2 + 11'd12);
assign BGoM = (xCnt >= x_BGoM && xCnt <= x_BGoM + 11'd14 && yCnt >= y_BGoM && yCnt <= y_BGoM + 11'd28);
assign min = (xCnt >= x_min && xCnt <= x_min + 11'd3 && yCnt >= y_min && yCnt <= y_min + 11'd26);
assign min2 = (xCnt >= x_min2 && xCnt <= x_min2 + 11'd3 && yCnt >= y_min2 && yCnt <= y_min2 + 11'd26);
assign BGoE = (xCnt >= x_BGoE && xCnt <= x_BGoE + 11'd14 && yCnt >= y_BGoE && yCnt <= y_BGoE + 11'd28);
assign ein = (xCnt >= x_ein && xCnt <= x_ein + 11'd12 && yCnt >= y_ein && yCnt <= y_ein + 11'd10);
assign ein2 = (xCnt >= x_ein2 && xCnt <= x_ein2 + 11'd12 && yCnt >= y_ein2 && yCnt <= y_ein2 + 11'd10);
assign BGoO = (xCnt >= x_BGoO && xCnt <= x_BGoO + 11'd14 && yCnt >= y_BGoO && yCnt <= y_BGoO + 11'd28);
assign oin = (xCnt >= x_oin && xCnt <= x_oin + 11'd10 && yCnt >= y_oin && yCnt <= y_oin + 11'd24);
assign BGoN = (xCnt >= x_BGoN && xCnt <= x_BGoN + 11'd14 && yCnt >= y_BGoN && yCnt <= y_BGoN + 11'd28);
assign nin = (xCnt >= x_nin && xCnt <= x_nin + 11'd3 && yCnt >= y_nin && yCnt <= y_nin + 11'd26);
assign nin2 = (xCnt >= x_nin2 && xCnt <= x_nin2 + 11'd3 && yCnt >= y_nin2 && yCnt <= y_nin2 + 11'd26);
assign leaves = (xCnt >= x_leaves && xCnt <= x_leaves + 11'd60 && yCnt >= y_leaves && yCnt <= y_leaves + 11'd90);
assign deaded = (xCnt >= x_deaded && xCnt <= x_deaded + 11'd20 && yCnt >= y_deaded && yCnt <= y_deaded + 11'd20);
assign health1 = (xCnt >= x_health1 && xCnt <= x_health1 + 11'd60 && yCnt >= y_health1 && yCnt <= y_health1 + 11'd9); //health bar on screen
assign health2 = (xCnt >= x_health2 && xCnt <= x_health2 + 11'd60 && yCnt >= y_health2 && yCnt <= y_health2 + 11'd9);
assign health3 = (xCnt >= x_health3 && xCnt <= x_health3 + 11'd60 && yCnt >= y_health3 && yCnt <= y_health3 + 11'd9);
assign health4 = (xCnt >= x_health4 && xCnt <= x_health4 + 11'd60 && yCnt >= y_health4 && yCnt <= y_health4 + 11'd9);
assign health5 = (xCnt >= x_health5 && xCnt <= x_health5 + 11'd60 && yCnt >= y_health5 && yCnt <= y_health5 + 11'd9);
assign health6 = (xCnt >= x_health6 && xCnt <= x_health6 + 11'd60 && yCnt >= y_health6 && yCnt <= y_health6 + 11'd9);
assign health7 = (xCnt >= x_health7 && xCnt <= x_health7 + 11'd60 && yCnt >= y_health7 && yCnt <= y_health7 + 11'd9);
assign health8 = (xCnt >= x_health8 && xCnt <= x_health8 + 11'd60 && yCnt >= y_health8 && yCnt <= y_health8 + 11'd9);
assign health9 = (xCnt >= x_health9 && xCnt <= x_health9 + 11'd60 && yCnt >= y_health9 && yCnt <= y_health9 + 11'd9); 
assign health10 = (xCnt >= x_health10 && xCnt <= x_health10 + 11'd60 && yCnt >= y_health10 && yCnt <= y_health10 + 11'd9); //
assign BGoE2 = (xCnt >= x_BGoE2 && xCnt <= x_BGoE2 + 11'd14 && yCnt >= y_BGoE2 && yCnt <= y_BGoE2 + 11'd28); // more lettering
assign e2in1 = (xCnt >= x_e2in1 && xCnt <= x_e2in1 + 11'd12 && yCnt >= y_e2in1 && yCnt <= y_e2in1 + 11'd10);
assign e2in2 = (xCnt >= x_e2in2 && xCnt <= x_e2in2 + 11'd12 && yCnt >= y_e2in2 && yCnt <= y_e2in2 + 11'd10);
assign BGoV = (xCnt >= x_BGoV && xCnt <= x_BGoV + 11'd14 && yCnt >= y_BGoV && yCnt <= y_BGoV + 11'd28);
assign vin = (xCnt >= x_vin && xCnt <= x_vin + 11'd10 && yCnt >= y_vin && yCnt <= y_vin + 11'd23);
assign vin2 = (xCnt >= x_vin2 && xCnt <= x_vin2 + 11'd6 && yCnt >= y_vin2 && yCnt <= y_vin2 + 11'd23);
assign BGoR = (xCnt >= x_BGoR && xCnt <= x_BGoR + 11'd14 && yCnt >= y_BGoR && yCnt <= y_BGoR + 11'd28);
assign rin = (xCnt >= x_rin && xCnt <= x_rin + 11'd10 && yCnt >= y_rin && yCnt <= y_rin + 11'd10);
assign rin2 = (xCnt >= x_rin2 && xCnt <= x_rin2 + 11'd7 && yCnt >= y_rin2 && yCnt <= y_rin2 + 11'd12);
assign rin3 = (xCnt >= x_rin3 && xCnt <= x_rin3 + 11'd3 && yCnt >= y_rin3 && yCnt <= y_rin3 + 11'd6);
assign topb = (xCnt >= x_topb && xCnt <= x_topb + 11'd74 && yCnt >= y_topb && yCnt <= y_topb + 11'd2);
assign midb = (xCnt >= x_midb && xCnt <= x_midb + 11'd74 && yCnt >= y_midb && yCnt <= y_midb + 11'd3);
assign botb = (xCnt >= x_botb && xCnt <= x_botb + 11'd38 && yCnt >= y_botb && yCnt <= y_botb + 11'd2);
assign outb = (xCnt >= x_outb && xCnt <= x_outb + 11'd2 && yCnt >= y_outb && yCnt <= y_outb + 11'd28);
assign leftb = (xCnt >= x_leftb && xCnt <= x_leftb + 11'd2 && yCnt >= y_leftb && yCnt <= y_leftb + 11'd28);
assign middleb = (xCnt >= x_middleb && xCnt <= x_middleb + 11'd2 && yCnt >= y_middleb && yCnt <= y_middleb + 11'd61);
assign rightb = (xCnt >= x_rightb && xCnt <= x_rightb + 11'd2 && yCnt >= y_rightb && yCnt <= y_rightb + 11'd61);
assign outrb = (xCnt >= x_outrb && xCnt <= x_outrb + 11'd2 && yCnt >= y_outrb && yCnt <= y_outrb + 11'd61);
assign RightSideOfOnSw = (xCnt >= x_RightSideOfOnSw && xCnt <= x_RightSideOfOnSw + 11'd2 && yCnt >= y_RightSideOfOnSw && yCnt <= y_RightSideOfOnSw + 11'd28);
assign LeftSideOfOnSw = (xCnt >= x_LeftSideOfOnSw && xCnt <= x_LeftSideOfOnSw + 11'd2 && yCnt >= y_LeftSideOfOnSw && yCnt <= y_LeftSideOfOnSw + 11'd28);
assign bot2b = (xCnt >= x_bot2b && xCnt <= x_bot2b + 11'd38 && yCnt >= y_bot2b && yCnt <= y_bot2b + 11'd2);
assign top2b = (xCnt >= x_top2b && xCnt <= x_top2b + 11'd38 && yCnt >= y_top2b && yCnt <= y_top2b + 11'd2);
assign bot1b = (xCnt >= x_bot1b && xCnt <= x_bot1b + 11'd20 && yCnt >= y_bot1b && yCnt <= y_bot1b + 11'd2);
assign iout = (xCnt >= x_iout && xCnt <= x_iout + 11'd14 && yCnt >= y_iout && yCnt <= y_iout + 11'd28);
assign iin = (xCnt >= x_iin && xCnt <= x_iin + 11'd5 && yCnt >= y_iin && yCnt <= y_iin + 11'd24);
assign iin2 = (xCnt >= x_iin2 && xCnt <= x_iin2 + 11'd5 && yCnt >= y_iin2 && yCnt <= y_iin2 + 11'd24);
assign wout = (xCnt >= x_wout && xCnt <= x_wout + 11'd14 && yCnt >= y_wout && yCnt <= y_wout + 11'd28);
assign goodbye = (xCnt >= x_goodbye && xCnt <= x_goodbye + 11'd4 && yCnt >= y_goodbye && yCnt <= y_goodbye + 11'd4); //asteroid is destroyed
assign return1 = (xCnt >= x_return1 && xCnt <= x_return1 + 11'd10 && yCnt >= y_return1 && yCnt <= y_return1 + 11'd10);
assign return2 = (xCnt >= x_return2 && xCnt <= x_return2 + 11'd10 && yCnt >= y_return2 && yCnt <= y_return2 + 11'd10);
assign return3 = (xCnt >= x_return3 && xCnt <= x_return3 + 11'd10 && yCnt >= y_return3 && yCnt <= y_return3 + 11'd10);

//the asteroids.
assign rock1 = (xCnt >= xPosRock1 && xCnt <= xPosRock1 + 8'd20 && yCnt >= yPosRock1 && yCnt <= yPosRock1 + 8'd20);
assign rock2 = (xCnt >= xPosRock2 && xCnt <= xPosRock2 + 8'd20 && yCnt >= yPosRock2 && yCnt <= yPosRock2 + 8'd20);
assign rock3 = (xCnt >= xPosRock3 && xCnt <= xPosRock3 + 8'd20 && yCnt >= yPosRock3 && yCnt <= yPosRock3 + 8'd20);
assign rock4 = (xCnt >= xPosRock4 && xCnt <= xPosRock4 + 8'd20 && yCnt >= yPosRock4 && yCnt <= yPosRock4 + 8'd20);
assign rock5 = (xCnt >= xPosRock5 && xCnt <= xPosRock5 + 8'd20 && yCnt >= yPosRock5 && yCnt <= yPosRock5 + 8'd20);
assign rock6 = (xCnt >= xPosRock6 && xCnt <= xPosRock6 + 8'd20 && yCnt >= yPosRock6 && yCnt <= yPosRock6 + 8'd20);
assign rock7 = (xCnt >= xPosRock7 && xCnt <= xPosRock7 + 8'd20 && yCnt >= yPosRock7 && yCnt <= yPosRock7 + 8'd20);
assign rock8 = (xCnt >= xPosRock8 && xCnt <= xPosRock8 + 8'd20 && yCnt >= yPosRock8 && yCnt <= yPosRock8 + 8'd20);
assign rock9 = (xCnt >= xPosRock9 && xCnt <= xPosRock9 + 8'd20 && yCnt >= yPosRock9 && yCnt <= yPosRock9 + 8'd20);
assign rock10 = (xCnt >= xPosRock10 && xCnt <= xPosRock10 + 8'd20 && yCnt >= yPosRock10 && yCnt <= yPosRock10 + 8'd20);
assign rock11 = (xCnt >= xPosRock11 && xCnt <= xPosRock11 + 8'd20 && yCnt >= yPosRock11 && yCnt <= yPosRock11 + 8'd20);
assign rock12 = (xCnt >= xPosRock12 && xCnt <= xPosRock12 + 8'd20 && yCnt >= yPosRock12 && yCnt <= yPosRock12 + 8'd20);
assign rock13 = (xCnt >= xPosRock13 && xCnt <= xPosRock13 + 8'd20 && yCnt >= yPosRock13 && yCnt <= yPosRock13 + 8'd20);


//FSM.
reg [10:0] S;
reg [10:0] NS;
reg [10:0] S1; //these are for moving rocks
reg [10:0] NS1;
reg [10:0] S2;
reg [10:0] NS2;
reg [10:0] S3;
reg [10:0] NS3;
reg [10:0] S4;
reg [10:0] NS4;
reg [10:0] S5;
reg [10:0] NS5;
reg [10:0] S6;
reg [10:0] NS6;
reg [10:0] S7;
reg [10:0] NS7;
reg [10:0] S8;
reg [10:0] NS8;
reg [10:0] S9;
reg [10:0] NS9;
reg [10:0] S10;
reg [10:0] NS10;
reg [10:0] S11;
reg [10:0] NS11;
reg [10:0] S12;
reg [10:0] NS12;
reg [10:0] S13;
reg [10:0] NS13;
parameter PREGAME = 11'd0, start = 11'd1, laserRight = 11'd2, collision = 11'd3, laser_reload = 11'd4, end_game = 11'd5, laser_move_45 = 11'd6, laser_move_135 = 11'd7, laser_move_225 = 11'd8, laser_move_315 = 11'd9, laser_reload1 = 11'd14; 
parameter IDKWhatTocallThis = 11'd1000, rock1_move_225 = 11'd2, rock1_move_315 = 11'd3, rock1_move_45 = 11'd4, rock1_move_135 = 11'd5, rock1_shot = 11'd6, SA = 11'd50;


/* This code handles impacts for the asteroids and the ship. Be warned, there's a lot of code here.
 Collisions are detected by tracking the location of every item on the screen, and it triggers when the coords overlap or equal each other */
// Check if the shot hits an asteroid
wire hit_rock1;
wire hit_rock2;
wire hit_rock3;
wire hit_rock4;
wire hit_rock5;
wire hit_rock6;
wire hit_rock7;
wire hit_rock8;
wire hit_rock9;
wire hit_rock10;
wire hit_rock11;
wire hit_rock12;
wire hit_rock13;

assign hit_rock1 = ((yShot + 8'd6 >= yPosRock1) && (yShot < yPosRock1 +8'd20) && (xShot + 8'd20 > xPosRock1) && (xShot < xPosRock1 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_rock2 = ((yShot + 8'd6 >= yPosRock2) && (yShot < yPosRock2 +8'd20) && (xShot + 8'd20 > xPosRock2) && (xShot < xPosRock2 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_rock3 = ((yShot + 8'd6 >= yPosRock3) && (yShot < yPosRock3 +8'd20) && (xShot + 8'd20 > xPosRock3) && (xShot < xPosRock3 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_rock4 = ((yShot + 8'd6 >= yPosRock4) && (yShot < yPosRock4 +8'd20) && (xShot + 8'd20 > xPosRock4) && (xShot < xPosRock4 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_rock5 = ((yShot + 8'd6 >= yPosRock5) && (yShot < yPosRock5 +8'd20) && (xShot + 8'd20 > xPosRock5) && (xShot < xPosRock5 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_rock6 = ((yShot + 8'd6 >= yPosRock6) && (yShot < yPosRock6 +8'd20) && (xShot + 8'd20 > xPosRock6) && (xShot < xPosRock6 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_rock7 = ((yShot + 8'd6 >= yPosRock7) && (yShot < yPosRock7 +8'd20) && (xShot + 8'd20 > xPosRock7) && (xShot < xPosRock7 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_rock8 = ((yShot + 8'd6 >= yPosRock8) && (yShot < yPosRock8 +8'd20) && (xShot + 8'd20 > xPosRock8) && (xShot < xPosRock8 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_rock9 = ((yShot + 8'd6 >= yPosRock9) && (yShot < yPosRock9 +8'd20) && (xShot + 8'd20 > xPosRock9) && (xShot < xPosRock9 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_rock10 = ((yShot + 8'd6 >= yPosRock10) && (yShot < yPosRock10 +8'd20) && (xShot + 8'd20 > xPosRock10) && (xShot < xPosRock10 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_rock11 = ((yShot + 8'd6 >= yPosRock11) && (yShot < yPosRock11 +8'd20) && (xShot + 8'd20 > xPosRock11) && (xShot < xPosRock11 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_rock12 = ((yShot + 8'd6 >= yPosRock12) && (yShot < yPosRock12 +8'd20) && (xShot + 8'd20 > xPosRock12) && (xShot < xPosRock12 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_rock13 = ((yShot + 8'd6 >= yPosRock13) && (yShot < yPosRock13 +8'd20) && (xShot + 8'd20 > xPosRock13) && (xShot < xPosRock13 + 8'd20)) ? 1'b1 : 1'b0;

//asteroid 1 from above
wire hit_a1_b2t;
wire hit_a1_b3t;
wire hit_a1_b4t;
wire hit_a1_b5t;
wire hit_a1_b6t;
wire hit_a1_b7t;
wire hit_a1_b9t;
wire hit_a1_b8t;
wire hit_a1_b10t;
wire hit_a1_b11t;
wire hit_a1_b12t;
wire hit_a1_b13t;
wire hit_a1_pt;
wire hit_a1_ht;
wire hit_a1_let;

assign hit_a1_b2t = ((yPosRock1 + 8'd20 == yPosRock2) && (xPosRock1 + 8'd20 > xPosRock2) && (xPosRock1 < xPosRock2 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_b3t = ((yPosRock1 + 8'd20 == yPosRock3) && (xPosRock1 + 8'd20 > xPosRock3) && (xPosRock1 < xPosRock3 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_b4t = ((yPosRock1 + 8'd20 == yPosRock4) && (xPosRock1 + 8'd20 > xPosRock4) && (xPosRock1 < xPosRock4 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_b5t = ((yPosRock1 + 8'd20 == yPosRock5) && (xPosRock1 + 8'd20 > xPosRock5) && (xPosRock1 < xPosRock5 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_b6t = ((yPosRock1 + 8'd20 == yPosRock6) && (xPosRock1 + 8'd20 > xPosRock6) && (xPosRock1 < xPosRock6 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_b7t = ((yPosRock1 + 8'd20 == yPosRock7) && (xPosRock1 + 8'd20 > xPosRock7) && (xPosRock1 < xPosRock7 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_b9t = ((yPosRock1 + 8'd20 == yPosRock9) && (xPosRock1 + 8'd20 > xPosRock9) && (xPosRock1 < xPosRock9 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_b8t = ((yPosRock1 + 8'd20 == yPosRock8) && (xPosRock1 + 8'd20 > xPosRock8) && (xPosRock1 < xPosRock8 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_b10t = ((yPosRock1 + 8'd20 == yPosRock10) && (xPosRock1 + 8'd20 > xPosRock10) && (xPosRock1 < xPosRock10 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_b11t = ((yPosRock1 + 8'd20 == yPosRock11) && (xPosRock1 + 8'd20 > xPosRock11) && (xPosRock1 < xPosRock11 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_b12t = ((yPosRock1 + 8'd20 == yPosRock12) && (xPosRock1 + 8'd20 > xPosRock12) && (xPosRock1 < xPosRock12 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_b13t = ((yPosRock1 + 8'd20 == yPosRock13) && (xPosRock1 + 8'd20 > xPosRock13) && (xPosRock1 < xPosRock13 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_pt = ((yPosRock1 + 8'd20 == yPos) && (xPosRock1 + 8'd20 > xPos) && (xPosRock1 < xPos + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_ht = ((yPosRock1 + 8'd20 == y_ZZZ) && (xPosRock1 + 8'd20 > x_ZZZ) && (xPosRock1 < x_ZZZ + 8'd60)) ? 1'b1 : 1'b0;
assign hit_a1_let = ((yPosRock1 + 8'd20 == y_leaves) && (xPosRock1 + 8'd20 > x_leaves) && (xPosRock1 < x_leaves + 8'd60)) ? 1'b1 : 1'b0;

//asteroid 1 from below
wire hit_a1_b2b;
wire hit_a1_b3b;
wire hit_a1_b4b;
wire hit_a1_b5b;
wire hit_a1_b6b;
wire hit_a1_b7b;
wire hit_a1_b9b;
wire hit_a1_b8b;
wire hit_a1_b10b;
wire hit_a1_b11b;
wire hit_a1_b12b;
wire hit_a1_b13b;
wire hit_a1_pb;

assign hit_a1_b2b = ((yPosRock1 == yPosRock2 + 8'd20) && (xPosRock1 + 8'd20 > xPosRock2) && (xPosRock1 < xPosRock2 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_b3b = ((yPosRock1 == yPosRock3 + 8'd20) && (xPosRock1 + 8'd20 > xPosRock3) && (xPosRock1 < xPosRock3 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_b4b = ((yPosRock1 == yPosRock4 + 8'd20) && (xPosRock1 + 8'd20 > xPosRock4) && (xPosRock1 < xPosRock4 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_b5b = ((yPosRock1 == yPosRock5 + 8'd20) && (xPosRock1 + 8'd20 > xPosRock5) && (xPosRock1 < xPosRock5 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_b6b = ((yPosRock1 == yPosRock6 + 8'd20) && (xPosRock1 + 8'd20 > xPosRock6) && (xPosRock1 < xPosRock6 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_b7b = ((yPosRock1 == yPosRock7 + 8'd20) && (xPosRock1 + 8'd20 > xPosRock7) && (xPosRock1 < xPosRock7 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_b9b = ((yPosRock1 == yPosRock9 + 8'd20) && (xPosRock1 + 8'd20 > xPosRock9) && (xPosRock1 < xPosRock9 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_b8b = ((yPosRock1 == yPosRock8 + 8'd20) && (xPosRock1 + 8'd20 > xPosRock8) && (xPosRock1 < xPosRock8 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_b10b = ((yPosRock1 == yPosRock10 + 8'd20) && (xPosRock1 + 8'd20 > xPosRock10) && (xPosRock1 < xPosRock10 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_b11b = ((yPosRock1 == yPosRock11 + 8'd20) && (xPosRock1 + 8'd20 > xPosRock11) && (xPosRock1 < xPosRock11 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_b12b = ((yPosRock1 == yPosRock12 + 8'd20) && (xPosRock1 + 8'd20 > xPosRock12) && (xPosRock1 < xPosRock12 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_b13b = ((yPosRock1 == yPosRock13 + 8'd20) && (xPosRock1 + 8'd20 > xPosRock13) && (xPosRock1 < xPosRock13 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_pb = ((yPosRock1 == yPos + 8'd20) && (xPosRock1 + 8'd20 > xPos) && (xPosRock1 < xPos + 8'd20)) ? 1'b1 : 1'b0;

//asteroid 1 from left
wire hit_a1_b2l;
wire hit_a1_b3l;
wire hit_a1_b4l;
wire hit_a1_b5l;
wire hit_a1_b6l;
wire hit_a1_b7l;
wire hit_a1_b9l;
wire hit_a1_b8l;
wire hit_a1_b10l;
wire hit_a1_b11l;
wire hit_a1_b12l;
wire hit_a1_b13l;
wire hit_a1_pl;

assign hit_a1_b2l = ((xPosRock1 + 8'd20 == xPosRock2) && (yPosRock1 + 8'd20 > yPosRock2) && (yPosRock1 < yPosRock2 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_b3l = ((xPosRock1 + 8'd20 == xPosRock3) && (yPosRock1 + 8'd20 > yPosRock3) && (yPosRock1 < yPosRock3 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_b4l = ((xPosRock1 + 8'd20 == xPosRock4) && (yPosRock1 + 8'd20 > yPosRock4) && (yPosRock1 < yPosRock4 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_b5l = ((xPosRock1 + 8'd20 == xPosRock5) && (yPosRock1 + 8'd20 > yPosRock5) && (yPosRock1 < yPosRock5 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_b6l = ((xPosRock1 + 8'd20 == xPosRock6) && (yPosRock1 + 8'd20 > yPosRock6) && (yPosRock1 < yPosRock6 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_b7l = ((xPosRock1 + 8'd20 == xPosRock7) && (yPosRock1 + 8'd20 > yPosRock7) && (yPosRock1 < yPosRock7 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_b9l = ((xPosRock1 + 8'd20 == xPosRock9) && (yPosRock1 + 8'd20 > yPosRock9) && (yPosRock1 < yPosRock9 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_b8l = ((xPosRock1 + 8'd20 == xPosRock8) && (yPosRock1 + 8'd20 > yPosRock8) && (yPosRock1 < yPosRock8 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_b10l = ((xPosRock1 + 8'd20 == xPosRock10) && (yPosRock1 + 8'd20 > yPosRock10) && (yPosRock1 < yPosRock10 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_b11l = ((xPosRock1 + 8'd20 == xPosRock11) && (yPosRock1 + 8'd20 > yPosRock11) && (yPosRock1 < yPosRock11 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_b12l = ((xPosRock1 + 8'd20 == xPosRock12) && (yPosRock1 + 8'd20 > yPosRock12) && (yPosRock1 < yPosRock12 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_b13l = ((xPosRock1 + 8'd20 == xPosRock13) && (yPosRock1 + 8'd20 > yPosRock13) && (yPosRock1 < yPosRock13 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_pl = ((xPosRock1 + 8'd20 == xPos) && (yPosRock1 + 8'd20 > yPos) && (yPosRock1 < yPos + 8'd20)) ? 1'b1 : 1'b0;

//asteroid 1 from right 
wire hit_a1_b2r;
wire hit_a1_b3r;
wire hit_a1_b4r;
wire hit_a1_b5r;
wire hit_a1_b6r;
wire hit_a1_b7r;
wire hit_a1_b9r;
wire hit_a1_b8r;
wire hit_a1_b10r;
wire hit_a1_b11r;
wire hit_a1_b12r;
wire hit_a1_b13r;
wire hit_a1_pr;
wire hit_a1_hr;
wire hit_a1_ler;

assign hit_a1_b2r = ((xPosRock1 == xPosRock2 + 8'd20) && (yPosRock1 + 8'd20 > yPosRock2) && (yPosRock1 < yPosRock2 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_b3r = ((xPosRock1 == xPosRock3 + 8'd20) && (yPosRock1 + 8'd20 > yPosRock3) && (yPosRock1 < yPosRock3 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_b4r = ((xPosRock1 == xPosRock4 + 8'd20) && (yPosRock1 + 8'd20 > yPosRock4) && (yPosRock1 < yPosRock4 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_b5r = ((xPosRock1 == xPosRock5 + 8'd20) && (yPosRock1 + 8'd20 > yPosRock5) && (yPosRock1 < yPosRock5 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_b6r = ((xPosRock1 == xPosRock6 + 8'd20) && (yPosRock1 + 8'd20 > yPosRock6) && (yPosRock1 < yPosRock6 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_b7r = ((xPosRock1 == xPosRock7 + 8'd20) && (yPosRock1 + 8'd20 > yPosRock7) && (yPosRock1 < yPosRock7 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_b9r = ((xPosRock1 == xPosRock9 + 8'd20) && (yPosRock1 + 8'd20 > yPosRock9) && (yPosRock1 < yPosRock9 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_b8r = ((xPosRock1 == xPosRock8 + 8'd20) && (yPosRock1 + 8'd20 > yPosRock8) && (yPosRock1 < yPosRock8 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_b10r = ((xPosRock1 == xPosRock10 + 8'd20) && (yPosRock1 + 8'd20 > yPosRock10) && (yPosRock1 < yPosRock10 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_b11r = ((xPosRock1 == xPosRock11 + 8'd20) && (yPosRock1 + 8'd20 > yPosRock11) && (yPosRock1 < yPosRock11 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_b12r = ((xPosRock1 == xPosRock12 + 8'd20) && (yPosRock1 + 8'd20 > yPosRock12) && (yPosRock1 < yPosRock12 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_b13r = ((xPosRock1 == xPosRock13 + 8'd20) && (yPosRock1 + 8'd20 > yPosRock13) && (yPosRock1 < yPosRock13 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_pr = ((xPosRock1 == xPos + 8'd20) && (yPosRock1 + 8'd20 > yPos) && (yPosRock1 < yPos + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a1_hr = ((xPosRock1 == x_ZZZ + 8'd60) && (yPosRock1 + 8'd20 > y_ZZZ) && (yPosRock1 < y_ZZZ + 8'd60)) ? 1'b1 : 1'b0;
assign hit_a1_ler = ((xPosRock1 == x_leaves + 8'd60) && (yPosRock1 + 8'd20 > y_leaves) && (yPosRock1 < y_leaves + 8'd90)) ? 1'b1 : 1'b0;

// hitting stuff for asteroid 2 from top
wire hit_a2_b1t;
wire hit_a2_b3t;
wire hit_a2_b4t;
wire hit_a2_b5t;
wire hit_a2_b6t;
wire hit_a2_b7t;
wire hit_a2_b9t;
wire hit_a2_b8t;
wire hit_a2_b10t;
wire hit_a2_b11t;
wire hit_a2_b12t;
wire hit_a2_b13t;
wire hit_a2_pt;
wire hit_a2_ht;
wire hit_a2_let;

assign hit_a2_b1t = ((yPosRock2 + 8'd20 == yPosRock1) && (xPosRock2 + 8'd20 > xPosRock1) && (xPosRock2 < xPosRock1 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_b3t = ((yPosRock2 + 8'd20 == yPosRock3) && (xPosRock2 + 8'd20 > xPosRock3) && (xPosRock2 < xPosRock3 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_b4t = ((yPosRock2 + 8'd20 == yPosRock4) && (xPosRock2 + 8'd20 > xPosRock4) && (xPosRock2 < xPosRock4 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_b5t = ((yPosRock2 + 8'd20 == yPosRock5) && (xPosRock2 + 8'd20 > xPosRock5) && (xPosRock2 < xPosRock5 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_b6t = ((yPosRock2 + 8'd20 == yPosRock6) && (xPosRock2 + 8'd20 > xPosRock6) && (xPosRock2 < xPosRock6 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_b7t = ((yPosRock2 + 8'd20 == yPosRock7) && (xPosRock2 + 8'd20 > xPosRock7) && (xPosRock2 < xPosRock7 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_b9t = ((yPosRock2 + 8'd20 == yPosRock9) && (xPosRock2 + 8'd20 > xPosRock9) && (xPosRock2 < xPosRock9 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_b8t = ((yPosRock2 + 8'd20 == yPosRock8) && (xPosRock2 + 8'd20 > xPosRock8) && (xPosRock2 < xPosRock8 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_b10t = ((yPosRock2 + 8'd20 == yPosRock10) && (xPosRock2 + 8'd20 > xPosRock10) && (xPosRock2 < xPosRock10 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_b11t = ((yPosRock2 + 8'd20 == yPosRock11) && (xPosRock2 + 8'd20 > xPosRock11) && (xPosRock2 < xPosRock11 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_b12t = ((yPosRock2 + 8'd20 == yPosRock12) && (xPosRock2 + 8'd20 > xPosRock12) && (xPosRock2 < xPosRock12 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_b13t = ((yPosRock2 + 8'd20 == yPosRock13) && (xPosRock2 + 8'd20 > xPosRock13) && (xPosRock2 < xPosRock13 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_pt = ((yPosRock2 + 8'd20 == yPos) && (xPosRock2 + 8'd20 > xPos) && (xPosRock2 < xPos + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_ht = ((yPosRock2 + 8'd20 == y_ZZZ) && (xPosRock2 + 8'd20 > x_ZZZ) && (xPosRock2 < x_ZZZ + 8'd60)) ? 1'b1 : 1'b0;
assign hit_a2_let = ((yPosRock2 + 8'd20 == y_leaves) && (xPosRock2 + 8'd20 > x_leaves) && (xPosRock2 < x_leaves + 8'd60)) ? 1'b1 : 1'b0;

//asteroid 2 from below 
wire hit_a2_b1b;
wire hit_a2_b3b;
wire hit_a2_b4b;
wire hit_a2_b5b;
wire hit_a2_b6b;
wire hit_a2_b7b;
wire hit_a2_b9b;
wire hit_a2_b8b;
wire hit_a2_b10b;
wire hit_a2_b11b;
wire hit_a2_b12b;
wire hit_a2_b13b;
wire hit_a2_pb;

assign hit_a2_b1b = ((yPosRock2 == yPosRock1 + 8'd20) && (xPosRock2 + 8'd20 > xPosRock1) && (xPosRock2 < xPosRock1 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_b3b = ((yPosRock2 == yPosRock3 + 8'd20) && (xPosRock2 + 8'd20 > xPosRock3) && (xPosRock2 < xPosRock3 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_b4b = ((yPosRock2 == yPosRock4 + 8'd20) && (xPosRock2 + 8'd20 > xPosRock4) && (xPosRock2 < xPosRock4 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_b5b = ((yPosRock2 == yPosRock5 + 8'd20) && (xPosRock2 + 8'd20 > xPosRock5) && (xPosRock2 < xPosRock5 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_b6b = ((yPosRock2 == yPosRock6 + 8'd20) && (xPosRock2 + 8'd20 > xPosRock6) && (xPosRock2 < xPosRock6 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_b7b = ((yPosRock2 == yPosRock7 + 8'd20) && (xPosRock2 + 8'd20 > xPosRock7) && (xPosRock2 < xPosRock7 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_b9b = ((yPosRock2 == yPosRock9 + 8'd20) && (xPosRock2 + 8'd20 > xPosRock9) && (xPosRock2 < xPosRock9 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_b8b = ((yPosRock2 == yPosRock8 + 8'd20) && (xPosRock2 + 8'd20 > xPosRock8) && (xPosRock2 < xPosRock8 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_b10b = ((yPosRock2 == yPosRock10 + 8'd20) && (xPosRock2 + 8'd20 > xPosRock10) && (xPosRock2 < xPosRock10 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_b11b = ((yPosRock2 == yPosRock11 + 8'd20) && (xPosRock2 + 8'd20 > xPosRock11) && (xPosRock2 < xPosRock11 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_b12b = ((yPosRock2 == yPosRock12 + 8'd20) && (xPosRock2 + 8'd20 > xPosRock12) && (xPosRock2 < xPosRock12 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_b13b = ((yPosRock2 == yPosRock13 + 8'd20) && (xPosRock2 + 8'd20 > xPosRock13) && (xPosRock2 < xPosRock13 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_pb = ((yPosRock2 == yPos + 8'd20) && (xPosRock2 + 8'd20 > xPos) && (xPosRock2 < xPos + 8'd20)) ? 1'b1 : 1'b0;

//asteroid 2 from left
wire hit_a2_b1l;
wire hit_a2_b2l;
wire hit_a2_b4l;
wire hit_a2_b5l;
wire hit_a2_b6l;
wire hit_a2_b7l;
wire hit_a2_b9l;
wire hit_a2_b8l;
wire hit_a2_b10l;
wire hit_a2_b11l;
wire hit_a2_b12l;
wire hit_a2_b13l;
wire hit_a2_pl;

assign hit_a2_b1l = ((xPosRock2 + 8'd20 == xPosRock1) && (yPosRock2 + 8'd20 > yPosRock1) && (yPosRock2 < yPosRock1 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_b3l = ((xPosRock2 + 8'd20 == xPosRock3) && (yPosRock2 + 8'd20 > yPosRock3) && (yPosRock2 < yPosRock3 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_b4l = ((xPosRock2 + 8'd20 == xPosRock4) && (yPosRock2 + 8'd20 > yPosRock4) && (yPosRock2 < yPosRock4 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_b5l = ((xPosRock2 + 8'd20 == xPosRock5) && (yPosRock2 + 8'd20 > yPosRock5) && (yPosRock2 < yPosRock5 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_b6l = ((xPosRock2 + 8'd20 == xPosRock6) && (yPosRock2 + 8'd20 > yPosRock6) && (yPosRock2 < yPosRock6 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_b7l = ((xPosRock2 + 8'd20 == xPosRock7) && (yPosRock2 + 8'd20 > yPosRock7) && (yPosRock2 < yPosRock7 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_b9l = ((xPosRock2 + 8'd20 == xPosRock9) && (yPosRock2 + 8'd20 > yPosRock9) && (yPosRock2 < yPosRock9 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_b8l = ((xPosRock2 + 8'd20 == xPosRock8) && (yPosRock2 + 8'd20 > yPosRock8) && (yPosRock2 < yPosRock8 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_b10l = ((xPosRock2 + 8'd20 == xPosRock10) && (yPosRock2 + 8'd20 > yPosRock10) && (yPosRock2 < yPosRock10 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_b11l = ((xPosRock2 + 8'd20 == xPosRock11) && (yPosRock2 + 8'd20 > yPosRock11) && (yPosRock2 < yPosRock11 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_b12l = ((xPosRock2 + 8'd20 == xPosRock12) && (yPosRock2 + 8'd20 > yPosRock12) && (yPosRock2 < yPosRock12 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_b13l = ((xPosRock2 + 8'd20 == xPosRock13) && (yPosRock2 + 8'd20 > yPosRock13) && (yPosRock2 < yPosRock13 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_pl = ((xPosRock2 + 8'd20 == xPos) && (yPosRock2 + 8'd20 > yPos) && (yPosRock2 < yPos + 8'd20)) ? 1'b1 : 1'b0;

//asteroid 2 from right
wire hit_a2_b1r;
wire hit_a2_b3r;
wire hit_a2_b4r;
wire hit_a2_b5r;
wire hit_a2_b6r;
wire hit_a2_b7r;
wire hit_a2_b9r;
wire hit_a2_b8r;
wire hit_a2_b10r;
wire hit_a2_b11r;
wire hit_a2_b12r;
wire hit_a2_b13r;
wire hit_a2_pr;
wire hit_a2_hr;
wire hit_a2_ler;

assign hit_a2_b1r = ((xPosRock2 == xPosRock1 + 8'd20) && (yPosRock2 + 8'd20 > yPosRock1) && (yPosRock2 < yPosRock1 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_b3r = ((xPosRock2 == xPosRock3 + 8'd20) && (yPosRock2 + 8'd20 > yPosRock3) && (yPosRock2 < yPosRock3 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_b4r = ((xPosRock2 == xPosRock4 + 8'd20) && (yPosRock2 + 8'd20 > yPosRock4) && (yPosRock2 < yPosRock4 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_b5r = ((xPosRock2 == xPosRock5 + 8'd20) && (yPosRock2 + 8'd20 > yPosRock5) && (yPosRock2 < yPosRock5 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_b6r = ((xPosRock2 == xPosRock6 + 8'd20) && (yPosRock2 + 8'd20 > yPosRock6) && (yPosRock2 < yPosRock6 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_b7r = ((xPosRock2 == xPosRock7 + 8'd20) && (yPosRock2 + 8'd20 > yPosRock7) && (yPosRock2 < yPosRock7 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_b9r = ((xPosRock2 == xPosRock9 + 8'd20) && (yPosRock2 + 8'd20 > yPosRock9) && (yPosRock2 < yPosRock9 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_b8r = ((xPosRock2 == xPosRock8 + 8'd20) && (yPosRock2 + 8'd20 > yPosRock8) && (yPosRock2 < yPosRock8 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_b10r = ((xPosRock2 == xPosRock10 + 8'd20) && (yPosRock2 + 8'd20 > yPosRock10) && (yPosRock2 < yPosRock10 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_b11r = ((xPosRock2 == xPosRock11 + 8'd20) && (yPosRock2 + 8'd20 > yPosRock11) && (yPosRock2 < yPosRock11 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_b12r = ((xPosRock2 == xPosRock12 + 8'd20) && (yPosRock2 + 8'd20 > yPosRock12) && (yPosRock2 < yPosRock12 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_b13r = ((xPosRock2 == xPosRock13 + 8'd20) && (yPosRock2 + 8'd20 > yPosRock13) && (yPosRock2 < yPosRock13 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_pr = ((xPosRock2 == xPos + 8'd20) && (yPosRock2 + 8'd20 > yPos) && (yPosRock2 < yPos + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a2_hr = ((xPosRock2 == x_ZZZ + 8'd60) && (yPosRock2 + 8'd20 > y_ZZZ) && (yPosRock2 < y_ZZZ + 8'd60)) ? 1'b1 : 1'b0;
assign hit_a2_ler = ((xPosRock2 == x_leaves + 8'd60) && (yPosRock2 + 8'd20 > y_leaves) && (yPosRock2 < y_leaves + 8'd90)) ? 1'b1 : 1'b0;


//collision stuff for asteroid 3 from the top
wire hit_a3_b1t;
wire hit_a3_b2t;
wire hit_a3_b4t;
wire hit_a3_b5t;
wire hit_a3_b6t;
wire hit_a3_b7t;
wire hit_a3_b9t;
wire hit_a3_b8t;
wire hit_a3_b10t;
wire hit_a3_b11t;
wire hit_a3_b12t;
wire hit_a3_b13t;
wire hit_a3_pt;
wire hit_a3_ht;
wire hit_a3_let;

assign hit_a3_b1t = ((yPosRock3 + 8'd20 == yPosRock1) && (xPosRock3 + 8'd20 > xPosRock1) && (xPosRock3 < xPosRock1 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_b2t = ((yPosRock3 + 8'd20 == yPosRock2) && (xPosRock3 + 8'd20 > xPosRock2) && (xPosRock3 < xPosRock2 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_b4t = ((yPosRock3 + 8'd20 == yPosRock4) && (xPosRock3 + 8'd20 > xPosRock4) && (xPosRock3 < xPosRock4 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_b5t = ((yPosRock3 + 8'd20 == yPosRock5) && (xPosRock3 + 8'd20 > xPosRock5) && (xPosRock3 < xPosRock5 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_b6t = ((yPosRock3 + 8'd20 == yPosRock6) && (xPosRock3 + 8'd20 > xPosRock6) && (xPosRock3 < xPosRock6 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_b7t = ((yPosRock3 + 8'd20 == yPosRock7) && (xPosRock3 + 8'd20 > xPosRock7) && (xPosRock3 < xPosRock7 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_b9t = ((yPosRock3 + 8'd20 == yPosRock9) && (xPosRock3 + 8'd20 > xPosRock9) && (xPosRock3 < xPosRock9 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_b8t = ((yPosRock3 + 8'd20 == yPosRock8) && (xPosRock3 + 8'd20 > xPosRock8) && (xPosRock3 < xPosRock8 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_b10t = ((yPosRock3 + 8'd20 == yPosRock10) && (xPosRock3 + 8'd20 > xPosRock10) && (xPosRock3 < xPosRock10 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_b11t = ((yPosRock3 + 8'd20 == yPosRock11) && (xPosRock3 + 8'd20 > xPosRock11) && (xPosRock3 < xPosRock11 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_b12t = ((yPosRock3 + 8'd20 == yPosRock12) && (xPosRock3 + 8'd20 > xPosRock12) && (xPosRock3 < xPosRock12 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_b13t = ((yPosRock3 + 8'd20 == yPosRock13) && (xPosRock3 + 8'd20 > xPosRock13) && (xPosRock3 < xPosRock13 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_pt = ((yPosRock3 + 8'd20 == yPos) && (xPosRock3 + 8'd20 > xPos) && (xPosRock3 < xPos + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_ht = ((yPosRock3 + 8'd20 == y_ZZZ) && (xPosRock3 + 8'd20 > x_ZZZ) && (xPosRock3 < x_ZZZ + 8'd60)) ? 1'b1 : 1'b0;
assign hit_a3_let = ((yPosRock3 + 8'd20 == y_leaves) && (xPosRock3 + 8'd20 > x_leaves) && (xPosRock3 < x_leaves + 8'd60)) ? 1'b1 : 1'b0;

//3 from below
wire hit_a3_b1b;
wire hit_a3_b2b;
wire hit_a3_b4b;
wire hit_a3_b5b;
wire hit_a3_b6b;
wire hit_a3_b7b;
wire hit_a3_b9b;
wire hit_a3_b8b;
wire hit_a3_b10b;
wire hit_a3_b11b;
wire hit_a3_b12b;
wire hit_a3_b13b;
wire hit_a3_pb;

assign hit_a3_b1b = ((yPosRock3 == yPosRock1 + 8'd20) && (xPosRock3 + 8'd20 > xPosRock1) && (xPosRock3 < xPosRock1 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_b2b = ((yPosRock3 == yPosRock2 + 8'd20) && (xPosRock3 + 8'd20 > xPosRock2) && (xPosRock3 < xPosRock2 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_b4b = ((yPosRock3 == yPosRock4 + 8'd20) && (xPosRock3 + 8'd20 > xPosRock4) && (xPosRock3 < xPosRock4 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_b5b = ((yPosRock3 == yPosRock5 + 8'd20) && (xPosRock3 + 8'd20 > xPosRock5) && (xPosRock3 < xPosRock5 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_b6b = ((yPosRock3 == yPosRock6 + 8'd20) && (xPosRock3 + 8'd20 > xPosRock6) && (xPosRock3 < xPosRock6 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_b7b = ((yPosRock3 == yPosRock7 + 8'd20) && (xPosRock3 + 8'd20 > xPosRock7) && (xPosRock3 < xPosRock7 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_b9b = ((yPosRock3 == yPosRock9 + 8'd20) && (xPosRock3 + 8'd20 > xPosRock9) && (xPosRock3 < xPosRock9 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_b8b = ((yPosRock3 == yPosRock8 + 8'd20) && (xPosRock3 + 8'd20 > xPosRock8) && (xPosRock3 < xPosRock8 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_b10b = ((yPosRock3 == yPosRock10 + 8'd20) && (xPosRock3 + 8'd20 > xPosRock10) && (xPosRock3 < xPosRock10 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_b11b = ((yPosRock3 == yPosRock11 + 8'd20) && (xPosRock3 + 8'd20 > xPosRock11) && (xPosRock3 < xPosRock11 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_b12b = ((yPosRock3 == yPosRock12 + 8'd20) && (xPosRock3 + 8'd20 > xPosRock12) && (xPosRock3 < xPosRock12 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_b13b = ((yPosRock3 == yPosRock13 + 8'd20) && (xPosRock3 + 8'd20 > xPosRock13) && (xPosRock3 < xPosRock13 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_pb = ((yPosRock3 == yPos + 8'd20) && (xPosRock3 + 8'd20 > xPos) && (xPosRock3 < xPos + 8'd20)) ? 1'b1 : 1'b0;

//3 from left
wire hit_a3_b1l;
wire hit_a3_b2l;
wire hit_a3_b4l;
wire hit_a3_b5l;
wire hit_a3_b6l;
wire hit_a3_b7l;
wire hit_a3_b9l;
wire hit_a3_b8l;
wire hit_a3_b10l;
wire hit_a3_b11l;
wire hit_a3_b12l;
wire hit_a3_b13l;
wire hit_a3_pl;

assign hit_a3_b1l = ((xPosRock3 + 8'd20 == xPosRock1) && (yPosRock3 + 8'd20 > yPosRock1) && (yPosRock3 < yPosRock1 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_b2l = ((xPosRock3 + 8'd20 == xPosRock2) && (yPosRock3 + 8'd20 > yPosRock2) && (yPosRock3 < yPosRock2 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_b4l = ((xPosRock3 + 8'd20 == xPosRock4) && (yPosRock3 + 8'd20 > yPosRock4) && (yPosRock3 < yPosRock4 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_b5l = ((xPosRock3 + 8'd20 == xPosRock5) && (yPosRock3 + 8'd20 > yPosRock5) && (yPosRock3 < yPosRock5 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_b6l = ((xPosRock3 + 8'd20 == xPosRock6) && (yPosRock3 + 8'd20 > yPosRock6) && (yPosRock3 < yPosRock6 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_b7l = ((xPosRock3 + 8'd20 == xPosRock7) && (yPosRock3 + 8'd20 > yPosRock7) && (yPosRock3 < yPosRock7 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_b9l = ((xPosRock3 + 8'd20 == xPosRock9) && (yPosRock3 + 8'd20 > yPosRock9) && (yPosRock3 < yPosRock9 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_b8l = ((xPosRock3 + 8'd20 == xPosRock8) && (yPosRock3 + 8'd20 > yPosRock8) && (yPosRock3 < yPosRock8 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_b10l = ((xPosRock3 + 8'd20 == xPosRock10) && (yPosRock3 + 8'd20 > yPosRock10) && (yPosRock3 < yPosRock10 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_b11l = ((xPosRock3 + 8'd20 == xPosRock11) && (yPosRock3 + 8'd20 > yPosRock11) && (yPosRock3 < yPosRock11 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_b12l = ((xPosRock3 + 8'd20 == xPosRock12) && (yPosRock3 + 8'd20 > yPosRock12) && (yPosRock3 < yPosRock12 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_b13l = ((xPosRock3 + 8'd20 == xPosRock13) && (yPosRock3 + 8'd20 > yPosRock13) && (yPosRock3 < yPosRock13 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_pl = ((xPosRock3 + 8'd20 == xPos) && (yPosRock3 + 8'd20 > yPos) && (yPosRock3 < yPos + 8'd20)) ? 1'b1 : 1'b0;

//3 from right 
wire hit_a3_b1r;
wire hit_a3_b2r;
wire hit_a3_b4r;
wire hit_a3_b5r;
wire hit_a3_b6r;
wire hit_a3_b7r;
wire hit_a3_b9r;
wire hit_a3_b8r;
wire hit_a3_b10r;
wire hit_a3_b11r;
wire hit_a3_b12r;
wire hit_a3_b13r;
wire hit_a3_pr;
wire hit_a3_hr;
wire hit_a3_ler;

assign hit_a3_b1r = ((xPosRock3 == xPosRock1 + 8'd20) && (yPosRock3 + 8'd20 > yPosRock1) && (yPosRock3 < yPosRock1 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_b2r = ((xPosRock3 == xPosRock2 + 8'd20) && (yPosRock3 + 8'd20 > yPosRock2) && (yPosRock3 < yPosRock2 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_b4r = ((xPosRock3 == xPosRock4 + 8'd20) && (yPosRock3 + 8'd20 > yPosRock4) && (yPosRock3 < yPosRock4 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_b5r = ((xPosRock3 == xPosRock5 + 8'd20) && (yPosRock3 + 8'd20 > yPosRock5) && (yPosRock3 < yPosRock5 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_b6r = ((xPosRock3 == xPosRock6 + 8'd20) && (yPosRock3 + 8'd20 > yPosRock6) && (yPosRock3 < yPosRock6 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_b7r = ((xPosRock3 == xPosRock7 + 8'd20) && (yPosRock3 + 8'd20 > yPosRock7) && (yPosRock3 < yPosRock7 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_b9r = ((xPosRock3 == xPosRock9 + 8'd20) && (yPosRock3 + 8'd20 > yPosRock9) && (yPosRock3 < yPosRock9 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_b8r = ((xPosRock3 == xPosRock8 + 8'd20) && (yPosRock3 + 8'd20 > yPosRock8) && (yPosRock3 < yPosRock8 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_b10r = ((xPosRock3 == xPosRock10 + 8'd20) && (yPosRock3 + 8'd20 > yPosRock10) && (yPosRock3 < yPosRock10 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_b11r = ((xPosRock3 == xPosRock11 + 8'd20) && (yPosRock3 + 8'd20 > yPosRock11) && (yPosRock3 < yPosRock11 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_b12r = ((xPosRock3 == xPosRock12 + 8'd20) && (yPosRock3 + 8'd20 > yPosRock12) && (yPosRock3 < yPosRock12 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_b13r = ((xPosRock3 == xPosRock13 + 8'd20) && (yPosRock3 + 8'd20 > yPosRock13) && (yPosRock3 < yPosRock13 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_pr = ((xPosRock3 == xPos + 8'd20) && (yPosRock3 + 8'd20 > yPos) && (yPosRock3 < yPos + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a3_hr = ((xPosRock3 == x_ZZZ + 8'd60) && (yPosRock3 + 8'd20 > y_ZZZ) && (yPosRock3 < y_ZZZ + 8'd60)) ? 1'b1 : 1'b0;
assign hit_a3_ler = ((xPosRock3 == x_leaves + 8'd60) && (yPosRock3 + 8'd20 > y_leaves) && (yPosRock3 < y_leaves + 8'd90)) ? 1'b1 : 1'b0;
	
//4 from top
wire hit_a4_b1t;
wire hit_a4_b2t;
wire hit_a4_b3t;
wire hit_a4_b5t;
wire hit_a4_b6t;
wire hit_a4_b7t;
wire hit_a4_b9t;
wire hit_a4_b8t;
wire hit_a4_b10t;
wire hit_a4_b11t;
wire hit_a4_b12t;
wire hit_a4_b13t;
wire hit_a4_pt;
wire hit_a4_ht;
wire hit_a4_let;

assign hit_a4_b1t = ((yPosRock4 + 8'd20 == yPosRock1) && (xPosRock4 + 8'd20 > xPosRock1) && (xPosRock4 < xPosRock1 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_b2t = ((yPosRock4 + 8'd20 == yPosRock2) && (xPosRock4 + 8'd20 > xPosRock2) && (xPosRock4 < xPosRock2 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_b3t = ((yPosRock4 + 8'd20 == yPosRock3) && (xPosRock4 + 8'd20 > xPosRock3) && (xPosRock4 < xPosRock3 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_b5t = ((yPosRock4 + 8'd20 == yPosRock5) && (xPosRock4 + 8'd20 > xPosRock5) && (xPosRock4 < xPosRock5 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_b6t = ((yPosRock4 + 8'd20 == yPosRock6) && (xPosRock4 + 8'd20 > xPosRock6) && (xPosRock4 < xPosRock6 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_b7t = ((yPosRock4 + 8'd20 == yPosRock7) && (xPosRock4 + 8'd20 > xPosRock7) && (xPosRock4 < xPosRock7 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_b9t = ((yPosRock4 + 8'd20 == yPosRock9) && (xPosRock4 + 8'd20 > xPosRock9) && (xPosRock4 < xPosRock9 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_b8t = ((yPosRock4 + 8'd20 == yPosRock8) && (xPosRock4 + 8'd20 > xPosRock8) && (xPosRock4 < xPosRock8 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_b10t = ((yPosRock4 + 8'd20 == yPosRock10) && (xPosRock4 + 8'd20 > xPosRock10) && (xPosRock4 < xPosRock10 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_b11t = ((yPosRock4 + 8'd20 == yPosRock11) && (xPosRock4 + 8'd20 > xPosRock11) && (xPosRock4 < xPosRock11 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_b12t = ((yPosRock4 + 8'd20 == yPosRock12) && (xPosRock4 + 8'd20 > xPosRock12) && (xPosRock4 < xPosRock12 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_b13t = ((yPosRock4 + 8'd20 == yPosRock13) && (xPosRock4 + 8'd20 > xPosRock13) && (xPosRock4 < xPosRock13 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_pt = ((yPosRock4 + 8'd20 == yPos) && (xPosRock4 + 8'd20 > xPos) && (xPosRock4 < xPos + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_ht = ((yPosRock4 + 8'd20 == y_ZZZ) && (xPosRock4 + 8'd20 > x_ZZZ) && (xPosRock4 < x_ZZZ + 8'd60)) ? 1'b1 : 1'b0;
assign hit_a4_let = ((yPosRock4 + 8'd20 == y_leaves) && (xPosRock4 + 8'd20 > x_leaves) && (xPosRock4 < x_leaves + 8'd60)) ? 1'b1 : 1'b0;

//4 from below 
wire hit_a4_b1b;
wire hit_a4_b2b;
wire hit_a4_b3b;
wire hit_a4_b5b;
wire hit_a4_b6b;
wire hit_a4_b7b;
wire hit_a4_b9b;
wire hit_a4_b8b;
wire hit_a4_b10b;
wire hit_a4_b11b;
wire hit_a4_b12b;
wire hit_a4_b13b;
wire hit_a4_pb;

assign hit_a4_b1b = ((yPosRock4 == yPosRock1 + 8'd20) && (xPosRock4 + 8'd20 > xPosRock1) && (xPosRock4 < xPosRock1 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_b2b = ((yPosRock4 == yPosRock2 + 8'd20) && (xPosRock4 + 8'd20 > xPosRock2) && (xPosRock4 < xPosRock2 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_b3b = ((yPosRock4 == yPosRock3 + 8'd20) && (xPosRock4 + 8'd20 > xPosRock3) && (xPosRock4 < xPosRock3 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_b5b = ((yPosRock4 == yPosRock5 + 8'd20) && (xPosRock4 + 8'd20 > xPosRock5) && (xPosRock4 < xPosRock5 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_b6b = ((yPosRock4 == yPosRock6 + 8'd20) && (xPosRock4 + 8'd20 > xPosRock6) && (xPosRock4 < xPosRock6 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_b7b = ((yPosRock4 == yPosRock7 + 8'd20) && (xPosRock4 + 8'd20 > xPosRock7) && (xPosRock4 < xPosRock7 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_b9b = ((yPosRock4 == yPosRock9 + 8'd20) && (xPosRock4 + 8'd20 > xPosRock9) && (xPosRock4 < xPosRock9 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_b8b = ((yPosRock4 == yPosRock8 + 8'd20) && (xPosRock4 + 8'd20 > xPosRock8) && (xPosRock4 < xPosRock8 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_b10b = ((yPosRock4 == yPosRock10 + 8'd20) && (xPosRock4 + 8'd20 > xPosRock10) && (xPosRock4 < xPosRock10 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_b11b = ((yPosRock4 == yPosRock11 + 8'd20) && (xPosRock4 + 8'd20 > xPosRock11) && (xPosRock4 < xPosRock11 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_b12b = ((yPosRock4 == yPosRock12 + 8'd20) && (xPosRock4 + 8'd20 > xPosRock12) && (xPosRock4 < xPosRock12 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_b13b = ((yPosRock4 == yPosRock13 + 8'd20) && (xPosRock4 + 8'd20 > xPosRock13) && (xPosRock4 < xPosRock13 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_pb = ((yPosRock4 == yPos + 8'd20) && (xPosRock4 + 8'd20 > xPos) && (xPosRock4 < xPos + 8'd20)) ? 1'b1 : 1'b0;

//4 left
wire hit_a4_b1l;
wire hit_a4_b2l;
wire hit_a4_b3l;
wire hit_a4_b5l;
wire hit_a4_b6l;
wire hit_a4_b7l;
wire hit_a4_b9l;
wire hit_a4_b8l;
wire hit_a4_b10l;
wire hit_a4_b11l;
wire hit_a4_b12l;
wire hit_a4_b13l;
wire hit_a4_pl;

assign hit_a4_b1l = ((xPosRock4 + 8'd20 == xPosRock1) && (yPosRock4 + 8'd20 > yPosRock1) && (yPosRock4 < yPosRock1 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_b2l = ((xPosRock4 + 8'd20 == xPosRock2) && (yPosRock4 + 8'd20 > yPosRock2) && (yPosRock4 < yPosRock2 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_b3l = ((xPosRock4 + 8'd20 == xPosRock3) && (yPosRock4 + 8'd20 > yPosRock3) && (yPosRock4 < yPosRock3 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_b5l = ((xPosRock4 + 8'd20 == xPosRock5) && (yPosRock4 + 8'd20 > yPosRock5) && (yPosRock4 < yPosRock5 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_b6l = ((xPosRock4 + 8'd20 == xPosRock6) && (yPosRock4 + 8'd20 > yPosRock6) && (yPosRock4 < yPosRock6 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_b7l = ((xPosRock4 + 8'd20 == xPosRock7) && (yPosRock4 + 8'd20 > yPosRock7) && (yPosRock4 < yPosRock7 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_b9l = ((xPosRock4 + 8'd20 == xPosRock9) && (yPosRock4 + 8'd20 > yPosRock9) && (yPosRock4 < yPosRock9 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_b8l = ((xPosRock4 + 8'd20 == xPosRock8) && (yPosRock4 + 8'd20 > yPosRock8) && (yPosRock4 < yPosRock8 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_b10l = ((xPosRock4 + 8'd20 == xPosRock10) && (yPosRock4 + 8'd20 > yPosRock10) && (yPosRock4 < yPosRock10 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_b11l = ((xPosRock4 + 8'd20 == xPosRock11) && (yPosRock4 + 8'd20 > yPosRock11) && (yPosRock4 < yPosRock11 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_b12l = ((xPosRock4 + 8'd20 == xPosRock12) && (yPosRock4 + 8'd20 > yPosRock12) && (yPosRock4 < yPosRock12 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_b13l = ((xPosRock4 + 8'd20 == xPosRock13) && (yPosRock4 + 8'd20 > yPosRock13) && (yPosRock4 < yPosRock13 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_pl = ((xPosRock4 + 8'd20 == xPos) && (yPosRock4 + 8'd20 > yPos) && (yPosRock4 < yPos + 8'd20)) ? 1'b1 : 1'b0;

//4 right 
wire hit_a4_b1r;
wire hit_a4_b2r;
wire hit_a4_b3r;
wire hit_a4_b5r;
wire hit_a4_b6r;
wire hit_a4_b7r;
wire hit_a4_b9r;
wire hit_a4_b8r;
wire hit_a4_b10r;
wire hit_a4_b11r;
wire hit_a4_b12r;
wire hit_a4_b13r;
wire hit_a4_pr;
wire hit_a4_hr;
wire hit_a4_ler;

assign hit_a4_b1r = ((xPosRock4 == xPosRock1 + 8'd20) && (yPosRock4 + 8'd20 > yPosRock1) && (yPosRock4 < yPosRock1 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_b2r = ((xPosRock4 == xPosRock2 + 8'd20) && (yPosRock4 + 8'd20 > yPosRock2) && (yPosRock4 < yPosRock2 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_b3r = ((xPosRock4 == xPosRock3 + 8'd20) && (yPosRock4 + 8'd20 > yPosRock3) && (yPosRock4 < yPosRock3 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_b5r = ((xPosRock4 == xPosRock5 + 8'd20) && (yPosRock4 + 8'd20 > yPosRock5) && (yPosRock4 < yPosRock5 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_b6r = ((xPosRock4 == xPosRock6 + 8'd20) && (yPosRock4 + 8'd20 > yPosRock6) && (yPosRock4 < yPosRock6 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_b7r = ((xPosRock4 == xPosRock7 + 8'd20) && (yPosRock4 + 8'd20 > yPosRock7) && (yPosRock4 < yPosRock7 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_b9r = ((xPosRock4 == xPosRock9 + 8'd20) && (yPosRock4 + 8'd20 > yPosRock9) && (yPosRock4 < yPosRock9 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_b8r = ((xPosRock4 == xPosRock8 + 8'd20) && (yPosRock4 + 8'd20 > yPosRock8) && (yPosRock4 < yPosRock8 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_b10r = ((xPosRock4 == xPosRock10 + 8'd20) && (yPosRock4 + 8'd20 > yPosRock10) && (yPosRock4 < yPosRock10 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_b11r = ((xPosRock4 == xPosRock11 + 8'd20) && (yPosRock4 + 8'd20 > yPosRock11) && (yPosRock4 < yPosRock11 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_b12r = ((xPosRock4 == xPosRock12 + 8'd20) && (yPosRock4 + 8'd20 > yPosRock12) && (yPosRock4 < yPosRock12 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_b13r = ((xPosRock4 == xPosRock13 + 8'd20) && (yPosRock4 + 8'd20 > yPosRock13) && (yPosRock4 < yPosRock13 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_pr = ((xPosRock4 == xPos + 8'd20) && (yPosRock4 + 8'd20 > yPos) && (yPosRock4 < yPos + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a4_hr = ((xPosRock4 == x_ZZZ + 8'd60) && (yPosRock4 + 8'd20 > y_ZZZ) && (yPosRock4 < y_ZZZ + 8'd60)) ? 1'b1 : 1'b0;
assign hit_a4_ler = ((xPosRock4 == x_leaves + 8'd60) && (yPosRock4 + 8'd20 > y_leaves) && (yPosRock4 < y_leaves + 8'd90)) ? 1'b1 : 1'b0;

//5 top
wire hit_a5_b1t;
wire hit_a5_b2t;
wire hit_a5_b3t;
wire hit_a5_b4t;
wire hit_a5_b6t;
wire hit_a5_b7t;
wire hit_a5_b9t;
wire hit_a5_b8t;
wire hit_a5_b10t;
wire hit_a5_b11t;
wire hit_a5_b12t;
wire hit_a5_b13t;
wire hit_a5_pt;
wire hit_a5_ht;
wire hit_a5_let;

assign hit_a5_b1t = ((yPosRock5 + 8'd20 == yPosRock1) && (xPosRock5 + 8'd20 > xPosRock1) && (xPosRock5 < xPosRock1 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_b2t = ((yPosRock5 + 8'd20 == yPosRock2) && (xPosRock5 + 8'd20 > xPosRock2) && (xPosRock5 < xPosRock2 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_b3t = ((yPosRock5 + 8'd20 == yPosRock3) && (xPosRock5 + 8'd20 > xPosRock3) && (xPosRock5 < xPosRock3 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_b4t = ((yPosRock5 + 8'd20 == yPosRock4) && (xPosRock5 + 8'd20 > xPosRock4) && (xPosRock5 < xPosRock4 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_b6t = ((yPosRock5 + 8'd20 == yPosRock6) && (xPosRock5 + 8'd20 > xPosRock6) && (xPosRock5 < xPosRock6 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_b7t = ((yPosRock5 + 8'd20 == yPosRock7) && (xPosRock5 + 8'd20 > xPosRock7) && (xPosRock5 < xPosRock7 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_b9t = ((yPosRock5 + 8'd20 == yPosRock9) && (xPosRock5 + 8'd20 > xPosRock9) && (xPosRock5 < xPosRock9 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_b8t = ((yPosRock5 + 8'd20 == yPosRock8) && (xPosRock5 + 8'd20 > xPosRock8) && (xPosRock5 < xPosRock8 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_b10t = ((yPosRock5 + 8'd20 == yPosRock10) && (xPosRock5 + 8'd20 > xPosRock10) && (xPosRock5 < xPosRock10 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_b11t = ((yPosRock5 + 8'd20 == yPosRock11) && (xPosRock5 + 8'd20 > xPosRock11) && (xPosRock5 < xPosRock11 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_b12t = ((yPosRock5 + 8'd20 == yPosRock12) && (xPosRock5 + 8'd20 > xPosRock12) && (xPosRock5 < xPosRock12 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_b13t = ((yPosRock5 + 8'd20 == yPosRock13) && (xPosRock5 + 8'd20 > xPosRock13) && (xPosRock5 < xPosRock13 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_pt = ((yPosRock5 + 8'd20 == yPos) && (xPosRock5 + 8'd20 > xPos) && (xPosRock5 < xPos + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_ht = ((yPosRock5 + 8'd20 == y_ZZZ) && (xPosRock5 + 8'd20 > x_ZZZ) && (xPosRock5 < x_ZZZ + 8'd60)) ? 1'b1 : 1'b0;
assign hit_a5_let = ((yPosRock5 + 8'd20 == y_leaves) && (xPosRock5 + 8'd20 > x_leaves) && (xPosRock5 < x_leaves + 8'd60)) ? 1'b1 : 1'b0;

//5 bottom 
wire hit_a5_b1b;
wire hit_a5_b2b;
wire hit_a5_b3b;
wire hit_a5_b4b;
wire hit_a5_b5b;
wire hit_a5_b7b;
wire hit_a5_b9b;
wire hit_a5_b8b;
wire hit_a5_b10b;
wire hit_a5_b11b;
wire hit_a5_b12b;
wire hit_a5_b13b;
wire hit_a5_pb;

assign hit_a5_b1b = ((yPosRock5 == yPosRock1 + 8'd20) && (xPosRock5 + 8'd20 > xPosRock1) && (xPosRock5 < xPosRock1 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_b2b = ((yPosRock5 == yPosRock2 + 8'd20) && (xPosRock5 + 8'd20 > xPosRock2) && (xPosRock5 < xPosRock2 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_b3b = ((yPosRock5 == yPosRock3 + 8'd20) && (xPosRock5 + 8'd20 > xPosRock3) && (xPosRock5 < xPosRock3 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_b4b = ((yPosRock5 == yPosRock4 + 8'd20) && (xPosRock5 + 8'd20 > xPosRock4) && (xPosRock5 < xPosRock4 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_b6b = ((yPosRock5 == yPosRock6 + 8'd20) && (xPosRock5 + 8'd20 > xPosRock6) && (xPosRock5 < xPosRock6 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_b7b = ((yPosRock5 == yPosRock7 + 8'd20) && (xPosRock5 + 8'd20 > xPosRock7) && (xPosRock5 < xPosRock7 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_b9b = ((yPosRock5 == yPosRock9 + 8'd20) && (xPosRock5 + 8'd20 > xPosRock9) && (xPosRock5 < xPosRock9 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_b8b = ((yPosRock5 == yPosRock8 + 8'd20) && (xPosRock5 + 8'd20 > xPosRock8) && (xPosRock5 < xPosRock8 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_b10b = ((yPosRock5 == yPosRock10 + 8'd20) && (xPosRock5 + 8'd20 > xPosRock10) && (xPosRock5 < xPosRock10 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_b11b = ((yPosRock5 == yPosRock11 + 8'd20) && (xPosRock5 + 8'd20 > xPosRock11) && (xPosRock5 < xPosRock11 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_b12b = ((yPosRock5 == yPosRock12 + 8'd20) && (xPosRock5 + 8'd20 > xPosRock12) && (xPosRock5 < xPosRock12 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_b13b = ((yPosRock5 == yPosRock13 + 8'd20) && (xPosRock5 + 8'd20 > xPosRock13) && (xPosRock5 < xPosRock13 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_pb = ((yPosRock5 == yPos + 8'd20) && (xPosRock5 + 8'd20 > xPos) && (xPosRock5 < xPos + 8'd20)) ? 1'b1 : 1'b0;


//5 left 
wire hit_a5_b1l;
wire hit_a5_b2l;
wire hit_a5_b3l;
wire hit_a5_b4l;
wire hit_a5_b6l;
wire hit_a5_b7l;
wire hit_a5_b9l;
wire hit_a5_b8l;
wire hit_a5_b10l;
wire hit_a5_b11l;
wire hit_a5_b12l;
wire hit_a5_b13l;
wire hit_a5_pl;

assign hit_a5_b1l = ((xPosRock5 + 8'd20 == xPosRock1) && (yPosRock5 + 8'd20 > yPosRock1) && (yPosRock5 < yPosRock1 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_b2l = ((xPosRock5 + 8'd20 == xPosRock2) && (yPosRock5 + 8'd20 > yPosRock2) && (yPosRock5 < yPosRock2 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_b3l = ((xPosRock5 + 8'd20 == xPosRock3) && (yPosRock5 + 8'd20 > yPosRock3) && (yPosRock5 < yPosRock3 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_b4l = ((xPosRock5 + 8'd20 == xPosRock4) && (yPosRock5 + 8'd20 > yPosRock4) && (yPosRock5 < yPosRock4 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_b6l = ((xPosRock5 + 8'd20 == xPosRock6) && (yPosRock5 + 8'd20 > yPosRock6) && (yPosRock5 < yPosRock6 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_b7l = ((xPosRock5 + 8'd20 == xPosRock7) && (yPosRock5 + 8'd20 > yPosRock7) && (yPosRock5 < yPosRock7 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_b9l = ((xPosRock5 + 8'd20 == xPosRock9) && (yPosRock5 + 8'd20 > yPosRock9) && (yPosRock5 < yPosRock9 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_b8l = ((xPosRock5 + 8'd20 == xPosRock8) && (yPosRock5 + 8'd20 > yPosRock8) && (yPosRock5 < yPosRock8 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_b10l = ((xPosRock5 + 8'd20 == xPosRock10) && (yPosRock5 + 8'd20 > yPosRock10) && (yPosRock5 < yPosRock10 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_b11l = ((xPosRock5 + 8'd20 == xPosRock11) && (yPosRock5 + 8'd20 > yPosRock11) && (yPosRock5 < yPosRock11 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_b12l = ((xPosRock5 + 8'd20 == xPosRock12) && (yPosRock5 + 8'd20 > yPosRock12) && (yPosRock5 < yPosRock12 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_b13l = ((xPosRock5 + 8'd20 == xPosRock13) && (yPosRock5 + 8'd20 > yPosRock13) && (yPosRock5 < yPosRock13 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_pl = ((xPosRock5 + 8'd20 == xPos) && (yPosRock5 + 8'd20 > yPos) && (yPosRock5 < yPos + 8'd20)) ? 1'b1 : 1'b0;

//5 right 
wire hit_a5_b1r;
wire hit_a5_b2r;
wire hit_a5_b3r;
wire hit_a5_b4r;
wire hit_a5_b6r;
wire hit_a5_b7r;
wire hit_a5_b9r;
wire hit_a5_b8r;
wire hit_a5_b10r;
wire hit_a5_b11r;
wire hit_a5_b12r;
wire hit_a5_b13r;
wire hit_a5_pr;
wire hit_a5_hr;
wire hit_a5_ler;

assign hit_a5_b1r = ((xPosRock5 == xPosRock1 + 8'd20) && (yPosRock5 + 8'd20 > yPosRock1) && (yPosRock5 < yPosRock1 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_b2r = ((xPosRock5 == xPosRock2 + 8'd20) && (yPosRock5 + 8'd20 > yPosRock2) && (yPosRock5 < yPosRock2 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_b3r = ((xPosRock5 == xPosRock3 + 8'd20) && (yPosRock5 + 8'd20 > yPosRock3) && (yPosRock5 < yPosRock3 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_b4r = ((xPosRock5 == xPosRock4 + 8'd20) && (yPosRock5 + 8'd20 > yPosRock4) && (yPosRock5 < yPosRock4 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_b6r = ((xPosRock5 == xPosRock6 + 8'd20) && (yPosRock5 + 8'd20 > yPosRock6) && (yPosRock5 < yPosRock6 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_b7r = ((xPosRock5 == xPosRock7 + 8'd20) && (yPosRock5 + 8'd20 > yPosRock7) && (yPosRock5 < yPosRock7 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_b9r = ((xPosRock5 == xPosRock9 + 8'd20) && (yPosRock5 + 8'd20 > yPosRock9) && (yPosRock5 < yPosRock9 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_b8r = ((xPosRock5 == xPosRock8 + 8'd20) && (yPosRock5 + 8'd20 > yPosRock8) && (yPosRock5 < yPosRock8 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_b10r = ((xPosRock5 == xPosRock10 + 8'd20) && (yPosRock5 + 8'd20 > yPosRock10) && (yPosRock5 < yPosRock10 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_b11r = ((xPosRock5 == xPosRock11 + 8'd20) && (yPosRock5 + 8'd20 > yPosRock11) && (yPosRock5 < yPosRock11 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_b12r = ((xPosRock5 == xPosRock12 + 8'd20) && (yPosRock5 + 8'd20 > yPosRock12) && (yPosRock5 < yPosRock12 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_b13r = ((xPosRock5 == xPosRock13 + 8'd20) && (yPosRock5 + 8'd20 > yPosRock13) && (yPosRock5 < yPosRock13 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_pr = ((xPosRock5 == xPos + 8'd20) && (yPosRock5 + 8'd20 > yPos) && (yPosRock5 < yPos + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a5_hr = ((xPosRock5 == x_ZZZ + 8'd60) && (yPosRock5 + 8'd20 > y_ZZZ) && (yPosRock5 < y_ZZZ + 8'd60)) ? 1'b1 : 1'b0;
assign hit_a5_ler = ((xPosRock5 == x_leaves + 8'd60) && (yPosRock5 + 8'd20 > y_leaves) && (yPosRock5 < y_leaves + 8'd90)) ? 1'b1 : 1'b0;

//6 top
wire hit_a6_b1t;
wire hit_a6_b2t;
wire hit_a6_b3t;
wire hit_a6_b4t;
wire hit_a6_b5t;
wire hit_a6_b7t;
wire hit_a6_b9t;
wire hit_a6_b8t;
wire hit_a6_b10t;
wire hit_a6_b11t;
wire hit_a6_b12t;
wire hit_a6_b13t;
wire hit_a6_pt;
wire hit_a6_ht;
wire hit_a6_let;

assign hit_a6_b1t = ((yPosRock6 + 8'd20 == yPosRock1) && (xPosRock6 + 8'd20 > xPosRock1) && (xPosRock6 < xPosRock1 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_b2t = ((yPosRock6 + 8'd20 == yPosRock2) && (xPosRock6 + 8'd20 > xPosRock2) && (xPosRock6 < xPosRock2 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_b3t = ((yPosRock6 + 8'd20 == yPosRock3) && (xPosRock6 + 8'd20 > xPosRock3) && (xPosRock6 < xPosRock3 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_b4t = ((yPosRock6 + 8'd20 == yPosRock4) && (xPosRock6 + 8'd20 > xPosRock4) && (xPosRock6 < xPosRock4 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_b5t = ((yPosRock6 + 8'd20 == yPosRock5) && (xPosRock6 + 8'd20 > xPosRock5) && (xPosRock6 < xPosRock5 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_b7t = ((yPosRock6 + 8'd20 == yPosRock7) && (xPosRock6 + 8'd20 > xPosRock7) && (xPosRock6 < xPosRock7 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_b9t = ((yPosRock6 + 8'd20 == yPosRock9) && (xPosRock6 + 8'd20 > xPosRock9) && (xPosRock6 < xPosRock9 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_b8t = ((yPosRock6 + 8'd20 == yPosRock8) && (xPosRock6 + 8'd20 > xPosRock8) && (xPosRock6 < xPosRock8 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_b10t = ((yPosRock6 + 8'd20 == yPosRock10) && (xPosRock6 + 8'd20 > xPosRock10) && (xPosRock6 < xPosRock10 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_b11t = ((yPosRock6 + 8'd20 == yPosRock11) && (xPosRock6 + 8'd20 > xPosRock11) && (xPosRock6 < xPosRock11 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_b12t = ((yPosRock6 + 8'd20 == yPosRock12) && (xPosRock6 + 8'd20 > xPosRock12) && (xPosRock6 < xPosRock12 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_b13t = ((yPosRock6 + 8'd20 == yPosRock13) && (xPosRock6 + 8'd20 > xPosRock13) && (xPosRock6 < xPosRock13 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_pt = ((yPosRock6 + 8'd20 == yPos) && (xPosRock6 + 8'd20 > xPos) && (xPosRock6 < xPos + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_ht = ((yPosRock6 + 8'd20 == y_ZZZ) && (xPosRock6 + 8'd20 > x_ZZZ) && (xPosRock6 < x_ZZZ + 8'd60)) ? 1'b1 : 1'b0;
assign hit_a6_let = ((yPosRock6 + 8'd20 == y_leaves) && (xPosRock6 + 8'd20 > x_leaves) && (xPosRock6 < x_leaves + 8'd60)) ? 1'b1 : 1'b0;

//6 bottom 
wire hit_a6_b1b;
wire hit_a6_b2b;
wire hit_a6_b3b;
wire hit_a6_b4b;
wire hit_a6_b5b;
wire hit_a6_b7b;
wire hit_a6_b9b;
wire hit_a6_b8b;
wire hit_a6_b10b;
wire hit_a6_b11b;
wire hit_a6_b12b;
wire hit_a6_b13b;
wire hit_a6_pb;

assign hit_a6_b1b = ((yPosRock6 == yPosRock1 + 8'd20) && (xPosRock6 + 8'd20 > xPosRock1) && (xPosRock6 < xPosRock1 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_b2b = ((yPosRock6 == yPosRock2 + 8'd20) && (xPosRock6 + 8'd20 > xPosRock2) && (xPosRock6 < xPosRock2 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_b3b = ((yPosRock6 == yPosRock3 + 8'd20) && (xPosRock6 + 8'd20 > xPosRock3) && (xPosRock6 < xPosRock3 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_b4b = ((yPosRock6 == yPosRock4 + 8'd20) && (xPosRock6 + 8'd20 > xPosRock4) && (xPosRock6 < xPosRock4 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_b5b = ((yPosRock6 == yPosRock5 + 8'd20) && (xPosRock6 + 8'd20 > xPosRock5) && (xPosRock6 < xPosRock5 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_b7b = ((yPosRock6 == yPosRock7 + 8'd20) && (xPosRock6 + 8'd20 > xPosRock7) && (xPosRock6 < xPosRock7 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_b9b = ((yPosRock6 == yPosRock9 + 8'd20) && (xPosRock6 + 8'd20 > xPosRock9) && (xPosRock6 < xPosRock9 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_b8b = ((yPosRock6 == yPosRock8 + 8'd20) && (xPosRock6 + 8'd20 > xPosRock8) && (xPosRock6 < xPosRock8 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_b10b = ((yPosRock6 == yPosRock10 + 8'd20) && (xPosRock6 + 8'd20 > xPosRock10) && (xPosRock6 < xPosRock10 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_b11b = ((yPosRock6 == yPosRock11 + 8'd20) && (xPosRock6 + 8'd20 > xPosRock11) && (xPosRock6 < xPosRock11 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_b12b = ((yPosRock6 == yPosRock12 + 8'd20) && (xPosRock6 + 8'd20 > xPosRock12) && (xPosRock6 < xPosRock12 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_b13b = ((yPosRock6 == yPosRock13 + 8'd20) && (xPosRock6 + 8'd20 > xPosRock13) && (xPosRock6 < xPosRock13 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_pb = ((yPosRock6 == yPos + 8'd20) && (xPosRock6 + 8'd20 > xPos) && (xPosRock6 < xPos + 8'd20)) ? 1'b1 : 1'b0;

// 6 left 
wire hit_a6_b1l;
wire hit_a6_b2l;
wire hit_a6_b3l;
wire hit_a6_b4l;
wire hit_a6_b5l;
wire hit_a6_b7l;
wire hit_a6_b9l;
wire hit_a6_b8l;
wire hit_a6_b10l;
wire hit_a6_b11l;
wire hit_a6_b12l;
wire hit_a6_b13l;
wire hit_a6_pl;

assign hit_a6_b1l = ((xPosRock6 + 8'd20 == xPosRock1) && (yPosRock6 + 8'd20 > yPosRock1) && (yPosRock6 < yPosRock1 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_b2l = ((xPosRock6 + 8'd20 == xPosRock2) && (yPosRock6 + 8'd20 > yPosRock2) && (yPosRock6 < yPosRock2 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_b3l = ((xPosRock6 + 8'd20 == xPosRock3) && (yPosRock6 + 8'd20 > yPosRock3) && (yPosRock6 < yPosRock3 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_b4l = ((xPosRock6 + 8'd20 == xPosRock4) && (yPosRock6 + 8'd20 > yPosRock4) && (yPosRock6 < yPosRock4 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_b5l = ((xPosRock6 + 8'd20 == xPosRock5) && (yPosRock6 + 8'd20 > yPosRock5) && (yPosRock6 < yPosRock5 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_b7l = ((xPosRock6 + 8'd20 == xPosRock7) && (yPosRock6 + 8'd20 > yPosRock7) && (yPosRock6 < yPosRock7 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_b9l = ((xPosRock6 + 8'd20 == xPosRock9) && (yPosRock6 + 8'd20 > yPosRock9) && (yPosRock6 < yPosRock9 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_b8l = ((xPosRock6 + 8'd20 == xPosRock8) && (yPosRock6 + 8'd20 > yPosRock8) && (yPosRock6 < yPosRock8 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_b10l = ((xPosRock6 + 8'd20 == xPosRock10) && (yPosRock6 + 8'd20 > yPosRock10) && (yPosRock6 < yPosRock10 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_b11l = ((xPosRock6 + 8'd20 == xPosRock11) && (yPosRock6 + 8'd20 > yPosRock11) && (yPosRock6 < yPosRock11 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_b12l = ((xPosRock6 + 8'd20 == xPosRock12) && (yPosRock6 + 8'd20 > yPosRock12) && (yPosRock6 < yPosRock12 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_b13l = ((xPosRock6 + 8'd20 == xPosRock13) && (yPosRock6 + 8'd20 > yPosRock13) && (yPosRock6 < yPosRock13 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_pl = ((xPosRock6 + 8'd20 == xPos) && (yPosRock6 + 8'd20 > yPos) && (yPosRock6 < yPos + 8'd20)) ? 1'b1 : 1'b0;

//6 right 
wire hit_a6_b1r;
wire hit_a6_b2r;
wire hit_a6_b3r;
wire hit_a6_b4r;
wire hit_a6_b5r;
wire hit_a6_b7r;
wire hit_a6_b9r;
wire hit_a6_b8r;
wire hit_a6_b10r;
wire hit_a6_b11r;
wire hit_a6_b12r;
wire hit_a6_b13r;
wire hit_a6_pr;
wire hit_a6_hr;
wire hit_a6_ler;

assign hit_a6_b1r = ((xPosRock6 == xPosRock1 + 8'd20) && (yPosRock6 + 8'd20 > yPosRock1) && (yPosRock6 < yPosRock1 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_b2r = ((xPosRock6 == xPosRock2 + 8'd20) && (yPosRock6 + 8'd20 > yPosRock2) && (yPosRock6 < yPosRock2 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_b3r = ((xPosRock6 == xPosRock3 + 8'd20) && (yPosRock6 + 8'd20 > yPosRock3) && (yPosRock6 < yPosRock3 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_b4r = ((xPosRock6 == xPosRock4 + 8'd20) && (yPosRock6 + 8'd20 > yPosRock4) && (yPosRock6 < yPosRock4 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_b5r = ((xPosRock6 == xPosRock5 + 8'd20) && (yPosRock6 + 8'd20 > yPosRock5) && (yPosRock6 < yPosRock5 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_b7r = ((xPosRock6 == xPosRock7 + 8'd20) && (yPosRock6 + 8'd20 > yPosRock7) && (yPosRock6 < yPosRock7 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_b9r = ((xPosRock6 == xPosRock9 + 8'd20) && (yPosRock6 + 8'd20 > yPosRock9) && (yPosRock6 < yPosRock9 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_b8r = ((xPosRock6 == xPosRock8 + 8'd20) && (yPosRock6 + 8'd20 > yPosRock8) && (yPosRock6 < yPosRock8 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_b10r = ((xPosRock6 == xPosRock10 + 8'd20) && (yPosRock6 + 8'd20 > yPosRock10) && (yPosRock6 < yPosRock10 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_b11r = ((xPosRock6 == xPosRock11 + 8'd20) && (yPosRock6 + 8'd20 > yPosRock11) && (yPosRock6 < yPosRock11 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_b12r = ((xPosRock6 == xPosRock12 + 8'd20) && (yPosRock6 + 8'd20 > yPosRock12) && (yPosRock6 < yPosRock12 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_b13r = ((xPosRock6 == xPosRock13 + 8'd20) && (yPosRock6 + 8'd20 > yPosRock13) && (yPosRock6 < yPosRock13 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_pr = ((xPosRock6 == xPos + 8'd20) && (yPosRock6 + 8'd20 > yPos) && (yPosRock6 < yPos + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a6_hr = ((xPosRock6 == x_ZZZ + 8'd60) && (yPosRock6 + 8'd20 > y_ZZZ) && (yPosRock6 < y_ZZZ + 8'd60)) ? 1'b1 : 1'b0;
assign hit_a6_ler = ((xPosRock6 == x_leaves + 8'd60) && (yPosRock6 + 8'd20 > y_leaves) && (yPosRock6 < y_leaves + 8'd90)) ? 1'b1 : 1'b0;

//7 top
wire hit_a7_b1t;
wire hit_a7_b2t;
wire hit_a7_b3t;
wire hit_a7_b4t;
wire hit_a7_b5t;
wire hit_a7_b6t;
wire hit_a7_b9t;
wire hit_a7_b8t;
wire hit_a7_b10t;
wire hit_a7_b11t;
wire hit_a7_b12t;
wire hit_a7_b13t;
wire hit_a7_pt;
wire hit_a7_ht;
wire hit_a7_let;

assign hit_a7_b1t = ((yPosRock7 + 8'd20 == yPosRock1) && (xPosRock7 + 8'd20 > xPosRock1) && (xPosRock7 < xPosRock1 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_b2t = ((yPosRock7 + 8'd20 == yPosRock2) && (xPosRock7 + 8'd20 > xPosRock2) && (xPosRock7 < xPosRock2 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_b3t = ((yPosRock7 + 8'd20 == yPosRock3) && (xPosRock7 + 8'd20 > xPosRock3) && (xPosRock7 < xPosRock3 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_b4t = ((yPosRock7 + 8'd20 == yPosRock4) && (xPosRock7 + 8'd20 > xPosRock4) && (xPosRock7 < xPosRock4 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_b5t = ((yPosRock7 + 8'd20 == yPosRock5) && (xPosRock7 + 8'd20 > xPosRock5) && (xPosRock7 < xPosRock5 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_b6t = ((yPosRock7 + 8'd20 == yPosRock6) && (xPosRock7 + 8'd20 > xPosRock6) && (xPosRock7 < xPosRock6 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_b9t = ((yPosRock7 + 8'd20 == yPosRock9) && (xPosRock7 + 8'd20 > xPosRock9) && (xPosRock7 < xPosRock9 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_b8t = ((yPosRock7 + 8'd20 == yPosRock8) && (xPosRock7 + 8'd20 > xPosRock8) && (xPosRock7 < xPosRock8 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_b10t = ((yPosRock7 + 8'd20 == yPosRock10) && (xPosRock7 + 8'd20 > xPosRock10) && (xPosRock7 < xPosRock10 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_b11t = ((yPosRock7 + 8'd20 == yPosRock11) && (xPosRock7 + 8'd20 > xPosRock11) && (xPosRock7 < xPosRock11 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_b12t = ((yPosRock7 + 8'd20 == yPosRock12) && (xPosRock7 + 8'd20 > xPosRock12) && (xPosRock7 < xPosRock12 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_b13t = ((yPosRock7 + 8'd20 == yPosRock13) && (xPosRock7 + 8'd20 > xPosRock13) && (xPosRock7 < xPosRock13 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_pt = ((yPosRock7 + 8'd20 == yPos) && (xPosRock7 + 8'd20 > xPos) && (xPosRock7 < xPos + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_ht = ((yPosRock7 + 8'd20 == y_ZZZ) && (xPosRock7 + 8'd20 > x_ZZZ) && (xPosRock7 < x_ZZZ + 8'd60)) ? 1'b1 : 1'b0;
assign hit_a7_let = ((yPosRock7 + 8'd20 == y_leaves) && (xPosRock7 + 8'd20 > x_leaves) && (xPosRock7 < x_leaves + 8'd60)) ? 1'b1 : 1'b0;

//7 bottom 
wire hit_a7_b1b;
wire hit_a7_b2b;
wire hit_a7_b3b;
wire hit_a7_b4b;
wire hit_a7_b5b;
wire hit_a7_b6b;
wire hit_a7_b9b;
wire hit_a7_b8b;
wire hit_a7_b10b;
wire hit_a7_b11b;
wire hit_a7_b12b;
wire hit_a7_b13b;
wire hit_a7_pb;

assign hit_a7_b1b = ((yPosRock7 == yPosRock1 + 8'd20) && (xPosRock7 + 8'd20 > xPosRock1) && (xPosRock7 < xPosRock1 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_b2b = ((yPosRock7 == yPosRock2 + 8'd20) && (xPosRock7 + 8'd20 > xPosRock2) && (xPosRock7 < xPosRock2 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_b3b = ((yPosRock7 == yPosRock3 + 8'd20) && (xPosRock7 + 8'd20 > xPosRock3) && (xPosRock7 < xPosRock3 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_b4b = ((yPosRock7 == yPosRock4 + 8'd20) && (xPosRock7 + 8'd20 > xPosRock4) && (xPosRock7 < xPosRock4 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_b5b = ((yPosRock7 == yPosRock5 + 8'd20) && (xPosRock7 + 8'd20 > xPosRock5) && (xPosRock7 < xPosRock5 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_b6b = ((yPosRock7 == yPosRock6 + 8'd20) && (xPosRock7 + 8'd20 > xPosRock6) && (xPosRock7 < xPosRock6 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_b9b = ((yPosRock7 == yPosRock9 + 8'd20) && (xPosRock7 + 8'd20 > xPosRock9) && (xPosRock7 < xPosRock9 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_b8b = ((yPosRock7 == yPosRock8 + 8'd20) && (xPosRock7 + 8'd20 > xPosRock8) && (xPosRock7 < xPosRock8 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_b10b = ((yPosRock7 == yPosRock10 + 8'd20) && (xPosRock7 + 8'd20 > xPosRock10) && (xPosRock7 < xPosRock10 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_b11b = ((yPosRock7 == yPosRock11 + 8'd20) && (xPosRock7 + 8'd20 > xPosRock11) && (xPosRock7 < xPosRock11 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_b12b = ((yPosRock7 == yPosRock12 + 8'd20) && (xPosRock7 + 8'd20 > xPosRock12) && (xPosRock7 < xPosRock12 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_b13b = ((yPosRock7 == yPosRock13 + 8'd20) && (xPosRock7 + 8'd20 > xPosRock13) && (xPosRock7 < xPosRock13 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_pb = ((yPosRock7 == yPos + 8'd20) && (xPosRock7 + 8'd20 > xPos) && (xPosRock7 < xPos + 8'd20)) ? 1'b1 : 1'b0;

//7 left 
wire hit_a7_b1l;
wire hit_a7_b2l;
wire hit_a7_b3l;
wire hit_a7_b4l;
wire hit_a7_b5l;
wire hit_a7_b6l;
wire hit_a7_b9l;
wire hit_a7_b8l;
wire hit_a7_b10l;
wire hit_a7_b11l;
wire hit_a7_b12l;
wire hit_a7_b13l;
wire hit_a7_pl;

assign hit_a7_b1l = ((xPosRock7 + 8'd20 == xPosRock1) && (yPosRock7 + 8'd20 > yPosRock1) && (yPosRock7 < yPosRock1 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_b2l = ((xPosRock7 + 8'd20 == xPosRock2) && (yPosRock7 + 8'd20 > yPosRock2) && (yPosRock7 < yPosRock2 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_b3l = ((xPosRock7 + 8'd20 == xPosRock3) && (yPosRock7 + 8'd20 > yPosRock3) && (yPosRock7 < yPosRock3 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_b4l = ((xPosRock7 + 8'd20 == xPosRock4) && (yPosRock7 + 8'd20 > yPosRock4) && (yPosRock7 < yPosRock4 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_b5l = ((xPosRock7 + 8'd20 == xPosRock5) && (yPosRock7 + 8'd20 > yPosRock5) && (yPosRock7 < yPosRock5 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_b6l = ((xPosRock7 + 8'd20 == xPosRock6) && (yPosRock7 + 8'd20 > yPosRock6) && (yPosRock7 < yPosRock6 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_b9l = ((xPosRock7 + 8'd20 == xPosRock9) && (yPosRock7 + 8'd20 > yPosRock9) && (yPosRock7 < yPosRock9 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_b8l = ((xPosRock7 + 8'd20 == xPosRock8) && (yPosRock7 + 8'd20 > yPosRock8) && (yPosRock7 < yPosRock8 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_b10l = ((xPosRock7 + 8'd20 == xPosRock10) && (yPosRock7 + 8'd20 > yPosRock10) && (yPosRock7 < yPosRock10 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_b11l = ((xPosRock7 + 8'd20 == xPosRock11) && (yPosRock7 + 8'd20 > yPosRock11) && (yPosRock7 < yPosRock11 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_b12l = ((xPosRock7 + 8'd20 == xPosRock12) && (yPosRock7 + 8'd20 > yPosRock12) && (yPosRock7 < yPosRock12 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_b13l = ((xPosRock7 + 8'd20 == xPosRock13) && (yPosRock7 + 8'd20 > yPosRock13) && (yPosRock7 < yPosRock13 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_pl = ((xPosRock7 + 8'd20 == xPos) && (yPosRock7 + 8'd20 > yPos) && (yPosRock7 < yPos + 8'd20)) ? 1'b1 : 1'b0;

//7 right 
wire hit_a7_b1r;
wire hit_a7_b2r;
wire hit_a7_b3r;
wire hit_a7_b4r;
wire hit_a7_b5r;
wire hit_a7_b6r;
wire hit_a7_b9r;
wire hit_a7_b8r;
wire hit_a7_b10r;
wire hit_a7_b11r;
wire hit_a7_b12r;
wire hit_a7_b13r;
wire hit_a7_pr;
wire hit_a7_hr;
wire hit_a7_ler;

assign hit_a7_b1r = ((xPosRock7 == xPosRock1 + 8'd20) && (yPosRock7 + 8'd20 > yPosRock1) && (yPosRock7 < yPosRock1 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_b2r = ((xPosRock7 == xPosRock2 + 8'd20) && (yPosRock7 + 8'd20 > yPosRock2) && (yPosRock7 < yPosRock2 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_b3r = ((xPosRock7 == xPosRock3 + 8'd20) && (yPosRock7 + 8'd20 > yPosRock3) && (yPosRock7 < yPosRock3 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_b4r = ((xPosRock7 == xPosRock4 + 8'd20) && (yPosRock7 + 8'd20 > yPosRock4) && (yPosRock7 < yPosRock4 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_b5r = ((xPosRock7 == xPosRock5 + 8'd20) && (yPosRock7 + 8'd20 > yPosRock5) && (yPosRock7 < yPosRock5 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_b6r = ((xPosRock7 == xPosRock6 + 8'd20) && (yPosRock7 + 8'd20 > yPosRock6) && (yPosRock7 < yPosRock6 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_b9r = ((xPosRock7 == xPosRock9 + 8'd20) && (yPosRock7 + 8'd20 > yPosRock9) && (yPosRock7 < yPosRock9 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_b8r = ((xPosRock7 == xPosRock8 + 8'd20) && (yPosRock7 + 8'd20 > yPosRock8) && (yPosRock7 < yPosRock8 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_b10r = ((xPosRock7 == xPosRock10 + 8'd20) && (yPosRock7 + 8'd20 > yPosRock10) && (yPosRock7 < yPosRock10 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_b11r = ((xPosRock7 == xPosRock11 + 8'd20) && (yPosRock7 + 8'd20 > yPosRock11) && (yPosRock7 < yPosRock11 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_b12r = ((xPosRock7 == xPosRock12 + 8'd20) && (yPosRock7 + 8'd20 > yPosRock12) && (yPosRock7 < yPosRock12 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_b13r = ((xPosRock7 == xPosRock13 + 8'd20) && (yPosRock7 + 8'd20 > yPosRock13) && (yPosRock7 < yPosRock13 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_pr = ((xPosRock7 == xPos + 8'd20) && (yPosRock7 + 8'd20 > yPos) && (yPosRock7 < yPos + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a7_hr = ((xPosRock7 == x_ZZZ + 8'd60) && (yPosRock7 + 8'd20 > y_ZZZ) && (yPosRock7 < y_ZZZ + 8'd60)) ? 1'b1 : 1'b0;
assign hit_a7_ler = ((xPosRock7 == x_leaves + 8'd60) && (yPosRock7 + 8'd20 > y_leaves) && (yPosRock7 < y_leaves + 8'd90)) ? 1'b1 : 1'b0;

//8 top
wire hit_a8_b1t;
wire hit_a8_b2t;
wire hit_a8_b3t;
wire hit_a8_b4t;
wire hit_a8_b5t;
wire hit_a8_b6t;
wire hit_a8_b9t;
wire hit_a8_b7t;
wire hit_a8_b10t;
wire hit_a8_b11t;
wire hit_a8_b12t;
wire hit_a8_b13t;
wire hit_a8_pt;
wire hit_a8_ht;
wire hit_a8_let;

assign hit_a8_b1t = ((yPosRock8 + 8'd20 == yPosRock1) && (xPosRock8 + 8'd20 > xPosRock1) && (xPosRock8 < xPosRock1 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_b2t = ((yPosRock8 + 8'd20 == yPosRock2) && (xPosRock8 + 8'd20 > xPosRock2) && (xPosRock8 < xPosRock2 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_b3t = ((yPosRock8 + 8'd20 == yPosRock3) && (xPosRock8 + 8'd20 > xPosRock3) && (xPosRock8 < xPosRock3 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_b4t = ((yPosRock8 + 8'd20 == yPosRock4) && (xPosRock8 + 8'd20 > xPosRock4) && (xPosRock8 < xPosRock4 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_b5t = ((yPosRock8 + 8'd20 == yPosRock5) && (xPosRock8 + 8'd20 > xPosRock5) && (xPosRock8 < xPosRock5 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_b6t = ((yPosRock8 + 8'd20 == yPosRock6) && (xPosRock8 + 8'd20 > xPosRock6) && (xPosRock8 < xPosRock6 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_b9t = ((yPosRock8 + 8'd20 == yPosRock9) && (xPosRock8 + 8'd20 > xPosRock9) && (xPosRock8 < xPosRock9 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_b7t = ((yPosRock8 + 8'd20 == yPosRock7) && (xPosRock8 + 8'd20 > xPosRock7) && (xPosRock8 < xPosRock7 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_b10t = ((yPosRock8 + 8'd20 == yPosRock10) && (xPosRock8 + 8'd20 > xPosRock10) && (xPosRock8 < xPosRock10 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_b11t = ((yPosRock8 + 8'd20 == yPosRock11) && (xPosRock8 + 8'd20 > xPosRock11) && (xPosRock8 < xPosRock11 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_b12t = ((yPosRock8 + 8'd20 == yPosRock12) && (xPosRock8 + 8'd20 > xPosRock12) && (xPosRock8 < xPosRock12 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_b13t = ((yPosRock8 + 8'd20 == yPosRock13) && (xPosRock8 + 8'd20 > xPosRock13) && (xPosRock8 < xPosRock13 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_pt = ((yPosRock8 + 8'd20 == yPos) && (xPosRock8 + 8'd20 > xPos) && (xPosRock8 < xPos + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_ht = ((yPosRock8 + 8'd20 == y_ZZZ) && (xPosRock8 + 8'd20 > x_ZZZ) && (xPosRock8 < x_ZZZ + 8'd60)) ? 1'b1 : 1'b0;
assign hit_a8_let = ((yPosRock8 + 8'd20 == y_leaves) && (xPosRock8 + 8'd20 > x_leaves) && (xPosRock8 < x_leaves + 8'd60)) ? 1'b1 : 1'b0;

//8 bottom 
wire hit_a8_b1b;
wire hit_a8_b2b;
wire hit_a8_b3b;
wire hit_a8_b4b;
wire hit_a8_b5b;
wire hit_a8_b6b;
wire hit_a8_b9b;
wire hit_a8_b7b;
wire hit_a8_b10b;
wire hit_a8_b11b;
wire hit_a8_b12b;
wire hit_a8_b13b;
wire hit_a8_pb;

assign hit_a8_b1b = ((yPosRock8 == yPosRock1 + 8'd20) && (xPosRock8 + 8'd20 > xPosRock1) && (xPosRock8 < xPosRock1 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_b2b = ((yPosRock8 == yPosRock2 + 8'd20) && (xPosRock8 + 8'd20 > xPosRock2) && (xPosRock8 < xPosRock2 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_b3b = ((yPosRock8 == yPosRock3 + 8'd20) && (xPosRock8 + 8'd20 > xPosRock3) && (xPosRock8 < xPosRock3 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_b4b = ((yPosRock8 == yPosRock4 + 8'd20) && (xPosRock8 + 8'd20 > xPosRock4) && (xPosRock8 < xPosRock4 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_b5b = ((yPosRock8 == yPosRock5 + 8'd20) && (xPosRock8 + 8'd20 > xPosRock5) && (xPosRock8 < xPosRock5 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_b6b = ((yPosRock8 == yPosRock6 + 8'd20) && (xPosRock8 + 8'd20 > xPosRock6) && (xPosRock8 < xPosRock6 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_b9b = ((yPosRock8 == yPosRock9 + 8'd20) && (xPosRock8 + 8'd20 > xPosRock9) && (xPosRock8 < xPosRock9 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_b7b = ((yPosRock8 == yPosRock7 + 8'd20) && (xPosRock8 + 8'd20 > xPosRock7) && (xPosRock8 < xPosRock7 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_b10b = ((yPosRock8 == yPosRock10 + 8'd20) && (xPosRock8 + 8'd20 > xPosRock10) && (xPosRock8 < xPosRock10 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_b11b = ((yPosRock8 == yPosRock11 + 8'd20) && (xPosRock8 + 8'd20 > xPosRock11) && (xPosRock8 < xPosRock11 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_b12b = ((yPosRock8 == yPosRock12 + 8'd20) && (xPosRock8 + 8'd20 > xPosRock12) && (xPosRock8 < xPosRock12 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_b13b = ((yPosRock8 == yPosRock13 + 8'd20) && (xPosRock8 + 8'd20 > xPosRock13) && (xPosRock8 < xPosRock13 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_pb = ((yPosRock8 == yPos + 8'd20) && (xPosRock8 + 8'd20 > xPos) && (xPosRock8 < xPos + 8'd20)) ? 1'b1 : 1'b0;

//8 left 
wire hit_a8_b1l;
wire hit_a8_b2l;
wire hit_a8_b3l;
wire hit_a8_b4l;
wire hit_a8_b5l;
wire hit_a8_b6l;
wire hit_a8_b9l;
wire hit_a8_b7l;
wire hit_a8_b10l;
wire hit_a8_b11l;
wire hit_a8_b12l;
wire hit_a8_b13l;
wire hit_a8_pl;

assign hit_a8_b1l = ((xPosRock8 + 8'd20 == xPosRock1) && (yPosRock8 + 8'd20 > yPosRock1) && (yPosRock8 < yPosRock1 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_b2l = ((xPosRock8 + 8'd20 == xPosRock2) && (yPosRock8 + 8'd20 > yPosRock2) && (yPosRock8 < yPosRock2 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_b3l = ((xPosRock8 + 8'd20 == xPosRock3) && (yPosRock8 + 8'd20 > yPosRock3) && (yPosRock8 < yPosRock3 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_b4l = ((xPosRock8 + 8'd20 == xPosRock4) && (yPosRock8 + 8'd20 > yPosRock4) && (yPosRock8 < yPosRock4 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_b5l = ((xPosRock8 + 8'd20 == xPosRock5) && (yPosRock8 + 8'd20 > yPosRock5) && (yPosRock8 < yPosRock5 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_b6l = ((xPosRock8 + 8'd20 == xPosRock6) && (yPosRock8 + 8'd20 > yPosRock6) && (yPosRock8 < yPosRock6 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_b9l = ((xPosRock8 + 8'd20 == xPosRock9) && (yPosRock8 + 8'd20 > yPosRock9) && (yPosRock8 < yPosRock9 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_b7l = ((xPosRock8 + 8'd20 == xPosRock7) && (yPosRock8 + 8'd20 > yPosRock7) && (yPosRock8 < yPosRock7 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_b10l = ((xPosRock8 + 8'd20 == xPosRock10) && (yPosRock8 + 8'd20 > yPosRock10) && (yPosRock8 < yPosRock10 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_b11l = ((xPosRock8 + 8'd20 == xPosRock11) && (yPosRock8 + 8'd20 > yPosRock11) && (yPosRock8 < yPosRock11 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_b12l = ((xPosRock8 + 8'd20 == xPosRock12) && (yPosRock8 + 8'd20 > yPosRock12) && (yPosRock8 < yPosRock12 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_b13l = ((xPosRock8 + 8'd20 == xPosRock13) && (yPosRock8 + 8'd20 > yPosRock13) && (yPosRock8 < yPosRock13 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_pl = ((xPosRock8 + 8'd20 == xPos) && (yPosRock8 + 8'd20 > yPos) && (yPosRock8 < yPos + 8'd20)) ? 1'b1 : 1'b0;

//8 right 
wire hit_a8_b1r;
wire hit_a8_b2r;
wire hit_a8_b3r;
wire hit_a8_b4r;
wire hit_a8_b5r;
wire hit_a8_b6r;
wire hit_a8_b9r;
wire hit_a8_b7r;
wire hit_a8_b10r;
wire hit_a8_b11r;
wire hit_a8_b12r;
wire hit_a8_b13r;
wire hit_a8_pr;
wire hit_a8_hr;
wire hit_a8_ler;

assign hit_a8_b1r = ((xPosRock8 == xPosRock1 + 8'd20) && (yPosRock8 + 8'd20 > yPosRock1) && (yPosRock8 < yPosRock1 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_b2r = ((xPosRock8 == xPosRock2 + 8'd20) && (yPosRock8 + 8'd20 > yPosRock2) && (yPosRock8 < yPosRock2 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_b3r = ((xPosRock8 == xPosRock3 + 8'd20) && (yPosRock8 + 8'd20 > yPosRock3) && (yPosRock8 < yPosRock3 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_b4r = ((xPosRock8 == xPosRock4 + 8'd20) && (yPosRock8 + 8'd20 > yPosRock4) && (yPosRock8 < yPosRock4 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_b5r = ((xPosRock8 == xPosRock5 + 8'd20) && (yPosRock8 + 8'd20 > yPosRock5) && (yPosRock8 < yPosRock5 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_b6r = ((xPosRock8 == xPosRock6 + 8'd20) && (yPosRock8 + 8'd20 > yPosRock6) && (yPosRock8 < yPosRock6 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_b9r = ((xPosRock8 == xPosRock9 + 8'd20) && (yPosRock8 + 8'd20 > yPosRock9) && (yPosRock8 < yPosRock9 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_b7r = ((xPosRock8 == xPosRock7 + 8'd20) && (yPosRock8 + 8'd20 > yPosRock7) && (yPosRock8 < yPosRock7 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_b10r = ((xPosRock8 == xPosRock10 + 8'd20) && (yPosRock8 + 8'd20 > yPosRock10) && (yPosRock8 < yPosRock10 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_b11r = ((xPosRock8 == xPosRock11 + 8'd20) && (yPosRock8 + 8'd20 > yPosRock11) && (yPosRock8 < yPosRock11 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_b12r = ((xPosRock8 == xPosRock12 + 8'd20) && (yPosRock8 + 8'd20 > yPosRock12) && (yPosRock8 < yPosRock12 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_b13r = ((xPosRock8 == xPosRock13 + 8'd20) && (yPosRock8 + 8'd20 > yPosRock13) && (yPosRock8 < yPosRock13 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_pr = ((xPosRock8 == xPos + 8'd20) && (yPosRock8 + 8'd20 > yPos) && (yPosRock8 < yPos + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a8_hr = ((xPosRock8 == x_ZZZ + 8'd60) && (yPosRock8 + 8'd20 > y_ZZZ) && (yPosRock8 < y_ZZZ + 8'd60)) ? 1'b1 : 1'b0;
assign hit_a8_ler = ((xPosRock8 == x_leaves + 8'd60) && (yPosRock8 + 8'd20 > y_leaves) && (yPosRock8 < y_leaves + 8'd90)) ? 1'b1 : 1'b0;

//9 top
wire hit_a9_b1t;
wire hit_a9_b2t;
wire hit_a9_b3t;
wire hit_a9_b4t;
wire hit_a9_b5t;
wire hit_a9_b6t;
wire hit_a9_b8t;
wire hit_a9_b7t;
wire hit_a9_b10t;
wire hit_a9_b11t;
wire hit_a9_b12t;
wire hit_a9_b13t;
wire hit_a9_pt;
wire hit_a9_ht;
wire hit_a9_let;

assign hit_a9_b1t = ((yPosRock9 + 8'd20 == yPosRock1) && (xPosRock9 + 8'd20 > xPosRock1) && (xPosRock9 < xPosRock1 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_b2t = ((yPosRock9 + 8'd20 == yPosRock2) && (xPosRock9 + 8'd20 > xPosRock2) && (xPosRock9 < xPosRock2 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_b3t = ((yPosRock9 + 8'd20 == yPosRock3) && (xPosRock9 + 8'd20 > xPosRock3) && (xPosRock9 < xPosRock3 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_b4t = ((yPosRock9 + 8'd20 == yPosRock4) && (xPosRock9 + 8'd20 > xPosRock4) && (xPosRock9 < xPosRock4 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_b5t = ((yPosRock9 + 8'd20 == yPosRock5) && (xPosRock9 + 8'd20 > xPosRock5) && (xPosRock9 < xPosRock5 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_b6t = ((yPosRock9 + 8'd20 == yPosRock6) && (xPosRock9 + 8'd20 > xPosRock6) && (xPosRock9 < xPosRock6 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_b8t = ((yPosRock9 + 8'd20 == yPosRock8) && (xPosRock9 + 8'd20 > xPosRock8) && (xPosRock9 < xPosRock8 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_b7t = ((yPosRock9 + 8'd20 == yPosRock7) && (xPosRock9 + 8'd20 > xPosRock7) && (xPosRock9 < xPosRock7 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_b10t = ((yPosRock9 + 8'd20 == yPosRock10) && (xPosRock9 + 8'd20 > xPosRock10) && (xPosRock9 < xPosRock10 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_b11t = ((yPosRock9 + 8'd20 == yPosRock11) && (xPosRock9 + 8'd20 > xPosRock11) && (xPosRock9 < xPosRock11 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_b12t = ((yPosRock9 + 8'd20 == yPosRock12) && (xPosRock9 + 8'd20 > xPosRock12) && (xPosRock9 < xPosRock12 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_b13t = ((yPosRock9 + 8'd20 == yPosRock13) && (xPosRock9 + 8'd20 > xPosRock13) && (xPosRock9 < xPosRock13 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_pt = ((yPosRock9 + 8'd20 == yPos) && (xPosRock9 + 8'd20 > xPos) && (xPosRock9 < xPos + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_ht = ((yPosRock9 + 8'd20 == y_ZZZ) && (xPosRock9 + 8'd20 > x_ZZZ) && (xPosRock9 < x_ZZZ + 8'd60)) ? 1'b1 : 1'b0;
assign hit_a9_let = ((yPosRock9 + 8'd20 == y_leaves) && (xPosRock9 + 8'd20 > x_leaves) && (xPosRock9 < x_leaves + 8'd60)) ? 1'b1 : 1'b0;

//9 bottom 
wire hit_a9_b1b;
wire hit_a9_b2b;
wire hit_a9_b3b;
wire hit_a9_b4b;
wire hit_a9_b5b;
wire hit_a9_b6b;
wire hit_a9_b8b;
wire hit_a9_b7b;
wire hit_a9_b10b;
wire hit_a9_b11b;
wire hit_a9_b12b;
wire hit_a9_b13b;
wire hit_a9_pb;

assign hit_a9_b1b = ((yPosRock9 == yPosRock1 + 8'd20) && (xPosRock9 + 8'd20 > xPosRock1) && (xPosRock9 < xPosRock1 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_b2b = ((yPosRock9 == yPosRock2 + 8'd20) && (xPosRock9 + 8'd20 > xPosRock2) && (xPosRock9 < xPosRock2 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_b3b = ((yPosRock9 == yPosRock3 + 8'd20) && (xPosRock9 + 8'd20 > xPosRock3) && (xPosRock9 < xPosRock3 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_b4b = ((yPosRock9 == yPosRock4 + 8'd20) && (xPosRock9 + 8'd20 > xPosRock4) && (xPosRock9 < xPosRock4 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_b5b = ((yPosRock9 == yPosRock5 + 8'd20) && (xPosRock9 + 8'd20 > xPosRock5) && (xPosRock9 < xPosRock5 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_b6b = ((yPosRock9 == yPosRock6 + 8'd20) && (xPosRock9 + 8'd20 > xPosRock6) && (xPosRock9 < xPosRock6 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_b8b = ((yPosRock9 == yPosRock8 + 8'd20) && (xPosRock9 + 8'd20 > xPosRock8) && (xPosRock9 < xPosRock8 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_b7b = ((yPosRock9 == yPosRock7 + 8'd20) && (xPosRock9 + 8'd20 > xPosRock7) && (xPosRock9 < xPosRock7 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_b10b = ((yPosRock9 == yPosRock10 + 8'd20) && (xPosRock9 + 8'd20 > xPosRock10) && (xPosRock9 < xPosRock10 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_b11b = ((yPosRock9 == yPosRock11 + 8'd20) && (xPosRock9 + 8'd20 > xPosRock11) && (xPosRock9 < xPosRock11 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_b12b = ((yPosRock9 == yPosRock12 + 8'd20) && (xPosRock9 + 8'd20 > xPosRock12) && (xPosRock9 < xPosRock12 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_b13b = ((yPosRock9 == yPosRock13 + 8'd20) && (xPosRock9 + 8'd20 > xPosRock13) && (xPosRock9 < xPosRock13 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_pb = ((yPosRock9 == yPos + 8'd20) && (xPosRock9 + 8'd20 > xPos) && (xPosRock9 < xPos + 8'd20)) ? 1'b1 : 1'b0;

//9 left 
wire hit_a9_b1l;
wire hit_a9_b2l;
wire hit_a9_b3l;
wire hit_a9_b4l;
wire hit_a9_b5l;
wire hit_a9_b6l;
wire hit_a9_b8l;
wire hit_a9_b7l;
wire hit_a9_b10l;
wire hit_a9_b11l;
wire hit_a9_b12l;
wire hit_a9_b13l;
wire hit_a9_pl;

assign hit_a9_b1l = ((xPosRock9 + 8'd20 == xPosRock1) && (yPosRock9 + 8'd20 > yPosRock1) && (yPosRock9 < yPosRock1 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_b2l = ((xPosRock9 + 8'd20 == xPosRock2) && (yPosRock9 + 8'd20 > yPosRock2) && (yPosRock9 < yPosRock2 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_b3l = ((xPosRock9 + 8'd20 == xPosRock3) && (yPosRock9 + 8'd20 > yPosRock3) && (yPosRock9 < yPosRock3 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_b4l = ((xPosRock9 + 8'd20 == xPosRock4) && (yPosRock9 + 8'd20 > yPosRock4) && (yPosRock9 < yPosRock4 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_b5l = ((xPosRock9 + 8'd20 == xPosRock5) && (yPosRock9 + 8'd20 > yPosRock5) && (yPosRock9 < yPosRock5 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_b6l = ((xPosRock9 + 8'd20 == xPosRock6) && (yPosRock9 + 8'd20 > yPosRock6) && (yPosRock9 < yPosRock6 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_b8l = ((xPosRock9 + 8'd20 == xPosRock8) && (yPosRock9 + 8'd20 > yPosRock8) && (yPosRock9 < yPosRock8 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_b7l = ((xPosRock9 + 8'd20 == xPosRock7) && (yPosRock9 + 8'd20 > yPosRock7) && (yPosRock9 < yPosRock7 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_b10l = ((xPosRock9 + 8'd20 == xPosRock10) && (yPosRock9 + 8'd20 > yPosRock10) && (yPosRock9 < yPosRock10 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_b11l = ((xPosRock9 + 8'd20 == xPosRock11) && (yPosRock9 + 8'd20 > yPosRock11) && (yPosRock9 < yPosRock11 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_b12l = ((xPosRock9 + 8'd20 == xPosRock12) && (yPosRock9 + 8'd20 > yPosRock12) && (yPosRock9 < yPosRock12 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_b13l = ((xPosRock9 + 8'd20 == xPosRock13) && (yPosRock9 + 8'd20 > yPosRock13) && (yPosRock9 < yPosRock13 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_pl = ((xPosRock9 + 8'd20 == xPos) && (yPosRock9 + 8'd20 > yPos) && (yPosRock9 < yPos + 8'd20)) ? 1'b1 : 1'b0;

//9 right 
wire hit_a9_b1r;
wire hit_a9_b2r;
wire hit_a9_b3r;
wire hit_a9_b4r;
wire hit_a9_b5r;
wire hit_a9_b6r;
wire hit_a9_b8r;
wire hit_a9_b7r;
wire hit_a9_b10r;
wire hit_a9_b11r;
wire hit_a9_b12r;
wire hit_a9_b13r;
wire hit_a9_pr;
wire hit_a9_hr;
wire hit_a9_ler;

assign hit_a9_b1r = ((xPosRock9 == xPosRock1 + 8'd20) && (yPosRock9 + 8'd20 > yPosRock1) && (yPosRock9 < yPosRock1 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_b2r = ((xPosRock9 == xPosRock2 + 8'd20) && (yPosRock9 + 8'd20 > yPosRock2) && (yPosRock9 < yPosRock2 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_b3r = ((xPosRock9 == xPosRock3 + 8'd20) && (yPosRock9 + 8'd20 > yPosRock3) && (yPosRock9 < yPosRock3 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_b4r = ((xPosRock9 == xPosRock4 + 8'd20) && (yPosRock9 + 8'd20 > yPosRock4) && (yPosRock9 < yPosRock4 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_b5r = ((xPosRock9 == xPosRock5 + 8'd20) && (yPosRock9 + 8'd20 > yPosRock5) && (yPosRock9 < yPosRock5 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_b6r = ((xPosRock9 == xPosRock6 + 8'd20) && (yPosRock9 + 8'd20 > yPosRock6) && (yPosRock9 < yPosRock6 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_b8r = ((xPosRock9 == xPosRock8 + 8'd20) && (yPosRock9 + 8'd20 > yPosRock8) && (yPosRock9 < yPosRock8 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_b7r = ((xPosRock9 == xPosRock7 + 8'd20) && (yPosRock9 + 8'd20 > yPosRock7) && (yPosRock9 < yPosRock7 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_b10r = ((xPosRock9 == xPosRock10 + 8'd20) && (yPosRock9 + 8'd20 > yPosRock10) && (yPosRock9 < yPosRock10 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_b11r = ((xPosRock9 == xPosRock11 + 8'd20) && (yPosRock9 + 8'd20 > yPosRock11) && (yPosRock9 < yPosRock11 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_b12r = ((xPosRock9 == xPosRock12 + 8'd20) && (yPosRock9 + 8'd20 > yPosRock12) && (yPosRock9 < yPosRock12 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_b13r = ((xPosRock9 == xPosRock13 + 8'd20) && (yPosRock9 + 8'd20 > yPosRock13) && (yPosRock9 < yPosRock13 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_pr = ((xPosRock9 == xPos + 8'd20) && (yPosRock9 + 8'd20 > yPos) && (yPosRock9 < yPos + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a9_hr = ((xPosRock9 == x_ZZZ + 8'd60) && (yPosRock9 + 8'd20 > y_ZZZ) && (yPosRock9 < y_ZZZ + 8'd60)) ? 1'b1 : 1'b0;
assign hit_a9_ler = ((xPosRock9 == x_leaves + 8'd60) && (yPosRock9 + 8'd20 > y_leaves) && (yPosRock9 < y_leaves + 8'd90)) ? 1'b1 : 1'b0;

//10 top
wire hit_a10_b1t;
wire hit_a10_b2t;
wire hit_a10_b3t;
wire hit_a10_b4t;
wire hit_a10_b5t;
wire hit_a10_b6t;
wire hit_a10_b8t;
wire hit_a10_b7t;
wire hit_a10_b9t;
wire hit_a10_b11t;
wire hit_a10_b12t;
wire hit_a10_b13t;
wire hit_a10_pt;
wire hit_a10_ht;
wire hit_a10_let;

assign hit_a10_b1t = ((yPosRock10 + 8'd20 == yPosRock1) && (xPosRock10 + 8'd20 > xPosRock1) && (xPosRock10 < xPosRock1 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_b2t = ((yPosRock10 + 8'd20 == yPosRock2) && (xPosRock10 + 8'd20 > xPosRock2) && (xPosRock10 < xPosRock2 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_b3t = ((yPosRock10 + 8'd20 == yPosRock3) && (xPosRock10 + 8'd20 > xPosRock3) && (xPosRock10 < xPosRock3 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_b4t = ((yPosRock10 + 8'd20 == yPosRock4) && (xPosRock10 + 8'd20 > xPosRock4) && (xPosRock10 < xPosRock4 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_b5t = ((yPosRock10 + 8'd20 == yPosRock5) && (xPosRock10 + 8'd20 > xPosRock5) && (xPosRock10 < xPosRock5 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_b6t = ((yPosRock10 + 8'd20 == yPosRock6) && (xPosRock10 + 8'd20 > xPosRock6) && (xPosRock10 < xPosRock6 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_b8t = ((yPosRock10 + 8'd20 == yPosRock8) && (xPosRock10 + 8'd20 > xPosRock8) && (xPosRock10 < xPosRock8 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_b7t = ((yPosRock10 + 8'd20 == yPosRock7) && (xPosRock10 + 8'd20 > xPosRock7) && (xPosRock10 < xPosRock7 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_b9t = ((yPosRock10 + 8'd20 == yPosRock9) && (xPosRock10 + 8'd20 > xPosRock9) && (xPosRock10 < xPosRock9 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_b11t = ((yPosRock10 + 8'd20 == yPosRock11) && (xPosRock10 + 8'd20 > xPosRock11) && (xPosRock10 < xPosRock11 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_b12t = ((yPosRock10 + 8'd20 == yPosRock12) && (xPosRock10 + 8'd20 > xPosRock12) && (xPosRock10 < xPosRock12 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_b13t = ((yPosRock10 + 8'd20 == yPosRock13) && (xPosRock10 + 8'd20 > xPosRock13) && (xPosRock10 < xPosRock13 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_pt = ((yPosRock10 + 8'd20 == yPos) && (xPosRock10 + 8'd20 > xPos) && (xPosRock10 < xPos + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_ht = ((yPosRock10 + 8'd20 == y_ZZZ) && (xPosRock10 + 8'd20 > x_ZZZ) && (xPosRock10 < x_ZZZ + 8'd60)) ? 1'b1 : 1'b0;
assign hit_a10_let = ((yPosRock10 + 8'd20 == y_leaves) && (xPosRock10 + 8'd20 > x_leaves) && (xPosRock10 < x_leaves + 8'd60)) ? 1'b1 : 1'b0;

//10 bottom 
wire hit_a10_b1b;
wire hit_a10_b2b;
wire hit_a10_b3b;
wire hit_a10_b4b;
wire hit_a10_b5b;
wire hit_a10_b6b;
wire hit_a10_b8b;
wire hit_a10_b7b;
wire hit_a10_b9b;
wire hit_a10_b11b;
wire hit_a10_b12b;
wire hit_a10_b13b;
wire hit_a10_pb;

assign hit_a10_b1b = ((yPosRock10 == yPosRock1 + 8'd20) && (xPosRock10 + 8'd20 > xPosRock1) && (xPosRock10 < xPosRock1 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_b2b = ((yPosRock10 == yPosRock2 + 8'd20) && (xPosRock10 + 8'd20 > xPosRock2) && (xPosRock10 < xPosRock2 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_b3b = ((yPosRock10 == yPosRock3 + 8'd20) && (xPosRock10 + 8'd20 > xPosRock3) && (xPosRock10 < xPosRock3 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_b4b = ((yPosRock10 == yPosRock4 + 8'd20) && (xPosRock10 + 8'd20 > xPosRock4) && (xPosRock10 < xPosRock4 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_b5b = ((yPosRock10 == yPosRock5 + 8'd20) && (xPosRock10 + 8'd20 > xPosRock5) && (xPosRock10 < xPosRock5 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_b6b = ((yPosRock10 == yPosRock6 + 8'd20) && (xPosRock10 + 8'd20 > xPosRock6) && (xPosRock10 < xPosRock6 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_b8b = ((yPosRock10 == yPosRock8 + 8'd20) && (xPosRock10 + 8'd20 > xPosRock8) && (xPosRock10 < xPosRock8 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_b7b = ((yPosRock10 == yPosRock7 + 8'd20) && (xPosRock10 + 8'd20 > xPosRock7) && (xPosRock10 < xPosRock7 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_b9b = ((yPosRock10 == yPosRock9 + 8'd20) && (xPosRock10 + 8'd20 > xPosRock9) && (xPosRock10 < xPosRock9 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_b11b = ((yPosRock10 == yPosRock11 + 8'd20) && (xPosRock10 + 8'd20 > xPosRock11) && (xPosRock10 < xPosRock11 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_b12b = ((yPosRock10 == yPosRock12 + 8'd20) && (xPosRock10 + 8'd20 > xPosRock12) && (xPosRock10 < xPosRock12 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_b13b = ((yPosRock10 == yPosRock13 + 8'd20) && (xPosRock10 + 8'd20 > xPosRock13) && (xPosRock10 < xPosRock13 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_pb = ((yPosRock10 == yPos + 8'd20) && (xPosRock10 + 8'd20 > xPos) && (xPosRock10 < xPos + 8'd20)) ? 1'b1 : 1'b0;

//10 left 
wire hit_a10_b1l;
wire hit_a10_b2l;
wire hit_a10_b3l;
wire hit_a10_b4l;
wire hit_a10_b5l;
wire hit_a10_b6l;
wire hit_a10_b8l;
wire hit_a10_b7l;
wire hit_a10_b9l;
wire hit_a10_b11l;
wire hit_a10_b12l;
wire hit_a10_b13l;
wire hit_a10_pl;

assign hit_a10_b1l = ((xPosRock10 + 8'd20 == xPosRock1) && (yPosRock10 + 8'd20 > yPosRock1) && (yPosRock10 < yPosRock1 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_b2l = ((xPosRock10 + 8'd20 == xPosRock2) && (yPosRock10 + 8'd20 > yPosRock2) && (yPosRock10 < yPosRock2 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_b3l = ((xPosRock10 + 8'd20 == xPosRock3) && (yPosRock10 + 8'd20 > yPosRock3) && (yPosRock10 < yPosRock3 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_b4l = ((xPosRock10 + 8'd20 == xPosRock4) && (yPosRock10 + 8'd20 > yPosRock4) && (yPosRock10 < yPosRock4 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_b5l = ((xPosRock10 + 8'd20 == xPosRock5) && (yPosRock10 + 8'd20 > yPosRock5) && (yPosRock10 < yPosRock5 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_b6l = ((xPosRock10 + 8'd20 == xPosRock6) && (yPosRock10 + 8'd20 > yPosRock6) && (yPosRock10 < yPosRock6 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_b8l = ((xPosRock10 + 8'd20 == xPosRock8) && (yPosRock10 + 8'd20 > yPosRock8) && (yPosRock10 < yPosRock8 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_b7l = ((xPosRock10 + 8'd20 == xPosRock7) && (yPosRock10 + 8'd20 > yPosRock7) && (yPosRock10 < yPosRock7 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_b9l = ((xPosRock10 + 8'd20 == xPosRock9) && (yPosRock10 + 8'd20 > yPosRock9) && (yPosRock10 < yPosRock9 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_b11l = ((xPosRock10 + 8'd20 == xPosRock11) && (yPosRock10 + 8'd20 > yPosRock11) && (yPosRock10 < yPosRock11 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_b12l = ((xPosRock10 + 8'd20 == xPosRock12) && (yPosRock10 + 8'd20 > yPosRock12) && (yPosRock10 < yPosRock12 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_b13l = ((xPosRock10 + 8'd20 == xPosRock13) && (yPosRock10 + 8'd20 > yPosRock13) && (yPosRock10 < yPosRock13 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_pl = ((xPosRock10 + 8'd20 == xPos) && (yPosRock10 + 8'd20 > yPos) && (yPosRock10 < yPos + 8'd20)) ? 1'b1 : 1'b0;

//10 right 
wire hit_a10_b1r;
wire hit_a10_b2r;
wire hit_a10_b3r;
wire hit_a10_b4r;
wire hit_a10_b5r;
wire hit_a10_b6r;
wire hit_a10_b8r;
wire hit_a10_b7r;
wire hit_a10_b9r;
wire hit_a10_b11r;
wire hit_a10_b12r;
wire hit_a10_b13r;
wire hit_a10_pr;
wire hit_a10_hr;
wire hit_a10_ler;

assign hit_a10_b1r = ((xPosRock10 == xPosRock1 + 8'd20) && (yPosRock10 + 8'd20 > yPosRock1) && (yPosRock10 < yPosRock1 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_b2r = ((xPosRock10 == xPosRock2 + 8'd20) && (yPosRock10 + 8'd20 > yPosRock2) && (yPosRock10 < yPosRock2 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_b3r = ((xPosRock10 == xPosRock3 + 8'd20) && (yPosRock10 + 8'd20 > yPosRock3) && (yPosRock10 < yPosRock3 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_b4r = ((xPosRock10 == xPosRock4 + 8'd20) && (yPosRock10 + 8'd20 > yPosRock4) && (yPosRock10 < yPosRock4 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_b5r = ((xPosRock10 == xPosRock5 + 8'd20) && (yPosRock10 + 8'd20 > yPosRock5) && (yPosRock10 < yPosRock5 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_b6r = ((xPosRock10 == xPosRock6 + 8'd20) && (yPosRock10 + 8'd20 > yPosRock6) && (yPosRock10 < yPosRock6 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_b8r = ((xPosRock10 == xPosRock8 + 8'd20) && (yPosRock10 + 8'd20 > yPosRock8) && (yPosRock10 < yPosRock8 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_b7r = ((xPosRock10 == xPosRock7 + 8'd20) && (yPosRock10 + 8'd20 > yPosRock7) && (yPosRock10 < yPosRock7 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_b9r = ((xPosRock10 == xPosRock9 + 8'd20) && (yPosRock10 + 8'd20 > yPosRock9) && (yPosRock10 < yPosRock9 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_b11r = ((xPosRock10 == xPosRock11 + 8'd20) && (yPosRock10 + 8'd20 > yPosRock11) && (yPosRock10 < yPosRock11 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_b12r = ((xPosRock10 == xPosRock12 + 8'd20) && (yPosRock10 + 8'd20 > yPosRock12) && (yPosRock10 < yPosRock12 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_b13r = ((xPosRock10 == xPosRock13 + 8'd20) && (yPosRock10 + 8'd20 > yPosRock13) && (yPosRock10 < yPosRock13 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_pr = ((xPosRock10 == xPos + 8'd20) && (yPosRock10 + 8'd20 > yPos) && (yPosRock10 < yPos + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a10_hr = ((xPosRock10 == x_ZZZ + 8'd60) && (yPosRock10 + 8'd20 > y_ZZZ) && (yPosRock10 < y_ZZZ + 8'd60)) ? 1'b1 : 1'b0;
assign hit_a10_ler = ((xPosRock10 == x_leaves + 8'd60) && (yPosRock10 + 8'd20 > y_leaves) && (yPosRock10 < y_leaves + 8'd90)) ? 1'b1 : 1'b0;

//11 top
wire hit_a11_b1t;
wire hit_a11_b2t;
wire hit_a11_b3t;
wire hit_a11_b4t;
wire hit_a11_b5t;
wire hit_a11_b6t;
wire hit_a11_b8t;
wire hit_a11_b7t;
wire hit_a11_b9t;
wire hit_a11_b10t;
wire hit_a11_b12t;
wire hit_a11_b13t;
wire hit_a11_pt;
wire hit_a11_ht;
wire hit_a11_let;

assign hit_a11_b1t = ((yPosRock11 + 8'd20 == yPosRock1) && (xPosRock11 + 8'd20 > xPosRock1) && (xPosRock11 < xPosRock1 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_b2t = ((yPosRock11 + 8'd20 == yPosRock2) && (xPosRock11 + 8'd20 > xPosRock2) && (xPosRock11 < xPosRock2 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_b3t = ((yPosRock11 + 8'd20 == yPosRock3) && (xPosRock11 + 8'd20 > xPosRock3) && (xPosRock11 < xPosRock3 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_b4t = ((yPosRock11 + 8'd20 == yPosRock4) && (xPosRock11 + 8'd20 > xPosRock4) && (xPosRock11 < xPosRock4 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_b5t = ((yPosRock11 + 8'd20 == yPosRock5) && (xPosRock11 + 8'd20 > xPosRock5) && (xPosRock11 < xPosRock5 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_b6t = ((yPosRock11 + 8'd20 == yPosRock6) && (xPosRock11 + 8'd20 > xPosRock6) && (xPosRock11 < xPosRock6 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_b8t = ((yPosRock11 + 8'd20 == yPosRock8) && (xPosRock11 + 8'd20 > xPosRock8) && (xPosRock11 < xPosRock8 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_b7t = ((yPosRock11 + 8'd20 == yPosRock7) && (xPosRock11 + 8'd20 > xPosRock7) && (xPosRock11 < xPosRock7 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_b9t = ((yPosRock11 + 8'd20 == yPosRock9) && (xPosRock11 + 8'd20 > xPosRock9) && (xPosRock11 < xPosRock9 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_b10t = ((yPosRock11 + 8'd20 == yPosRock10) && (xPosRock11 + 8'd20 > xPosRock10) && (xPosRock11 < xPosRock10 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_b12t = ((yPosRock11 + 8'd20 == yPosRock12) && (xPosRock11 + 8'd20 > xPosRock12) && (xPosRock11 < xPosRock12 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_b13t = ((yPosRock11 + 8'd20 == yPosRock13) && (xPosRock11 + 8'd20 > xPosRock13) && (xPosRock11 < xPosRock13 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_pt = ((yPosRock11 + 8'd20 == yPos) && (xPosRock11 + 8'd20 > xPos) && (xPosRock11 < xPos + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_ht = ((yPosRock11 + 8'd20 == y_ZZZ) && (xPosRock11 + 8'd20 > x_ZZZ) && (xPosRock11 < x_ZZZ + 8'd60)) ? 1'b1 : 1'b0;
assign hit_a11_let = ((yPosRock11 + 8'd20 == y_leaves) && (xPosRock11 + 8'd20 > x_leaves) && (xPosRock11 < x_leaves + 8'd60)) ? 1'b1 : 1'b0;

//11 bottom
wire hit_a11_b1b;
wire hit_a11_b2b;
wire hit_a11_b3b;
wire hit_a11_b4b;
wire hit_a11_b5b;
wire hit_a11_b6b;
wire hit_a11_b8b;
wire hit_a11_b7b;
wire hit_a11_b19b;
wire hit_a11_b10b;
wire hit_a11_b12b;
wire hit_a11_b13b;
wire hit_a11_pb;

assign hit_a11_b1b = ((yPosRock11 == yPosRock1 + 8'd20) && (xPosRock11 + 8'd20 > xPosRock1) && (xPosRock11 < xPosRock1 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_b2b = ((yPosRock11 == yPosRock2 + 8'd20) && (xPosRock11 + 8'd20 > xPosRock2) && (xPosRock11 < xPosRock2 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_b3b = ((yPosRock11 == yPosRock3 + 8'd20) && (xPosRock11 + 8'd20 > xPosRock3) && (xPosRock11 < xPosRock3 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_b4b = ((yPosRock11 == yPosRock4 + 8'd20) && (xPosRock11 + 8'd20 > xPosRock4) && (xPosRock11 < xPosRock4 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_b5b = ((yPosRock11 == yPosRock5 + 8'd20) && (xPosRock11 + 8'd20 > xPosRock5) && (xPosRock11 < xPosRock5 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_b6b = ((yPosRock11 == yPosRock6 + 8'd20) && (xPosRock11 + 8'd20 > xPosRock6) && (xPosRock11 < xPosRock6 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_b8b = ((yPosRock11 == yPosRock8 + 8'd20) && (xPosRock11 + 8'd20 > xPosRock8) && (xPosRock11 < xPosRock8 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_b7b = ((yPosRock11 == yPosRock7 + 8'd20) && (xPosRock11 + 8'd20 > xPosRock7) && (xPosRock11 < xPosRock7 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_b9b = ((yPosRock11 == yPosRock9 + 8'd20) && (xPosRock11 + 8'd20 > xPosRock9) && (xPosRock11 < xPosRock9 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_b10b = ((yPosRock11 == yPosRock10 + 8'd20) && (xPosRock11 + 8'd20 > xPosRock10) && (xPosRock11 < xPosRock10 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_b12b = ((yPosRock11 == yPosRock12 + 8'd20) && (xPosRock11 + 8'd20 > xPosRock12) && (xPosRock11 < xPosRock12 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_b13b = ((yPosRock11 == yPosRock13 + 8'd20) && (xPosRock11 + 8'd20 > xPosRock13) && (xPosRock11 < xPosRock13 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_pb = ((yPosRock11 == yPos + 8'd20) && (xPosRock11 + 8'd20 > xPos) && (xPosRock11 < xPos + 8'd20)) ? 1'b1 : 1'b0;

//11 left
wire hit_a11_b1l;
wire hit_a11_b2l;
wire hit_a11_b3l;
wire hit_a11_b4l;
wire hit_a11_b5l;
wire hit_a11_b6l;
wire hit_a11_b8l;
wire hit_a11_b7l;
wire hit_a11_b9l;
wire hit_a11_b10l;
wire hit_a11_b12l;
wire hit_a11_b13l;
wire hit_a11_pl;

assign hit_a11_b1l = ((xPosRock11 + 8'd20 == xPosRock1) && (yPosRock11 + 8'd20 > yPosRock1) && (yPosRock11 < yPosRock1 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_b2l = ((xPosRock11 + 8'd20 == xPosRock2) && (yPosRock11 + 8'd20 > yPosRock2) && (yPosRock11 < yPosRock2 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_b3l = ((xPosRock11 + 8'd20 == xPosRock3) && (yPosRock11 + 8'd20 > yPosRock3) && (yPosRock11 < yPosRock3 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_b4l = ((xPosRock11 + 8'd20 == xPosRock4) && (yPosRock11 + 8'd20 > yPosRock4) && (yPosRock11 < yPosRock4 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_b5l = ((xPosRock11 + 8'd20 == xPosRock5) && (yPosRock11 + 8'd20 > yPosRock5) && (yPosRock11 < yPosRock5 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_b6l = ((xPosRock11 + 8'd20 == xPosRock6) && (yPosRock11 + 8'd20 > yPosRock6) && (yPosRock11 < yPosRock6 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_b8l = ((xPosRock11 + 8'd20 == xPosRock8) && (yPosRock11 + 8'd20 > yPosRock8) && (yPosRock11 < yPosRock8 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_b7l = ((xPosRock11 + 8'd20 == xPosRock7) && (yPosRock11 + 8'd20 > yPosRock7) && (yPosRock11 < yPosRock7 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_b9l = ((xPosRock11 + 8'd20 == xPosRock9) && (yPosRock11 + 8'd20 > yPosRock9) && (yPosRock11 < yPosRock9 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_b10l = ((xPosRock11 + 8'd20 == xPosRock10) && (yPosRock11 + 8'd20 > yPosRock10) && (yPosRock11 < yPosRock10 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_b12l = ((xPosRock11 + 8'd20 == xPosRock12) && (yPosRock11 + 8'd20 > yPosRock12) && (yPosRock11 < yPosRock12 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_b13l = ((xPosRock11 + 8'd20 == xPosRock13) && (yPosRock11 + 8'd20 > yPosRock13) && (yPosRock11 < yPosRock13 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_pl = ((xPosRock11 + 8'd20 == xPos) && (yPosRock11 + 8'd20 > yPos) && (yPosRock11 < yPos + 8'd20)) ? 1'b1 : 1'b0;

//11 right
wire hit_a11_b1r;
wire hit_a11_b2r;
wire hit_a11_b3r;
wire hit_a11_b4r;
wire hit_a11_b5r;
wire hit_a11_b6r;
wire hit_a11_b8r;
wire hit_a11_b7r;
wire hit_a11_b9r;
wire hit_a11_b10r;
wire hit_a11_b12r;
wire hit_a11_b13r;
wire hit_a11_pr;
wire hit_a11_hr;
wire hit_a11_ler;

assign hit_a11_b1r = ((xPosRock11 == xPosRock1 + 8'd20) && (yPosRock11 + 8'd20 > yPosRock1) && (yPosRock11 < yPosRock1 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_b2r = ((xPosRock11 == xPosRock2 + 8'd20) && (yPosRock11 + 8'd20 > yPosRock2) && (yPosRock11 < yPosRock2 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_b3r = ((xPosRock11 == xPosRock3 + 8'd20) && (yPosRock11 + 8'd20 > yPosRock3) && (yPosRock11 < yPosRock3 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_b4r = ((xPosRock11 == xPosRock4 + 8'd20) && (yPosRock11 + 8'd20 > yPosRock4) && (yPosRock11 < yPosRock4 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_b5r = ((xPosRock11 == xPosRock5 + 8'd20) && (yPosRock11 + 8'd20 > yPosRock5) && (yPosRock11 < yPosRock5 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_b6r = ((xPosRock11 == xPosRock6 + 8'd20) && (yPosRock11 + 8'd20 > yPosRock6) && (yPosRock11 < yPosRock6 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_b8r = ((xPosRock11 == xPosRock8 + 8'd20) && (yPosRock11 + 8'd20 > yPosRock8) && (yPosRock11 < yPosRock8 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_b7r = ((xPosRock11 == xPosRock7 + 8'd20) && (yPosRock11 + 8'd20 > yPosRock7) && (yPosRock11 < yPosRock7 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_b9r = ((xPosRock11 == xPosRock9 + 8'd20) && (yPosRock11 + 8'd20 > yPosRock9) && (yPosRock11 < yPosRock9 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_b10r = ((xPosRock11 == xPosRock10 + 8'd20) && (yPosRock11 + 8'd20 > yPosRock10) && (yPosRock11 < yPosRock10 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_b12r = ((xPosRock11 == xPosRock12 + 8'd20) && (yPosRock11 + 8'd20 > yPosRock12) && (yPosRock11 < yPosRock12 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_b13r = ((xPosRock11 == xPosRock13 + 8'd20) && (yPosRock11 + 8'd20 > yPosRock13) && (yPosRock11 < yPosRock13 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_pr = ((xPosRock11 == xPos + 8'd20) && (yPosRock11 + 8'd20 > yPos) && (yPosRock11 < yPos + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a11_hr = ((xPosRock11 == x_ZZZ + 8'd60) && (yPosRock11 + 8'd20 > y_ZZZ) && (yPosRock11 < y_ZZZ + 8'd60)) ? 1'b1 : 1'b0;
assign hit_a11_ler = ((xPosRock11 == x_leaves + 8'd60) && (yPosRock11 + 8'd20 > y_leaves) && (yPosRock11 < y_leaves + 8'd90)) ? 1'b1 : 1'b0;
	
//12 top
wire hit_a12_b1t;
wire hit_a12_b2t;
wire hit_a12_b3t;
wire hit_a12_b4t;
wire hit_a12_b5t;
wire hit_a12_b6t;
wire hit_a12_b8t;
wire hit_a12_b7t;
wire hit_a12_b9t;
wire hit_a12_b10t;
wire hit_a12_b11t;
wire hit_a12_b13t;
wire hit_a12_pt;
wire hit_a12_ht;
wire hit_a12_let;

assign hit_a12_b1t = ((yPosRock12 + 8'd20 == yPosRock1) && (xPosRock12 + 8'd20 > xPosRock1) && (xPosRock12 < xPosRock1 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_b2t = ((yPosRock12 + 8'd20 == yPosRock2) && (xPosRock12 + 8'd20 > xPosRock2) && (xPosRock12 < xPosRock2 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_b3t = ((yPosRock12 + 8'd20 == yPosRock3) && (xPosRock12 + 8'd20 > xPosRock3) && (xPosRock12 < xPosRock3 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_b4t = ((yPosRock12 + 8'd20 == yPosRock4) && (xPosRock12 + 8'd20 > xPosRock4) && (xPosRock12 < xPosRock4 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_b5t = ((yPosRock12 + 8'd20 == yPosRock5) && (xPosRock12 + 8'd20 > xPosRock5) && (xPosRock12 < xPosRock5 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_b6t = ((yPosRock12 + 8'd20 == yPosRock6) && (xPosRock12 + 8'd20 > xPosRock6) && (xPosRock12 < xPosRock6 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_b8t = ((yPosRock12 + 8'd20 == yPosRock8) && (xPosRock12 + 8'd20 > xPosRock8) && (xPosRock12 < xPosRock8 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_b7t = ((yPosRock12 + 8'd20 == yPosRock7) && (xPosRock12 + 8'd20 > xPosRock7) && (xPosRock12 < xPosRock7 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_b9t = ((yPosRock12 + 8'd20 == yPosRock9) && (xPosRock12 + 8'd20 > xPosRock9) && (xPosRock12 < xPosRock9 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_b10t = ((yPosRock12 + 8'd20 == yPosRock10) && (xPosRock12 + 8'd20 > xPosRock10) && (xPosRock12 < xPosRock10 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_b11t = ((yPosRock12 + 8'd20 == yPosRock11) && (xPosRock12 + 8'd20 > xPosRock11) && (xPosRock12 < xPosRock11 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_b13t = ((yPosRock12 + 8'd20 == yPosRock13) && (xPosRock12 + 8'd20 > xPosRock13) && (xPosRock12 < xPosRock13 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_pt = ((yPosRock12 + 8'd20 == yPos) && (xPosRock12 + 8'd20 > xPos) && (xPosRock12 < xPos + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_ht = ((yPosRock12 + 8'd20 == y_ZZZ) && (xPosRock12 + 8'd20 > x_ZZZ) && (xPosRock12 < x_ZZZ + 8'd60)) ? 1'b1 : 1'b0;
assign hit_a12_let = ((yPosRock12 + 8'd20 == y_leaves) && (xPosRock12 + 8'd20 > x_leaves) && (xPosRock12 < x_leaves + 8'd60)) ? 1'b1 : 1'b0;

//12 bottom
wire hit_a12_b1b;
wire hit_a12_b2b;
wire hit_a12_b3b;
wire hit_a12_b4b;
wire hit_a12_b5b;
wire hit_a12_b6b;
wire hit_a12_b8b;
wire hit_a12_b7b;
wire hit_a12_b9b;
wire hit_a12_b10b;
wire hit_a12_b11b;
wire hit_a12_b13b;
wire hit_a12_pb;

assign hit_a12_b1b = ((yPosRock12 == yPosRock1 + 8'd20) && (xPosRock12 + 8'd20 > xPosRock1) && (xPosRock12 < xPosRock1 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_b2b = ((yPosRock12 == yPosRock2 + 8'd20) && (xPosRock12 + 8'd20 > xPosRock2) && (xPosRock12 < xPosRock2 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_b3b = ((yPosRock12 == yPosRock3 + 8'd20) && (xPosRock12 + 8'd20 > xPosRock3) && (xPosRock12 < xPosRock3 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_b4b = ((yPosRock12 == yPosRock4 + 8'd20) && (xPosRock12 + 8'd20 > xPosRock4) && (xPosRock12 < xPosRock4 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_b5b = ((yPosRock12 == yPosRock5 + 8'd20) && (xPosRock12 + 8'd20 > xPosRock5) && (xPosRock12 < xPosRock5 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_b6b = ((yPosRock12 == yPosRock6 + 8'd20) && (xPosRock12 + 8'd20 > xPosRock6) && (xPosRock12 < xPosRock6 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_b8b = ((yPosRock12 == yPosRock8 + 8'd20) && (xPosRock12 + 8'd20 > xPosRock8) && (xPosRock12 < xPosRock8 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_b7b = ((yPosRock12 == yPosRock7 + 8'd20) && (xPosRock12 + 8'd20 > xPosRock7) && (xPosRock12 < xPosRock7 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_b9b = ((yPosRock12 == yPosRock9 + 8'd20) && (xPosRock12 + 8'd20 > xPosRock9) && (xPosRock12 < xPosRock9 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_b10b = ((yPosRock12 == yPosRock10 + 8'd20) && (xPosRock12 + 8'd20 > xPosRock10) && (xPosRock12 < xPosRock10 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_b11b = ((yPosRock12 == yPosRock11 + 8'd20) && (xPosRock12 + 8'd20 > xPosRock11) && (xPosRock12 < xPosRock11 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_b13b = ((yPosRock12 == yPosRock13 + 8'd20) && (xPosRock12 + 8'd20 > xPosRock13) && (xPosRock12 < xPosRock13 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_pb = ((yPosRock12 == yPos + 8'd20) && (xPosRock12 + 8'd20 > xPos) && (xPosRock12 < xPos + 8'd20)) ? 1'b1 : 1'b0;

// 12 left
wire hit_a12_b1l;
wire hit_a12_b2l;
wire hit_a12_b3l;
wire hit_a12_b4l;
wire hit_a12_b5l;
wire hit_a12_b6l;
wire hit_a12_b8l;
wire hit_a12_b7l;
wire hit_a12_b9l;
wire hit_a12_b10l;
wire hit_a12_b11l;
wire hit_a12_b13l;
wire hit_a12_pl;

assign hit_a12_b1l = ((xPosRock12 + 8'd20 == xPosRock1) && (yPosRock12 + 8'd20 > yPosRock1) && (yPosRock12 < yPosRock1 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_b2l = ((xPosRock12 + 8'd20 == xPosRock2) && (yPosRock12 + 8'd20 > yPosRock2) && (yPosRock12 < yPosRock2 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_b3l = ((xPosRock12 + 8'd20 == xPosRock3) && (yPosRock12 + 8'd20 > yPosRock3) && (yPosRock12 < yPosRock3 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_b4l = ((xPosRock12 + 8'd20 == xPosRock4) && (yPosRock12 + 8'd20 > yPosRock4) && (yPosRock12 < yPosRock4 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_b5l = ((xPosRock12 + 8'd20 == xPosRock5) && (yPosRock12 + 8'd20 > yPosRock5) && (yPosRock12 < yPosRock5 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_b6l = ((xPosRock12 + 8'd20 == xPosRock6) && (yPosRock12 + 8'd20 > yPosRock6) && (yPosRock12 < yPosRock6 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_b8l = ((xPosRock12 + 8'd20 == xPosRock8) && (yPosRock12 + 8'd20 > yPosRock8) && (yPosRock12 < yPosRock8 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_b7l = ((xPosRock12 + 8'd20 == xPosRock7) && (yPosRock12 + 8'd20 > yPosRock7) && (yPosRock12 < yPosRock7 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_b9l = ((xPosRock12 + 8'd20 == xPosRock9) && (yPosRock12 + 8'd20 > yPosRock9) && (yPosRock12 < yPosRock9 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_b10l = ((xPosRock12 + 8'd20 == xPosRock10) && (yPosRock12 + 8'd20 > yPosRock10) && (yPosRock12 < yPosRock10 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_b11l = ((xPosRock12 + 8'd20 == xPosRock11) && (yPosRock12 + 8'd20 > yPosRock11) && (yPosRock12 < yPosRock11 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_b13l = ((xPosRock12 + 8'd20 == xPosRock13) && (yPosRock12 + 8'd20 > yPosRock13) && (yPosRock12 < yPosRock13 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_pl = ((xPosRock12 + 8'd20 == xPos) && (yPosRock12 + 8'd20 > yPos) && (yPosRock12 < yPos + 8'd20)) ? 1'b1 : 1'b0;

//12 right
wire hit_a12_b1r;
wire hit_a12_b2r;
wire hit_a12_b3r;
wire hit_a12_b4r;
wire hit_a12_b5r;
wire hit_a12_b6r;
wire hit_a12_b8r;
wire hit_a12_b7r;
wire hit_a12_b9r;
wire hit_a12_b10r;
wire hit_a12_b11r;
wire hit_a12_b13r;
wire hit_a12_pr;
wire hit_a12_hr;
wire hit_a12_ler;

assign hit_a12_b1r = ((xPosRock12 == xPosRock1 + 8'd20) && (yPosRock12 + 8'd20 > yPosRock1) && (yPosRock12 < yPosRock1 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_b2r = ((xPosRock12 == xPosRock2 + 8'd20) && (yPosRock12 + 8'd20 > yPosRock2) && (yPosRock12 < yPosRock2 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_b3r = ((xPosRock12 == xPosRock3 + 8'd20) && (yPosRock12 + 8'd20 > yPosRock3) && (yPosRock12 < yPosRock3 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_b4r = ((xPosRock12 == xPosRock4 + 8'd20) && (yPosRock12 + 8'd20 > yPosRock4) && (yPosRock12 < yPosRock4 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_b5r = ((xPosRock12 == xPosRock5 + 8'd20) && (yPosRock12 + 8'd20 > yPosRock5) && (yPosRock12 < yPosRock5 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_b6r = ((xPosRock12 == xPosRock6 + 8'd20) && (yPosRock12 + 8'd20 > yPosRock6) && (yPosRock12 < yPosRock6 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_b8r = ((xPosRock12 == xPosRock8 + 8'd20) && (yPosRock12 + 8'd20 > yPosRock8) && (yPosRock12 < yPosRock8 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_b7r = ((xPosRock12 == xPosRock7 + 8'd20) && (yPosRock12 + 8'd20 > yPosRock7) && (yPosRock12 < yPosRock7 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_b9r = ((xPosRock12 == xPosRock9 + 8'd20) && (yPosRock12 + 8'd20 > yPosRock9) && (yPosRock12 < yPosRock9 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_b10r = ((xPosRock12 == xPosRock10 + 8'd20) && (yPosRock12 + 8'd20 > yPosRock10) && (yPosRock12 < yPosRock10 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_b11r = ((xPosRock12 == xPosRock11 + 8'd20) && (yPosRock12 + 8'd20 > yPosRock11) && (yPosRock12 < yPosRock11 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_b13r = ((xPosRock12 == xPosRock13 + 8'd20) && (yPosRock12 + 8'd20 > yPosRock13) && (yPosRock12 < yPosRock13 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_pr = ((xPosRock12 == xPos + 8'd20) && (yPosRock12 + 8'd20 > yPos) && (yPosRock12 < yPos + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a12_hr = ((xPosRock12 == x_ZZZ + 8'd60) && (yPosRock12 + 8'd20 > y_ZZZ) && (yPosRock12 < y_ZZZ + 8'd60)) ? 1'b1 : 1'b0;
assign hit_a12_ler = ((xPosRock12 == x_leaves + 8'd60) && (yPosRock12 + 8'd20 > y_leaves) && (yPosRock12 < y_leaves + 8'd90)) ? 1'b1 : 1'b0;

//13 top
wire hit_a13_b1t;
wire hit_a13_b2t;
wire hit_a13_b3t;
wire hit_a13_b4t;
wire hit_a13_b5t;
wire hit_a13_b6t;
wire hit_a13_b8t;
wire hit_a13_b7t;
wire hit_a13_b9t;
wire hit_a13_b10t;
wire hit_a13_b11t;
wire hit_a13_b12t;
wire hit_a13_pt;
wire hit_a13_ht;
wire hit_a13_let;

assign hit_a13_b1t = ((yPosRock13 + 8'd20 == yPosRock1) && (xPosRock13 + 8'd20 > xPosRock1) && (xPosRock13 < xPosRock1 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_b2t = ((yPosRock13 + 8'd20 == yPosRock2) && (xPosRock13 + 8'd20 > xPosRock2) && (xPosRock13 < xPosRock2 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_b3t = ((yPosRock13 + 8'd20 == yPosRock3) && (xPosRock13 + 8'd20 > xPosRock3) && (xPosRock13 < xPosRock3 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_b4t = ((yPosRock13 + 8'd20 == yPosRock4) && (xPosRock13 + 8'd20 > xPosRock4) && (xPosRock13 < xPosRock4 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_b5t = ((yPosRock13 + 8'd20 == yPosRock5) && (xPosRock13 + 8'd20 > xPosRock5) && (xPosRock13 < xPosRock5 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_b6t = ((yPosRock13 + 8'd20 == yPosRock6) && (xPosRock13 + 8'd20 > xPosRock6) && (xPosRock13 < xPosRock6 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_b8t = ((yPosRock13 + 8'd20 == yPosRock8) && (xPosRock13 + 8'd20 > xPosRock8) && (xPosRock13 < xPosRock8 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_b7t = ((yPosRock13 + 8'd20 == yPosRock7) && (xPosRock13 + 8'd20 > xPosRock7) && (xPosRock13 < xPosRock7 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_b9t = ((yPosRock13 + 8'd20 == yPosRock9) && (xPosRock13 + 8'd20 > xPosRock9) && (xPosRock13 < xPosRock9 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_b10t = ((yPosRock13 + 8'd20 == yPosRock10) && (xPosRock13 + 8'd20 > xPosRock10) && (xPosRock13 < xPosRock10 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_b11t = ((yPosRock13 + 8'd20 == yPosRock11) && (xPosRock13 + 8'd20 > xPosRock11) && (xPosRock13 < xPosRock11 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_b12t = ((yPosRock13 + 8'd20 == yPosRock12) && (xPosRock13 + 8'd20 > xPosRock12) && (xPosRock13 < xPosRock12 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_pt = ((yPosRock13 + 8'd20 == yPos) && (xPosRock13 + 8'd20 > xPos) && (xPosRock13 < xPos + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_ht = ((yPosRock13 + 8'd20 == y_ZZZ) && (xPosRock13 + 8'd20 > x_ZZZ) && (xPosRock13 < x_ZZZ + 8'd60)) ? 1'b1 : 1'b0;
assign hit_a13_let = ((yPosRock13 + 8'd20 == y_leaves) && (xPosRock13 + 8'd20 > x_leaves) && (xPosRock13 < x_leaves + 8'd60)) ? 1'b1 : 1'b0;

//13 bottom
wire hit_a13_b1b;
wire hit_a13_b2b;
wire hit_a13_b3b;
wire hit_a13_b4b;
wire hit_a13_b5b;
wire hit_a13_b6b;
wire hit_a13_b8b;
wire hit_a13_b7b;
wire hit_a13_b9b;
wire hit_a13_b10b;
wire hit_a13_b11b;
wire hit_a13_b12b;
wire hit_a13_pb;

assign hit_a13_b1b = ((yPosRock13 == yPosRock1 + 8'd20) && (xPosRock13 + 8'd20 > xPosRock1) && (xPosRock13 < xPosRock1 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_b2b = ((yPosRock13 == yPosRock2 + 8'd20) && (xPosRock13 + 8'd20 > xPosRock2) && (xPosRock13 < xPosRock2 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_b3b = ((yPosRock13 == yPosRock3 + 8'd20) && (xPosRock13 + 8'd20 > xPosRock3) && (xPosRock13 < xPosRock3 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_b4b = ((yPosRock13 == yPosRock4 + 8'd20) && (xPosRock13 + 8'd20 > xPosRock4) && (xPosRock13 < xPosRock4 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_b5b = ((yPosRock13 == yPosRock5 + 8'd20) && (xPosRock13 + 8'd20 > xPosRock5) && (xPosRock13 < xPosRock5 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_b6b = ((yPosRock13 == yPosRock6 + 8'd20) && (xPosRock13 + 8'd20 > xPosRock6) && (xPosRock13 < xPosRock6 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_b8b = ((yPosRock13 == yPosRock8 + 8'd20) && (xPosRock13 + 8'd20 > xPosRock8) && (xPosRock13 < xPosRock8 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_b7b = ((yPosRock13 == yPosRock7 + 8'd20) && (xPosRock13 + 8'd20 > xPosRock7) && (xPosRock13 < xPosRock7 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_b9b = ((yPosRock13 == yPosRock9 + 8'd20) && (xPosRock13 + 8'd20 > xPosRock9) && (xPosRock13 < xPosRock9 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_b10b = ((yPosRock13 == yPosRock10 + 8'd20) && (xPosRock13 + 8'd20 > xPosRock10) && (xPosRock13 < xPosRock10 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_b11b = ((yPosRock13 == yPosRock11 + 8'd20) && (xPosRock13 + 8'd20 > xPosRock11) && (xPosRock13 < xPosRock11 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_b12b = ((yPosRock13 == yPosRock12 + 8'd20) && (xPosRock13 + 8'd20 > xPosRock12) && (xPosRock13 < xPosRock12 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_pb = ((yPosRock13 == yPos + 8'd20) && (xPosRock13 + 8'd20 > xPos) && (xPosRock13 < xPos + 8'd20)) ? 1'b1 : 1'b0;

//13 left
wire hit_a13_b1l;
wire hit_a13_b2l;
wire hit_a13_b3l;
wire hit_a13_b4l;
wire hit_a13_b5l;
wire hit_a13_b6l;
wire hit_a13_b8l;
wire hit_a13_b7l;
wire hit_a13_b9l;
wire hit_a13_b10l;
wire hit_a13_b11l;
wire hit_a13_b12l;
wire hit_a13_pl;

assign hit_a13_b1l = ((xPosRock13 + 8'd20 == xPosRock1) && (yPosRock13 + 8'd20 > yPosRock1) && (yPosRock13 < yPosRock1 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_b2l = ((xPosRock13 + 8'd20 == xPosRock2) && (yPosRock13 + 8'd20 > yPosRock2) && (yPosRock13 < yPosRock2 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_b3l = ((xPosRock13 + 8'd20 == xPosRock3) && (yPosRock13 + 8'd20 > yPosRock3) && (yPosRock13 < yPosRock3 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_b4l = ((xPosRock13 + 8'd20 == xPosRock4) && (yPosRock13 + 8'd20 > yPosRock4) && (yPosRock13 < yPosRock4 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_b5l = ((xPosRock13 + 8'd20 == xPosRock5) && (yPosRock13 + 8'd20 > yPosRock5) && (yPosRock13 < yPosRock5 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_b6l = ((xPosRock13 + 8'd20 == xPosRock6) && (yPosRock13 + 8'd20 > yPosRock6) && (yPosRock13 < yPosRock6 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_b8l = ((xPosRock13 + 8'd20 == xPosRock8) && (yPosRock13 + 8'd20 > yPosRock8) && (yPosRock13 < yPosRock8 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_b7l = ((xPosRock13 + 8'd20 == xPosRock7) && (yPosRock13 + 8'd20 > yPosRock7) && (yPosRock13 < yPosRock7 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_b9l = ((xPosRock13 + 8'd20 == xPosRock9) && (yPosRock13 + 8'd20 > yPosRock9) && (yPosRock13 < yPosRock9 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_b10l = ((xPosRock13 + 8'd20 == xPosRock10) && (yPosRock13 + 8'd20 > yPosRock10) && (yPosRock13 < yPosRock10 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_b11l = ((xPosRock13 + 8'd20 == xPosRock11) && (yPosRock13 + 8'd20 > yPosRock11) && (yPosRock13 < yPosRock11 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_b12l = ((xPosRock13 + 8'd20 == xPosRock12) && (yPosRock13 + 8'd20 > yPosRock12) && (yPosRock13 < yPosRock12 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_pl = ((xPosRock13 + 8'd20 == xPos) && (yPosRock13 + 8'd20 > yPos) && (yPosRock13 < yPos + 8'd20)) ? 1'b1 : 1'b0;

//13 right
wire hit_a13_b1r;
wire hit_a13_b2r;
wire hit_a13_b3r;
wire hit_a13_b4r;
wire hit_a13_b5r;
wire hit_a13_b6r;
wire hit_a13_b8r;
wire hit_a13_b7r;
wire hit_a13_b9r;
wire hit_a13_b10r;
wire hit_a13_b11r;
wire hit_a13_b12r;
wire hit_a13_pr;
wire hit_a13_hr;
wire hit_a13_ler;

assign hit_a13_b1r = ((xPosRock13 == xPosRock1 + 8'd20) && (yPosRock13 + 8'd20 > yPosRock1) && (yPosRock13 < yPosRock1 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_b2r = ((xPosRock13 == xPosRock2 + 8'd20) && (yPosRock13 + 8'd20 > yPosRock2) && (yPosRock13 < yPosRock2 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_b3r = ((xPosRock13 == xPosRock3 + 8'd20) && (yPosRock13 + 8'd20 > yPosRock3) && (yPosRock13 < yPosRock3 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_b4r = ((xPosRock13 == xPosRock4 + 8'd20) && (yPosRock13 + 8'd20 > yPosRock4) && (yPosRock13 < yPosRock4 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_b5r = ((xPosRock13 == xPosRock5 + 8'd20) && (yPosRock13 + 8'd20 > yPosRock5) && (yPosRock13 < yPosRock5 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_b6r = ((xPosRock13 == xPosRock6 + 8'd20) && (yPosRock13 + 8'd20 > yPosRock6) && (yPosRock13 < yPosRock6 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_b8r = ((xPosRock13 == xPosRock8 + 8'd20) && (yPosRock13 + 8'd20 > yPosRock8) && (yPosRock13 < yPosRock8 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_b7r = ((xPosRock13 == xPosRock7 + 8'd20) && (yPosRock13 + 8'd20 > yPosRock7) && (yPosRock13 < yPosRock7 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_b9r = ((xPosRock13 == xPosRock9 + 8'd20) && (yPosRock13 + 8'd20 > yPosRock9) && (yPosRock13 < yPosRock9 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_b10r = ((xPosRock13 == xPosRock10 + 8'd20) && (yPosRock13 + 8'd20 > yPosRock10) && (yPosRock13 < yPosRock10 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_b11r = ((xPosRock13 == xPosRock11 + 8'd20) && (yPosRock13 + 8'd20 > yPosRock11) && (yPosRock13 < yPosRock11 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_b12r = ((xPosRock13 == xPosRock12 + 8'd20) && (yPosRock13 + 8'd20 > yPosRock12) && (yPosRock13 < yPosRock12 + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_pr = ((xPosRock13 == xPos + 8'd20) && (yPosRock13 + 8'd20 > yPos) && (yPosRock13 < yPos + 8'd20)) ? 1'b1 : 1'b0;
assign hit_a13_hr = ((xPosRock13 == x_ZZZ + 8'd60) && (yPosRock13 + 8'd20 > y_ZZZ) && (yPosRock13 < y_ZZZ + 8'd60)) ? 1'b1 : 1'b0;
assign hit_a13_ler = ((xPosRock13 == x_leaves + 8'd60) && (yPosRock13 + 8'd20 > y_leaves) && (yPosRock13 < y_leaves + 8'd90)) ? 1'b1 : 1'b0;

//Ship collisions from top
wire hitShipA1t;
wire hitShipA2t;
wire hitShipA3t;
wire hitShipA4t;
wire hitShipA5t;
wire hitShipA6t;
wire hitShipA8t;
wire hitShipA7t;
wire hitShipA9t;
wire hitShipA10t;
wire hitShipA11t;
wire hitShipA12t;
wire hitShipA13t;
wire hit_ship_ht;
wire hit_ship_let;

assign hitShipA1t = ((yPos + 8'd21 == yPosRock1) && (xPos + 8'd21 > xPosRock1) && (xPos < xPosRock1 + 8'd21)) ? 1'b1 : 1'b0;
assign hitShipA2t = ((yPos + 8'd21 == yPosRock2) && (xPos + 8'd21 > xPosRock2) && (xPos < xPosRock2 + 8'd21)) ? 1'b1 : 1'b0;
assign hitShipA3t = ((yPos + 8'd21 == yPosRock3) && (xPos + 8'd21 > xPosRock3) && (xPos < xPosRock3 + 8'd21)) ? 1'b1 : 1'b0;
assign hitShipA4t = ((yPos + 8'd21 == yPosRock4) && (xPos + 8'd21 > xPosRock4) && (xPos < xPosRock4 + 8'd21)) ? 1'b1 : 1'b0;
assign hitShipA5t = ((yPos + 8'd21 == yPosRock5) && (xPos + 8'd21 > xPosRock5) && (xPos < xPosRock5 + 8'd21)) ? 1'b1 : 1'b0;
assign hitShipA6t = ((yPos + 8'd21 == yPosRock6) && (xPos + 8'd21 > xPosRock6) && (xPos < xPosRock6 + 8'd21)) ? 1'b1 : 1'b0;
assign hitShipA8t = ((yPos + 8'd21 == yPosRock8) && (xPos + 8'd21 > xPosRock8) && (xPos < xPosRock8 + 8'd21)) ? 1'b1 : 1'b0;
assign hitShipA7t = ((yPos + 8'd21 == yPosRock7) && (xPos + 8'd21 > xPosRock7) && (xPos < xPosRock7 + 8'd21)) ? 1'b1 : 1'b0;
assign hitShipA9t = ((yPos + 8'd21 == yPosRock9) && (xPos + 8'd21 > xPosRock9) && (xPos < xPosRock9 + 8'd21)) ? 1'b1 : 1'b0;
assign hitShipA10t = ((yPos + 8'd21 == yPosRock10) && (xPos + 8'd21 > xPosRock10) && (xPos < xPosRock10 + 8'd21)) ? 1'b1 : 1'b0;
assign hitShipA11t = ((yPos + 8'd21 == yPosRock11) && (xPos + 8'd21 > xPosRock11) && (xPos < xPosRock11 + 8'd21)) ? 1'b1 : 1'b0;
assign hitShipA12t = ((yPos + 8'd21 == yPosRock12) && (xPos + 8'd21 > xPosRock12) && (xPos < xPosRock12 + 8'd21)) ? 1'b1 : 1'b0;
assign hitShipA13t = ((yPos + 8'd21 == yPosRock13) && (xPos + 8'd21 > xPosRock13) && (xPos < xPosRock13 + 8'd21)) ? 1'b1 : 1'b0;
assign hit_ship_ht = ((yPos + 8'd24 == y_ZZZ) && (xPos + 8'd30 > x_ZZZ) && (xPos < x_ZZZ + 8'd60)) ? 1'b1 : 1'b0;
assign hit_ship_let = ((yPos + 8'd24 == y_leaves) && (xPos + 8'd30 > x_leaves) && (xPos < x_leaves + 8'd60)) ? 1'b1 : 1'b0;

//ship bottom 
wire hitShipA1b;
wire hitShipA2b;
wire hitShipA3b;
wire hitShipA4b;
wire hitShipA5b;
wire hitShipA6b;
wire hitShipA8b;
wire hitShipA7b;
wire hitShipA9b;
wire hitShipA10b;
wire hitShipA11b;
wire hitShipA12b;
wire hitShipA13b;

assign hitShipA1b = ((yPos == yPosRock1 + 8'd21) && (xPos + 8'd21 > xPosRock1) && (xPos < xPosRock1 + 8'd21)) ? 1'b1 : 1'b0;
assign hitShipA2b = ((yPos == yPosRock2 + 8'd21) && (xPos + 8'd21 > xPosRock2) && (xPos < xPosRock2 + 8'd21)) ? 1'b1 : 1'b0;
assign hitShipA3b = ((yPos == yPosRock3 + 8'd21) && (xPos + 8'd21 > xPosRock3) && (xPos < xPosRock3 + 8'd21)) ? 1'b1 : 1'b0;
assign hitShipA4b = ((yPos == yPosRock4 + 8'd21) && (xPos + 8'd21 > xPosRock4) && (xPos < xPosRock4 + 8'd21)) ? 1'b1 : 1'b0;
assign hitShipA5b = ((yPos == yPosRock5 + 8'd21) && (xPos + 8'd21 > xPosRock5) && (xPos < xPosRock5 + 8'd21)) ? 1'b1 : 1'b0;
assign hitShipA6b = ((yPos == yPosRock6 + 8'd21) && (xPos + 8'd21 > xPosRock6) && (xPos < xPosRock6 + 8'd21)) ? 1'b1 : 1'b0;
assign hitShipA8b = ((yPos == yPosRock8 + 8'd21) && (xPos + 8'd21 > xPosRock8) && (xPos < xPosRock8 + 8'd21)) ? 1'b1 : 1'b0;
assign hitShipA7b = ((yPos == yPosRock7 + 8'd21) && (xPos + 8'd21 > xPosRock7) && (xPos < xPosRock7 + 8'd21)) ? 1'b1 : 1'b0;
assign hitShipA9b = ((yPos == yPosRock9 + 8'd21) && (xPos + 8'd21 > xPosRock9) && (xPos < xPosRock9 + 8'd21)) ? 1'b1 : 1'b0;
assign hitShipA10b = ((yPos == yPosRock10 + 8'd21) && (xPos + 8'd21 > xPosRock10) && (xPos < xPosRock10 + 8'd21)) ? 1'b1 : 1'b0;
assign hitShipA11b = ((yPos == yPosRock11 + 8'd21) && (xPos + 8'd21 > xPosRock11) && (xPos < xPosRock11 + 8'd21)) ? 1'b1 : 1'b0;
assign hitShipA12b = ((yPos == yPosRock12 + 8'd21) && (xPos + 8'd21 > xPosRock12) && (xPos < xPosRock12 + 8'd21)) ? 1'b1 : 1'b0;
assign hitShipA13b = ((yPos == yPosRock13 + 8'd21) && (xPos + 8'd21 > xPosRock13) && (xPos < xPosRock13 + 8'd21)) ? 1'b1 : 1'b0;

//ship left 
wire hitShipA1l;
wire hitShipA2l;
wire hitShipA3l;
wire hitShipA4l;
wire hitShipA5l;
wire hitShipA6l;
wire hitShipA8l;
wire hitShipA7l;
wire hitShipA9l;
wire hitShipA10l;
wire hitShipA11l;
wire hitShipA12l;
wire hitShipA13l;

assign hitShipA1l = ((xPos + 8'd21 == xPosRock1) && (yPos + 8'd21 > yPosRock1) && (yPos < yPosRock1 + 8'd21)) ? 1'b1 : 1'b0;
assign hitShipA2l = ((xPos + 8'd21 == xPosRock2) && (yPos + 8'd21 > yPosRock2) && (yPos < yPosRock2 + 8'd21)) ? 1'b1 : 1'b0;
assign hitShipA3l = ((xPos + 8'd21 == xPosRock3) && (yPos + 8'd21 > yPosRock3) && (yPos < yPosRock3 + 8'd21)) ? 1'b1 : 1'b0;
assign hitShipA4l = ((xPos + 8'd21 == xPosRock4) && (yPos + 8'd21 > yPosRock4) && (yPos < yPosRock4 + 8'd21)) ? 1'b1 : 1'b0;
assign hitShipA5l = ((xPos + 8'd21 == xPosRock5) && (yPos + 8'd21 > yPosRock5) && (yPos < yPosRock5 + 8'd21)) ? 1'b1 : 1'b0;
assign hitShipA6l = ((xPos + 8'd21 == xPosRock6) && (yPos + 8'd21 > yPosRock6) && (yPos < yPosRock6 + 8'd21)) ? 1'b1 : 1'b0;
assign hitShipA8l = ((xPos + 8'd21 == xPosRock8) && (yPos + 8'd21 > yPosRock8) && (yPos < yPosRock8 + 8'd21)) ? 1'b1 : 1'b0;
assign hitShipA7l = ((xPos + 8'd21 == xPosRock7) && (yPos + 8'd21 > yPosRock7) && (yPos < yPosRock7 + 8'd21)) ? 1'b1 : 1'b0;
assign hitShipA9l = ((xPos + 8'd21 == xPosRock9) && (yPos + 8'd21 > yPosRock9) && (yPos < yPosRock9 + 8'd21)) ? 1'b1 : 1'b0;
assign hitShipA10l = ((xPos + 8'd21 == xPosRock10) && (yPos + 8'd21 > yPosRock10) && (yPos < yPosRock10 + 8'd21)) ? 1'b1 : 1'b0;
assign hitShipA11l = ((xPos + 8'd21 == xPosRock11) && (yPos + 8'd21 > yPosRock11) && (yPos < yPosRock11 + 8'd21)) ? 1'b1 : 1'b0;
assign hitShipA12l = ((xPos + 8'd21 == xPosRock12) && (yPos + 8'd21 > yPosRock12) && (yPos < yPosRock12 + 8'd21)) ? 1'b1 : 1'b0;
assign hitShipA13l = ((xPos + 8'd21 == xPosRock13) && (yPos + 8'd21 > yPosRock13) && (yPos < yPosRock13 + 8'd21)) ? 1'b1 : 1'b0;

//ship right 
wire hitShipA1r;
wire hitShipA2r;
wire hitShipA3r;
wire hitShipA4r;
wire hitShipA5r;
wire hitShipA6r;
wire hitShipA8r;
wire hitShipA7r;
wire hitShipA9r;
wire hitShipA10r;
wire hitShipA11r;
wire hitShipA12r;
wire hitShipA13r;
wire hit_ship_hr;
wire hit_ship_ler;

assign hitShipA1r = ((xPos == xPosRock1 + 8'd21) && (yPos + 8'd21 > yPosRock1) && (yPos < yPosRock1 + 8'd21)) ? 1'b1 : 1'b0;
assign hitShipA2r = ((xPos == xPosRock2 + 8'd21) && (yPos + 8'd21 > yPosRock2) && (yPos < yPosRock2 + 8'd21)) ? 1'b1 : 1'b0;
assign hitShipA3r = ((xPos == xPosRock3 + 8'd21) && (yPosRock3 + 8'd21 > yPos) && (yPos < yPosRock3 + 8'd21)) ? 1'b1 : 1'b0;
assign hitShipA4r = ((xPos == xPosRock4 + 8'd21) && (yPos + 8'd21 > yPosRock4) && (yPos < yPosRock4 + 8'd21)) ? 1'b1 : 1'b0;
assign hitShipA5r = ((xPos == xPosRock5 + 8'd21) && (yPos + 8'd21 > yPosRock5) && (yPos < yPosRock5 + 8'd21)) ? 1'b1 : 1'b0;
assign hitShipA6r = ((xPos == xPosRock6 + 8'd21) && (yPos + 8'd21 > yPosRock6) && (yPos < yPosRock6 + 8'd21)) ? 1'b1 : 1'b0;
assign hitShipA8r = ((xPos == xPosRock8 + 8'd21) && (yPos + 8'd21 > yPosRock8) && (yPos < yPosRock8 + 8'd21)) ? 1'b1 : 1'b0;
assign hitShipA7r = ((xPos == xPosRock7 + 8'd21) && (yPos + 8'd21 > yPosRock7) && (yPos < yPosRock7 + 8'd21)) ? 1'b1 : 1'b0;
assign hitShipA9r = ((xPos == xPosRock9 + 8'd21) && (yPos + 8'd21 > yPosRock9) && (yPos < yPosRock9 + 8'd21)) ? 1'b1 : 1'b0;
assign hitShipA10r = ((xPos == xPosRock10 + 8'd21) && (yPos + 8'd21 > yPosRock10) && (yPos < yPosRock10 + 8'd21)) ? 1'b1 : 1'b0;
assign hitShipA11r = ((xPos == xPosRock11 + 8'd21) && (yPos + 8'd21 > yPosRock11) && (yPos < yPosRock11 + 8'd21)) ? 1'b1 : 1'b0;
assign hitShipA12r = ((xPos == xPosRock12 + 8'd21) && (yPos + 8'd21 > yPosRock12) && (yPos < yPosRock12 + 8'd21)) ? 1'b1 : 1'b0;
assign hitShipA13r = ((xPos == xPosRock13 + 8'd21) && (yPos + 8'd21 > yPosRock13) && (yPos < yPosRock13 + 8'd21)) ? 1'b1 : 1'b0;
assign hit_ship_hr = ((xPos == x_ZZZ + 8'd60) && (yPos + 8'd24 > y_ZZZ) && (yPos < y_ZZZ + 8'd60)) ? 1'b1 : 1'b0;
assign hit_ship_ler = ((xPos == x_leaves + 8'd60) && (yPos + 8'd24 > y_leaves) && (yPos < y_leaves + 8'd90)) ? 1'b1 : 1'b0;

//reset control. 
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
		S10 <= 11'd0;
		S11 <= 11'd0;
		S12 <= 11'd0;
		S13 <= 11'd0;

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
		S10 <= NS10;
		S11 <= NS11;
		S12 <= NS12;
		S13 <= NS13;
	end
end

//state transitions. There are too many of these, but oh well
always @ (posedge update or negedge rst)
begin
	case (S)
		PREGAME: 
		begin
			if (rst == 1'd0)
				NS = PREGAME;
			else
				NS = start;
		end

		start:
		begin
			if (SG == 1'd1)
				NS = start;
			else 
				NS = SA;
		end		
		SA:
		begin
			if (y_startScreen >= 11'd499)
				NS = laser_reload;
			else
				NS = SA;
		end
		laserRight:
		begin 
			
			if((xShot < 11'd622 && hit_rock1 == 1'd0 && hit_rock2 == 1'd0 && hit_rock3 == 1'd0 && hit_rock4 == 1'd0 && hit_rock5 == 1'd0 && hit_rock6 == 1'd0 && hit_rock7 == 1'd0 && hit_rock8 == 1'd0 && hit_rock9 == 1'd0 && hit_rock10 == 1'd0 && hit_rock11 == 1'd0 && hit_rock12 == 1'd0 && hit_rock13 == 1'd0) && hit_me == 1'd0)
				NS = laserRight;
			else if(hit_rock1 == 1'd1 || hit_rock2 == 1'd1 || hit_rock3 == 1'd1 || hit_rock4 == 1'd1 || hit_rock5 == 1'd1 || hit_rock6 == 1'd1 || hit_rock7 == 1'd1 || hit_rock8 == 1'd1 || hit_rock9 == 1'd1 || hit_rock10 == 1'd1 || hit_rock11 == 1'd1 || hit_rock12 == 1'd1 || hit_rock13 == 1'd1)
				NS = laser_reload1; //2 different states for reloading. One for when the laser goes off the map, the other for when it hits something
			else if( xShot >= 11'd622)
				NS = laser_reload; 
			if (life == 11'd0)
				NS = end_game;
		end
			
		laser_reload: //this reload state is for when the shot hits.
		begin	
			
			if(fire == 1'd1)
				NS = laserRight;
			else
				NS = laser_reload;
			if (life == 11'd0)
				NS = end_game;
		end
		
		laser_reload1: //this reload is the one for missing and hitting the map border 
		begin	
			
			if(fire == 1'd1) // Do you want to shoot asteroids? this code lets you do just that.
				NS = laserRight;
			else
				NS = laser_reload;
			if (life == 11'd0)
				NS = end_game;
		end
		
		end_game:
			NS = end_game;
	endcase	
	
	case(S1)
		PREGAME: 
		begin
			if (rst == 1'd0)
				NS1 = PREGAME;
			else
				NS1 = start;
		end

		start:
		begin
			if (SG == 1'd0)
				NS1 = start;
			else 
				NS1 = SA;
		end
		SA:
		begin
			if (y_startScreen >= 11'd499)
				NS1 = rock1_move_45;
			else
				NS1 = SA;
		end
		rock1_move_225:
		begin
			if( hit_a1_ler == 1'd1 || hit_a1_hr == 1'd1 || hit_a1_pr == 1'd1  || hit_a1_b2r == 1'd1 || hit_a1_b3r == 1'd1 || hit_a1_b4r == 1'd1 || hit_a1_b5r == 1'd1 || hit_a1_b6r == 1'd1 || hit_a1_b7r == 1'd1 || hit_a1_b8r == 1'd1 || hit_a1_b9r == 1'd1 || hit_a1_b10r == 1'd1 || hit_a1_b11r == 1'd1 || hit_a1_b12r == 1'd1 || hit_a1_b13r == 1'd1)
				NS1 = rock1_move_315;
			else if( hit_a1_let == 1'd1 || hit_a1_ht == 1'd1 || hit_a1_pt == 1'd1 || hit_a1_b2t == 1'd1 || hit_a1_b3t == 1'd1 || hit_a1_b4t == 1'd1 || hit_a1_b5t == 1'd1 || hit_a1_b6t == 1'd1 || hit_a1_b7t == 1'd1 || hit_a1_b8t == 1'd1 || hit_a1_b9t == 1'd1 || hit_a1_b10t == 1'd1 || hit_a1_b11t == 1'd1 || hit_a1_b12t == 1'd1 || hit_a1_b13t == 1'd1)
				NS1 = rock1_move_135;
			else
				NS1 = rock1_move_225;
			end
		rock1_move_315:
		begin
			if ( hit_a1_pl == 1'd1 || hit_a1_b2l == 1'd1 || hit_a1_b3l == 1'd1 || hit_a1_b4l == 1'd1 || hit_a1_b5l == 1'd1 || hit_a1_b6l == 1'd1 || hit_a1_b7l == 1'd1 || hit_a1_b8l == 1'd1 || hit_a1_b9l == 1'd1 || hit_a1_b10l == 1'd1 || hit_a1_b11l == 1'd1 || hit_a1_b12l == 1'd1 || hit_a1_b13l == 1'd1)
				NS1 = rock1_move_225;
			else if( hit_a1_let == 1'd1 || hit_a1_ht == 1'd1 || hit_a1_pt == 1'd1 || hit_a1_b2t == 1'd1 || hit_a1_b3t == 1'd1 || hit_a1_b4t == 1'd1 || hit_a1_b5t == 1'd1 || hit_a1_b6t == 1'd1 || hit_a1_b7t == 1'd1 || hit_a1_b8t == 1'd1 || hit_a1_b9t == 1'd1 || hit_a1_b10t == 1'd1 || hit_a1_b11t == 1'd1 || hit_a1_b12t == 1'd1 || hit_a1_b13t == 1'd1)
				NS1 = rock1_move_45;
			else
				NS1 = rock1_move_315;
		end
		rock1_move_135:
		begin
			if( hit_a1_ler == 1'd1 || hit_a1_hr == 1'd1 || hit_a1_pr == 1'd1 || hit_a1_b2r == 1'd1 || hit_a1_b3r == 1'd1 || hit_a1_b4r == 1'd1 || hit_a1_b5r == 1'd1 || hit_a1_b6r == 1'd1 || hit_a1_b7r == 1'd1 || hit_a1_b8r == 1'd1 || hit_a1_b9r == 1'd1 || hit_a1_b10r == 1'd1 || hit_a1_b11r == 1'd1 || hit_a1_b12r == 1'd1 || hit_a1_b13r == 1'd1)
				NS1 = rock1_move_45;
			else if( hit_a1_pb == 1'd1 || hit_a1_b2b == 1'd1 || hit_a1_b3b == 1'd1 || hit_a1_b4b == 1'd1 || hit_a1_b5b == 1'd1 || hit_a1_b6b == 1'd1 || hit_a1_b7b == 1'd1 || hit_a1_b8b == 1'd1 || hit_a1_b9b == 1'd1 || hit_a1_b10b == 1'd1 || hit_a1_b11b == 1'd1 || hit_a1_b12b == 1'd1 || hit_a1_b13b == 1'd1)
				NS1 = rock1_move_225;
			
			else
				NS1 = rock1_move_135;
		end
		rock1_move_45:
		begin
			if(hit_a1_pl == 1'd1 || hit_a1_b2l == 1'd1 || hit_a1_b3l == 1'd1 || hit_a1_b4l == 1'd1 || hit_a1_b5l == 1'd1 || hit_a1_b6l == 1'd1 || hit_a1_b7l == 1'd1 || hit_a1_b8l == 1'd1 || hit_a1_b9l == 1'd1 || hit_a1_b10l == 1'd1 || hit_a1_b11l == 1'd1 || hit_a1_b12l == 1'd1 || hit_a1_b13l == 1'd1)
				NS1 = rock1_move_135;
			else if( hit_a1_pb == 1'd1 || hit_a1_b2b == 1'd1 || hit_a1_b3b == 1'd1 || hit_a1_b4b == 1'd1 || hit_a1_b5b == 1'd1 || hit_a1_b6b == 1'd1 || hit_a1_b7b == 1'd1 || hit_a1_b8b == 1'd1 || hit_a1_b9b == 1'd1 || hit_a1_b10b == 1'd1 || hit_a1_b11b == 1'd1 || hit_a1_b12b == 1'd1 || hit_a1_b13b == 1'd1)
				NS1 = rock1_move_315;
			
			else
				NS1 = rock1_move_45;
		end
		rock1_shot:
		begin
		if (etc >= 32'd1000)
		NS1 = IDKWhatTocallThis;
		else
		NS1 = rock1_shot;
		end
		
		IDKWhatTocallThis:
		begin
			if (etc >= 32'd1005)
				NS1 = rock1_move_225;
			else
				NS1 = IDKWhatTocallThis;
		end
	endcase
	
	case(S2)
		PREGAME: 
		begin
			if (rst == 1'd0)
				NS2 = PREGAME;
			else
				NS2 = start;
		end

		start:
		begin
			if (SG == 1'd0)
				NS2 = start;
			else 
				NS2 = SA;
		end
		
		SA:
		begin
			if (y_startScreen >= 11'd499)
				NS2 = rock1_move_315;
			else
				NS2 = SA;
		end
		rock1_move_225:
		begin
			if(hit_a2_ler == 1'd1 || hit_a2_hr == 1'd1 || hit_a2_pr == 1'd1 || hit_a2_b1r == 1'd1 || hit_a2_b3r == 1'd1 || hit_a2_b4r == 1'd1 || hit_a2_b5r == 1'd1 || hit_a2_b6r == 1'd1 || hit_a2_b7r == 1'd1 || hit_a2_b8r == 1'd1 || hit_a2_b9r == 1'd1 || hit_a2_b10r == 1'd1 || hit_a2_b11r == 1'd1 || hit_a2_b12r == 1'd1 || hit_a2_b13r == 1'd1)
				NS2 = rock1_move_315;
			else if( hit_a2_let == 1'd1 || hit_a2_ht == 1'd1 || hit_a2_pt == 1'd1 || hit_a2_b1t == 1'd1 || hit_a2_b3t == 1'd1 || hit_a2_b4t == 1'd1 || hit_a2_b5t == 1'd1 || hit_a2_b6t == 1'd1 || hit_a2_b7t == 1'd1 || hit_a2_b8t == 1'd1 || hit_a2_b9t == 1'd1 || hit_a2_b10t == 1'd1 || hit_a2_b11t == 1'd1 || hit_a2_b12t == 1'd1 || hit_a2_b13t == 1'd1)
				NS2 = rock1_move_135;
			
			else
				NS2 = rock1_move_225;
			end
		rock1_move_315:
		begin
			if(  hit_a2_pl == 1'd1 || hit_a2_b1l == 1'd1 || hit_a2_b3l == 1'd1 || hit_a2_b4l == 1'd1 || hit_a2_b5l == 1'd1 || hit_a2_b6l == 1'd1 || hit_a2_b7l == 1'd1 || hit_a2_b8l == 1'd1 || hit_a2_b9l == 1'd1 || hit_a2_b10l == 1'd1 || hit_a2_b11l == 1'd1 || hit_a2_b12l == 1'd1 || hit_a2_b13l == 1'd1)
				NS2 = rock1_move_225;
			else if(  hit_a2_let == 1'd1 || hit_a2_ht == 1'd1 || hit_a2_pt == 1'd1 || hit_a2_b1t == 1'd1 || hit_a2_b3t == 1'd1 || hit_a2_b4t == 1'd1 || hit_a2_b5t == 1'd1 || hit_a2_b6t == 1'd1 || hit_a2_b7t == 1'd1 || hit_a2_b8t == 1'd1 || hit_a2_b9t == 1'd1|| hit_a2_b10t == 1'd1 || hit_a2_b11t == 1'd1 || hit_a2_b12t == 1'd1 || hit_a2_b13t == 1'd1)
				NS2 = rock1_move_45;
			
			else
				NS2 = rock1_move_315;
		end
		rock1_move_135:
		begin
			if(  hit_a2_ler == 1'd1 || hit_a2_hr == 1'd1|| hit_a2_pr == 1'd1 || hit_a2_b1r == 1'd1 || hit_a2_b3r == 1'd1 || hit_a2_b4r == 1'd1 || hit_a2_b5r == 1'd1 || hit_a2_b6r == 1'd1 || hit_a2_b7r == 1'd1 || hit_a2_b8r == 1'd1 || hit_a2_b9r == 1'd1 || hit_a2_b10r == 1'd1 || hit_a2_b11r == 1'd1 || hit_a2_b12r == 1'd1 || hit_a2_b13r == 1'd1)
				NS2 = rock1_move_45;
			else if(hit_a2_pb == 1'd1 || hit_a2_b1b == 1'd1 || hit_a2_b3b == 1'd1 || hit_a2_b4b == 1'd1 || hit_a2_b5b == 1'd1 || hit_a2_b6b == 1'd1 || hit_a2_b7b == 1'd1 || hit_a2_b8b == 1'd1 || hit_a2_b9b == 1'd1 || hit_a2_b10b == 1'd1 || hit_a2_b11b == 1'd1 || hit_a2_b12b == 1'd1 || hit_a2_b13b == 1'd1)
				NS2 = rock1_move_225;
			
			else
				NS2 = rock1_move_135;
		end
		rock1_move_45:
		begin
			if(  hit_a2_pl == 1'd1 || hit_a2_b1l == 1'd1 || hit_a2_b3l == 1'd1 || hit_a2_b4l == 1'd1 || hit_a2_b5l == 1'd1 || hit_a2_b6l == 1'd1 || hit_a2_b7l == 1'd1 || hit_a2_b8l == 1'd1 || hit_a2_b9l == 1'd1 || hit_a2_b10l == 1'd1 || hit_a2_b11l == 1'd1 || hit_a2_b12l == 1'd1 || hit_a2_b13l == 1'd1)
				NS2 = rock1_move_135;
			else if( hit_a2_pb == 1'd1 || hit_a2_b1b == 1'd1 || hit_a2_b3b == 1'd1 || hit_a2_b4b == 1'd1 || hit_a2_b5b == 1'd1 || hit_a2_b6b == 1'd1 || hit_a2_b7b == 1'd1 || hit_a2_b8b == 1'd1 || hit_a2_b9b == 1'd1 || hit_a2_b10b == 1'd1 || hit_a2_b11b == 1'd1 || hit_a2_b12b == 1'd1 || hit_a2_b13b == 1'd1)
				NS2 = rock1_move_315;
			
			else
				NS2 = rock1_move_45;
		end
		rock1_shot:
		begin
		if (etc2 >= 32'd1000)
		NS2 = IDKWhatTocallThis;
		else
		NS2 = rock1_shot;
		end
		IDKWhatTocallThis:
		begin
			if (etc2 >= 32'd1005)
				NS2 = rock1_move_225;
			else
				NS2 = IDKWhatTocallThis;
		end
	endcase
	
		case(S3)
		PREGAME: 
		begin
			if (rst == 1'd0)
				NS3 = PREGAME;
			else
				NS3 = start;
		end

		start:
		begin
			if (SG == 1'd0)
				NS3 = start;
			else 
				NS3 = SA;
		end
		SA:
		begin
			if (y_startScreen >= 11'd499)
				NS3 = rock1_move_315;
			else
				NS3 = SA;
		end
		rock1_move_225:
		begin
			if(  hit_a3_ler == 1'd1 || hit_a3_hr == 1'd1 || hit_a3_pr == 1'd1 || hit_a3_b1r == 1'd1 || hit_a3_b2r == 1'd1 || hit_a3_b4r == 1'd1 || hit_a3_b5r == 1'd1 || hit_a3_b6r == 1'd1 || hit_a3_b7r == 1'd1 || hit_a3_b8r == 1'd1 || hit_a3_b9r == 1'd1 || hit_a3_b10r == 1'd1 || hit_a3_b11r == 1'd1 || hit_a3_b12r == 1'd1 || hit_a3_b13r == 1'd1)
				NS3 = rock1_move_315;
			else if(  hit_a3_let == 1'd1 || hit_a3_ht == 1'd1 || hit_a3_pt == 1'd1 || hit_a3_b1t == 1'd1 || hit_a3_b2t == 1'd1 || hit_a3_b4t == 1'd1 || hit_a3_b5t == 1'd1 || hit_a3_b6t == 1'd1 || hit_a3_b7t == 1'd1 || hit_a3_b8t == 1'd1 || hit_a3_b9t == 1'd1 || hit_a3_b10t == 1'd1 || hit_a3_b11t == 1'd1 || hit_a3_b12t == 1'd1 || hit_a3_b13t == 1'd1)
				NS3 = rock1_move_135;
			
			else
				NS3 = rock1_move_225;
			end
		rock1_move_315:
		begin
			if( hit_a3_pl == 1'd1 || hit_a3_b1l == 1'd1 || hit_a3_b2l == 1'd1 || hit_a3_b4l == 1'd1 || hit_a3_b5l == 1'd1 || hit_a3_b6l == 1'd1 || hit_a3_b7l == 1'd1 || hit_a3_b8l == 1'd1 || hit_a3_b9l == 1'd1 || hit_a3_b10l == 1'd1 || hit_a3_b11l == 1'd1 || hit_a3_b12l == 1'd1 || hit_a3_b13l == 1'd1)
				NS3 = rock1_move_225;
			else if( hit_a3_let == 1'd1 || hit_a3_ht == 1'd1 || hit_a3_pt == 1'd1 || hit_a3_b1t == 1'd1 || hit_a3_b2t == 1'd1 || hit_a3_b4t == 1'd1 || hit_a3_b5t == 1'd1 || hit_a3_b6t == 1'd1 || hit_a3_b7t == 1'd1 || hit_a3_b8t == 1'd1 || hit_a3_b9t == 1'd1 || hit_a3_b10t == 1'd1 || hit_a3_b11t == 1'd1 || hit_a3_b12t == 1'd1 || hit_a3_b13t == 1'd1)
				NS3 = rock1_move_45;
			
			else
				NS3 = rock1_move_315;
		end
		rock1_move_135:
		begin
			if(  hit_a3_ler == 1'd1 || hit_a3_hr == 1'd1 || hit_a3_pr == 1'd1 || hit_a3_b1r == 1'd1 || hit_a3_b2r == 1'd1 || hit_a3_b4r == 1'd1 || hit_a3_b5r == 1'd1 || hit_a3_b6r == 1'd1 || hit_a3_b7r == 1'd1 || hit_a3_b8r == 1'd1 || hit_a3_b9r == 1'd1 || hit_a3_b10r == 1'd1 || hit_a3_b11r == 1'd1 || hit_a3_b12r == 1'd1 || hit_a3_b13r == 1'd1)
				NS3 = rock1_move_45;
			else if( hit_a3_pb == 1'd1 || hit_a3_b1b == 1'd1 || hit_a3_b2b == 1'd1 || hit_a3_b4b == 1'd1 || hit_a3_b5b == 1'd1 || hit_a3_b6b == 1'd1 || hit_a3_b7b == 1'd1 || hit_a3_b8b == 1'd1 || hit_a3_b9b == 1'd1 || hit_a3_b10b == 1'd1 || hit_a3_b11b == 1'd1 || hit_a3_b12b == 1'd1 || hit_a3_b13b == 1'd1)
				NS3 = rock1_move_225;
			
			else
				NS3 = rock1_move_135;
		end
		rock1_move_45:
		begin
			if(  hit_a3_pl == 1'd1 || hit_a3_b1l == 1'd1 || hit_a3_b2l == 1'd1 || hit_a3_b4l == 1'd1 || hit_a3_b5l == 1'd1 || hit_a3_b6l == 1'd1 || hit_a3_b7l == 1'd1 || hit_a3_b8l == 1'd1 || hit_a3_b9l == 1'd1 || hit_a3_b10l == 1'd1 || hit_a3_b11l == 1'd1 || hit_a3_b12l == 1'd1 || hit_a3_b13l == 1'd1)
				NS3 = rock1_move_135;
			else if(  hit_a3_pb == 1'd1 || hit_a3_b1b == 1'd1 || hit_a3_b2b == 1'd1 || hit_a3_b4b == 1'd1 || hit_a3_b5b == 1'd1 || hit_a3_b6b == 1'd1 || hit_a3_b7b == 1'd1 || hit_a3_b8b == 1'd1 || hit_a3_b9b == 1'd1 || hit_a3_b10b == 1'd1 || hit_a3_b11b == 1'd1 || hit_a3_b12b == 1'd1 || hit_a3_b13b == 1'd1)
				NS3 = rock1_move_315;

			else
				NS3 = rock1_move_45;
		end
		rock1_shot:
		begin
		if (etc3 >= 32'd1000)
		NS3 = IDKWhatTocallThis;
		else
		NS3 = rock1_shot;
		end
		
		IDKWhatTocallThis:
		begin
			if (etc3 >= 32'd1005)
				NS3 = rock1_move_135;
			else
				NS3 = IDKWhatTocallThis;
		end
	endcase
	
		case(S4)
		PREGAME: 
		begin
			if (rst == 1'd0)
				NS4 = PREGAME;
			else
				NS4 = start;
		end

		start:
		begin
			if (SG == 1'd0)
				NS4 = start;
			else 
				NS4 =  SA;
		end
		SA:
		begin
			if (y_startScreen >= 11'd499)
				NS4 = rock1_move_225;
			else
				NS4 = SA;
		end
		rock1_move_225:
		begin
			if(  hit_a4_ler == 1'd1 || hit_a4_hr == 1'd1 || hit_a4_pr == 1'd1 || hit_a4_b1r == 1'd1 || hit_a4_b2r == 1'd1 || hit_a4_b3r == 1'd1 || hit_a4_b5r == 1'd1 || hit_a4_b6r == 1'd1 || hit_a4_b7r == 1'd1 || hit_a4_b8r == 1'd1 || hit_a4_b9r == 1'd1 || hit_a4_b10r == 1'd1 || hit_a4_b11r == 1'd1 || hit_a4_b12r == 1'd1 || hit_a4_b13r == 1'd1)
				NS4 = rock1_move_315;
			else if( hit_a4_let == 1'd1 || hit_a4_ht == 1'd1 || hit_a4_pt == 1'd1 || hit_a4_b1t == 1'd1 || hit_a4_b2t == 1'd1 || hit_a4_b3t == 1'd1 || hit_a4_b5t == 1'd1 || hit_a4_b6t == 1'd1 || hit_a4_b7t == 1'd1 || hit_a4_b8t == 1'd1 || hit_a4_b9t == 1'd1 || hit_a4_b10t == 1'd1 || hit_a4_b11t == 1'd1 || hit_a4_b12t == 1'd1 || hit_a4_b13t == 1'd1)
				NS4 = rock1_move_135;
			
			else
				NS4 = rock1_move_225;
			end
		rock1_move_315:
		begin
			if( hit_a4_pl == 1'd1 || hit_a4_b1l == 1'd1 || hit_a4_b2l == 1'd1 || hit_a4_b3l == 1'd1 || hit_a4_b5l == 1'd1 || hit_a4_b6l == 1'd1 || hit_a4_b7l == 1'd1 || hit_a4_b8l == 1'd1 || hit_a4_b9l == 1'd1 || hit_a4_b10l == 1'd1 || hit_a4_b11l == 1'd1 || hit_a4_b12l == 1'd1 || hit_a4_b13l == 1'd1)
				NS4 = rock1_move_225;
			else if(  hit_a4_let == 1'd1 || hit_a4_ht == 1'd1 || hit_a4_pt == 1'd1 || hit_a4_b1t == 1'd1 || hit_a4_b2t == 1'd1 || hit_a4_b3t == 1'd1 || hit_a4_b5t == 1'd1 || hit_a4_b6t == 1'd1 || hit_a4_b7t == 1'd1 || hit_a4_b8t == 1'd1 || hit_a4_b9t == 1'd1 || hit_a4_b10t == 1'd1 || hit_a4_b11t == 1'd1 || hit_a4_b12t == 1'd1 || hit_a4_b13t == 1'd1)
				NS4 = rock1_move_45;
			
			else
				NS4 = rock1_move_315;
		end
		rock1_move_135:
		begin
			if( hit_a4_ler == 1'd1 || hit_a4_hr == 1'd1 || hit_a4_pr == 1'd1 || hit_a4_b1r == 1'd1 || hit_a4_b2r == 1'd1 || hit_a4_b3r == 1'd1 || hit_a4_b5r == 1'd1 || hit_a4_b6r == 1'd1 || hit_a4_b7r == 1'd1 || hit_a4_b8r == 1'd1 || hit_a4_b9r == 1'd1 || hit_a4_b10r == 1'd1 || hit_a4_b11r == 1'd1 || hit_a4_b12r == 1'd1 || hit_a4_b13r == 1'd1)
				NS4 = rock1_move_45;
			else if( hit_a4_pb == 1'd1 || hit_a4_b1b == 1'd1 || hit_a4_b2b == 1'd1 || hit_a4_b3b == 1'd1 || hit_a4_b5b == 1'd1 || hit_a4_b6b == 1'd1 || hit_a4_b7b == 1'd1 || hit_a4_b8b == 1'd1 || hit_a4_b9b == 1'd1 || hit_a4_b10b == 1'd1 || hit_a4_b11b == 1'd1 || hit_a4_b12b == 1'd1 || hit_a4_b13b == 1'd1)
				NS4 = rock1_move_225;
			
			else
				NS4 = rock1_move_135;
		end
		rock1_move_45:
		begin
			if( hit_a4_pl == 1'd1 || hit_a4_b1l == 1'd1 || hit_a4_b2l == 1'd1 || hit_a4_b3l == 1'd1 || hit_a4_b5l == 1'd1 || hit_a4_b6l == 1'd1 || hit_a4_b7l == 1'd1 || hit_a4_b8l == 1'd1 || hit_a4_b9l == 1'd1 || hit_a4_b10l == 1'd1 || hit_a4_b11l == 1'd1 || hit_a4_b12l == 1'd1 || hit_a4_b13l == 1'd1)
				NS4 = rock1_move_135;
			else if(  hit_a4_pb == 1'd1 || hit_a4_b1b == 1'd1 || hit_a4_b2b == 1'd1 || hit_a4_b3b == 1'd1 || hit_a4_b5b == 1'd1 || hit_a4_b6b == 1'd1 || hit_a4_b7b == 1'd1 || hit_a4_b8b == 1'd1 || hit_a4_b9b == 1'd1|| hit_a4_b10b == 1'd1 || hit_a4_b11b == 1'd1 || hit_a4_b12b == 1'd1 || hit_a4_b13b == 1'd1)
				NS4 = rock1_move_315;
			
			else
				NS4 = rock1_move_45;
		end
		rock1_shot:
		begin
		if (etc4 >= 32'd1000)
		NS4 = IDKWhatTocallThis;
		else
		NS4 = rock1_shot;
		end
		IDKWhatTocallThis:
		begin
			if (etc4 >= 32'd1005)
				NS4 = rock1_move_225;
			else
				NS4 = IDKWhatTocallThis;
		end
	endcase
	
	case(S5)
		PREGAME: 
		begin
			if (rst == 1'd0)
				NS5 = PREGAME;
			else
				NS5 = start;
		end

		start:
		begin
			if (SG == 1'd0)
				NS5 = start;
			else 
				NS5 =  SA;
		end
		SA:
		begin
			if (y_startScreen >= 11'd499)
				NS5 = rock1_move_45;
			else
				NS5 = SA;
		end
		rock1_move_225:
		begin
			if( hit_a5_ler == 1'd1 || hit_a5_hr == 1'd1 || hit_a5_pr == 1'd1 || hit_a5_b1r == 1'd1 || hit_a5_b2r == 1'd1 || hit_a5_b3r == 1'd1 || hit_a5_b4r == 1'd1 || hit_a5_b6r == 1'd1 || hit_a5_b7r == 1'd1 || hit_a5_b8r == 1'd1 || hit_a5_b9r == 1'd1 || hit_a5_b10r == 1'd1 || hit_a5_b11r == 1'd1 || hit_a5_b12r == 1'd1 || hit_a5_b13r == 1'd1)
				NS5 = rock1_move_315;
			else if(  hit_a5_let == 1'd1 || hit_a5_ht == 1'd1 || hit_a5_pt == 1'd1 || hit_a5_b1t == 1'd1 || hit_a5_b2t == 1'd1 || hit_a5_b3t == 1'd1 || hit_a5_b4t == 1'd1 || hit_a5_b6t == 1'd1 || hit_a5_b7t == 1'd1 || hit_a5_b8t == 1'd1 || hit_a5_b9t == 1'd1 || hit_a5_b10t == 1'd1 || hit_a5_b11t == 1'd1 || hit_a5_b12t == 1'd1 || hit_a5_b13t == 1'd1)
				NS5 = rock1_move_135;
			
			else
				NS5 = rock1_move_225;
			end
		rock1_move_315:
		begin
			if( hit_a5_pl == 1'd1 || hit_a5_b1l == 1'd1 || hit_a5_b2l == 1'd1 || hit_a5_b3l == 1'd1 || hit_a5_b4l == 1'd1 || hit_a5_b6l == 1'd1 || hit_a5_b7l == 1'd1 || hit_a5_b8l == 1'd1 || hit_a5_b9l == 1'd1 || hit_a5_b10l == 1'd1 || hit_a5_b11l == 1'd1 || hit_a5_b12l == 1'd1 || hit_a5_b13l == 1'd1)
				NS5 = rock1_move_225;
			else if(  hit_a5_let == 1'd1 || hit_a5_ht == 1'd1 || hit_a5_pt == 1'd1 || hit_a5_b1t == 1'd1 || hit_a5_b2t == 1'd1 || hit_a5_b3t == 1'd1 || hit_a5_b4t == 1'd1 || hit_a5_b6t == 1'd1 || hit_a5_b7t == 1'd1 || hit_a5_b8t == 1'd1 || hit_a5_b9t == 1'd1 || hit_a5_b10t == 1'd1 || hit_a5_b11t == 1'd1 || hit_a5_b12t == 1'd1 || hit_a5_b13t == 1'd1)
				NS5 = rock1_move_45;
			
			else
				NS5 = rock1_move_315;
		end
		rock1_move_135:
		begin
			if( hit_a5_ler == 1'd1 || hit_a5_hr == 1'd1 || hit_a5_pr == 1'd1 || hit_a5_b1r == 1'd1 || hit_a5_b2r == 1'd1 || hit_a5_b3r == 1'd1 || hit_a5_b4r == 1'd1 || hit_a5_b6r == 1'd1 || hit_a5_b7r == 1'd1 || hit_a5_b8r == 1'd1 || hit_a5_b9r == 1'd1 || hit_a5_b10r == 1'd1 || hit_a5_b11r == 1'd1 || hit_a5_b12r == 1'd1 || hit_a5_b13r == 1'd1)
				NS5 = rock1_move_45;
			else if( hit_a5_pb == 1'd1 || hit_a5_b1b == 1'd1 || hit_a5_b2b == 1'd1 || hit_a5_b3b == 1'd1 || hit_a5_b4b == 1'd1 || hit_a5_b6b == 1'd1 || hit_a5_b7b == 1'd1 || hit_a5_b8b == 1'd1 || hit_a5_b9b == 1'd1 || hit_a5_b10b == 1'd1 || hit_a5_b11b == 1'd1 || hit_a5_b12b == 1'd1 || hit_a5_b13b == 1'd1)
				NS5 = rock1_move_225;
			
			else
				NS5 = rock1_move_135;
		end
		rock1_move_45:
		begin
			if( hit_a5_pl == 1'd1 || hit_a5_b1l == 1'd1 || hit_a5_b2l == 1'd1 || hit_a5_b3l == 1'd1 || hit_a5_b4l == 1'd1 || hit_a5_b6l == 1'd1 || hit_a5_b7l == 1'd1 || hit_a5_b8l == 1'd1 || hit_a5_b9l == 1'd1 || hit_a5_b10l == 1'd1 || hit_a5_b11l == 1'd1 || hit_a5_b12l == 1'd1 || hit_a5_b13l == 1'd1)
				NS5 = rock1_move_135;
			else if(  hit_a5_pb == 1'd1 || hit_a5_b1b == 1'd1 || hit_a5_b2b == 1'd1 || hit_a5_b3b == 1'd1 || hit_a5_b4b == 1'd1 || hit_a5_b6b == 1'd1 || hit_a5_b7b == 1'd1 || hit_a5_b8b == 1'd1 || hit_a5_b9b == 1'd1 || hit_a5_b10b == 1'd1 || hit_a5_b11b == 1'd1 || hit_a5_b12b == 1'd1 || hit_a5_b13b == 1'd1)
				NS5 = rock1_move_315;
			
			else
				NS5 = rock1_move_45;
		end
		rock1_shot:
		begin
		if (etc5 >= 32'd1000)
		NS5 = IDKWhatTocallThis;
		else
		NS5 = rock1_shot;
		end
		IDKWhatTocallThis:
		begin
			if (etc5 >= 32'd1005)
				NS5 = rock1_move_225;
			else
				NS5 = IDKWhatTocallThis;
		end
	endcase
	
	case(S6)
		PREGAME: 
		begin
			if (rst == 1'd0)
				NS6 = PREGAME;
			else
				NS6 = start;
		end

		start:
		begin
			if (SG == 1'd0)
				NS6 = start;
			else 
				NS6 =  SA;
		end
		SA:
		begin
			if (y_startScreen >= 11'd499)
				NS6 = rock1_move_315;
			else
				NS6 = SA;
		end
		rock1_move_225:
		begin
			if(hit_a6_ler == 1'd1 || hit_a6_hr == 1'd1 || hit_a6_pr == 1'd1 || hit_a6_b1r == 1'd1 || hit_a6_b2r == 1'd1 || hit_a6_b3r == 1'd1 || hit_a6_b4r == 1'd1 || hit_a6_b5r == 1'd1 || hit_a6_b7r == 1'd1 || hit_a6_b8r == 1'd1 || hit_a6_b9r == 1'd1 || hit_a6_b10r == 1'd1 || hit_a6_b11r == 1'd1 || hit_a6_b12r == 1'd1 || hit_a6_b13r == 1'd1)
				NS6 = rock1_move_315;
			else if( hit_a6_let == 1'd1 || hit_a6_ht == 1'd1 || hit_a6_pt == 1'd1 || hit_a6_b1t == 1'd1 || hit_a6_b2t == 1'd1 || hit_a6_b3t == 1'd1 || hit_a6_b4t == 1'd1 || hit_a6_b5t == 1'd1 || hit_a6_b7t == 1'd1 || hit_a6_b8t == 1'd1 || hit_a6_b9t == 1'd1 || hit_a6_b10t == 1'd1 || hit_a6_b11t == 1'd1 || hit_a6_b12t == 1'd1 || hit_a6_b13t == 1'd1)
				NS6 = rock1_move_135;
			
			else
				NS6 = rock1_move_225;
			end
		rock1_move_315:
		begin
			if( hit_a6_pl == 1'd1 || hit_a6_b1l == 1'd1 || hit_a6_b2l == 1'd1 || hit_a6_b3l == 1'd1 || hit_a6_b4l == 1'd1 || hit_a6_b5l == 1'd1 || hit_a6_b7l == 1'd1 || hit_a6_b8l == 1'd1 || hit_a6_b9l == 1'd1 || hit_a6_b10l == 1'd1 || hit_a6_b11l == 1'd1 || hit_a6_b12l == 1'd1 || hit_a6_b13l == 1'd1)
				NS6 = rock1_move_225;
			else if( hit_a6_let == 1'd1 || hit_a6_ht == 1'd1 || hit_a6_pt == 1'd1 || hit_a6_b1t == 1'd1 || hit_a6_b2t == 1'd1 || hit_a6_b3t == 1'd1 || hit_a6_b4t == 1'd1 || hit_a6_b5t == 1'd1 || hit_a6_b7t == 1'd1 || hit_a6_b8t == 1'd1 || hit_a6_b9t == 1'd1 || hit_a6_b10t == 1'd1 || hit_a6_b11t == 1'd1 || hit_a6_b12t == 1'd1 || hit_a6_b13t == 1'd1)
				NS6 = rock1_move_45;
			
			else
				NS6 = rock1_move_315;
		end
		rock1_move_135:
		begin
			if(hit_a6_ler == 1'd1 || hit_a6_hr == 1'd1 || hit_a6_pr == 1'd1 || hit_a6_b1r == 1'd1 || hit_a6_b2r == 1'd1 || hit_a6_b3r == 1'd1 || hit_a6_b4r == 1'd1 || hit_a6_b5r == 1'd1 || hit_a6_b7r == 1'd1 || hit_a6_b8r == 1'd1 || hit_a6_b9r == 1'd1 || hit_a6_b10r == 1'd1 || hit_a6_b11r == 1'd1 || hit_a6_b12r == 1'd1 || hit_a6_b13r == 1'd1)
				NS6 = rock1_move_45;
			else if(hit_a6_pb == 1'd1 || hit_a6_b1b == 1'd1 || hit_a6_b2b == 1'd1 || hit_a6_b3b == 1'd1 || hit_a6_b4b == 1'd1 || hit_a6_b5b == 1'd1 || hit_a6_b7b == 1'd1 || hit_a6_b8b == 1'd1 || hit_a6_b9b == 1'd1 || hit_a6_b10b == 1'd1 || hit_a6_b11b == 1'd1 || hit_a6_b12b == 1'd1 || hit_a6_b13b == 1'd1)
				NS6 = rock1_move_225;
			
			else
				NS6 = rock1_move_135;
		end
		rock1_move_45:
		begin
			if(hit_a6_pl == 1'd1 || hit_a6_b1l == 1'd1 || hit_a6_b2l == 1'd1 || hit_a6_b3l == 1'd1 || hit_a6_b4l == 1'd1 || hit_a6_b5l == 1'd1 || hit_a6_b7l == 1'd1 || hit_a6_b8l == 1'd1 || hit_a6_b9l == 1'd1 || hit_a6_b10l == 1'd1 || hit_a6_b11l == 1'd1 || hit_a6_b12l == 1'd1 || hit_a6_b13l == 1'd1)
				NS6 = rock1_move_135;
			else if( hit_a6_pb == 1'd1 || hit_a6_b1b == 1'd1 || hit_a6_b2b == 1'd1 || hit_a6_b3b == 1'd1 || hit_a6_b4b == 1'd1 || hit_a6_b5b == 1'd1 || hit_a6_b7b == 1'd1 || hit_a6_b8b == 1'd1 || hit_a6_b9b == 1'd1 || hit_a6_b10b == 1'd1 || hit_a6_b11b == 1'd1 || hit_a6_b12b == 1'd1 || hit_a6_b13b == 1'd1)
				NS6 = rock1_move_315;
			
			else
				NS6 = rock1_move_45;
		end
		rock1_shot:
		begin
		if (etc6 >= 32'd1000)
		NS6 = IDKWhatTocallThis;
		else
		NS6 = rock1_shot;
		end
		IDKWhatTocallThis:
		begin
			if (etc6 >= 32'd1005)
				NS6 = rock1_move_225;
			else
				NS6 = IDKWhatTocallThis;
		end
	endcase	
	
	case(S7)
		PREGAME: 
		begin
			if (rst == 1'd0)
				NS7 = PREGAME;
			else
				NS7 = start;
		end

		start:
		begin
			if (SG == 1'd0)
				NS7 = start;
			else 
				NS7 =  SA;
		end
		SA:
		begin
			if (y_startScreen >= 11'd499)
				NS7 = rock1_move_45;
			else
				NS7 = SA;
		end
		rock1_move_225:
		begin
			if(hit_a7_ler == 1'd1 || hit_a7_hr == 1'd1 || hit_a7_pr == 1'd1 || hit_a7_b1r == 1'd1 || hit_a7_b2r == 1'd1 || hit_a7_b3r == 1'd1 || hit_a7_b4r == 1'd1 || hit_a7_b5r == 1'd1 || hit_a7_b6r == 1'd1 || hit_a7_b8r == 1'd1 || hit_a7_b9r == 1'd1 || hit_a7_b10r == 1'd1 || hit_a7_b11r == 1'd1 || hit_a7_b12r == 1'd1 || hit_a7_b13r == 1'd1)
				NS7 = rock1_move_315;
			else if(hit_a7_let == 1'd1 || hit_a7_ht == 1'd1 || hit_a7_pt == 1'd1 || hit_a7_b1t == 1'd1 || hit_a7_b2t == 1'd1 || hit_a7_b3t == 1'd1 || hit_a7_b4t == 1'd1 || hit_a7_b5t == 1'd1 || hit_a7_b6t == 1'd1 || hit_a7_b8t == 1'd1 || hit_a7_b9t == 1'd1 || hit_a7_b10t == 1'd1 || hit_a7_b11t == 1'd1 || hit_a7_b12t == 1'd1 || hit_a7_b13t == 1'd1)
				NS7 = rock1_move_135;
			
			else
				NS7 = rock1_move_225;
			end
		rock1_move_315:
		begin
			if(hit_a7_pl == 1'd1 || hit_a7_b1l == 1'd1 || hit_a7_b2l == 1'd1 || hit_a7_b3l == 1'd1 || hit_a7_b4l == 1'd1 || hit_a7_b5l == 1'd1 || hit_a7_b6l == 1'd1 || hit_a7_b8l == 1'd1 || hit_a7_b9l == 1'd1 || hit_a7_b10l == 1'd1 || hit_a7_b11l == 1'd1 || hit_a7_b12l == 1'd1 || hit_a7_b13l == 1'd1)
				NS7 = rock1_move_225;
			else if( hit_a7_let == 1'd1 || hit_a7_ht == 1'd1 || hit_a7_pt == 1'd1 || hit_a7_b1t == 1'd1 || hit_a7_b2t == 1'd1 || hit_a7_b3t == 1'd1 || hit_a7_b4t == 1'd1 || hit_a7_b5t == 1'd1 || hit_a7_b6t == 1'd1 || hit_a7_b8t == 1'd1 || hit_a7_b9t == 1'd1 || hit_a7_b10t == 1'd1 || hit_a7_b11t == 1'd1 || hit_a7_b12t == 1'd1 || hit_a7_b13t == 1'd1)
				NS7 = rock1_move_45;
			
			else
				NS7 = rock1_move_315;
		end
		rock1_move_135:
		begin
			if( hit_a7_ler == 1'd1 || hit_a7_hr == 1'd1 || hit_a7_pr == 1'd1 || hit_a7_b1r == 1'd1 || hit_a7_b2r == 1'd1 || hit_a7_b3r == 1'd1 || hit_a7_b4r == 1'd1 || hit_a7_b5r == 1'd1 || hit_a7_b6r == 1'd1 || hit_a7_b8r == 1'd1 || hit_a7_b9r == 1'd1 || hit_a7_b10r == 1'd1 || hit_a7_b11r == 1'd1 || hit_a7_b12r == 1'd1 || hit_a7_b13r == 1'd1)
				NS7 = rock1_move_45;
			else if(hit_a7_pb == 1'd1 || hit_a7_b1b == 1'd1 || hit_a7_b2b == 1'd1 || hit_a7_b3b == 1'd1 || hit_a7_b4b == 1'd1 || hit_a7_b5b == 1'd1 || hit_a7_b6b == 1'd1 || hit_a7_b8b == 1'd1 || hit_a7_b9b == 1'd1 || hit_a7_b10b == 1'd1 || hit_a7_b11b == 1'd1 || hit_a7_b12b == 1'd1 || hit_a7_b13b == 1'd1)
				NS7 = rock1_move_225;
			
			else
				NS7 = rock1_move_135;
		end
		rock1_move_45:
		begin
			if( hit_a7_pl == 1'd1 || hit_a7_b1l == 1'd1 || hit_a7_b2l == 1'd1 || hit_a7_b3l == 1'd1 || hit_a7_b4l == 1'd1 || hit_a7_b5l == 1'd1 || hit_a7_b6l == 1'd1 || hit_a7_b8l == 1'd1 || hit_a7_b9l == 1'd1 || hit_a7_b10l == 1'd1 || hit_a7_b11l == 1'd1 || hit_a7_b12l == 1'd1 || hit_a7_b13l == 1'd1)
				NS7 = rock1_move_135;
			else if( hit_a7_pb == 1'd1 || hit_a7_b1b == 1'd1 || hit_a7_b2b == 1'd1 || hit_a7_b3b == 1'd1 || hit_a7_b4b == 1'd1 || hit_a7_b5b == 1'd1 || hit_a7_b6b == 1'd1 || hit_a7_b8b == 1'd1 || hit_a7_b9b == 1'd1 || hit_a7_b10b == 1'd1 || hit_a7_b11b == 1'd1 || hit_a7_b12b == 1'd1 || hit_a7_b13b == 1'd1)
				NS7 = rock1_move_315;
			
			else
				NS7 = rock1_move_45;
		end
		rock1_shot:
		begin
		if (etc7 >= 32'd1000)
		NS7 = IDKWhatTocallThis;
		else
		NS7 = rock1_shot;
		end
		IDKWhatTocallThis:
		begin
			if (etc7 >= 32'd1005)
				NS7 = rock1_move_135;
			else
				NS7 = IDKWhatTocallThis;
		end
	endcase	
	
		case(S8)
		PREGAME: 
		begin
			if (rst == 1'd0)
				NS8 = PREGAME;
			else
				NS8 = start;
		end

		start:
		begin
			if (SG == 1'd0)
				NS8 = start;
			else 
				NS8 =  SA;
		end
		SA:
		begin
			if (y_startScreen >= 11'd499)
				NS8 = rock1_move_315;
			else
				NS8 = SA;
		end
		rock1_move_225:
		begin
			if( hit_a8_ler == 1'd1 || hit_a8_hr == 1'd1|| hit_a8_pr == 1'd1 || hit_a8_b1r == 1'd1 || hit_a8_b2r == 1'd1 || hit_a8_b3r == 1'd1 || hit_a8_b4r == 1'd1 || hit_a8_b5r == 1'd1 || hit_a8_b6r == 1'd1 || hit_a8_b7r == 1'd1 || hit_a8_b9r == 1'd1 || hit_a8_b10r == 1'd1 || hit_a8_b11r == 1'd1 || hit_a8_b12r == 1'd1 || hit_a8_b13r == 1'd1)
				NS8 = rock1_move_315;
			else if(hit_a8_let == 1'd1 || hit_a8_ht == 1'd1|| hit_a8_pt == 1'd1 || hit_a8_b1t == 1'd1 || hit_a8_b2t == 1'd1 || hit_a8_b3t == 1'd1 || hit_a8_b4t == 1'd1 || hit_a8_b5t == 1'd1 || hit_a8_b6t == 1'd1 || hit_a8_b7t == 1'd1 || hit_a8_b9t == 1'd1 || hit_a8_b10t == 1'd1 || hit_a8_b11t == 1'd1 || hit_a8_b12t == 1'd1 || hit_a8_b13t == 1'd1)
				NS8 = rock1_move_135;
			
			else
				NS8 = rock1_move_225;
			end
		rock1_move_315:
		begin
			if(hit_a8_pl == 1'd1 || hit_a8_b1l == 1'd1 || hit_a8_b2l == 1'd1 || hit_a8_b3l == 1'd1 || hit_a8_b4l == 1'd1 || hit_a8_b5l == 1'd1 || hit_a8_b6l == 1'd1 || hit_a8_b7l == 1'd1 || hit_a8_b9l == 1'd1 || hit_a8_b10l == 1'd1 || hit_a8_b11l == 1'd1 || hit_a8_b12l == 1'd1 || hit_a8_b13l == 1'd1)
				NS8 = rock1_move_225;
			else if(  hit_a8_let == 1'd1 || hit_a8_ht == 1'd1 || hit_a8_pt == 1'd1 || hit_a8_b1t == 1'd1 || hit_a8_b2t == 1'd1 || hit_a8_b3t == 1'd1 || hit_a8_b4t == 1'd1 || hit_a8_b5t == 1'd1 || hit_a8_b6t == 1'd1 || hit_a8_b7t == 1'd1 || hit_a8_b9t == 1'd1 || hit_a8_b10t == 1'd1 || hit_a8_b11t == 1'd1 || hit_a8_b12t == 1'd1 || hit_a8_b13t == 1'd1)
				NS8 = rock1_move_45;
			
			else
				NS8 = rock1_move_315;
		end
		rock1_move_135:
		begin
			if( hit_a8_ler == 1'd1 || hit_a8_hr == 1'd1 || hit_a8_pr == 1'd1 || hit_a8_b1r == 1'd1 || hit_a8_b2r == 1'd1 || hit_a8_b3r == 1'd1 || hit_a8_b4r == 1'd1 || hit_a8_b5r == 1'd1 || hit_a8_b6r == 1'd1 || hit_a8_b7r == 1'd1 || hit_a8_b9r == 1'd1 || hit_a8_b10r == 1'd1 || hit_a8_b11r == 1'd1 || hit_a8_b12r == 1'd1 || hit_a8_b13r == 1'd1)
				NS8 = rock1_move_45;
			else if( hit_a8_pb == 1'd1 || hit_a8_b1b == 1'd1 || hit_a8_b2b == 1'd1 || hit_a8_b3b == 1'd1 || hit_a8_b4b == 1'd1 || hit_a8_b5b == 1'd1 || hit_a8_b6b == 1'd1 || hit_a8_b7b == 1'd1 || hit_a8_b9b == 1'd1 || hit_a8_b10b == 1'd1 || hit_a8_b11b == 1'd1 || hit_a8_b12b == 1'd1 || hit_a8_b13b == 1'd1)
				NS8 = rock1_move_225;
			
			else
				NS8 = rock1_move_135;
		end
		rock1_move_45:
		begin
			if(  hit_a8_pl == 1'd1 || hit_a8_b1l == 1'd1 || hit_a8_b2l == 1'd1 || hit_a8_b3l == 1'd1 || hit_a8_b4l == 1'd1 || hit_a8_b5l == 1'd1 || hit_a8_b6l == 1'd1 || hit_a8_b7l == 1'd1 || hit_a8_b9l == 1'd1 || hit_a8_b10l == 1'd1 || hit_a8_b11l == 1'd1 || hit_a8_b12l == 1'd1 || hit_a8_b13l == 1'd1)
				NS8 = rock1_move_135;
			else if( hit_a8_pb == 1'd1 || hit_a8_b1b == 1'd1 || hit_a8_b2b == 1'd1 || hit_a8_b3b == 1'd1 || hit_a8_b4b == 1'd1 || hit_a8_b5b == 1'd1 || hit_a8_b6b == 1'd1 || hit_a8_b7b == 1'd1 || hit_a8_b9b == 1'd1 || hit_a8_b10b == 1'd1 || hit_a8_b11b == 1'd1 || hit_a8_b12b == 1'd1 || hit_a8_b13b == 1'd1)
				NS8 = rock1_move_315;
			
			else
				NS8 = rock1_move_45;
		end
		rock1_shot:
		begin
		if (etc8 >= 32'd1000)
		NS8 = IDKWhatTocallThis;
		else
		NS8 = rock1_shot;
		end
		IDKWhatTocallThis:
		begin
			if (etc8 >= 32'd1005)
				NS8 = rock1_move_225;
			else
				NS8 = IDKWhatTocallThis;
		end
	endcase

		case(S9)
		PREGAME: 
		begin
			if (rst == 1'd0)
				NS9 = PREGAME;
			else
				NS9 = start;
		end
		start:
		begin
			if (SG == 1'd0)
				NS9 = start;
			else 
				NS9 =  SA;
		end
		SA:
		begin
			if (y_startScreen >= 11'd499)
				NS9 = rock1_move_315;
			else
				NS9 = SA;
		end
		rock1_move_225:
		begin
			if( hit_a9_ler == 1'd1 || hit_a9_hr == 1'd1 || hit_a9_pr == 1'd1 || hit_a9_b1r == 1'd1 || hit_a9_b2r == 1'd1 || hit_a9_b3r == 1'd1 || hit_a9_b4r == 1'd1 || hit_a9_b5r == 1'd1 || hit_a9_b6r == 1'd1 || hit_a9_b7r == 1'd1 || hit_a9_b8r == 1'd1 || hit_a9_b10r == 1'd1 || hit_a9_b11r == 1'd1 || hit_a9_b12r == 1'd1 || hit_a9_b13r == 1'd1)
				NS9 = rock1_move_315;
			else if( hit_a9_let == 1'd1 || hit_a9_ht == 1'd1 || hit_a9_pt == 1'd1 || hit_a9_b1t == 1'd1 || hit_a9_b2t == 1'd1 || hit_a9_b3t == 1'd1 || hit_a9_b4t == 1'd1 || hit_a9_b5t == 1'd1 || hit_a9_b6t == 1'd1 || hit_a9_b7t == 1'd1 || hit_a9_b8t == 1'd1 || hit_a9_b10t == 1'd1 || hit_a9_b11t == 1'd1 || hit_a9_b12t == 1'd1 || hit_a9_b13t == 1'd1)
				NS9 = rock1_move_135;
			
			else
				NS9 = rock1_move_225;
			end
		rock1_move_315:
		begin
			if(hit_a9_pl == 1'd1 || hit_a9_b1l == 1'd1 || hit_a9_b2l == 1'd1 || hit_a9_b3l == 1'd1 || hit_a9_b4l == 1'd1 || hit_a9_b5l == 1'd1 || hit_a9_b6l == 1'd1 || hit_a9_b7l == 1'd1 || hit_a9_b8l == 1'd1 || hit_a9_b10l == 1'd1 || hit_a9_b11l == 1'd1 || hit_a9_b12l == 1'd1 || hit_a9_b13l == 1'd1)
				NS9 = rock1_move_225;
			else if( hit_a9_let == 1'd1 || hit_a9_ht == 1'd1 || hit_a9_pt == 1'd1 || hit_a9_b1t == 1'd1 || hit_a9_b2t == 1'd1 || hit_a9_b3t == 1'd1 || hit_a9_b4t == 1'd1 || hit_a9_b5t == 1'd1 || hit_a9_b6t == 1'd1 || hit_a9_b7t == 1'd1 || hit_a9_b8t == 1'd1 || hit_a9_b10t == 1'd1 || hit_a9_b11t == 1'd1 || hit_a9_b12t == 1'd1 || hit_a9_b13t == 1'd1)
				NS9 = rock1_move_45;
			
			else
				NS9 = rock1_move_315;
		end
		rock1_move_135:
		begin
			if( hit_a9_ler == 1'd1 || hit_a9_hr == 1'd1 || hit_a9_pr == 1'd1 || hit_a9_b1r == 1'd1 || hit_a9_b2r == 1'd1 || hit_a9_b3r == 1'd1 || hit_a9_b4r == 1'd1 || hit_a9_b5r == 1'd1 || hit_a9_b6r == 1'd1 || hit_a9_b7r == 1'd1 || hit_a9_b8r == 1'd1 || hit_a9_b10r == 1'd1 || hit_a9_b11r == 1'd1 || hit_a9_b12r == 1'd1 || hit_a9_b13r == 1'd1)
				NS9 = rock1_move_45;
			else if( hit_a9_pb == 1'd1 || hit_a9_b1b == 1'd1 || hit_a9_b2b == 1'd1 || hit_a9_b3b == 1'd1 || hit_a9_b4b == 1'd1 || hit_a9_b5b == 1'd1 || hit_a9_b6b == 1'd1 || hit_a9_b7b == 1'd1 || hit_a9_b8b == 1'd1 || hit_a9_b10b == 1'd1 || hit_a9_b11b == 1'd1 || hit_a9_b12b == 1'd1 || hit_a9_b13b == 1'd1)
				NS9 = rock1_move_225;
			
			else
				NS9 = rock1_move_135;
		end
		rock1_move_45:
		begin
			if( hit_a9_pl == 1'd1 || hit_a9_b1l == 1'd1 || hit_a9_b2l == 1'd1 || hit_a9_b3l == 1'd1 || hit_a9_b4l == 1'd1 || hit_a9_b5l == 1'd1 || hit_a9_b6l == 1'd1 || hit_a9_b8l == 1'd1 || hit_a9_b7l == 1'd1 || hit_a9_b10l == 1'd1 || hit_a9_b11l == 1'd1 || hit_a9_b12l == 1'd1 || hit_a9_b13l == 1'd1)
				NS9 = rock1_move_135;
			else if(hit_a9_pb == 1'd1 || hit_a9_b1b == 1'd1 || hit_a9_b2b == 1'd1 || hit_a9_b3b == 1'd1 || hit_a9_b4b == 1'd1 || hit_a9_b5b == 1'd1 || hit_a9_b6b == 1'd1 || hit_a9_b7b == 1'd1 || hit_a9_b8b == 1'd1 || hit_a9_b10b == 1'd1 || hit_a9_b11b == 1'd1 || hit_a9_b12b == 1'd1 || hit_a9_b13b == 1'd1)
				NS9 = rock1_move_315;
			
			else
				NS9 = rock1_move_45;
		end
		rock1_shot:
		begin
		if (etc9 >= 32'd1000)
		NS9 = IDKWhatTocallThis;
		else
		NS9 = rock1_shot;
		end
		IDKWhatTocallThis:
		begin
			if (etc9 >= 32'd1005)
				NS9 = rock1_move_135;
			else
				NS9 = IDKWhatTocallThis;
		end
	endcase
	
	case(S10)
		PREGAME: 
		begin
			if (rst == 1'd0)
				NS10 = PREGAME;
			else
				NS10 = start;
		end
		start:
		begin
			if (SG == 1'd0)
				NS10 = start;
			else 
				NS10 =  SA;
		end
		SA:
		begin
			if (y_startScreen >= 11'd499)
				NS10 = rock1_move_315;
			else
				NS10 = SA;
		end
		rock1_move_225:
		begin
			if( hit_a10_ler == 1'd1 || hit_a10_hr == 1'd1 || hit_a10_pr == 1'd1 || hit_a10_b1r == 1'd1 || hit_a10_b2r == 1'd1 || hit_a10_b3r == 1'd1 || hit_a10_b4r == 1'd1 || hit_a10_b5r == 1'd1 || hit_a10_b6r == 1'd1 || hit_a10_b7r == 1'd1 || hit_a10_b8r == 1'd1 || hit_a10_b9r == 1'd1 || hit_a10_b11r == 1'd1 || hit_a10_b12r == 1'd1 || hit_a10_b13r == 1'd1)
				NS10 = rock1_move_315;
			else if( hit_a10_let == 1'd1 || hit_a10_ht == 1'd1 || hit_a10_pt == 1'd1 || hit_a10_b1t == 1'd1 || hit_a10_b2t == 1'd1 || hit_a10_b3t == 1'd1 || hit_a10_b4t == 1'd1 || hit_a10_b5t == 1'd1 || hit_a10_b6t == 1'd1 || hit_a10_b7t == 1'd1 || hit_a10_b8t == 1'd1 || hit_a10_b9t == 1'd1 || hit_a10_b11t == 1'd1 || hit_a10_b12t == 1'd1 || hit_a10_b13t == 1'd1)
				NS10 = rock1_move_135;
			
			else
				NS10 = rock1_move_225;
			end
		rock1_move_315:
		begin
			if(hit_a10_pl == 1'd1 || hit_a10_b1l == 1'd1 || hit_a10_b2l == 1'd1 || hit_a10_b3l == 1'd1 || hit_a10_b4l == 1'd1 || hit_a10_b5l == 1'd1 || hit_a10_b6l == 1'd1 || hit_a10_b7l == 1'd1 || hit_a10_b8l == 1'd1 || hit_a10_b9l == 1'd1 || hit_a10_b11l == 1'd1 || hit_a10_b12l == 1'd1 || hit_a10_b13l == 1'd1)
				NS10 = rock1_move_225;
			else if( hit_a10_let == 1'd1 || hit_a10_ht == 1'd1 || hit_a10_pt == 1'd1 || hit_a10_b1t == 1'd1 || hit_a10_b2t == 1'd1 || hit_a10_b3t == 1'd1 || hit_a10_b4t == 1'd1 || hit_a10_b5t == 1'd1 || hit_a10_b6t == 1'd1 || hit_a10_b7t == 1'd1 || hit_a10_b8t == 1'd1 || hit_a10_b9t == 1'd1 || hit_a10_b11t == 1'd1 || hit_a10_b12t == 1'd1 || hit_a10_b13t == 1'd1)
				NS10 = rock1_move_45;
			
			else
				NS10 = rock1_move_315;
		end
		rock1_move_135:
		begin
			if( hit_a10_ler == 1'd1 || hit_a10_hr == 1'd1 || hit_a10_pr == 1'd1 || hit_a10_b1r == 1'd1 || hit_a10_b2r == 1'd1 || hit_a10_b3r == 1'd1 || hit_a10_b4r == 1'd1 || hit_a10_b5r == 1'd1 || hit_a10_b6r == 1'd1 || hit_a10_b7r == 1'd1 || hit_a10_b8r == 1'd1 || hit_a10_b9r == 1'd1 || hit_a10_b11r == 1'd1 || hit_a10_b12r == 1'd1 || hit_a10_b13r == 1'd1)
				NS10 = rock1_move_45;
			else if( hit_a10_pb == 1'd1 || hit_a10_b1b == 1'd1 || hit_a10_b2b == 1'd1 || hit_a10_b3b == 1'd1 || hit_a10_b4b == 1'd1 || hit_a10_b5b == 1'd1 || hit_a10_b6b == 1'd1 || hit_a10_b7b == 1'd1 || hit_a10_b8b == 1'd1 || hit_a10_b9b == 1'd1 || hit_a10_b11b == 1'd1 || hit_a10_b12b == 1'd1 || hit_a10_b13b == 1'd1)
				NS10 = rock1_move_225;
			
			else
				NS10 = rock1_move_135;
		end
		rock1_move_45:
		begin
			if( hit_a10_pl == 1'd1 || hit_a10_b1l == 1'd1 || hit_a10_b2l == 1'd1 || hit_a10_b3l == 1'd1 || hit_a10_b4l == 1'd1 || hit_a10_b5l == 1'd1 || hit_a10_b6l == 1'd1 || hit_a10_b7l == 1'd1 || hit_a10_b8l == 1'd1 || hit_a10_b9l == 1'd1 || hit_a10_b11l == 1'd1 || hit_a10_b12l == 1'd1 || hit_a10_b13l == 1'd1)
				NS10 = rock1_move_135;
			else if(hit_a10_pb == 1'd1 || hit_a10_b1b == 1'd1 || hit_a10_b2b == 1'd1 || hit_a10_b3b == 1'd1 || hit_a10_b4b == 1'd1 || hit_a10_b5b == 1'd1 || hit_a10_b6b == 1'd1 || hit_a10_b7b == 1'd1 || hit_a10_b8b == 1'd1 || hit_a10_b9b == 1'd1 || hit_a10_b11b == 1'd1 || hit_a10_b12b == 1'd1 || hit_a10_b13b == 1'd1)
				NS10 = rock1_move_315;
			
			else
				NS10 = rock1_move_45;
		end
		rock1_shot:
		begin
		if (etc10 >= 32'd1000)
		NS10 = IDKWhatTocallThis;
		else
		NS10 = rock1_shot;
		end
		IDKWhatTocallThis:
		begin
			if (etc10 >= 32'd1005)
				NS10 = rock1_move_135;
			else
				NS10 = IDKWhatTocallThis;
		end
	endcase
	case(S11)
		PREGAME: 
		begin
			if (rst == 1'd0)
				NS11 = PREGAME;
			else
				NS11 = start;
		end
		start:
		begin
			if (SG == 1'd0)
				NS11 = start;
			else 
				NS11 =  SA;
		end
		SA:
		begin
			if (y_startScreen >= 11'd499)
				NS11 = rock1_move_315;
			else
				NS11 = SA;
		end
		rock1_move_225:
		begin
			if( hit_a11_ler == 1'd1 || hit_a11_hr == 1'd1 || hit_a11_pr == 1'd1 || hit_a11_b1r == 1'd1 || hit_a11_b2r == 1'd1 || hit_a11_b3r == 1'd1 || hit_a11_b4r == 1'd1 || hit_a11_b5r == 1'd1 || hit_a11_b6r == 1'd1 || hit_a11_b7r == 1'd1 || hit_a11_b8r == 1'd1 || hit_a11_b10r == 1'd1 || hit_a11_b9r == 1'd1 || hit_a11_b12r == 1'd1 || hit_a11_b13r == 1'd1)
				NS11 = rock1_move_315;
			else if( hit_a11_let == 1'd1 || hit_a11_ht == 1'd1 || hit_a11_pt == 1'd1 || hit_a11_b1t == 1'd1 || hit_a11_b2t == 1'd1 || hit_a11_b3t == 1'd1 || hit_a11_b4t == 1'd1 || hit_a11_b5t == 1'd1 || hit_a11_b6t == 1'd1 || hit_a11_b7t == 1'd1 || hit_a11_b8t == 1'd1 || hit_a11_b10t == 1'd1 || hit_a11_b9t == 1'd1 || hit_a11_b12t == 1'd1 || hit_a11_b13t == 1'd1)
				NS11 = rock1_move_135;
			
			else
				NS11 = rock1_move_225;
			end
		rock1_move_315:
		begin
			if(hit_a11_pl == 1'd1 || hit_a11_b1l == 1'd1 || hit_a11_b2l == 1'd1 || hit_a11_b3l == 1'd1 || hit_a11_b4l == 1'd1 || hit_a11_b5l == 1'd1 || hit_a11_b6l == 1'd1 || hit_a11_b7l == 1'd1 || hit_a11_b8l == 1'd1 || hit_a11_b10l == 1'd1 || hit_a11_b9l == 1'd1 || hit_a11_b12l == 1'd1 || hit_a11_b13l == 1'd1)
				NS11 = rock1_move_225;
			else if( hit_a11_let == 1'd1 || hit_a11_ht == 1'd1 || hit_a11_pt == 1'd1 || hit_a11_b1t == 1'd1 || hit_a11_b2t == 1'd1 || hit_a11_b3t == 1'd1 || hit_a11_b4t == 1'd1 || hit_a11_b5t == 1'd1 || hit_a11_b6t == 1'd1 || hit_a11_b7t == 1'd1 || hit_a11_b8t == 1'd1 || hit_a11_b10t == 1'd1 || hit_a11_b9t == 1'd1 || hit_a11_b12t == 1'd1 || hit_a11_b13t == 1'd1)
				NS11 = rock1_move_45;
			
			else
				NS11 = rock1_move_315;
		end
		rock1_move_135:
		begin
			if( hit_a11_ler == 1'd1 || hit_a11_hr == 1'd1 || hit_a11_pr == 1'd1 || hit_a11_b1r == 1'd1 || hit_a11_b2r == 1'd1 || hit_a11_b3r == 1'd1 || hit_a11_b4r == 1'd1 || hit_a11_b5r == 1'd1 || hit_a11_b6r == 1'd1 || hit_a11_b8r == 1'd1 || hit_a11_b7r == 1'd1 || hit_a11_b10r == 1'd1 || hit_a11_b9r == 1'd1 || hit_a11_b12r == 1'd1 || hit_a11_b13r == 1'd1)
				NS11 = rock1_move_45;
			else if( hit_a11_pb == 1'd1 || hit_a11_b1b == 1'd1 || hit_a11_b2b == 1'd1 || hit_a11_b3b == 1'd1 || hit_a11_b4b == 1'd1 || hit_a11_b5b == 1'd1 || hit_a11_b6b == 1'd1 || hit_a11_b7b == 1'd1 || hit_a11_b8b == 1'd1 || hit_a11_b10b == 1'd1 || hit_a11_b9b == 1'd1 || hit_a11_b12b == 1'd1 || hit_a11_b13b == 1'd1)
				NS11 = rock1_move_225;
			
			else
				NS11 = rock1_move_135;
		end
		rock1_move_45:
		begin
			if( hit_a11_pl == 1'd1 || hit_a11_b1l == 1'd1 || hit_a11_b2l == 1'd1 || hit_a11_b3l == 1'd1 || hit_a11_b4l == 1'd1 || hit_a11_b5l == 1'd1 || hit_a11_b6l == 1'd1 || hit_a11_b8l == 1'd1 || hit_a11_b7l == 1'd1 || hit_a11_b10l == 1'd1 || hit_a11_b9l == 1'd1 || hit_a11_b12l == 1'd1 || hit_a11_b13l == 1'd1)
				NS11 = rock1_move_135;
			else if(hit_a11_pb == 1'd1 || hit_a11_b1b == 1'd1 || hit_a11_b2b == 1'd1 || hit_a11_b3b == 1'd1 || hit_a11_b4b == 1'd1 || hit_a11_b5b == 1'd1 || hit_a11_b6b == 1'd1 || hit_a11_b8b == 1'd1 || hit_a11_b7b == 1'd1 || hit_a11_b10b == 1'd1 || hit_a11_b9b == 1'd1 || hit_a11_b12b == 1'd1 || hit_a11_b13b == 1'd1)
				NS11 = rock1_move_315;
			
			else
				NS11 = rock1_move_45;
		end
		rock1_shot:
		begin
		if (etc11 >= 32'd1000)
		NS11 = IDKWhatTocallThis;
		else
		NS11 = rock1_shot;
		end
		IDKWhatTocallThis:
		begin
			if (etc11 >= 32'd1005)
				NS11 = rock1_move_135;
			else
				NS11 = IDKWhatTocallThis;
		end
	endcase
	
	case(S12)
		PREGAME: 
		begin
			if (rst == 1'd0)
				NS12 = PREGAME;
			else
				NS12 = start;
		end
		start:
		begin
			if (SG == 1'd0)
				NS12 = start;
			else 
				NS12 =  SA;
		end
		SA:
		begin
			if (y_startScreen >= 11'd499)
				NS12 = rock1_move_315;
			else
				NS12 = SA;
		end
		rock1_move_225:
		begin
			if( hit_a12_ler == 1'd1 || hit_a12_hr == 1'd1 || hit_a12_pr == 1'd1 || hit_a12_b1r == 1'd1 || hit_a12_b2r == 1'd1 || hit_a12_b3r == 1'd1 || hit_a12_b4r == 1'd1 || hit_a12_b5r == 1'd1 || hit_a12_b6r == 1'd1 || hit_a12_b7r == 1'd1 || hit_a12_b8r == 1'd1 || hit_a12_b10r == 1'd1 || hit_a12_b11r == 1'd1 || hit_a12_b9r == 1'd1 || hit_a12_b13r == 1'd1)
				NS12 = rock1_move_315;
			else if( hit_a12_let == 1'd1 || hit_a12_ht == 1'd1 || hit_a12_pt == 1'd1 || hit_a12_b1t == 1'd1 || hit_a12_b2t == 1'd1 || hit_a12_b3t == 1'd1 || hit_a12_b4t == 1'd1 || hit_a12_b5t == 1'd1 || hit_a12_b6t == 1'd1 || hit_a12_b7t == 1'd1 || hit_a12_b8t == 1'd1 || hit_a12_b10t == 1'd1 || hit_a12_b11t == 1'd1 || hit_a12_b9t == 1'd1 || hit_a12_b13t == 1'd1)
				NS12 = rock1_move_135;
			
			else
				NS12 = rock1_move_225;
			end
		rock1_move_315:
		begin
			if(hit_a12_pl == 1'd1 || hit_a12_b1l == 1'd1 || hit_a12_b2l == 1'd1 || hit_a12_b3l == 1'd1 || hit_a12_b4l == 1'd1 || hit_a12_b5l == 1'd1 || hit_a12_b6l == 1'd1 || hit_a12_b7l == 1'd1 || hit_a12_b7l == 1'd1 || hit_a12_b10l == 1'd1 || hit_a12_b11l == 1'd1 || hit_a12_b9l == 1'd1 || hit_a12_b13l == 1'd1)
				NS12 = rock1_move_225;
			else if( hit_a12_let == 1'd1 || hit_a12_ht == 1'd1 || hit_a12_pt == 1'd1 || hit_a12_b1t == 1'd1 || hit_a12_b2t == 1'd1 || hit_a12_b3t == 1'd1 || hit_a12_b4t == 1'd1 || hit_a12_b5t == 1'd1 || hit_a12_b6t == 1'd1 || hit_a12_b7t == 1'd1 || hit_a12_b7t == 1'd1 || hit_a12_b10t == 1'd1 || hit_a12_b11t == 1'd1 || hit_a12_b9t == 1'd1 || hit_a12_b13t == 1'd1)
				NS12 = rock1_move_45;
			
			else
				NS12 = rock1_move_315;
		end
		rock1_move_135:
		begin
			if( hit_a12_ler == 1'd1 || hit_a12_hr == 1'd1 || hit_a12_pr == 1'd1 || hit_a12_b1r == 1'd1 || hit_a12_b2r == 1'd1 || hit_a12_b3r == 1'd1 || hit_a12_b4r == 1'd1 || hit_a12_b5r == 1'd1 || hit_a12_b6r == 1'd1 || hit_a12_b7r == 1'd1 || hit_a12_b7r == 1'd1 || hit_a12_b10r == 1'd1 || hit_a12_b11r == 1'd1 || hit_a12_b9r == 1'd1 || hit_a12_b13r == 1'd1)
				NS12 = rock1_move_45;
			else if( hit_a12_pb == 1'd1 || hit_a12_b1b == 1'd1 || hit_a12_b2b == 1'd1 || hit_a12_b3b == 1'd1 || hit_a12_b4b == 1'd1 || hit_a12_b5b == 1'd1 || hit_a12_b6b == 1'd1 || hit_a12_b7b == 1'd1 || hit_a12_b7b == 1'd1 || hit_a12_b10b == 1'd1 || hit_a12_b11b == 1'd1 || hit_a12_b9b == 1'd1 || hit_a12_b13b == 1'd1)
				NS12 = rock1_move_225;
			
			else
				NS12 = rock1_move_135;
		end
		rock1_move_45:
		begin
			if( hit_a12_pl == 1'd1 || hit_a12_b1l == 1'd1 || hit_a12_b2l == 1'd1 || hit_a12_b3l == 1'd1 || hit_a12_b4l == 1'd1 || hit_a12_b5l == 1'd1 || hit_a12_b6l == 1'd1 || hit_a12_b8l == 1'd1 || hit_a12_b7l == 1'd1 || hit_a12_b10l == 1'd1 || hit_a12_b11l == 1'd1 || hit_a12_b9l == 1'd1 || hit_a12_b13l == 1'd1)
				NS12 = rock1_move_135;
			else if(hit_a11_pb == 1'd1 || hit_a12_b1b == 1'd1 || hit_a12_b2b == 1'd1 || hit_a12_b3b == 1'd1 || hit_a12_b4b == 1'd1 || hit_a12_b5b == 1'd1 || hit_a12_b6b == 1'd1 || hit_a12_b8b == 1'd1 || hit_a12_b7b == 1'd1 || hit_a12_b10b == 1'd1 || hit_a12_b11b == 1'd1 || hit_a12_b9b == 1'd1 || hit_a12_b13b == 1'd1)
				NS12 = rock1_move_315;
			
			else
				NS12 = rock1_move_45;
		end
		rock1_shot:
		begin
		if (etc12 >= 32'd1000)
		NS12 = IDKWhatTocallThis;
		else
		NS12 = rock1_shot;
		end
		IDKWhatTocallThis:
		begin
			if (etc12 >= 32'd1005)
				NS12 = rock1_move_135;
			else
				NS12 = IDKWhatTocallThis;
		end
	endcase
	
	case(S13)
		PREGAME: 
		begin
			if (rst == 1'd0)
				NS13 = PREGAME;
			else
				NS13 = start;
		end
		start:
		begin
			if (SG == 1'd0)
				NS13 = start;
			else 
				NS13 =  SA;
		end
		SA:
		begin
			if (y_startScreen >= 11'd499)
				NS13 = rock1_move_315;
			else
				NS13 = SA;
		end
		rock1_move_225:
		begin
			if( hit_a13_ler == 1'd1 || hit_a13_hr == 1'd1 || hit_a13_pr == 1'd1 || hit_a13_b1r == 1'd1 || hit_a13_b2r == 1'd1 || hit_a13_b3r == 1'd1 || hit_a13_b4r == 1'd1 || hit_a13_b5r == 1'd1 || hit_a13_b6r == 1'd1 || hit_a13_b7r == 1'd1 || hit_a13_b8r == 1'd1 || hit_a13_b10r == 1'd1 || hit_a13_b11r == 1'd1 || hit_a13_b12r == 1'd1 || hit_a13_b9r == 1'd1)
				NS13 = rock1_move_315;
			else if( hit_a13_let == 1'd1 || hit_a13_ht == 1'd1 || hit_a13_pt == 1'd1 || hit_a13_b1t == 1'd1 || hit_a13_b2t == 1'd1 || hit_a13_b3t == 1'd1 || hit_a13_b4t == 1'd1 || hit_a13_b5t == 1'd1 || hit_a13_b6t == 1'd1 || hit_a13_b7t == 1'd1 || hit_a13_b8t == 1'd1 || hit_a13_b10t == 1'd1 || hit_a13_b11t == 1'd1 || hit_a13_b12t == 1'd1 || hit_a13_b9t == 1'd1)
				NS13 = rock1_move_135;
			
			else
				NS13 = rock1_move_225;
			end
		rock1_move_315:
		begin
			if(hit_a13_pl == 1'd1 || hit_a13_b1l == 1'd1 || hit_a13_b2l == 1'd1 || hit_a13_b3l == 1'd1 || hit_a13_b4l == 1'd1 || hit_a13_b5l == 1'd1 || hit_a13_b6l == 1'd1 || hit_a13_b7l == 1'd1 || hit_a13_b8l == 1'd1 || hit_a13_b10l == 1'd1 || hit_a13_b11l == 1'd1 || hit_a13_b12l == 1'd1 || hit_a13_b9l == 1'd1)
				NS13 = rock1_move_225;
			else if( hit_a13_let == 1'd1 || hit_a13_ht == 1'd1 || hit_a13_pt == 1'd1 || hit_a13_b1t == 1'd1 || hit_a13_b2t == 1'd1 || hit_a13_b3t == 1'd1 || hit_a13_b4t == 1'd1 || hit_a13_b5t == 1'd1 || hit_a13_b6t == 1'd1 || hit_a13_b8t == 1'd1 || hit_a13_b7t == 1'd1 || hit_a13_b10t == 1'd1 || hit_a13_b11t == 1'd1 || hit_a13_b12t == 1'd1 || hit_a13_b9t == 1'd1)
				NS13 = rock1_move_45;
			
			else
				NS13 = rock1_move_315;
		end
		rock1_move_135:
		begin
			if( hit_a13_ler == 1'd1 || hit_a13_hr == 1'd1 || hit_a13_pr == 1'd1 || hit_a13_b1r == 1'd1 || hit_a13_b2r == 1'd1 || hit_a13_b3r == 1'd1 || hit_a13_b4r == 1'd1 || hit_a13_b5r == 1'd1 || hit_a13_b6r == 1'd1 || hit_a13_b7r == 1'd1 || hit_a13_b8r == 1'd1 || hit_a13_b10r == 1'd1 || hit_a13_b11r == 1'd1 || hit_a13_b12r == 1'd1 || hit_a13_b9r == 1'd1)
				NS13 = rock1_move_45;
			else if( hit_a13_pb == 1'd1 || hit_a13_b1b == 1'd1 || hit_a13_b2b == 1'd1 || hit_a13_b3b == 1'd1 || hit_a13_b4b == 1'd1 || hit_a13_b5b == 1'd1 || hit_a13_b6b == 1'd1 || hit_a13_b7b == 1'd1 || hit_a13_b8b == 1'd1 || hit_a13_b10b == 1'd1 || hit_a13_b11b == 1'd1 || hit_a13_b12b == 1'd1 || hit_a13_b9b == 1'd1)
				NS13 = rock1_move_225;
			
			else
				NS13 = rock1_move_135;
		end
		rock1_move_45:
		begin
			if( hit_a13_pl == 1'd1 || hit_a13_b1l == 1'd1 || hit_a13_b2l == 1'd1 || hit_a13_b3l == 1'd1 || hit_a13_b4l == 1'd1 || hit_a13_b5l == 1'd1 || hit_a13_b6l == 1'd1 || hit_a13_b7l == 1'd1 || hit_a13_b8l == 1'd1 || hit_a13_b10l == 1'd1 || hit_a13_b11l == 1'd1 || hit_a13_b12l == 1'd1 || hit_a13_b9l == 1'd1)
				NS13 = rock1_move_135;
			else if(hit_a13_pb == 1'd1 || hit_a13_b1b == 1'd1 || hit_a13_b2b == 1'd1 || hit_a13_b3b == 1'd1 || hit_a13_b4b == 1'd1 || hit_a13_b5b == 1'd1 || hit_a13_b6b == 1'd1 || hit_a13_b7b == 1'd1 || hit_a13_b8b == 1'd1 || hit_a13_b10b == 1'd1 || hit_a13_b11b == 1'd1 || hit_a13_b12b == 1'd1 || hit_a13_b9b == 1'd1)
				NS13 = rock1_move_315;
			
			else
				NS13 = rock1_move_45;
		end
		rock1_shot:
		begin
		if (etc13 >= 32'd1000)
		NS13 = IDKWhatTocallThis;
		else
		NS13 = rock1_shot;
		end
		IDKWhatTocallThis:
		begin
			if (etc13 >= 32'd1005)
				NS13 = rock1_move_135;
			else
				NS13 = IDKWhatTocallThis;
		end
	endcase
end

//reset control. 
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
		S10 <= 11'd0;
		S11 <= 11'd0;
		S12 <= 11'd0;
		S13 <= 11'd0;

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
		S10 <= NS10;
		S11 <= NS11;
		S12 <= NS12;
		S13 <= NS13;
	end
end

//state transitions. There are too many of these, but oh well
always @ (posedge update or negedge rst)
begin
	case (S)
		PREGAME: 
		begin
			if (rst == 1'd0)
				NS = PREGAME;
			else
				NS = start;
		end

		start:
		begin
			if (SG == 1'd1)
				NS = start;
			else 
				NS = SA;
		end		
		SA:
		begin
			if (y_startScreen >= 11'd499)
				NS = laser_reload;
			else
				NS = SA;
		end
		laserRight:
		begin 
			
			if((xShot < 11'd622 && hit_rock1 == 1'd0 && hit_rock2 == 1'd0 && hit_rock3 == 1'd0 && hit_rock4 == 1'd0 && hit_rock5 == 1'd0 && hit_rock6 == 1'd0 && hit_rock7 == 1'd0 && hit_rock8 == 1'd0 && hit_rock9 == 1'd0 && hit_rock10 == 1'd0 && hit_rock11 == 1'd0 && hit_rock12 == 1'd0 && hit_rock13 == 1'd0) && hit_me == 1'd0)
				NS = laserRight;
			else if(hit_rock1 == 1'd1 || hit_rock2 == 1'd1 || hit_rock3 == 1'd1 || hit_rock4 == 1'd1 || hit_rock5 == 1'd1 || hit_rock6 == 1'd1 || hit_rock7 == 1'd1 || hit_rock8 == 1'd1 || hit_rock9 == 1'd1 || hit_rock10 == 1'd1 || hit_rock11 == 1'd1 || hit_rock12 == 1'd1 || hit_rock13 == 1'd1)
				NS = laser_reload1; //2 different states for reloading. One for when the laser goes off the map, the other for when it hits something
			else if( xShot >= 11'd622)
				NS = laser_reload; 
			if (life == 11'd0)
				NS = end_game;
		end
			
		laser_reload: //this reload state is for when the shot hits.
		begin	
			
			if(fire == 1'd1)
				NS = laserRight;
			else
				NS = laser_reload;
			if (life == 11'd0)
				NS = end_game;
		end
		
		laser_reload1: //this reload is the one for missing and hitting the map border 
		begin	
			
			if(fire == 1'd1) // Do you want to shoot asteroids? this code lets you do just that.
				NS = laserRight;
			else
				NS = laser_reload;
			if (life == 11'd0)
				NS = end_game;
		end
		
		end_game:
			NS = end_game;
	endcase	
	
	case(S1)
		PREGAME: 
		begin
			if (rst == 1'd0)
				NS1 = PREGAME;
			else
				NS1 = start;
		end

		start:
		begin
			if (SG == 1'd0)
				NS1 = start;
			else 
				NS1 = SA;
		end
		SA:
		begin
			if (y_startScreen >= 11'd499)
				NS1 = rock1_move_45;
			else
				NS1 = SA;
		end
		rock1_move_225:
		begin
			if( hit_a1_ler == 1'd1 || hit_a1_hr == 1'd1 || hit_a1_pr == 1'd1  || hit_a1_b2r == 1'd1 || hit_a1_b3r == 1'd1 || hit_a1_b4r == 1'd1 || hit_a1_b5r == 1'd1 || hit_a1_b6r == 1'd1 || hit_a1_b7r == 1'd1 || hit_a1_b8r == 1'd1 || hit_a1_b9r == 1'd1 || hit_a1_b10r == 1'd1 || hit_a1_b11r == 1'd1 || hit_a1_b12r == 1'd1 || hit_a1_b13r == 1'd1)
				NS1 = rock1_move_315;
			else if( hit_a1_let == 1'd1 || hit_a1_ht == 1'd1 || hit_a1_pt == 1'd1 || hit_a1_b2t == 1'd1 || hit_a1_b3t == 1'd1 || hit_a1_b4t == 1'd1 || hit_a1_b5t == 1'd1 || hit_a1_b6t == 1'd1 || hit_a1_b7t == 1'd1 || hit_a1_b8t == 1'd1 || hit_a1_b9t == 1'd1 || hit_a1_b10t == 1'd1 || hit_a1_b11t == 1'd1 || hit_a1_b12t == 1'd1 || hit_a1_b13t == 1'd1)
				NS1 = rock1_move_135;
			else
				NS1 = rock1_move_225;
			end
		rock1_move_315:
		begin
			if ( hit_a1_pl == 1'd1 || hit_a1_b2l == 1'd1 || hit_a1_b3l == 1'd1 || hit_a1_b4l == 1'd1 || hit_a1_b5l == 1'd1 || hit_a1_b6l == 1'd1 || hit_a1_b7l == 1'd1 || hit_a1_b8l == 1'd1 || hit_a1_b9l == 1'd1 || hit_a1_b10l == 1'd1 || hit_a1_b11l == 1'd1 || hit_a1_b12l == 1'd1 || hit_a1_b13l == 1'd1)
				NS1 = rock1_move_225;
			else if( hit_a1_let == 1'd1 || hit_a1_ht == 1'd1 || hit_a1_pt == 1'd1 || hit_a1_b2t == 1'd1 || hit_a1_b3t == 1'd1 || hit_a1_b4t == 1'd1 || hit_a1_b5t == 1'd1 || hit_a1_b6t == 1'd1 || hit_a1_b7t == 1'd1 || hit_a1_b8t == 1'd1 || hit_a1_b9t == 1'd1 || hit_a1_b10t == 1'd1 || hit_a1_b11t == 1'd1 || hit_a1_b12t == 1'd1 || hit_a1_b13t == 1'd1)
				NS1 = rock1_move_45;
			else
				NS1 = rock1_move_315;
		end
		rock1_move_135:
		begin
			if( hit_a1_ler == 1'd1 || hit_a1_hr == 1'd1 || hit_a1_pr == 1'd1 || hit_a1_b2r == 1'd1 || hit_a1_b3r == 1'd1 || hit_a1_b4r == 1'd1 || hit_a1_b5r == 1'd1 || hit_a1_b6r == 1'd1 || hit_a1_b7r == 1'd1 || hit_a1_b8r == 1'd1 || hit_a1_b9r == 1'd1 || hit_a1_b10r == 1'd1 || hit_a1_b11r == 1'd1 || hit_a1_b12r == 1'd1 || hit_a1_b13r == 1'd1)
				NS1 = rock1_move_45;
			else if( hit_a1_pb == 1'd1 || hit_a1_b2b == 1'd1 || hit_a1_b3b == 1'd1 || hit_a1_b4b == 1'd1 || hit_a1_b5b == 1'd1 || hit_a1_b6b == 1'd1 || hit_a1_b7b == 1'd1 || hit_a1_b8b == 1'd1 || hit_a1_b9b == 1'd1 || hit_a1_b10b == 1'd1 || hit_a1_b11b == 1'd1 || hit_a1_b12b == 1'd1 || hit_a1_b13b == 1'd1)
				NS1 = rock1_move_225;
			
			else
				NS1 = rock1_move_135;
		end
		rock1_move_45:
		begin
			if(hit_a1_pl == 1'd1 || hit_a1_b2l == 1'd1 || hit_a1_b3l == 1'd1 || hit_a1_b4l == 1'd1 || hit_a1_b5l == 1'd1 || hit_a1_b6l == 1'd1 || hit_a1_b7l == 1'd1 || hit_a1_b8l == 1'd1 || hit_a1_b9l == 1'd1 || hit_a1_b10l == 1'd1 || hit_a1_b11l == 1'd1 || hit_a1_b12l == 1'd1 || hit_a1_b13l == 1'd1)
				NS1 = rock1_move_135;
			else if( hit_a1_pb == 1'd1 || hit_a1_b2b == 1'd1 || hit_a1_b3b == 1'd1 || hit_a1_b4b == 1'd1 || hit_a1_b5b == 1'd1 || hit_a1_b6b == 1'd1 || hit_a1_b7b == 1'd1 || hit_a1_b8b == 1'd1 || hit_a1_b9b == 1'd1 || hit_a1_b10b == 1'd1 || hit_a1_b11b == 1'd1 || hit_a1_b12b == 1'd1 || hit_a1_b13b == 1'd1)
				NS1 = rock1_move_315;
			
			else
				NS1 = rock1_move_45;
		end
		rock1_shot:
		begin
		if (etc >= 32'd1000)
		NS1 = IDKWhatTocallThis;
		else
		NS1 = rock1_shot;
		end
		
		IDKWhatTocallThis:
		begin
			if (etc >= 32'd1005)
				NS1 = rock1_move_225;
			else
				NS1 = IDKWhatTocallThis;
		end
	endcase
	
	case(S2)
		PREGAME: 
		begin
			if (rst == 1'd0)
				NS2 = PREGAME;
			else
				NS2 = start;
		end

		start:
		begin
			if (SG == 1'd0)
				NS2 = start;
			else 
				NS2 = SA;
		end
		
		SA:
		begin
			if (y_startScreen >= 11'd499)
				NS2 = rock1_move_315;
			else
				NS2 = SA;
		end
		rock1_move_225:
		begin
			if(hit_a2_ler == 1'd1 || hit_a2_hr == 1'd1 || hit_a2_pr == 1'd1 || hit_a2_b1r == 1'd1 || hit_a2_b3r == 1'd1 || hit_a2_b4r == 1'd1 || hit_a2_b5r == 1'd1 || hit_a2_b6r == 1'd1 || hit_a2_b7r == 1'd1 || hit_a2_b8r == 1'd1 || hit_a2_b9r == 1'd1 || hit_a2_b10r == 1'd1 || hit_a2_b11r == 1'd1 || hit_a2_b12r == 1'd1 || hit_a2_b13r == 1'd1)
				NS2 = rock1_move_315;
			else if( hit_a2_let == 1'd1 || hit_a2_ht == 1'd1 || hit_a2_pt == 1'd1 || hit_a2_b1t == 1'd1 || hit_a2_b3t == 1'd1 || hit_a2_b4t == 1'd1 || hit_a2_b5t == 1'd1 || hit_a2_b6t == 1'd1 || hit_a2_b7t == 1'd1 || hit_a2_b8t == 1'd1 || hit_a2_b9t == 1'd1 || hit_a2_b10t == 1'd1 || hit_a2_b11t == 1'd1 || hit_a2_b12t == 1'd1 || hit_a2_b13t == 1'd1)
				NS2 = rock1_move_135;
			
			else
				NS2 = rock1_move_225;
			end
		rock1_move_315:
		begin
			if(  hit_a2_pl == 1'd1 || hit_a2_b1l == 1'd1 || hit_a2_b3l == 1'd1 || hit_a2_b4l == 1'd1 || hit_a2_b5l == 1'd1 || hit_a2_b6l == 1'd1 || hit_a2_b7l == 1'd1 || hit_a2_b8l == 1'd1 || hit_a2_b9l == 1'd1 || hit_a2_b10l == 1'd1 || hit_a2_b11l == 1'd1 || hit_a2_b12l == 1'd1 || hit_a2_b13l == 1'd1)
				NS2 = rock1_move_225;
			else if(  hit_a2_let == 1'd1 || hit_a2_ht == 1'd1 || hit_a2_pt == 1'd1 || hit_a2_b1t == 1'd1 || hit_a2_b3t == 1'd1 || hit_a2_b4t == 1'd1 || hit_a2_b5t == 1'd1 || hit_a2_b6t == 1'd1 || hit_a2_b7t == 1'd1 || hit_a2_b8t == 1'd1 || hit_a2_b9t == 1'd1|| hit_a2_b10t == 1'd1 || hit_a2_b11t == 1'd1 || hit_a2_b12t == 1'd1 || hit_a2_b13t == 1'd1)
				NS2 = rock1_move_45;
			
			else
				NS2 = rock1_move_315;
		end
		rock1_move_135:
		begin
			if(  hit_a2_ler == 1'd1 || hit_a2_hr == 1'd1|| hit_a2_pr == 1'd1 || hit_a2_b1r == 1'd1 || hit_a2_b3r == 1'd1 || hit_a2_b4r == 1'd1 || hit_a2_b5r == 1'd1 || hit_a2_b6r == 1'd1 || hit_a2_b7r == 1'd1 || hit_a2_b8r == 1'd1 || hit_a2_b9r == 1'd1 || hit_a2_b10r == 1'd1 || hit_a2_b11r == 1'd1 || hit_a2_b12r == 1'd1 || hit_a2_b13r == 1'd1)
				NS2 = rock1_move_45;
			else if(hit_a2_pb == 1'd1 || hit_a2_b1b == 1'd1 || hit_a2_b3b == 1'd1 || hit_a2_b4b == 1'd1 || hit_a2_b5b == 1'd1 || hit_a2_b6b == 1'd1 || hit_a2_b7b == 1'd1 || hit_a2_b8b == 1'd1 || hit_a2_b9b == 1'd1 || hit_a2_b10b == 1'd1 || hit_a2_b11b == 1'd1 || hit_a2_b12b == 1'd1 || hit_a2_b13b == 1'd1)
				NS2 = rock1_move_225;
			
			else
				NS2 = rock1_move_135;
		end
		rock1_move_45:
		begin
			if(  hit_a2_pl == 1'd1 || hit_a2_b1l == 1'd1 || hit_a2_b3l == 1'd1 || hit_a2_b4l == 1'd1 || hit_a2_b5l == 1'd1 || hit_a2_b6l == 1'd1 || hit_a2_b7l == 1'd1 || hit_a2_b8l == 1'd1 || hit_a2_b9l == 1'd1 || hit_a2_b10l == 1'd1 || hit_a2_b11l == 1'd1 || hit_a2_b12l == 1'd1 || hit_a2_b13l == 1'd1)
				NS2 = rock1_move_135;
			else if( hit_a2_pb == 1'd1 || hit_a2_b1b == 1'd1 || hit_a2_b3b == 1'd1 || hit_a2_b4b == 1'd1 || hit_a2_b5b == 1'd1 || hit_a2_b6b == 1'd1 || hit_a2_b7b == 1'd1 || hit_a2_b8b == 1'd1 || hit_a2_b9b == 1'd1 || hit_a2_b10b == 1'd1 || hit_a2_b11b == 1'd1 || hit_a2_b12b == 1'd1 || hit_a2_b13b == 1'd1)
				NS2 = rock1_move_315;
			
			else
				NS2 = rock1_move_45;
		end
		rock1_shot:
		begin
		if (etc2 >= 32'd1000)
		NS2 = IDKWhatTocallThis;
		else
		NS2 = rock1_shot;
		end
		IDKWhatTocallThis:
		begin
			if (etc2 >= 32'd1005)
				NS2 = rock1_move_225;
			else
				NS2 = IDKWhatTocallThis;
		end
	endcase
	
		case(S3)
		PREGAME: 
		begin
			if (rst == 1'd0)
				NS3 = PREGAME;
			else
				NS3 = start;
		end

		start:
		begin
			if (SG == 1'd0)
				NS3 = start;
			else 
				NS3 = SA;
		end
		SA:
		begin
			if (y_startScreen >= 11'd499)
				NS3 = rock1_move_315;
			else
				NS3 = SA;
		end
		rock1_move_225:
		begin
			if(  hit_a3_ler == 1'd1 || hit_a3_hr == 1'd1 || hit_a3_pr == 1'd1 || hit_a3_b1r == 1'd1 || hit_a3_b2r == 1'd1 || hit_a3_b4r == 1'd1 || hit_a3_b5r == 1'd1 || hit_a3_b6r == 1'd1 || hit_a3_b7r == 1'd1 || hit_a3_b8r == 1'd1 || hit_a3_b9r == 1'd1 || hit_a3_b10r == 1'd1 || hit_a3_b11r == 1'd1 || hit_a3_b12r == 1'd1 || hit_a3_b13r == 1'd1)
				NS3 = rock1_move_315;
			else if(  hit_a3_let == 1'd1 || hit_a3_ht == 1'd1 || hit_a3_pt == 1'd1 || hit_a3_b1t == 1'd1 || hit_a3_b2t == 1'd1 || hit_a3_b4t == 1'd1 || hit_a3_b5t == 1'd1 || hit_a3_b6t == 1'd1 || hit_a3_b7t == 1'd1 || hit_a3_b8t == 1'd1 || hit_a3_b9t == 1'd1 || hit_a3_b10t == 1'd1 || hit_a3_b11t == 1'd1 || hit_a3_b12t == 1'd1 || hit_a3_b13t == 1'd1)
				NS3 = rock1_move_135;
			
			else
				NS3 = rock1_move_225;
			end
		rock1_move_315:
		begin
			if( hit_a3_pl == 1'd1 || hit_a3_b1l == 1'd1 || hit_a3_b2l == 1'd1 || hit_a3_b4l == 1'd1 || hit_a3_b5l == 1'd1 || hit_a3_b6l == 1'd1 || hit_a3_b7l == 1'd1 || hit_a3_b8l == 1'd1 || hit_a3_b9l == 1'd1 || hit_a3_b10l == 1'd1 || hit_a3_b11l == 1'd1 || hit_a3_b12l == 1'd1 || hit_a3_b13l == 1'd1)
				NS3 = rock1_move_225;
			else if( hit_a3_let == 1'd1 || hit_a3_ht == 1'd1 || hit_a3_pt == 1'd1 || hit_a3_b1t == 1'd1 || hit_a3_b2t == 1'd1 || hit_a3_b4t == 1'd1 || hit_a3_b5t == 1'd1 || hit_a3_b6t == 1'd1 || hit_a3_b7t == 1'd1 || hit_a3_b8t == 1'd1 || hit_a3_b9t == 1'd1 || hit_a3_b10t == 1'd1 || hit_a3_b11t == 1'd1 || hit_a3_b12t == 1'd1 || hit_a3_b13t == 1'd1)
				NS3 = rock1_move_45;
			
			else
				NS3 = rock1_move_315;
		end
		rock1_move_135:
		begin
			if(  hit_a3_ler == 1'd1 || hit_a3_hr == 1'd1 || hit_a3_pr == 1'd1 || hit_a3_b1r == 1'd1 || hit_a3_b2r == 1'd1 || hit_a3_b4r == 1'd1 || hit_a3_b5r == 1'd1 || hit_a3_b6r == 1'd1 || hit_a3_b7r == 1'd1 || hit_a3_b8r == 1'd1 || hit_a3_b9r == 1'd1 || hit_a3_b10r == 1'd1 || hit_a3_b11r == 1'd1 || hit_a3_b12r == 1'd1 || hit_a3_b13r == 1'd1)
				NS3 = rock1_move_45;
			else if( hit_a3_pb == 1'd1 || hit_a3_b1b == 1'd1 || hit_a3_b2b == 1'd1 || hit_a3_b4b == 1'd1 || hit_a3_b5b == 1'd1 || hit_a3_b6b == 1'd1 || hit_a3_b7b == 1'd1 || hit_a3_b8b == 1'd1 || hit_a3_b9b == 1'd1 || hit_a3_b10b == 1'd1 || hit_a3_b11b == 1'd1 || hit_a3_b12b == 1'd1 || hit_a3_b13b == 1'd1)
				NS3 = rock1_move_225;
			
			else
				NS3 = rock1_move_135;
		end
		rock1_move_45:
		begin
			if(  hit_a3_pl == 1'd1 || hit_a3_b1l == 1'd1 || hit_a3_b2l == 1'd1 || hit_a3_b4l == 1'd1 || hit_a3_b5l == 1'd1 || hit_a3_b6l == 1'd1 || hit_a3_b7l == 1'd1 || hit_a3_b8l == 1'd1 || hit_a3_b9l == 1'd1 || hit_a3_b10l == 1'd1 || hit_a3_b11l == 1'd1 || hit_a3_b12l == 1'd1 || hit_a3_b13l == 1'd1)
				NS3 = rock1_move_135;
			else if(  hit_a3_pb == 1'd1 || hit_a3_b1b == 1'd1 || hit_a3_b2b == 1'd1 || hit_a3_b4b == 1'd1 || hit_a3_b5b == 1'd1 || hit_a3_b6b == 1'd1 || hit_a3_b7b == 1'd1 || hit_a3_b8b == 1'd1 || hit_a3_b9b == 1'd1 || hit_a3_b10b == 1'd1 || hit_a3_b11b == 1'd1 || hit_a3_b12b == 1'd1 || hit_a3_b13b == 1'd1)
				NS3 = rock1_move_315;

			else
				NS3 = rock1_move_45;
		end
		rock1_shot:
		begin
		if (etc3 >= 32'd1000)
		NS3 = IDKWhatTocallThis;
		else
		NS3 = rock1_shot;
		end
		
		IDKWhatTocallThis:
		begin
			if (etc3 >= 32'd1005)
				NS3 = rock1_move_135;
			else
				NS3 = IDKWhatTocallThis;
		end
	endcase
	
		case(S4)
		PREGAME: 
		begin
			if (rst == 1'd0)
				NS4 = PREGAME;
			else
				NS4 = start;
		end

		start:
		begin
			if (SG == 1'd0)
				NS4 = start;
			else 
				NS4 =  SA;
		end
		SA:
		begin
			if (y_startScreen >= 11'd499)
				NS4 = rock1_move_225;
			else
				NS4 = SA;
		end
		rock1_move_225:
		begin
			if(  hit_a4_ler == 1'd1 || hit_a4_hr == 1'd1 || hit_a4_pr == 1'd1 || hit_a4_b1r == 1'd1 || hit_a4_b2r == 1'd1 || hit_a4_b3r == 1'd1 || hit_a4_b5r == 1'd1 || hit_a4_b6r == 1'd1 || hit_a4_b7r == 1'd1 || hit_a4_b8r == 1'd1 || hit_a4_b9r == 1'd1 || hit_a4_b10r == 1'd1 || hit_a4_b11r == 1'd1 || hit_a4_b12r == 1'd1 || hit_a4_b13r == 1'd1)
				NS4 = rock1_move_315;
			else if( hit_a4_let == 1'd1 || hit_a4_ht == 1'd1 || hit_a4_pt == 1'd1 || hit_a4_b1t == 1'd1 || hit_a4_b2t == 1'd1 || hit_a4_b3t == 1'd1 || hit_a4_b5t == 1'd1 || hit_a4_b6t == 1'd1 || hit_a4_b7t == 1'd1 || hit_a4_b8t == 1'd1 || hit_a4_b9t == 1'd1 || hit_a4_b10t == 1'd1 || hit_a4_b11t == 1'd1 || hit_a4_b12t == 1'd1 || hit_a4_b13t == 1'd1)
				NS4 = rock1_move_135;
			
			else
				NS4 = rock1_move_225;
			end
		rock1_move_315:
		begin
			if( hit_a4_pl == 1'd1 || hit_a4_b1l == 1'd1 || hit_a4_b2l == 1'd1 || hit_a4_b3l == 1'd1 || hit_a4_b5l == 1'd1 || hit_a4_b6l == 1'd1 || hit_a4_b7l == 1'd1 || hit_a4_b8l == 1'd1 || hit_a4_b9l == 1'd1 || hit_a4_b10l == 1'd1 || hit_a4_b11l == 1'd1 || hit_a4_b12l == 1'd1 || hit_a4_b13l == 1'd1)
				NS4 = rock1_move_225;
			else if(  hit_a4_let == 1'd1 || hit_a4_ht == 1'd1 || hit_a4_pt == 1'd1 || hit_a4_b1t == 1'd1 || hit_a4_b2t == 1'd1 || hit_a4_b3t == 1'd1 || hit_a4_b5t == 1'd1 || hit_a4_b6t == 1'd1 || hit_a4_b7t == 1'd1 || hit_a4_b8t == 1'd1 || hit_a4_b9t == 1'd1 || hit_a4_b10t == 1'd1 || hit_a4_b11t == 1'd1 || hit_a4_b12t == 1'd1 || hit_a4_b13t == 1'd1)
				NS4 = rock1_move_45;
			
			else
				NS4 = rock1_move_315;
		end
		rock1_move_135:
		begin
			if( hit_a4_ler == 1'd1 || hit_a4_hr == 1'd1 || hit_a4_pr == 1'd1 || hit_a4_b1r == 1'd1 || hit_a4_b2r == 1'd1 || hit_a4_b3r == 1'd1 || hit_a4_b5r == 1'd1 || hit_a4_b6r == 1'd1 || hit_a4_b7r == 1'd1 || hit_a4_b8r == 1'd1 || hit_a4_b9r == 1'd1 || hit_a4_b10r == 1'd1 || hit_a4_b11r == 1'd1 || hit_a4_b12r == 1'd1 || hit_a4_b13r == 1'd1)
				NS4 = rock1_move_45;
			else if( hit_a4_pb == 1'd1 || hit_a4_b1b == 1'd1 || hit_a4_b2b == 1'd1 || hit_a4_b3b == 1'd1 || hit_a4_b5b == 1'd1 || hit_a4_b6b == 1'd1 || hit_a4_b7b == 1'd1 || hit_a4_b8b == 1'd1 || hit_a4_b9b == 1'd1 || hit_a4_b10b == 1'd1 || hit_a4_b11b == 1'd1 || hit_a4_b12b == 1'd1 || hit_a4_b13b == 1'd1)
				NS4 = rock1_move_225;
			
			else
				NS4 = rock1_move_135;
		end
		rock1_move_45:
		begin
			if( hit_a4_pl == 1'd1 || hit_a4_b1l == 1'd1 || hit_a4_b2l == 1'd1 || hit_a4_b3l == 1'd1 || hit_a4_b5l == 1'd1 || hit_a4_b6l == 1'd1 || hit_a4_b7l == 1'd1 || hit_a4_b8l == 1'd1 || hit_a4_b9l == 1'd1 || hit_a4_b10l == 1'd1 || hit_a4_b11l == 1'd1 || hit_a4_b12l == 1'd1 || hit_a4_b13l == 1'd1)
				NS4 = rock1_move_135;
			else if(  hit_a4_pb == 1'd1 || hit_a4_b1b == 1'd1 || hit_a4_b2b == 1'd1 || hit_a4_b3b == 1'd1 || hit_a4_b5b == 1'd1 || hit_a4_b6b == 1'd1 || hit_a4_b7b == 1'd1 || hit_a4_b8b == 1'd1 || hit_a4_b9b == 1'd1|| hit_a4_b10b == 1'd1 || hit_a4_b11b == 1'd1 || hit_a4_b12b == 1'd1 || hit_a4_b13b == 1'd1)
				NS4 = rock1_move_315;
			
			else
				NS4 = rock1_move_45;
		end
		rock1_shot:
		begin
		if (etc4 >= 32'd1000)
		NS4 = IDKWhatTocallThis;
		else
		NS4 = rock1_shot;
		end
		IDKWhatTocallThis:
		begin
			if (etc4 >= 32'd1005)
				NS4 = rock1_move_225;
			else
				NS4 = IDKWhatTocallThis;
		end
	endcase
	
	case(S5)
		PREGAME: 
		begin
			if (rst == 1'd0)
				NS5 = PREGAME;
			else
				NS5 = start;
		end

		start:
		begin
			if (SG == 1'd0)
				NS5 = start;
			else 
				NS5 =  SA;
		end
		SA:
		begin
			if (y_startScreen >= 11'd499)
				NS5 = rock1_move_45;
			else
				NS5 = SA;
		end
		rock1_move_225:
		begin
			if( hit_a5_ler == 1'd1 || hit_a5_hr == 1'd1 || hit_a5_pr == 1'd1 || hit_a5_b1r == 1'd1 || hit_a5_b2r == 1'd1 || hit_a5_b3r == 1'd1 || hit_a5_b4r == 1'd1 || hit_a5_b6r == 1'd1 || hit_a5_b7r == 1'd1 || hit_a5_b8r == 1'd1 || hit_a5_b9r == 1'd1 || hit_a5_b10r == 1'd1 || hit_a5_b11r == 1'd1 || hit_a5_b12r == 1'd1 || hit_a5_b13r == 1'd1)
				NS5 = rock1_move_315;
			else if(  hit_a5_let == 1'd1 || hit_a5_ht == 1'd1 || hit_a5_pt == 1'd1 || hit_a5_b1t == 1'd1 || hit_a5_b2t == 1'd1 || hit_a5_b3t == 1'd1 || hit_a5_b4t == 1'd1 || hit_a5_b6t == 1'd1 || hit_a5_b7t == 1'd1 || hit_a5_b8t == 1'd1 || hit_a5_b9t == 1'd1 || hit_a5_b10t == 1'd1 || hit_a5_b11t == 1'd1 || hit_a5_b12t == 1'd1 || hit_a5_b13t == 1'd1)
				NS5 = rock1_move_135;
			
			else
				NS5 = rock1_move_225;
			end
		rock1_move_315:
		begin
			if( hit_a5_pl == 1'd1 || hit_a5_b1l == 1'd1 || hit_a5_b2l == 1'd1 || hit_a5_b3l == 1'd1 || hit_a5_b4l == 1'd1 || hit_a5_b6l == 1'd1 || hit_a5_b7l == 1'd1 || hit_a5_b8l == 1'd1 || hit_a5_b9l == 1'd1 || hit_a5_b10l == 1'd1 || hit_a5_b11l == 1'd1 || hit_a5_b12l == 1'd1 || hit_a5_b13l == 1'd1)
				NS5 = rock1_move_225;
			else if(  hit_a5_let == 1'd1 || hit_a5_ht == 1'd1 || hit_a5_pt == 1'd1 || hit_a5_b1t == 1'd1 || hit_a5_b2t == 1'd1 || hit_a5_b3t == 1'd1 || hit_a5_b4t == 1'd1 || hit_a5_b6t == 1'd1 || hit_a5_b7t == 1'd1 || hit_a5_b8t == 1'd1 || hit_a5_b9t == 1'd1 || hit_a5_b10t == 1'd1 || hit_a5_b11t == 1'd1 || hit_a5_b12t == 1'd1 || hit_a5_b13t == 1'd1)
				NS5 = rock1_move_45;
			
			else
				NS5 = rock1_move_315;
		end
		rock1_move_135:
		begin
			if( hit_a5_ler == 1'd1 || hit_a5_hr == 1'd1 || hit_a5_pr == 1'd1 || hit_a5_b1r == 1'd1 || hit_a5_b2r == 1'd1 || hit_a5_b3r == 1'd1 || hit_a5_b4r == 1'd1 || hit_a5_b6r == 1'd1 || hit_a5_b7r == 1'd1 || hit_a5_b8r == 1'd1 || hit_a5_b9r == 1'd1 || hit_a5_b10r == 1'd1 || hit_a5_b11r == 1'd1 || hit_a5_b12r == 1'd1 || hit_a5_b13r == 1'd1)
				NS5 = rock1_move_45;
			else if( hit_a5_pb == 1'd1 || hit_a5_b1b == 1'd1 || hit_a5_b2b == 1'd1 || hit_a5_b3b == 1'd1 || hit_a5_b4b == 1'd1 || hit_a5_b6b == 1'd1 || hit_a5_b7b == 1'd1 || hit_a5_b8b == 1'd1 || hit_a5_b9b == 1'd1 || hit_a5_b10b == 1'd1 || hit_a5_b11b == 1'd1 || hit_a5_b12b == 1'd1 || hit_a5_b13b == 1'd1)
				NS5 = rock1_move_225;
			
			else
				NS5 = rock1_move_135;
		end
		rock1_move_45:
		begin
			if( hit_a5_pl == 1'd1 || hit_a5_b1l == 1'd1 || hit_a5_b2l == 1'd1 || hit_a5_b3l == 1'd1 || hit_a5_b4l == 1'd1 || hit_a5_b6l == 1'd1 || hit_a5_b7l == 1'd1 || hit_a5_b8l == 1'd1 || hit_a5_b9l == 1'd1 || hit_a5_b10l == 1'd1 || hit_a5_b11l == 1'd1 || hit_a5_b12l == 1'd1 || hit_a5_b13l == 1'd1)
				NS5 = rock1_move_135;
			else if(  hit_a5_pb == 1'd1 || hit_a5_b1b == 1'd1 || hit_a5_b2b == 1'd1 || hit_a5_b3b == 1'd1 || hit_a5_b4b == 1'd1 || hit_a5_b6b == 1'd1 || hit_a5_b7b == 1'd1 || hit_a5_b8b == 1'd1 || hit_a5_b9b == 1'd1 || hit_a5_b10b == 1'd1 || hit_a5_b11b == 1'd1 || hit_a5_b12b == 1'd1 || hit_a5_b13b == 1'd1)
				NS5 = rock1_move_315;
			
			else
				NS5 = rock1_move_45;
		end
		rock1_shot:
		begin
		if (etc5 >= 32'd1000)
		NS5 = IDKWhatTocallThis;
		else
		NS5 = rock1_shot;
		end
		IDKWhatTocallThis:
		begin
			if (etc5 >= 32'd1005)
				NS5 = rock1_move_225;
			else
				NS5 = IDKWhatTocallThis;
		end
	endcase
	
	case(S6)
		PREGAME: 
		begin
			if (rst == 1'd0)
				NS6 = PREGAME;
			else
				NS6 = start;
		end

		start:
		begin
			if (SG == 1'd0)
				NS6 = start;
			else 
				NS6 =  SA;
		end
		SA:
		begin
			if (y_startScreen >= 11'd499)
				NS6 = rock1_move_315;
			else
				NS6 = SA;
		end
		rock1_move_225:
		begin
			if(hit_a6_ler == 1'd1 || hit_a6_hr == 1'd1 || hit_a6_pr == 1'd1 || hit_a6_b1r == 1'd1 || hit_a6_b2r == 1'd1 || hit_a6_b3r == 1'd1 || hit_a6_b4r == 1'd1 || hit_a6_b5r == 1'd1 || hit_a6_b7r == 1'd1 || hit_a6_b8r == 1'd1 || hit_a6_b9r == 1'd1 || hit_a6_b10r == 1'd1 || hit_a6_b11r == 1'd1 || hit_a6_b12r == 1'd1 || hit_a6_b13r == 1'd1)
				NS6 = rock1_move_315;
			else if( hit_a6_let == 1'd1 || hit_a6_ht == 1'd1 || hit_a6_pt == 1'd1 || hit_a6_b1t == 1'd1 || hit_a6_b2t == 1'd1 || hit_a6_b3t == 1'd1 || hit_a6_b4t == 1'd1 || hit_a6_b5t == 1'd1 || hit_a6_b7t == 1'd1 || hit_a6_b8t == 1'd1 || hit_a6_b9t == 1'd1 || hit_a6_b10t == 1'd1 || hit_a6_b11t == 1'd1 || hit_a6_b12t == 1'd1 || hit_a6_b13t == 1'd1)
				NS6 = rock1_move_135;
			
			else
				NS6 = rock1_move_225;
			end
		rock1_move_315:
		begin
			if( hit_a6_pl == 1'd1 || hit_a6_b1l == 1'd1 || hit_a6_b2l == 1'd1 || hit_a6_b3l == 1'd1 || hit_a6_b4l == 1'd1 || hit_a6_b5l == 1'd1 || hit_a6_b7l == 1'd1 || hit_a6_b8l == 1'd1 || hit_a6_b9l == 1'd1 || hit_a6_b10l == 1'd1 || hit_a6_b11l == 1'd1 || hit_a6_b12l == 1'd1 || hit_a6_b13l == 1'd1)
				NS6 = rock1_move_225;
			else if( hit_a6_let == 1'd1 || hit_a6_ht == 1'd1 || hit_a6_pt == 1'd1 || hit_a6_b1t == 1'd1 || hit_a6_b2t == 1'd1 || hit_a6_b3t == 1'd1 || hit_a6_b4t == 1'd1 || hit_a6_b5t == 1'd1 || hit_a6_b7t == 1'd1 || hit_a6_b8t == 1'd1 || hit_a6_b9t == 1'd1 || hit_a6_b10t == 1'd1 || hit_a6_b11t == 1'd1 || hit_a6_b12t == 1'd1 || hit_a6_b13t == 1'd1)
				NS6 = rock1_move_45;
			
			else
				NS6 = rock1_move_315;
		end
		rock1_move_135:
		begin
			if(hit_a6_ler == 1'd1 || hit_a6_hr == 1'd1 || hit_a6_pr == 1'd1 || hit_a6_b1r == 1'd1 || hit_a6_b2r == 1'd1 || hit_a6_b3r == 1'd1 || hit_a6_b4r == 1'd1 || hit_a6_b5r == 1'd1 || hit_a6_b7r == 1'd1 || hit_a6_b8r == 1'd1 || hit_a6_b9r == 1'd1 || hit_a6_b10r == 1'd1 || hit_a6_b11r == 1'd1 || hit_a6_b12r == 1'd1 || hit_a6_b13r == 1'd1)
				NS6 = rock1_move_45;
			else if(hit_a6_pb == 1'd1 || hit_a6_b1b == 1'd1 || hit_a6_b2b == 1'd1 || hit_a6_b3b == 1'd1 || hit_a6_b4b == 1'd1 || hit_a6_b5b == 1'd1 || hit_a6_b7b == 1'd1 || hit_a6_b8b == 1'd1 || hit_a6_b9b == 1'd1 || hit_a6_b10b == 1'd1 || hit_a6_b11b == 1'd1 || hit_a6_b12b == 1'd1 || hit_a6_b13b == 1'd1)
				NS6 = rock1_move_225;
			
			else
				NS6 = rock1_move_135;
		end
		rock1_move_45:
		begin
			if(hit_a6_pl == 1'd1 || hit_a6_b1l == 1'd1 || hit_a6_b2l == 1'd1 || hit_a6_b3l == 1'd1 || hit_a6_b4l == 1'd1 || hit_a6_b5l == 1'd1 || hit_a6_b7l == 1'd1 || hit_a6_b8l == 1'd1 || hit_a6_b9l == 1'd1 || hit_a6_b10l == 1'd1 || hit_a6_b11l == 1'd1 || hit_a6_b12l == 1'd1 || hit_a6_b13l == 1'd1)
				NS6 = rock1_move_135;
			else if( hit_a6_pb == 1'd1 || hit_a6_b1b == 1'd1 || hit_a6_b2b == 1'd1 || hit_a6_b3b == 1'd1 || hit_a6_b4b == 1'd1 || hit_a6_b5b == 1'd1 || hit_a6_b7b == 1'd1 || hit_a6_b8b == 1'd1 || hit_a6_b9b == 1'd1 || hit_a6_b10b == 1'd1 || hit_a6_b11b == 1'd1 || hit_a6_b12b == 1'd1 || hit_a6_b13b == 1'd1)
				NS6 = rock1_move_315;
			
			else
				NS6 = rock1_move_45;
		end
		rock1_shot:
		begin
		if (etc6 >= 32'd1000)
		NS6 = IDKWhatTocallThis;
		else
		NS6 = rock1_shot;
		end
		IDKWhatTocallThis:
		begin
			if (etc6 >= 32'd1005)
				NS6 = rock1_move_225;
			else
				NS6 = IDKWhatTocallThis;
		end
	endcase	
	
	case(S7)
		PREGAME: 
		begin
			if (rst == 1'd0)
				NS7 = PREGAME;
			else
				NS7 = start;
		end

		start:
		begin
			if (SG == 1'd0)
				NS7 = start;
			else 
				NS7 =  SA;
		end
		SA:
		begin
			if (y_startScreen >= 11'd499)
				NS7 = rock1_move_45;
			else
				NS7 = SA;
		end
		rock1_move_225:
		begin
			if(hit_a7_ler == 1'd1 || hit_a7_hr == 1'd1 || hit_a7_pr == 1'd1 || hit_a7_b1r == 1'd1 || hit_a7_b2r == 1'd1 || hit_a7_b3r == 1'd1 || hit_a7_b4r == 1'd1 || hit_a7_b5r == 1'd1 || hit_a7_b6r == 1'd1 || hit_a7_b8r == 1'd1 || hit_a7_b9r == 1'd1 || hit_a7_b10r == 1'd1 || hit_a7_b11r == 1'd1 || hit_a7_b12r == 1'd1 || hit_a7_b13r == 1'd1)
				NS7 = rock1_move_315;
			else if(hit_a7_let == 1'd1 || hit_a7_ht == 1'd1 || hit_a7_pt == 1'd1 || hit_a7_b1t == 1'd1 || hit_a7_b2t == 1'd1 || hit_a7_b3t == 1'd1 || hit_a7_b4t == 1'd1 || hit_a7_b5t == 1'd1 || hit_a7_b6t == 1'd1 || hit_a7_b8t == 1'd1 || hit_a7_b9t == 1'd1 || hit_a7_b10t == 1'd1 || hit_a7_b11t == 1'd1 || hit_a7_b12t == 1'd1 || hit_a7_b13t == 1'd1)
				NS7 = rock1_move_135;
			
			else
				NS7 = rock1_move_225;
			end
		rock1_move_315:
		begin
			if(hit_a7_pl == 1'd1 || hit_a7_b1l == 1'd1 || hit_a7_b2l == 1'd1 || hit_a7_b3l == 1'd1 || hit_a7_b4l == 1'd1 || hit_a7_b5l == 1'd1 || hit_a7_b6l == 1'd1 || hit_a7_b8l == 1'd1 || hit_a7_b9l == 1'd1 || hit_a7_b10l == 1'd1 || hit_a7_b11l == 1'd1 || hit_a7_b12l == 1'd1 || hit_a7_b13l == 1'd1)
				NS7 = rock1_move_225;
			else if( hit_a7_let == 1'd1 || hit_a7_ht == 1'd1 || hit_a7_pt == 1'd1 || hit_a7_b1t == 1'd1 || hit_a7_b2t == 1'd1 || hit_a7_b3t == 1'd1 || hit_a7_b4t == 1'd1 || hit_a7_b5t == 1'd1 || hit_a7_b6t == 1'd1 || hit_a7_b8t == 1'd1 || hit_a7_b9t == 1'd1 || hit_a7_b10t == 1'd1 || hit_a7_b11t == 1'd1 || hit_a7_b12t == 1'd1 || hit_a7_b13t == 1'd1)
				NS7 = rock1_move_45;
			
			else
				NS7 = rock1_move_315;
		end
		rock1_move_135:
		begin
			if( hit_a7_ler == 1'd1 || hit_a7_hr == 1'd1 || hit_a7_pr == 1'd1 || hit_a7_b1r == 1'd1 || hit_a7_b2r == 1'd1 || hit_a7_b3r == 1'd1 || hit_a7_b4r == 1'd1 || hit_a7_b5r == 1'd1 || hit_a7_b6r == 1'd1 || hit_a7_b8r == 1'd1 || hit_a7_b9r == 1'd1 || hit_a7_b10r == 1'd1 || hit_a7_b11r == 1'd1 || hit_a7_b12r == 1'd1 || hit_a7_b13r == 1'd1)
				NS7 = rock1_move_45;
			else if(hit_a7_pb == 1'd1 || hit_a7_b1b == 1'd1 || hit_a7_b2b == 1'd1 || hit_a7_b3b == 1'd1 || hit_a7_b4b == 1'd1 || hit_a7_b5b == 1'd1 || hit_a7_b6b == 1'd1 || hit_a7_b8b == 1'd1 || hit_a7_b9b == 1'd1 || hit_a7_b10b == 1'd1 || hit_a7_b11b == 1'd1 || hit_a7_b12b == 1'd1 || hit_a7_b13b == 1'd1)
				NS7 = rock1_move_225;
			
			else
				NS7 = rock1_move_135;
		end
		rock1_move_45:
		begin
			if( hit_a7_pl == 1'd1 || hit_a7_b1l == 1'd1 || hit_a7_b2l == 1'd1 || hit_a7_b3l == 1'd1 || hit_a7_b4l == 1'd1 || hit_a7_b5l == 1'd1 || hit_a7_b6l == 1'd1 || hit_a7_b8l == 1'd1 || hit_a7_b9l == 1'd1 || hit_a7_b10l == 1'd1 || hit_a7_b11l == 1'd1 || hit_a7_b12l == 1'd1 || hit_a7_b13l == 1'd1)
				NS7 = rock1_move_135;
			else if( hit_a7_pb == 1'd1 || hit_a7_b1b == 1'd1 || hit_a7_b2b == 1'd1 || hit_a7_b3b == 1'd1 || hit_a7_b4b == 1'd1 || hit_a7_b5b == 1'd1 || hit_a7_b6b == 1'd1 || hit_a7_b8b == 1'd1 || hit_a7_b9b == 1'd1 || hit_a7_b10b == 1'd1 || hit_a7_b11b == 1'd1 || hit_a7_b12b == 1'd1 || hit_a7_b13b == 1'd1)
				NS7 = rock1_move_315;
			
			else
				NS7 = rock1_move_45;
		end
		rock1_shot:
		begin
		if (etc7 >= 32'd1000)
		NS7 = IDKWhatTocallThis;
		else
		NS7 = rock1_shot;
		end
		IDKWhatTocallThis:
		begin
			if (etc7 >= 32'd1005)
				NS7 = rock1_move_135;
			else
				NS7 = IDKWhatTocallThis;
		end
	endcase	
	
		case(S8)
		PREGAME: 
		begin
			if (rst == 1'd0)
				NS8 = PREGAME;
			else
				NS8 = start;
		end

		start:
		begin
			if (SG == 1'd0)
				NS8 = start;
			else 
				NS8 =  SA;
		end
		SA:
		begin
			if (y_startScreen >= 11'd499)
				NS8 = rock1_move_315;
			else
				NS8 = SA;
		end
		rock1_move_225:
		begin
			if( hit_a8_ler == 1'd1 || hit_a8_hr == 1'd1|| hit_a8_pr == 1'd1 || hit_a8_b1r == 1'd1 || hit_a8_b2r == 1'd1 || hit_a8_b3r == 1'd1 || hit_a8_b4r == 1'd1 || hit_a8_b5r == 1'd1 || hit_a8_b6r == 1'd1 || hit_a8_b7r == 1'd1 || hit_a8_b9r == 1'd1 || hit_a8_b10r == 1'd1 || hit_a8_b11r == 1'd1 || hit_a8_b12r == 1'd1 || hit_a8_b13r == 1'd1)
				NS8 = rock1_move_315;
			else if(hit_a8_let == 1'd1 || hit_a8_ht == 1'd1|| hit_a8_pt == 1'd1 || hit_a8_b1t == 1'd1 || hit_a8_b2t == 1'd1 || hit_a8_b3t == 1'd1 || hit_a8_b4t == 1'd1 || hit_a8_b5t == 1'd1 || hit_a8_b6t == 1'd1 || hit_a8_b7t == 1'd1 || hit_a8_b9t == 1'd1 || hit_a8_b10t == 1'd1 || hit_a8_b11t == 1'd1 || hit_a8_b12t == 1'd1 || hit_a8_b13t == 1'd1)
				NS8 = rock1_move_135;
			
			else
				NS8 = rock1_move_225;
			end
		rock1_move_315:
		begin
			if(hit_a8_pl == 1'd1 || hit_a8_b1l == 1'd1 || hit_a8_b2l == 1'd1 || hit_a8_b3l == 1'd1 || hit_a8_b4l == 1'd1 || hit_a8_b5l == 1'd1 || hit_a8_b6l == 1'd1 || hit_a8_b7l == 1'd1 || hit_a8_b9l == 1'd1 || hit_a8_b10l == 1'd1 || hit_a8_b11l == 1'd1 || hit_a8_b12l == 1'd1 || hit_a8_b13l == 1'd1)
				NS8 = rock1_move_225;
			else if(  hit_a8_let == 1'd1 || hit_a8_ht == 1'd1 || hit_a8_pt == 1'd1 || hit_a8_b1t == 1'd1 || hit_a8_b2t == 1'd1 || hit_a8_b3t == 1'd1 || hit_a8_b4t == 1'd1 || hit_a8_b5t == 1'd1 || hit_a8_b6t == 1'd1 || hit_a8_b7t == 1'd1 || hit_a8_b9t == 1'd1 || hit_a8_b10t == 1'd1 || hit_a8_b11t == 1'd1 || hit_a8_b12t == 1'd1 || hit_a8_b13t == 1'd1)
				NS8 = rock1_move_45;
			
			else
				NS8 = rock1_move_315;
		end
		rock1_move_135:
		begin
			if( hit_a8_ler == 1'd1 || hit_a8_hr == 1'd1 || hit_a8_pr == 1'd1 || hit_a8_b1r == 1'd1 || hit_a8_b2r == 1'd1 || hit_a8_b3r == 1'd1 || hit_a8_b4r == 1'd1 || hit_a8_b5r == 1'd1 || hit_a8_b6r == 1'd1 || hit_a8_b7r == 1'd1 || hit_a8_b9r == 1'd1 || hit_a8_b10r == 1'd1 || hit_a8_b11r == 1'd1 || hit_a8_b12r == 1'd1 || hit_a8_b13r == 1'd1)
				NS8 = rock1_move_45;
			else if( hit_a8_pb == 1'd1 || hit_a8_b1b == 1'd1 || hit_a8_b2b == 1'd1 || hit_a8_b3b == 1'd1 || hit_a8_b4b == 1'd1 || hit_a8_b5b == 1'd1 || hit_a8_b6b == 1'd1 || hit_a8_b7b == 1'd1 || hit_a8_b9b == 1'd1 || hit_a8_b10b == 1'd1 || hit_a8_b11b == 1'd1 || hit_a8_b12b == 1'd1 || hit_a8_b13b == 1'd1)
				NS8 = rock1_move_225;
			
			else
				NS8 = rock1_move_135;
		end
		rock1_move_45:
		begin
			if(  hit_a8_pl == 1'd1 || hit_a8_b1l == 1'd1 || hit_a8_b2l == 1'd1 || hit_a8_b3l == 1'd1 || hit_a8_b4l == 1'd1 || hit_a8_b5l == 1'd1 || hit_a8_b6l == 1'd1 || hit_a8_b7l == 1'd1 || hit_a8_b9l == 1'd1 || hit_a8_b10l == 1'd1 || hit_a8_b11l == 1'd1 || hit_a8_b12l == 1'd1 || hit_a8_b13l == 1'd1)
				NS8 = rock1_move_135;
			else if( hit_a8_pb == 1'd1 || hit_a8_b1b == 1'd1 || hit_a8_b2b == 1'd1 || hit_a8_b3b == 1'd1 || hit_a8_b4b == 1'd1 || hit_a8_b5b == 1'd1 || hit_a8_b6b == 1'd1 || hit_a8_b7b == 1'd1 || hit_a8_b9b == 1'd1 || hit_a8_b10b == 1'd1 || hit_a8_b11b == 1'd1 || hit_a8_b12b == 1'd1 || hit_a8_b13b == 1'd1)
				NS8 = rock1_move_315;
			
			else
				NS8 = rock1_move_45;
		end
		rock1_shot:
		begin
		if (etc8 >= 32'd1000)
		NS8 = IDKWhatTocallThis;
		else
		NS8 = rock1_shot;
		end
		IDKWhatTocallThis:
		begin
			if (etc8 >= 32'd1005)
				NS8 = rock1_move_225;
			else
				NS8 = IDKWhatTocallThis;
		end
	endcase

		case(S9)
		PREGAME: 
		begin
			if (rst == 1'd0)
				NS9 = PREGAME;
			else
				NS9 = start;
		end
		start:
		begin
			if (SG == 1'd0)
				NS9 = start;
			else 
				NS9 =  SA;
		end
		SA:
		begin
			if (y_startScreen >= 11'd499)
				NS9 = rock1_move_315;
			else
				NS9 = SA;
		end
		rock1_move_225:
		begin
			if( hit_a9_ler == 1'd1 || hit_a9_hr == 1'd1 || hit_a9_pr == 1'd1 || hit_a9_b1r == 1'd1 || hit_a9_b2r == 1'd1 || hit_a9_b3r == 1'd1 || hit_a9_b4r == 1'd1 || hit_a9_b5r == 1'd1 || hit_a9_b6r == 1'd1 || hit_a9_b7r == 1'd1 || hit_a9_b8r == 1'd1 || hit_a9_b10r == 1'd1 || hit_a9_b11r == 1'd1 || hit_a9_b12r == 1'd1 || hit_a9_b13r == 1'd1)
				NS9 = rock1_move_315;
			else if( hit_a9_let == 1'd1 || hit_a9_ht == 1'd1 || hit_a9_pt == 1'd1 || hit_a9_b1t == 1'd1 || hit_a9_b2t == 1'd1 || hit_a9_b3t == 1'd1 || hit_a9_b4t == 1'd1 || hit_a9_b5t == 1'd1 || hit_a9_b6t == 1'd1 || hit_a9_b7t == 1'd1 || hit_a9_b8t == 1'd1 || hit_a9_b10t == 1'd1 || hit_a9_b11t == 1'd1 || hit_a9_b12t == 1'd1 || hit_a9_b13t == 1'd1)
				NS9 = rock1_move_135;
			
			else
				NS9 = rock1_move_225;
			end
		rock1_move_315:
		begin
			if(hit_a9_pl == 1'd1 || hit_a9_b1l == 1'd1 || hit_a9_b2l == 1'd1 || hit_a9_b3l == 1'd1 || hit_a9_b4l == 1'd1 || hit_a9_b5l == 1'd1 || hit_a9_b6l == 1'd1 || hit_a9_b7l == 1'd1 || hit_a9_b8l == 1'd1 || hit_a9_b10l == 1'd1 || hit_a9_b11l == 1'd1 || hit_a9_b12l == 1'd1 || hit_a9_b13l == 1'd1)
				NS9 = rock1_move_225;
			else if( hit_a9_let == 1'd1 || hit_a9_ht == 1'd1 || hit_a9_pt == 1'd1 || hit_a9_b1t == 1'd1 || hit_a9_b2t == 1'd1 || hit_a9_b3t == 1'd1 || hit_a9_b4t == 1'd1 || hit_a9_b5t == 1'd1 || hit_a9_b6t == 1'd1 || hit_a9_b7t == 1'd1 || hit_a9_b8t == 1'd1 || hit_a9_b10t == 1'd1 || hit_a9_b11t == 1'd1 || hit_a9_b12t == 1'd1 || hit_a9_b13t == 1'd1)
				NS9 = rock1_move_45;
			
			else
				NS9 = rock1_move_315;
		end
		rock1_move_135:
		begin
			if( hit_a9_ler == 1'd1 || hit_a9_hr == 1'd1 || hit_a9_pr == 1'd1 || hit_a9_b1r == 1'd1 || hit_a9_b2r == 1'd1 || hit_a9_b3r == 1'd1 || hit_a9_b4r == 1'd1 || hit_a9_b5r == 1'd1 || hit_a9_b6r == 1'd1 || hit_a9_b7r == 1'd1 || hit_a9_b8r == 1'd1 || hit_a9_b10r == 1'd1 || hit_a9_b11r == 1'd1 || hit_a9_b12r == 1'd1 || hit_a9_b13r == 1'd1)
				NS9 = rock1_move_45;
			else if( hit_a9_pb == 1'd1 || hit_a9_b1b == 1'd1 || hit_a9_b2b == 1'd1 || hit_a9_b3b == 1'd1 || hit_a9_b4b == 1'd1 || hit_a9_b5b == 1'd1 || hit_a9_b6b == 1'd1 || hit_a9_b7b == 1'd1 || hit_a9_b8b == 1'd1 || hit_a9_b10b == 1'd1 || hit_a9_b11b == 1'd1 || hit_a9_b12b == 1'd1 || hit_a9_b13b == 1'd1)
				NS9 = rock1_move_225;
			
			else
				NS9 = rock1_move_135;
		end
		rock1_move_45:
		begin
			if( hit_a9_pl == 1'd1 || hit_a9_b1l == 1'd1 || hit_a9_b2l == 1'd1 || hit_a9_b3l == 1'd1 || hit_a9_b4l == 1'd1 || hit_a9_b5l == 1'd1 || hit_a9_b6l == 1'd1 || hit_a9_b8l == 1'd1 || hit_a9_b7l == 1'd1 || hit_a9_b10l == 1'd1 || hit_a9_b11l == 1'd1 || hit_a9_b12l == 1'd1 || hit_a9_b13l == 1'd1)
				NS9 = rock1_move_135;
			else if(hit_a9_pb == 1'd1 || hit_a9_b1b == 1'd1 || hit_a9_b2b == 1'd1 || hit_a9_b3b == 1'd1 || hit_a9_b4b == 1'd1 || hit_a9_b5b == 1'd1 || hit_a9_b6b == 1'd1 || hit_a9_b7b == 1'd1 || hit_a9_b8b == 1'd1 || hit_a9_b10b == 1'd1 || hit_a9_b11b == 1'd1 || hit_a9_b12b == 1'd1 || hit_a9_b13b == 1'd1)
				NS9 = rock1_move_315;
			
			else
				NS9 = rock1_move_45;
		end
		rock1_shot:
		begin
		if (etc9 >= 32'd1000)
		NS9 = IDKWhatTocallThis;
		else
		NS9 = rock1_shot;
		end
		IDKWhatTocallThis:
		begin
			if (etc9 >= 32'd1005)
				NS9 = rock1_move_135;
			else
				NS9 = IDKWhatTocallThis;
		end
	endcase
	
	case(S10)
		PREGAME: 
		begin
			if (rst == 1'd0)
				NS10 = PREGAME;
			else
				NS10 = start;
		end
		start:
		begin
			if (SG == 1'd0)
				NS10 = start;
			else 
				NS10 =  SA;
		end
		SA:
		begin
			if (y_startScreen >= 11'd499)
				NS10 = rock1_move_315;
			else
				NS10 = SA;
		end
		rock1_move_225:
		begin
			if( hit_a10_ler == 1'd1 || hit_a10_hr == 1'd1 || hit_a10_pr == 1'd1 || hit_a10_b1r == 1'd1 || hit_a10_b2r == 1'd1 || hit_a10_b3r == 1'd1 || hit_a10_b4r == 1'd1 || hit_a10_b5r == 1'd1 || hit_a10_b6r == 1'd1 || hit_a10_b7r == 1'd1 || hit_a10_b8r == 1'd1 || hit_a10_b9r == 1'd1 || hit_a10_b11r == 1'd1 || hit_a10_b12r == 1'd1 || hit_a10_b13r == 1'd1)
				NS10 = rock1_move_315;
			else if( hit_a10_let == 1'd1 || hit_a10_ht == 1'd1 || hit_a10_pt == 1'd1 || hit_a10_b1t == 1'd1 || hit_a10_b2t == 1'd1 || hit_a10_b3t == 1'd1 || hit_a10_b4t == 1'd1 || hit_a10_b5t == 1'd1 || hit_a10_b6t == 1'd1 || hit_a10_b7t == 1'd1 || hit_a10_b8t == 1'd1 || hit_a10_b9t == 1'd1 || hit_a10_b11t == 1'd1 || hit_a10_b12t == 1'd1 || hit_a10_b13t == 1'd1)
				NS10 = rock1_move_135;
			
			else
				NS10 = rock1_move_225;
			end
		rock1_move_315:
		begin
			if(hit_a10_pl == 1'd1 || hit_a10_b1l == 1'd1 || hit_a10_b2l == 1'd1 || hit_a10_b3l == 1'd1 || hit_a10_b4l == 1'd1 || hit_a10_b5l == 1'd1 || hit_a10_b6l == 1'd1 || hit_a10_b7l == 1'd1 || hit_a10_b8l == 1'd1 || hit_a10_b9l == 1'd1 || hit_a10_b11l == 1'd1 || hit_a10_b12l == 1'd1 || hit_a10_b13l == 1'd1)
				NS10 = rock1_move_225;
			else if( hit_a10_let == 1'd1 || hit_a10_ht == 1'd1 || hit_a10_pt == 1'd1 || hit_a10_b1t == 1'd1 || hit_a10_b2t == 1'd1 || hit_a10_b3t == 1'd1 || hit_a10_b4t == 1'd1 || hit_a10_b5t == 1'd1 || hit_a10_b6t == 1'd1 || hit_a10_b7t == 1'd1 || hit_a10_b8t == 1'd1 || hit_a10_b9t == 1'd1 || hit_a10_b11t == 1'd1 || hit_a10_b12t == 1'd1 || hit_a10_b13t == 1'd1)
				NS10 = rock1_move_45;
			
			else
				NS10 = rock1_move_315;
		end
		rock1_move_135:
		begin
			if( hit_a10_ler == 1'd1 || hit_a10_hr == 1'd1 || hit_a10_pr == 1'd1 || hit_a10_b1r == 1'd1 || hit_a10_b2r == 1'd1 || hit_a10_b3r == 1'd1 || hit_a10_b4r == 1'd1 || hit_a10_b5r == 1'd1 || hit_a10_b6r == 1'd1 || hit_a10_b7r == 1'd1 || hit_a10_b8r == 1'd1 || hit_a10_b9r == 1'd1 || hit_a10_b11r == 1'd1 || hit_a10_b12r == 1'd1 || hit_a10_b13r == 1'd1)
				NS10 = rock1_move_45;
			else if( hit_a10_pb == 1'd1 || hit_a10_b1b == 1'd1 || hit_a10_b2b == 1'd1 || hit_a10_b3b == 1'd1 || hit_a10_b4b == 1'd1 || hit_a10_b5b == 1'd1 || hit_a10_b6b == 1'd1 || hit_a10_b7b == 1'd1 || hit_a10_b8b == 1'd1 || hit_a10_b9b == 1'd1 || hit_a10_b11b == 1'd1 || hit_a10_b12b == 1'd1 || hit_a10_b13b == 1'd1)
				NS10 = rock1_move_225;
			
			else
				NS10 = rock1_move_135;
		end
		rock1_move_45:
		begin
			if( hit_a10_pl == 1'd1 || hit_a10_b1l == 1'd1 || hit_a10_b2l == 1'd1 || hit_a10_b3l == 1'd1 || hit_a10_b4l == 1'd1 || hit_a10_b5l == 1'd1 || hit_a10_b6l == 1'd1 || hit_a10_b7l == 1'd1 || hit_a10_b8l == 1'd1 || hit_a10_b9l == 1'd1 || hit_a10_b11l == 1'd1 || hit_a10_b12l == 1'd1 || hit_a10_b13l == 1'd1)
				NS10 = rock1_move_135;
			else if(hit_a10_pb == 1'd1 || hit_a10_b1b == 1'd1 || hit_a10_b2b == 1'd1 || hit_a10_b3b == 1'd1 || hit_a10_b4b == 1'd1 || hit_a10_b5b == 1'd1 || hit_a10_b6b == 1'd1 || hit_a10_b7b == 1'd1 || hit_a10_b8b == 1'd1 || hit_a10_b9b == 1'd1 || hit_a10_b11b == 1'd1 || hit_a10_b12b == 1'd1 || hit_a10_b13b == 1'd1)
				NS10 = rock1_move_315;
			
			else
				NS10 = rock1_move_45;
		end
		rock1_shot:
		begin
		if (etc10 >= 32'd1000)
		NS10 = IDKWhatTocallThis;
		else
		NS10 = rock1_shot;
		end
		IDKWhatTocallThis:
		begin
			if (etc10 >= 32'd1005)
				NS10 = rock1_move_135;
			else
				NS10 = IDKWhatTocallThis;
		end
	endcase
	case(S11)
		PREGAME: 
		begin
			if (rst == 1'd0)
				NS11 = PREGAME;
			else
				NS11 = start;
		end
		start:
		begin
			if (SG == 1'd0)
				NS11 = start;
			else 
				NS11 =  SA;
		end
		SA:
		begin
			if (y_startScreen >= 11'd499)
				NS11 = rock1_move_315;
			else
				NS11 = SA;
		end
		rock1_move_225:
		begin
			if( hit_a11_ler == 1'd1 || hit_a11_hr == 1'd1 || hit_a11_pr == 1'd1 || hit_a11_b1r == 1'd1 || hit_a11_b2r == 1'd1 || hit_a11_b3r == 1'd1 || hit_a11_b4r == 1'd1 || hit_a11_b5r == 1'd1 || hit_a11_b6r == 1'd1 || hit_a11_b7r == 1'd1 || hit_a11_b8r == 1'd1 || hit_a11_b10r == 1'd1 || hit_a11_b9r == 1'd1 || hit_a11_b12r == 1'd1 || hit_a11_b13r == 1'd1)
				NS11 = rock1_move_315;
			else if( hit_a11_let == 1'd1 || hit_a11_ht == 1'd1 || hit_a11_pt == 1'd1 || hit_a11_b1t == 1'd1 || hit_a11_b2t == 1'd1 || hit_a11_b3t == 1'd1 || hit_a11_b4t == 1'd1 || hit_a11_b5t == 1'd1 || hit_a11_b6t == 1'd1 || hit_a11_b7t == 1'd1 || hit_a11_b8t == 1'd1 || hit_a11_b10t == 1'd1 || hit_a11_b9t == 1'd1 || hit_a11_b12t == 1'd1 || hit_a11_b13t == 1'd1)
				NS11 = rock1_move_135;
			
			else
				NS11 = rock1_move_225;
			end
		rock1_move_315:
		begin
			if(hit_a11_pl == 1'd1 || hit_a11_b1l == 1'd1 || hit_a11_b2l == 1'd1 || hit_a11_b3l == 1'd1 || hit_a11_b4l == 1'd1 || hit_a11_b5l == 1'd1 || hit_a11_b6l == 1'd1 || hit_a11_b7l == 1'd1 || hit_a11_b8l == 1'd1 || hit_a11_b10l == 1'd1 || hit_a11_b9l == 1'd1 || hit_a11_b12l == 1'd1 || hit_a11_b13l == 1'd1)
				NS11 = rock1_move_225;
			else if( hit_a11_let == 1'd1 || hit_a11_ht == 1'd1 || hit_a11_pt == 1'd1 || hit_a11_b1t == 1'd1 || hit_a11_b2t == 1'd1 || hit_a11_b3t == 1'd1 || hit_a11_b4t == 1'd1 || hit_a11_b5t == 1'd1 || hit_a11_b6t == 1'd1 || hit_a11_b7t == 1'd1 || hit_a11_b8t == 1'd1 || hit_a11_b10t == 1'd1 || hit_a11_b9t == 1'd1 || hit_a11_b12t == 1'd1 || hit_a11_b13t == 1'd1)
				NS11 = rock1_move_45;
			
			else
				NS11 = rock1_move_315;
		end
		rock1_move_135:
		begin
			if( hit_a11_ler == 1'd1 || hit_a11_hr == 1'd1 || hit_a11_pr == 1'd1 || hit_a11_b1r == 1'd1 || hit_a11_b2r == 1'd1 || hit_a11_b3r == 1'd1 || hit_a11_b4r == 1'd1 || hit_a11_b5r == 1'd1 || hit_a11_b6r == 1'd1 || hit_a11_b8r == 1'd1 || hit_a11_b7r == 1'd1 || hit_a11_b10r == 1'd1 || hit_a11_b9r == 1'd1 || hit_a11_b12r == 1'd1 || hit_a11_b13r == 1'd1)
				NS11 = rock1_move_45;
			else if( hit_a11_pb == 1'd1 || hit_a11_b1b == 1'd1 || hit_a11_b2b == 1'd1 || hit_a11_b3b == 1'd1 || hit_a11_b4b == 1'd1 || hit_a11_b5b == 1'd1 || hit_a11_b6b == 1'd1 || hit_a11_b7b == 1'd1 || hit_a11_b8b == 1'd1 || hit_a11_b10b == 1'd1 || hit_a11_b9b == 1'd1 || hit_a11_b12b == 1'd1 || hit_a11_b13b == 1'd1)
				NS11 = rock1_move_225;
			
			else
				NS11 = rock1_move_135;
		end
		rock1_move_45:
		begin
			if( hit_a11_pl == 1'd1 || hit_a11_b1l == 1'd1 || hit_a11_b2l == 1'd1 || hit_a11_b3l == 1'd1 || hit_a11_b4l == 1'd1 || hit_a11_b5l == 1'd1 || hit_a11_b6l == 1'd1 || hit_a11_b8l == 1'd1 || hit_a11_b7l == 1'd1 || hit_a11_b10l == 1'd1 || hit_a11_b9l == 1'd1 || hit_a11_b12l == 1'd1 || hit_a11_b13l == 1'd1)
				NS11 = rock1_move_135;
			else if(hit_a11_pb == 1'd1 || hit_a11_b1b == 1'd1 || hit_a11_b2b == 1'd1 || hit_a11_b3b == 1'd1 || hit_a11_b4b == 1'd1 || hit_a11_b5b == 1'd1 || hit_a11_b6b == 1'd1 || hit_a11_b8b == 1'd1 || hit_a11_b7b == 1'd1 || hit_a11_b10b == 1'd1 || hit_a11_b9b == 1'd1 || hit_a11_b12b == 1'd1 || hit_a11_b13b == 1'd1)
				NS11 = rock1_move_315;
			
			else
				NS11 = rock1_move_45;
		end
		rock1_shot:
		begin
		if (etc11 >= 32'd1000)
		NS11 = IDKWhatTocallThis;
		else
		NS11 = rock1_shot;
		end
		IDKWhatTocallThis:
		begin
			if (etc11 >= 32'd1005)
				NS11 = rock1_move_135;
			else
				NS11 = IDKWhatTocallThis;
		end
	endcase
	
	case(S12)
		PREGAME: 
		begin
			if (rst == 1'd0)
				NS12 = PREGAME;
			else
				NS12 = start;
		end
		start:
		begin
			if (SG == 1'd0)
				NS12 = start;
			else 
				NS12 =  SA;
		end
		SA:
		begin
			if (y_startScreen >= 11'd499)
				NS12 = rock1_move_315;
			else
				NS12 = SA;
		end
		rock1_move_225:
		begin
			if( hit_a12_ler == 1'd1 || hit_a12_hr == 1'd1 || hit_a12_pr == 1'd1 || hit_a12_b1r == 1'd1 || hit_a12_b2r == 1'd1 || hit_a12_b3r == 1'd1 || hit_a12_b4r == 1'd1 || hit_a12_b5r == 1'd1 || hit_a12_b6r == 1'd1 || hit_a12_b7r == 1'd1 || hit_a12_b8r == 1'd1 || hit_a12_b10r == 1'd1 || hit_a12_b11r == 1'd1 || hit_a12_b9r == 1'd1 || hit_a12_b13r == 1'd1)
				NS12 = rock1_move_315;
			else if( hit_a12_let == 1'd1 || hit_a12_ht == 1'd1 || hit_a12_pt == 1'd1 || hit_a12_b1t == 1'd1 || hit_a12_b2t == 1'd1 || hit_a12_b3t == 1'd1 || hit_a12_b4t == 1'd1 || hit_a12_b5t == 1'd1 || hit_a12_b6t == 1'd1 || hit_a12_b7t == 1'd1 || hit_a12_b8t == 1'd1 || hit_a12_b10t == 1'd1 || hit_a12_b11t == 1'd1 || hit_a12_b9t == 1'd1 || hit_a12_b13t == 1'd1)
				NS12 = rock1_move_135;
			
			else
				NS12 = rock1_move_225;
			end
		rock1_move_315:
		begin
			if(hit_a12_pl == 1'd1 || hit_a12_b1l == 1'd1 || hit_a12_b2l == 1'd1 || hit_a12_b3l == 1'd1 || hit_a12_b4l == 1'd1 || hit_a12_b5l == 1'd1 || hit_a12_b6l == 1'd1 || hit_a12_b7l == 1'd1 || hit_a12_b7l == 1'd1 || hit_a12_b10l == 1'd1 || hit_a12_b11l == 1'd1 || hit_a12_b9l == 1'd1 || hit_a12_b13l == 1'd1)
				NS12 = rock1_move_225;
			else if( hit_a12_let == 1'd1 || hit_a12_ht == 1'd1 || hit_a12_pt == 1'd1 || hit_a12_b1t == 1'd1 || hit_a12_b2t == 1'd1 || hit_a12_b3t == 1'd1 || hit_a12_b4t == 1'd1 || hit_a12_b5t == 1'd1 || hit_a12_b6t == 1'd1 || hit_a12_b7t == 1'd1 || hit_a12_b7t == 1'd1 || hit_a12_b10t == 1'd1 || hit_a12_b11t == 1'd1 || hit_a12_b9t == 1'd1 || hit_a12_b13t == 1'd1)
				NS12 = rock1_move_45;
			
			else
				NS12 = rock1_move_315;
		end
		rock1_move_135:
		begin
			if( hit_a12_ler == 1'd1 || hit_a12_hr == 1'd1 || hit_a12_pr == 1'd1 || hit_a12_b1r == 1'd1 || hit_a12_b2r == 1'd1 || hit_a12_b3r == 1'd1 || hit_a12_b4r == 1'd1 || hit_a12_b5r == 1'd1 || hit_a12_b6r == 1'd1 || hit_a12_b7r == 1'd1 || hit_a12_b7r == 1'd1 || hit_a12_b10r == 1'd1 || hit_a12_b11r == 1'd1 || hit_a12_b9r == 1'd1 || hit_a12_b13r == 1'd1)
				NS12 = rock1_move_45;
			else if( hit_a12_pb == 1'd1 || hit_a12_b1b == 1'd1 || hit_a12_b2b == 1'd1 || hit_a12_b3b == 1'd1 || hit_a12_b4b == 1'd1 || hit_a12_b5b == 1'd1 || hit_a12_b6b == 1'd1 || hit_a12_b7b == 1'd1 || hit_a12_b7b == 1'd1 || hit_a12_b10b == 1'd1 || hit_a12_b11b == 1'd1 || hit_a12_b9b == 1'd1 || hit_a12_b13b == 1'd1)
				NS12 = rock1_move_225;
			
			else
				NS12 = rock1_move_135;
		end
		rock1_move_45:
		begin
			if( hit_a12_pl == 1'd1 || hit_a12_b1l == 1'd1 || hit_a12_b2l == 1'd1 || hit_a12_b3l == 1'd1 || hit_a12_b4l == 1'd1 || hit_a12_b5l == 1'd1 || hit_a12_b6l == 1'd1 || hit_a12_b8l == 1'd1 || hit_a12_b7l == 1'd1 || hit_a12_b10l == 1'd1 || hit_a12_b11l == 1'd1 || hit_a12_b9l == 1'd1 || hit_a12_b13l == 1'd1)
				NS12 = rock1_move_135;
			else if(hit_a11_pb == 1'd1 || hit_a12_b1b == 1'd1 || hit_a12_b2b == 1'd1 || hit_a12_b3b == 1'd1 || hit_a12_b4b == 1'd1 || hit_a12_b5b == 1'd1 || hit_a12_b6b == 1'd1 || hit_a12_b8b == 1'd1 || hit_a12_b7b == 1'd1 || hit_a12_b10b == 1'd1 || hit_a12_b11b == 1'd1 || hit_a12_b9b == 1'd1 || hit_a12_b13b == 1'd1)
				NS12 = rock1_move_315;
			
			else
				NS12 = rock1_move_45;
		end
		rock1_shot:
		begin
		if (etc12 >= 32'd1000)
		NS12 = IDKWhatTocallThis;
		else
		NS12 = rock1_shot;
		end
		IDKWhatTocallThis:
		begin
			if (etc12 >= 32'd1005)
				NS12 = rock1_move_135;
			else
				NS12 = IDKWhatTocallThis;
		end
	endcase
	
	case(S13)
		PREGAME: 
		begin
			if (rst == 1'd0)
				NS13 = PREGAME;
			else
				NS13 = start;
		end
		start:
		begin
			if (SG == 1'd0)
				NS13 = start;
			else 
				NS13 =  SA;
		end
		SA:
		begin
			if (y_startScreen >= 11'd499)
				NS13 = rock1_move_315;
			else
				NS13 = SA;
		end
		rock1_move_225:
		begin
			if( hit_a13_ler == 1'd1 || hit_a13_hr == 1'd1 || hit_a13_pr == 1'd1 || hit_a13_b1r == 1'd1 || hit_a13_b2r == 1'd1 || hit_a13_b3r == 1'd1 || hit_a13_b4r == 1'd1 || hit_a13_b5r == 1'd1 || hit_a13_b6r == 1'd1 || hit_a13_b7r == 1'd1 || hit_a13_b8r == 1'd1 || hit_a13_b10r == 1'd1 || hit_a13_b11r == 1'd1 || hit_a13_b12r == 1'd1 || hit_a13_b9r == 1'd1)
				NS13 = rock1_move_315;
			else if( hit_a13_let == 1'd1 || hit_a13_ht == 1'd1 || hit_a13_pt == 1'd1 || hit_a13_b1t == 1'd1 || hit_a13_b2t == 1'd1 || hit_a13_b3t == 1'd1 || hit_a13_b4t == 1'd1 || hit_a13_b5t == 1'd1 || hit_a13_b6t == 1'd1 || hit_a13_b7t == 1'd1 || hit_a13_b8t == 1'd1 || hit_a13_b10t == 1'd1 || hit_a13_b11t == 1'd1 || hit_a13_b12t == 1'd1 || hit_a13_b9t == 1'd1)
				NS13 = rock1_move_135;
			
			else
				NS13 = rock1_move_225;
			end
		rock1_move_315:
		begin
			if(hit_a13_pl == 1'd1 || hit_a13_b1l == 1'd1 || hit_a13_b2l == 1'd1 || hit_a13_b3l == 1'd1 || hit_a13_b4l == 1'd1 || hit_a13_b5l == 1'd1 || hit_a13_b6l == 1'd1 || hit_a13_b7l == 1'd1 || hit_a13_b8l == 1'd1 || hit_a13_b10l == 1'd1 || hit_a13_b11l == 1'd1 || hit_a13_b12l == 1'd1 || hit_a13_b9l == 1'd1)
				NS13 = rock1_move_225;
			else if( hit_a13_let == 1'd1 || hit_a13_ht == 1'd1 || hit_a13_pt == 1'd1 || hit_a13_b1t == 1'd1 || hit_a13_b2t == 1'd1 || hit_a13_b3t == 1'd1 || hit_a13_b4t == 1'd1 || hit_a13_b5t == 1'd1 || hit_a13_b6t == 1'd1 || hit_a13_b8t == 1'd1 || hit_a13_b7t == 1'd1 || hit_a13_b10t == 1'd1 || hit_a13_b11t == 1'd1 || hit_a13_b12t == 1'd1 || hit_a13_b9t == 1'd1)
				NS13 = rock1_move_45;
			
			else
				NS13 = rock1_move_315;
		end
		rock1_move_135:
		begin
			if( hit_a13_ler == 1'd1 || hit_a13_hr == 1'd1 || hit_a13_pr == 1'd1 || hit_a13_b1r == 1'd1 || hit_a13_b2r == 1'd1 || hit_a13_b3r == 1'd1 || hit_a13_b4r == 1'd1 || hit_a13_b5r == 1'd1 || hit_a13_b6r == 1'd1 || hit_a13_b7r == 1'd1 || hit_a13_b8r == 1'd1 || hit_a13_b10r == 1'd1 || hit_a13_b11r == 1'd1 || hit_a13_b12r == 1'd1 || hit_a13_b9r == 1'd1)
				NS13 = rock1_move_45;
			else if( hit_a13_pb == 1'd1 || hit_a13_b1b == 1'd1 || hit_a13_b2b == 1'd1 || hit_a13_b3b == 1'd1 || hit_a13_b4b == 1'd1 || hit_a13_b5b == 1'd1 || hit_a13_b6b == 1'd1 || hit_a13_b7b == 1'd1 || hit_a13_b8b == 1'd1 || hit_a13_b10b == 1'd1 || hit_a13_b11b == 1'd1 || hit_a13_b12b == 1'd1 || hit_a13_b9b == 1'd1)
				NS13 = rock1_move_225;
			
			else
				NS13 = rock1_move_135;
		end
		rock1_move_45:
		begin
			if( hit_a13_pl == 1'd1 || hit_a13_b1l == 1'd1 || hit_a13_b2l == 1'd1 || hit_a13_b3l == 1'd1 || hit_a13_b4l == 1'd1 || hit_a13_b5l == 1'd1 || hit_a13_b6l == 1'd1 || hit_a13_b7l == 1'd1 || hit_a13_b8l == 1'd1 || hit_a13_b10l == 1'd1 || hit_a13_b11l == 1'd1 || hit_a13_b12l == 1'd1 || hit_a13_b9l == 1'd1)
				NS13 = rock1_move_135;
			else if(hit_a13_pb == 1'd1 || hit_a13_b1b == 1'd1 || hit_a13_b2b == 1'd1 || hit_a13_b3b == 1'd1 || hit_a13_b4b == 1'd1 || hit_a13_b5b == 1'd1 || hit_a13_b6b == 1'd1 || hit_a13_b7b == 1'd1 || hit_a13_b8b == 1'd1 || hit_a13_b10b == 1'd1 || hit_a13_b11b == 1'd1 || hit_a13_b12b == 1'd1 || hit_a13_b9b == 1'd1)
				NS13 = rock1_move_315;
			
			else
				NS13 = rock1_move_45;
		end
		rock1_shot:
		begin
		if (etc13 >= 32'd1000)
		NS13 = IDKWhatTocallThis;
		else
		NS13 = rock1_shot;
		end
		IDKWhatTocallThis:
		begin
			if (etc13 >= 32'd1005)
				NS13 = rock1_move_135;
			else
				NS13 = IDKWhatTocallThis;
		end
	endcase
end


//state definitions
always @(posedge update or negedge rst)
begin
	if (rst==1'd0)
	begin	
		// Positions the missles and cosmetics on the screen following the player
				yShot = yPos + 8'd7;
				xShot = xPos;
				y_body = yPos + 8'd7;
				x_body = xPos;
				y_wing = yPos - 8'd5;
				x_wing = xPos + 8'd3;
				y_wing2 = yPos + 8'd21;
				x_wing2 = xPos + 8'd3;
				y_cockpit = yPos + 8'd5;
				x_cockpit = xPos + 8'd21;
				x_startScreen = 1'b0;
				y_startScreen = 1'b0;
				x_BGofOnSw = 11'd141;
				y_BGofOnSw = 11'd245;
				x_onswitch = 11'd142;
				y_onswitch = 11'd260;
				x_BGofG = 11'd141;
				y_BGofG = 11'd212;
				x_gin = 11'd144;
				y_gin = 11'd214; 
				x_gin2 = 11'd144;
				y_gin2 = 11'd218; 
				x_BGoA = 11'd159;
				y_BGoA = 11'd212;
				x_ain2 = 11'd161;
				y_ain2 = 11'd228;
				x_ain = 11'd161;
				y_ain = 11'd214;
				x_BGoM = 11'd177;
				y_BGoM = 11'd212;
				x_min = 11'd179;
				y_min = 11'd214;
				x_min2 = 11'd186;
				y_min2 = 11'd214;
				x_BGoE = 11'd195;
				y_BGoE = 11'd212;
				x_ein = 11'd197;
				y_ein = 11'd214;
				x_ein2 = 11'd197;
				y_ein2 = 11'd228;
				x_BGoO = 11'd177;
				y_BGoO = 11'd245;
				x_oin = 11'd179;
				y_oin = 11'd247;
				x_BGoN = 11'd195;
				y_BGoN = 11'd245;
				x_nin = 11'd198;
				y_nin = 11'd247;
				x_nin2 = 11'd204;
				y_nin2 = 11'd245;
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
				x_deaded = 11'd700;
				y_deaded = 11'd500;
				x_BGoE2 = 11'd700;
				y_BGoE2 = 11'd500;
				x_e2in1 = 11'd700;
				y_e2in1 = 11'd500;
				x_e2in2 = 11'd700;
				y_e2in2 = 11'd500;
				x_BGoV = 11'd700;
				y_BGoV = 11'd500;
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
				x_BGoR = 11'd700;
				y_BGoR = 11'd500;
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
				x_LeftSideOfOnSw = 11'd138;
				y_LeftSideOfOnSw = 11'd245;
				x_RightSideOfOnSw = 11'd156;
				y_RightSideOfOnSw = 11'd245;
				x_bot1b = 11'd138;
				y_bot1b = 11'd274;
				x_top2b = 11'd700;
				y_top2b = 11'd500;
				x_bot2b = 11'd700;
				y_bot2b = 11'd500;
				
				
				x_goodbye = 11'd616;
				y_goodbye = 11'd376;
				y_return1 = 11'd425;
				y_return2 = 11'd430;
				y_return3 = 11'd420;
				x_return1 = 11'd660;
				x_return2 = 11'd680;
				x_return3 = 11'd700;
		// Positions the asteroids
		xPosRock1 = 11'd177;
		yPosRock1 = 11'd45;
		xPosRock2 = 11'd259;
		yPosRock2 = 11'd68;
		xPosRock3 = 11'd340;
		yPosRock3 = 11'd245;
		xPosRock4 = 11'd382;
		yPosRock4 = 11'd27;
		xPosRock5 = 11'd365;
		yPosRock5 = 11'd380;
		xPosRock6 = 11'd420;
		yPosRock6 = 11'd230;
		xPosRock7 = 11'd474;
		yPosRock7 = 11'd100;
		xPosRock8 = 11'd560;
		yPosRock8 = 11'd420;
		xPosRock9 = 11'd260;
		yPosRock9 = 11'd360;
		xPosRock10 = 11'd460;
		yPosRock10 = 11'd270;
		xPosRock11 = 11'd485;
		yPosRock11 = 11'd95;
		xPosRock12 = 11'd540;
		yPosRock12 = 11'd220;
		xPosRock13 = 11'd150;
		yPosRock13 = 11'd360;
		
		x_screen_border = 11'd20;
		y_screen_border = 11'd20;
	end
	else
	begin
		case(S)
			start:
			begin //this is just the game starting, I made it manual to avoid issues found with auto-start and reset
				yShot = yPos + 8'd7;
				xShot = xPos;
				y_body = yPos + 8'd7;
				x_body = xPos;
				y_wing = yPos - 8'd5;
				x_wing = xPos + 8'd3;
				y_wing2 = yPos + 8'd21;
				x_wing2 = xPos + 8'd3;
				y_cockpit = yPos + 8'd5;
				x_cockpit = xPos + 8'd21;
				life = 11'd10; //Base life points. Subtracts by 2 per hit, so double what you want. Changing this value breaks the health  bar on screen.
			end
			SA:
			begin
			yShot = yPos + 8'd7;
				xShot = xPos;
				y_body = yPos + 8'd7;
				x_body = xPos;
				y_wing = yPos - 8'd5;
				x_wing = xPos + 8'd3;
				y_wing2 = yPos + 8'd21;
				x_wing2 = xPos + 8'd3;
				y_cockpit = yPos + 8'd5;
				x_cockpit = xPos + 8'd21;
			if (y_onswitch <= 11'd246)
				begin
					y_startScreen = y_startScreen + 11'd1;
					if (y_startScreen >= 11'd500)
						begin
							y_startScreen = 11'd500;
							score = 15'd0;
							y_BGofOnSw = 11'd500;
							y_onswitch = 11'd500;
							y_BGofG = 11'd500;
							y_gin = 11'd500;
							y_gin2 = 11'd500;
							y_BGoA = 11'd500;
							y_ain = 11'd500;
							y_ain2 = 11'd500;
							y_BGoM = 11'd500;
							y_min = 11'd500;
							y_min2 = 11'd500;
							y_BGoE = 11'd500;
							y_ein = 11'd500;
							y_ein2 = 11'd500;
							y_BGoN = 11'd500;
							y_nin = 11'd500;
							y_nin2 = 11'd500;
							y_BGoO = 11'd500;
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
							x_LeftSideOfOnSw = 11'd700;
							y_LeftSideOfOnSw = 11'd500;
							x_RightSideOfOnSw = 11'd700;
							y_RightSideOfOnSw = 11'd500;
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
			laserRight:
			begin
				// this is for when an asteroid is hit by a shot, currently causes them to break, needs to split if larger and break if smaller
				if(hit_rock1 == 1'b1) // Delete block 1
				begin
					score = score + 1'd1;
					y_goodbye = y_goodbye + 11'd4;
					xPosRock1 = 11'd700;
					yPosRock1 = 11'd0;
				end
				if(hit_rock2 == 1'b1) // Delete block 2
				begin
					score = score + 1'd1;
					y_goodbye = y_goodbye + 11'd4;
					xPosRock2 = 11'd700;
					yPosRock2 = 11'd30;
				end
				if(hit_rock3 == 1'b1) // Delete block 3
				begin
					score = score + 1'd1;
					y_goodbye = y_goodbye + 11'd4;
					xPosRock3 = 11'd700;
					yPosRock3 = 11'd60;
				end
				if(hit_rock4 == 1'b1) // Delete block 4
				begin
					score = score + 1'd1;
					y_goodbye = y_goodbye + 11'd4;
					xPosRock4 = 11'd700;
					yPosRock4 = 11'd90;
				end
				if(hit_rock5 == 1'b1) // Delete block 5
				begin
					score = score + 1'd1;
					y_goodbye = y_goodbye + 11'd4;
					xPosRock5 = 11'd700;
					yPosRock5 = 11'd120;
				end
				if(hit_rock6 == 1'b1) // Delete block 6
				begin
					score = score + 1'd1;
					y_goodbye = y_goodbye + 11'd4;
					xPosRock6 = 11'd700;
					yPosRock6 = 11'd150;
				end
				if(hit_rock7 == 1'b1) // Delete block 7
				begin
					score = score + 1'd1;
					y_goodbye = y_goodbye + 11'd4;
					xPosRock7 = 11'd700;
					yPosRock7 = 11'd180;
				end
				if(hit_rock8 == 1'b1) // Delete block 8
				begin
					score = score + 1'd1;
					y_goodbye = y_goodbye + 11'd4;
					xPosRock8 = 11'd700;
					yPosRock8 = 11'd210;
				end
				if(hit_rock9 == 1'b1) // Delete block 9
				begin
					score = score + 1'd1;
					y_goodbye = y_goodbye + 11'd4;
					xPosRock9 = 11'd700;
					yPosRock9 = 11'd240;
				end
				if (hit_rock10 == 1'b1) // delete 10
				begin
					score = score + 1'd1;
					y_goodbye = y_goodbye + 11'd4;
					xPosRock10 = 11'd700;
					yPosRock10 = 11'd270;
				end
				if (hit_rock11 == 1'b1) //delete 11
				begin
					score = score + 1'd1;
					y_goodbye = y_goodbye + 11'd4;
					xPosRock11 = 11'd700;
					yPosRock11 = 11'd300;
				end
				if (hit_rock12 == 1'b1) //delete 12
				begin
					score = score + 1'd1;
					y_goodbye = y_goodbye + 11'd4;
					xPosRock12 = 11'd700;
					yPosRock12 = 11'd330;
				end
				if (hit_rock13 == 1'b1) //delete 13
				begin
					score = score + 1'd1;
					y_goodbye = y_goodbye + 11'd4;
					xPosRock13 = 11'd700;
					yPosRock13 = 11'd360;
				end
				
				// controls motion of the shot
				xShot = xShot + 11'd5;
				y_wing = yPos - 8'd5;
				x_wing = xPos + 8'd3;
				y_wing2 = yPos + 8'd21;
				x_wing2 = xPos + 8'd3;
				y_cockpit = yPos + 8'd5;
				x_cockpit = xPos + 8'd21;
				y_body = yPos + 8'd7;
				x_body = xPos;
				
				
				//Code for when the ship is hit by a rock
				
				if (hitShipA2t == 1'd1 || hitShipA1t == 1'd1 || hitShipA3t == 1'd1 || hitShipA4t == 1'd1 || hitShipA5t == 1'd1 || hitShipA6t == 1'd1 || hitShipA7t == 1'd1 || hitShipA8t == 1'd1 || hitShipA9t == 1'd1 || hitShipA10t == 1'd1 || hitShipA11t == 1'd1 || hitShipA12t == 1'd1 || hitShipA13t == 1'd1 || hitShipA2b == 1'd1 || hitShipA1b == 1'd1 || hitShipA3b == 1'd1 || hitShipA4b == 1'd1 || hitShipA5b == 1'd1 || hitShipA6b == 1'd1 || hitShipA7b == 1'd1 || hitShipA8b == 1'd1 || hitShipA9b == 1'd1 || hitShipA10b == 1'd1 || hitShipA11b == 1'd1 || hitShipA12b == 1'd1 || hitShipA13b == 1'd1 || hitShipA2l == 1'd1 || hitShipA1l == 1'd1 || hitShipA3l == 1'd1 || hitShipA4l == 1'd1 || hitShipA5l == 1'd1 || hitShipA6l == 1'd1 || hitShipA7l == 1'd1 || hitShipA8l == 1'd1 || hitShipA9l == 1'd1 || hitShipA10l == 1'd1 || hitShipA11l == 1'd1 || hitShipA12l == 1'd1 || hitShipA13l == 1'd1 || hitShipA2r == 1'd1 || hitShipA1r == 1'd1 || hitShipA3r == 1'd1 || hitShipA4r == 1'd1 || hitShipA5r == 1'd1 || hitShipA6r == 1'd1 || hitShipA7r == 1'd1 || hitShipA8r == 1'd1 || hitShipA9r == 1'd1 || hitShipA10r == 1'd1 || hitShipA11r == 1'd1 || hitShipA12r == 1'd1 || hitShipA13r == 1'd1)
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
			
			laser_reload: //this makes all cosmetics follow the player and returns the missle to the body and player
			begin
				yShot = yPos + 8'd7;
				xShot = xPos;
				y_body = yPos + 8'd7;
				x_body = xPos;
				y_wing = yPos - 8'd5;
				x_wing = xPos + 8'd3;
				y_wing2 = yPos + 8'd21;
				x_wing2 = xPos + 8'd3;
				y_cockpit = yPos + 8'd5;
				x_cockpit = xPos + 8'd21;
				
				// ship's health
				if (hitShipA2t == 1'd1 || hitShipA1t == 1'd1 || hitShipA3t == 1'd1 || hitShipA4t == 1'd1 || hitShipA5t == 1'd1 || hitShipA6t == 1'd1 || hitShipA7t == 1'd1 || hitShipA8t == 1'd1 || hitShipA9t == 1'd1 || hitShipA10t == 1'd1 || hitShipA11t == 1'd1 || hitShipA12t == 1'd1 || hitShipA13t == 1'd1 || hitShipA2b == 1'd1 || hitShipA1b == 1'd1 || hitShipA3b == 1'd1 || hitShipA4b == 1'd1 || hitShipA5b == 1'd1 || hitShipA6b == 1'd1 || hitShipA7b == 1'd1 || hitShipA8b == 1'd1 || hitShipA9b == 1'd1 || hitShipA10b == 1'd1 || hitShipA11b == 1'd1 || hitShipA12b == 1'd1 || hitShipA13b == 1'd1 || hitShipA2l == 1'd1 || hitShipA1l == 1'd1 || hitShipA3l == 1'd1 || hitShipA4l == 1'd1 || hitShipA5l == 1'd1 || hitShipA6l == 1'd1 || hitShipA7l == 1'd1 || hitShipA8l == 1'd1 || hitShipA9l == 1'd1 || hitShipA10l == 1'd1 || hitShipA11l == 1'd1 || hitShipA12l == 1'd1 || hitShipA13l == 1'd1 || hitShipA2r == 1'd1 || hitShipA1r == 1'd1 || hitShipA3r == 1'd1 || hitShipA4r == 1'd1 || hitShipA5r == 1'd1 || hitShipA6r == 1'd1 || hitShipA7r == 1'd1 || hitShipA8r == 1'd1 || hitShipA9r == 1'd1 || hitShipA10r == 1'd1 || hitShipA11r == 1'd1 || hitShipA12r == 1'd1 || hitShipA13r == 1'd1)
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
			
			laser_reload1: //this makes all cosmetics follow the player and returns the missle to the body and player
			begin
				yShot = yPos + 8'd7;
				xShot = xPos;
				y_body = yPos + 8'd7;
				x_body = xPos;
				y_wing = yPos - 8'd5;
				x_wing = xPos + 8'd3;
				y_wing2 = yPos + 8'd21;
				x_wing2 = xPos + 8'd3;
				y_cockpit = yPos + 8'd5;
				x_cockpit = xPos + 8'd21;
				
				//ship hit conditions to decrease health and update bar on screen
				if (hitShipA2t == 1'd1 || hitShipA1t == 1'd1 || hitShipA3t == 1'd1 || hitShipA4t == 1'd1 || hitShipA5t == 1'd1 || hitShipA6t == 1'd1 || hitShipA7t == 1'd1 || hitShipA8t == 1'd1 || hitShipA9t == 1'd1 || hitShipA10t == 1'd1 || hitShipA11t == 1'd1 || hitShipA12t == 1'd1 || hitShipA13t == 1'd1 || hitShipA2b == 1'd1 || hitShipA1b == 1'd1 || hitShipA3b == 1'd1 || hitShipA4b == 1'd1 || hitShipA5b == 1'd1 || hitShipA6b == 1'd1 || hitShipA7b == 1'd1 || hitShipA8b == 1'd1 || hitShipA9b == 1'd1 || hitShipA10b == 1'd1 || hitShipA11b == 1'd1 || hitShipA12b == 1'd1 || hitShipA13b == 1'd1 || hitShipA2l == 1'd1 || hitShipA1l == 1'd1 || hitShipA3l == 1'd1 || hitShipA4l == 1'd1 || hitShipA5l == 1'd1 || hitShipA6l == 1'd1 || hitShipA7l == 1'd1 || hitShipA8l == 1'd1 || hitShipA9l == 1'd1 || hitShipA10l == 1'd1 || hitShipA11l == 1'd1 || hitShipA12l == 1'd1 || hitShipA13l == 1'd1 || hitShipA2r == 1'd1 || hitShipA1r == 1'd1 || hitShipA3r == 1'd1 || hitShipA4r == 1'd1 || hitShipA5r == 1'd1 || hitShipA6r == 1'd1 || hitShipA7r == 1'd1 || hitShipA8r == 1'd1 || hitShipA9r == 1'd1 || hitShipA10r == 1'd1 || hitShipA11r == 1'd1 || hitShipA12r == 1'd1 || hitShipA13r == 1'd1)
					life = life - 11'd1;
				if (life == 11'd6)
				begin
					x_health1 = 11'd700;
					y_health1 = 11'd500;
				end
				if (life == 11'd5)
				begin
					x_health2 = 11'd700;
					y_health2 = 11'd500;
				end
				if (life == 11'd4)
				begin
					x_health3 = 11'd700;
					y_health3 = 11'd500;
				end
				if (life == 11'd3)
				begin
					x_health4 = 11'd700;
					y_health4 = 11'd500;
				end
				if (life == 11'd2)
				begin
					x_health5 = 11'd700;
					y_health5 = 11'd500;
				end
				if (life == 11'd1)
				begin
					x_health6 = 11'd700;
					y_health6 = 11'd500;
				end
			end
				
			end_game: // Code for losing. Don't get hit and you won't see it work.
			begin
				x_leaves = 11'd700;
				y_leaves = 11'd500;
				x_health10 = 11'd700;
				y_health10 = 11'd500;
				yShot = 11'd500;
				xShot =  11'd700;
				y_body = 11'd500;
				x_body =  11'd700;
				y_wing = 11'd500;
				x_wing =  11'd700;
				y_wing2 = 11'd500;
				x_wing2 =  11'd700;
				y_cockpit =  11'd500;
				x_cockpit =  11'd700;
				y_deaded =  yPos;
				x_deaded =  xPos;
				x_startScreen = 1'b0;
				y_startScreen = y_startScreen - 11'd1;
				x_goodbye = 11'd700;
				y_goodbye = 11'd500;
					if (y_startScreen <= 11'd1)
						begin
							x_leaves = 11'd700;
							y_leaves = 11'd500;
							x_health10 = 11'd700;
							y_health10 = 11'd500;
							yShot = 11'd500;
							xShot =  11'd700;
							y_body = 11'd500;
							x_body =  11'd700;
							y_wing = 11'd500;
							x_wing =  11'd700;
							y_wing2 = 11'd500;
							x_wing2 =  11'd700;
							y_cockpit =  11'd500;
							x_cockpit =  11'd700;
							y_deaded =  yPos;
							x_deaded =  xPos;
							x_BGofG = 11'd141;
							y_BGofG = 11'd212;
							x_gin = 11'd144;
							y_gin = 11'd214; 
							x_gin2 = 11'd144;
							y_gin2 = 11'd218; 
							x_BGoA = 11'd159;
							y_BGoA = 11'd212;
							x_ain2 = 11'd161;
							y_ain2 = 11'd228;
							x_ain = 11'd161;
							y_ain = 11'd214;
							x_BGoM = 11'd177;
							y_BGoM = 11'd212;
							x_min = 11'd179;
							y_min = 11'd214;
							x_min2 = 11'd186;
							y_min2 = 11'd214;
							x_BGoE = 11'd195;
							y_BGoE = 11'd212;
							x_ein = 11'd197;
							y_ein = 11'd214;
							x_ein2 = 11'd197;
							y_ein2 = 11'd228;
							x_BGoO = 11'd177;
							y_BGoO = 11'd245;
							x_oin = 11'd179;
							y_oin = 11'd247;
							x_BGoV = 11'd195;
							y_BGoV = 11'd245;
							x_vin = 11'd197;
							y_vin = 11'd245;
							x_vin2 = 11'd199;
							y_vin2 = 11'd248;
							x_BGoE2 = 11'd213;
							y_BGoE2 = 11'd245;
							x_e2in1 = 11'd215;
							y_e2in1 = 11'd247;
							x_e2in2 = 11'd215;
							y_e2in2 = 11'd261;
							x_BGoR = 11'd231;
							y_BGoR = 11'd245;
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
							x_LeftSideOfOnSw = 11'd228;
							y_LeftSideOfOnSw = 11'd245;
							x_RightSideOfOnSw = 11'd246;
							y_RightSideOfOnSw = 11'd245;
							x_bot2b = 11'd210;
							y_bot2b = 11'd274;
							x_top2b = 11'd210;
							y_top2b = 11'd242;
							y_startScreen = 11'd1;
							
						end
						end
			
		endcase
		case(S1)
		start:
		begin
			xPosRock1 <= 11'd177;
			yPosRock1 <= 11'd45;
		end
		SA:
		begin
			xPosRock1 <= 11'd177;
			yPosRock1 <= 11'd45;
		end
		rock1_move_45:
		begin
			yPosRock1 <= yPosRock1 - 11'd1;
			xPosRock1 <= xPosRock1 + 11'd1;
		end
		rock1_move_135:
		begin
			yPosRock1 <= yPosRock1 - 11'd1;
			xPosRock1 <= xPosRock1 - 11'd1;
		if (etc>= 32'd1005)
				etc <= 11'b0;
			
		end
		rock1_move_315:
		begin
			yPosRock1 <= yPosRock1 + 11'd1;
			xPosRock1 <= xPosRock1 + 11'd1;
		end
		rock1_move_225:
		begin
			yPosRock1 <= yPosRock1 + 11'd1;
			xPosRock1 <= xPosRock1 - 11'd1;
		if (etc >= 32'd1005)
				etc <= 11'b0;
		end
		rock1_shot:
		begin
			xPosRock1 <= 11'd700;
			yPosRock1 <= 11'd0;
			if (update == 1'b1)
				etc <= etc + 11'd1;
			else
				etc <= etc;
		end
		IDKWhatTocallThis:
		begin
			xPosRock1 <= 11'd599;
			if (update == 1'b1)
				etc <= etc + 11'd1;
			else
				etc <= etc;
		end
		endcase
		
		case(S2)
		start:
		begin
			xPosRock2 <= 11'd259;
			yPosRock2 <= 11'd68;
		end
		SA:
		begin
			xPosRock2 <= 11'd259;
			yPosRock2 <= 11'd68;
		end
		rock1_move_45:
		begin
			yPosRock2 <= yPosRock2 - 11'd1;
			xPosRock2 <= xPosRock2 + 11'd1;
		end
		rock1_move_135:
		begin
			yPosRock2 <= yPosRock2 - 11'd1;
			xPosRock2 <= xPosRock2 - 11'd1;
		if (etc2>= 32'd1005)
				etc2 <= 11'h00;
		end
		rock1_move_315:
		begin
			yPosRock2 <= yPosRock2 + 11'd1;
			xPosRock2 <= xPosRock2 + 11'd1;
		end
		rock1_move_225:
		begin
			yPosRock2 <= yPosRock2 + 11'd1;
			xPosRock2 <= xPosRock2 - 11'd1;
		if (etc2 >= 32'd1005)
				etc2 <= 11'h00;
		end
		rock1_shot:
		begin
			xPosRock2 <= 11'd700;
			yPosRock2 <= 11'd50;
			if (update == 1'b1)
				etc2 <= etc2 + 11'd1;
			else
				etc2 <= etc2;
		end
		IDKWhatTocallThis:
		begin
			xPosRock2 <= 11'd599;
			if (update == 1'b1)
				etc2 <= etc2 + 11'd1;
			else
				etc2 <= etc2;
			if (etc2 >= 32'd1005)
				etc2 <= 11'h00;
		end
		endcase	
		
		case(S3)
		start:
		begin
			xPosRock3 <= 11'd340;
			yPosRock3 <= 11'd245;
		end
		SA:
		begin
			xPosRock3 <= 11'd340;
			yPosRock3 <= 11'd245;
		end
		rock1_move_45:
		begin
			yPosRock3 <= yPosRock3 - 11'd1;
			xPosRock3 <= xPosRock3 + 11'd1;
		end
		rock1_move_135:
		begin
			yPosRock3 <= yPosRock3 - 11'd1;
			xPosRock3 <= xPosRock3 - 11'd1;
			if (etc3 >= 32'd1005)
				etc3 <= 11'h00;
		end
		rock1_move_315:
		begin
			yPosRock3 <= yPosRock3 + 11'd1;
			xPosRock3 <= xPosRock3 + 11'd1;
		end
		rock1_move_225:
		begin
			yPosRock3 <= yPosRock3 + 11'd1;
			xPosRock3 <= xPosRock3 - 11'd1;
			if (etc3 >= 32'd1005)
				etc3 <= 11'h00;
		end
		rock1_shot:
		begin
			xPosRock3 <= 11'd700;
			yPosRock3 <= 11'd100;
			if (update == 1'b1)
				etc3 <= etc3 + 11'd1;
			else
				etc3 <= etc3;
		end
		IDKWhatTocallThis:
		begin
			xPosRock3 <= 11'd599;
			if (update == 1'b1)
				etc3 <= etc3 + 11'd1;
			else
				etc3 <= etc3;
				if (etc3 >= 32'd1005)
				etc3 <= 11'h00;
		end
		endcase
		
		case(S4)
		start:
		begin
			xPosRock4 <= 11'd382;
			yPosRock4 <= 11'd27;
		end
		SA:
		begin
			xPosRock4 <= 11'd382;
			yPosRock4 <= 11'd27;
		end
		rock1_move_45:
		begin
			yPosRock4 <= yPosRock4 - 11'd1;
			xPosRock4 <= xPosRock4 + 11'd1;
		end
		rock1_move_135:
		begin
			yPosRock4 <= yPosRock4 - 11'd1;
			xPosRock4 <= xPosRock4 - 11'd1;
		if (etc4>= 32'd1005)
				etc4 <= 11'h00;
		end
		rock1_move_315:
		begin
			yPosRock4 <= yPosRock4 + 11'd1;
			xPosRock4 <= xPosRock4 + 11'd1;
		end
		rock1_move_225:
		begin
			yPosRock4 <= yPosRock4 + 11'd1;
			xPosRock4 <= xPosRock4 - 11'd1;
		if (etc4>= 32'd1005)
				etc4 <= 11'h00;
		end
		rock1_shot:
		begin
			xPosRock4 <= 11'd700;
			yPosRock4 <= 11'd1500;
			if (update == 1'b1)
				etc4 <= etc4 + 11'd1;
			else
				etc4 <= etc4;
		end
		IDKWhatTocallThis:
		begin
			xPosRock4 <= 11'd599;
			if (update == 1'b1)
				etc4 <= etc4 + 11'd1;
			else
				etc4 <= etc4;
				if (etc4 >= 32'd1005)
				etc4 <= 11'h00;
		end
		endcase
		
		case(S5)
		start:
		begin
			xPosRock5 <= 11'd365;
			yPosRock5 <= 11'd380;
		end
		SA:
		begin
			xPosRock5 <= 11'd365;
			yPosRock5 <= 11'd380;
		end
		rock1_move_45:
		begin
			yPosRock5 <= yPosRock5 - 11'd1;
			xPosRock5 <= xPosRock5 + 11'd1;
		end
		rock1_move_135:
		begin
			yPosRock5 <= yPosRock5 - 11'd1;
			xPosRock5 <= xPosRock5 - 11'd1;
			if (etc5 >= 32'd1005)
				etc5 <= 11'h00;
		end
		rock1_move_315:
		begin
			yPosRock5 <= yPosRock5 + 11'd1;
			xPosRock5 <= xPosRock5 + 11'd1;
		end
		rock1_move_225:
		begin
			yPosRock5 <= yPosRock5 + 11'd1;
			xPosRock5 <= xPosRock5 - 11'd1;
		if (etc5>= 32'd1005)
				etc5 <= 11'h00;
		end
		rock1_shot:
		begin
			xPosRock5 <= 11'd700;
			yPosRock5 <= 11'd200;
			if (update == 1'b1)
				etc5 <= etc5 + 11'd1;
			else
				etc5 <= etc5;
		end
		IDKWhatTocallThis:
		begin
			xPosRock5 <= 11'd599;
			if (update == 1'b1)
				etc5 <= etc5 + 11'd1;
			else
				etc5 <= etc5;
		end
		endcase
		case(S6)
		start:
		begin
			xPosRock6 <= 11'd420;
			yPosRock6 <= 11'd230;
		end
		SA:
		begin
			xPosRock6 <= 11'd420;
			yPosRock6 <= 11'd230;
		end
		rock1_move_45:
		begin
			yPosRock6 <= yPosRock6 - 11'd1;
			xPosRock6 <= xPosRock6 + 11'd1;
		end
		rock1_move_135:
		begin
			yPosRock6 <= yPosRock6 - 11'd1;
			xPosRock6 <= xPosRock6 - 11'd1;
		if (etc6>= 32'd1005)
				etc6 <= 11'h00;
		end
		rock1_move_315:
		begin
			yPosRock6 <= yPosRock6 + 11'd1;
			xPosRock6 <= xPosRock6 + 11'd1;
		end
		rock1_move_225:
		begin
			yPosRock6 <= yPosRock6 + 11'd1;
			xPosRock6 <= xPosRock6 - 11'd1;
			if (etc6 >= 32'd1005)
				etc6 <= 11'h00;
		end
		rock1_shot:
		begin
			xPosRock6 <= 11'd700;
			yPosRock6 <= 11'd250;
			if (update == 1'b1)
				etc6 <= etc6 + 11'd1;
			else
				etc6 <= etc6;
		end
		IDKWhatTocallThis:
		begin
			xPosRock6 <= 11'd599;
			if (update == 1'b1)
				etc6 <= etc6 + 11'd1;
			else
				etc6 <= etc6;
				if (etc6 >= 32'd1005)
				etc6 <= 11'h00;
		end
		endcase		
		case(S7)
		start:
		begin
			xPosRock7 <= 11'd474;
			yPosRock7 <= 11'd100;
		end
		SA:
		begin
			xPosRock7 <= 11'd474;
			yPosRock7 <= 11'd100;
		end
		rock1_move_45:
		begin
			yPosRock7 <= yPosRock7 - 11'd1;
			xPosRock7 <= xPosRock7 + 11'd1;
		end
		rock1_move_135:
		begin
			yPosRock7 <= yPosRock7 - 11'd1;
			xPosRock7 <= xPosRock7 - 11'd1;
			if (etc7 >= 32'd1005)
				etc7 <= 11'h00;
		end
		rock1_move_315:
		begin
			yPosRock7 <= yPosRock7 + 11'd1;
			xPosRock7 <= xPosRock7 + 11'd1;
		end
		rock1_move_225:
		begin
			yPosRock7 <= yPosRock7 + 11'd1;
			xPosRock7 <= xPosRock7 - 11'd1;
		if (etc7>= 32'd1005)
				etc7 <= 11'h00;
		end
		rock1_shot:
		begin
			xPosRock7 <= 11'd700;
			yPosRock7 <= 11'd300;
			if (update == 1'b1)
				etc7 <= etc7 + 11'd1;
			else
				etc7 <= etc7;
		end
		IDKWhatTocallThis:
		begin
			xPosRock7 <= 11'd599;
			if (update == 1'b1)
				etc7 <= etc7 + 11'd1;
			else
				etc7 <= etc7;
				if (etc7 >= 32'd1005)
				etc7 <= 11'h00;
		end
		endcase
		case(S8)
		start:
		begin
			xPosRock8 <= 11'd590;
			yPosRock8 <= 11'd420;
		end
		SA:
		begin
			xPosRock8 <= 11'd590;
			yPosRock8 <= 11'd420;
		end
		rock1_move_45:
		begin
			yPosRock8 <= yPosRock8 - 11'd1;
			xPosRock8 <= xPosRock8 + 11'd1;
		end
		rock1_move_135:
		begin
			yPosRock8 <= yPosRock8 - 11'd1;
			xPosRock8 <= xPosRock8 - 11'd1;		
		if (etc8>= 32'd1005)
				etc8 <= 11'h00;
		end
		rock1_move_315:
		begin
			yPosRock8 <= yPosRock8 + 11'd1;
			xPosRock8 <= xPosRock8 + 11'd1;
		end
		rock1_move_225:
		begin
			yPosRock8 <= yPosRock8 + 11'd1;
			xPosRock8 <= xPosRock8 - 11'd1;
			if (etc8 >= 32'd1005)
				etc8 <= 11'd0;
		end
		rock1_shot:
		begin
			xPosRock8 <= 11'd700;
			yPosRock8 <= 11'd350;
			if (update == 1'b1)
				etc8 <= etc8 + 11'd1;
			else
				etc8 <= etc8;
		end
		IDKWhatTocallThis:
		begin
			xPosRock8 <= 11'd599;
			if (update == 1'b1)
				etc8 <= etc8 + 11'd1;
			else
				etc8 <= etc8;
				if (etc8 >= 32'd1005)
				etc8 <= 11'd0;
		end
		endcase
		case(S9)
		start:
		begin
			xPosRock9 <= 11'd260;
			yPosRock9 <= 11'd360;
		end
		SA:
		begin
			xPosRock9 <= 11'd260;
			yPosRock9 <= 11'd360;
		end
		rock1_move_45:
		begin
			yPosRock9 <= yPosRock9 - 11'd1;
			xPosRock9 <= xPosRock9 + 11'd1;
		end
		rock1_move_135:
		begin
			yPosRock9 <= yPosRock9 - 11'd1;
			xPosRock9 <= xPosRock9 - 11'd1;
			if (etc9 >= 32'd1005)
				etc9 <= 11'd0;
		end
		rock1_move_315:
		begin
			yPosRock9 <= yPosRock9 + 11'd1;
			xPosRock9 <= xPosRock9 + 11'd1;
		end
		rock1_move_225:
		begin
			yPosRock9 <= yPosRock9 + 11'd1;
			xPosRock9 <= xPosRock9 - 11'd1;
		if (etc9>= 32'd1005)
				etc9 <= 11'd0;
		end
		rock1_shot:
		begin
			xPosRock9 <= 11'd700;
			yPosRock9 <= 11'd400;
			if (update == 1'b1)
				etc9 <= etc9 + 11'd1;
			else
				etc9 <= etc9;
		end
		IDKWhatTocallThis:
		begin
			xPosRock9 <= 11'd599;
			if (update == 1'b1)
				etc9 <= etc9 + 11'd1;
			else
				etc9 <= etc9;
				if (etc9 >= 32'd1005)
				etc9 <= 11'd0;
		end
		endcase
		
		case(S10)
		start:
		begin
			xPosRock10 <= 11'd260;
			yPosRock10 <= 11'd360;
		end
		SA:
		begin
			xPosRock10 <= 11'd260;
			yPosRock10 <= 11'd360;
		end
		rock1_move_45:
		begin
			yPosRock10 <= yPosRock10 - 11'd1;
			xPosRock10 <= xPosRock10 + 11'd1;
		end
		rock1_move_135:
		begin
			yPosRock10 <= yPosRock10 - 11'd1;
			xPosRock10 <= xPosRock10 - 11'd1;
			if (etc10 >= 32'd1005)
				etc10 <= 11'd0;
		end
		rock1_move_315:
		begin
			yPosRock10 <= yPosRock10 + 11'd1;
			xPosRock10 <= xPosRock10 + 11'd1;
		end
		rock1_move_225:
		begin
			yPosRock10 <= yPosRock10 + 11'd1;
			xPosRock10 <= xPosRock10 - 11'd1;
		if (etc10>= 32'd1005)
				etc10 <= 11'd0;
		end
		rock1_shot:
		begin
			xPosRock10 <= 11'd700;
			yPosRock10 <= 11'd400;
			if (update == 1'b1)
				etc10 <= etc10 + 11'd1;
			else
				etc10 <= etc10;
		end
		IDKWhatTocallThis:
		begin
			xPosRock10 <= 11'd599;
			if (update == 1'b1)
				etc10 <= etc10 + 11'd1;
			else
				etc10 <= etc10;
				if (etc10 >= 32'd1005)
				etc10 <= 11'd0;
		end
		endcase
		
		case(S11)
		start:
		begin
			xPosRock11 <= 11'd260;
			yPosRock11 <= 11'd360;
		end
		SA:
		begin
			xPosRock11 <= 11'd260;
			yPosRock11 <= 11'd360;
		end
		rock1_move_45:
		begin
			yPosRock11 <= yPosRock11 - 11'd1;
			xPosRock11 <= xPosRock11 + 11'd1;
		end
		rock1_move_135:
		begin
			yPosRock11 <= yPosRock11 - 11'd1;
			xPosRock11 <= xPosRock11 - 11'd1;
			if (etc11 >= 32'd1005)
				etc11 <= 11'd0;
		end
		rock1_move_315:
		begin
			yPosRock11 <= yPosRock11 + 11'd1;
			xPosRock11 <= xPosRock11 + 11'd1;
		end
		rock1_move_225:
		begin
			yPosRock11 <= yPosRock11 + 11'd1;
			xPosRock11 <= xPosRock11 - 11'd1;
		if (etc11>= 32'd1005)
				etc11 <= 11'd0;
		end
		rock1_shot:
		begin
			xPosRock11 <= 11'd700;
			yPosRock11 <= 11'd400;
			if (update == 1'b1)
				etc11 <= etc11 + 11'd1;
			else
				etc11 <= etc11;
		end
		IDKWhatTocallThis:
		begin
			xPosRock11 <= 11'd599;
			if (update == 1'b1)
				etc11 <= etc11 + 11'd1;
			else
				etc11 <= etc11;
				if (etc11 >= 32'd1005)
				etc11 <= 11'd0;
		end
		endcase
		
		case(S12)
		start:
		begin
			xPosRock12 <= 11'd260;
			yPosRock12 <= 11'd360;
		end
		SA:
		begin
			xPosRock12 <= 11'd260;
			yPosRock12 <= 11'd360;
		end
		rock1_move_45:
		begin
			yPosRock12 <= yPosRock12 - 11'd1;
			xPosRock12 <= xPosRock12 + 11'd1;
		end
		rock1_move_135:
		begin
			yPosRock12 <= yPosRock12 - 11'd1;
			xPosRock12 <= xPosRock12 - 11'd1;
			if (etc12 >= 32'd1005)
				etc12 <= 11'd0;
		end
		rock1_move_315:
		begin
			yPosRock12 <= yPosRock12 + 11'd1;
			xPosRock12 <= xPosRock12 + 11'd1;
		end
		rock1_move_225:
		begin
			yPosRock12 <= yPosRock12 + 11'd1;
			xPosRock12 <= xPosRock12 - 11'd1;
		if (etc12>= 32'd1005)
				etc12 <= 11'd0;
		end
		rock1_shot:
		begin
			xPosRock12 <= 11'd700;
			yPosRock12 <= 11'd400;
			if (update == 1'b1)
				etc12 <= etc12 + 11'd1;
			else
				etc12 <= etc12;
		end
		IDKWhatTocallThis:
		begin
			xPosRock12 <= 11'd599;
			if (update == 1'b1)
				etc12 <= etc12 + 11'd1;
			else
				etc12 <= etc12;
				if (etc12 >= 32'd1005)
				etc12 <= 11'd0;
		end
		endcase
		
		case(S13)
		start:
		begin
			xPosRock13 <= 11'd260;
			yPosRock13 <= 11'd360;
		end
		SA:
		begin
			xPosRock13 <= 11'd260;
			yPosRock13 <= 11'd360;
		end
		rock1_move_45:
		begin
			yPosRock13 <= yPosRock13 - 11'd1;
			xPosRock13 <= xPosRock13 + 11'd1;
		end
		rock1_move_135:
		begin
			yPosRock13 <= yPosRock13 - 11'd1;
			xPosRock13 <= xPosRock13 - 11'd1;
			if (etc13 >= 32'd1005)
				etc13 <= 11'd0;
		end
		rock1_move_315:
		begin
			yPosRock13 <= yPosRock13 + 11'd1;
			xPosRock13 <= xPosRock13 + 11'd1;
		end
		rock1_move_225:
		begin
			yPosRock13 <= yPosRock13 + 11'd1;
			xPosRock13 <= xPosRock13 - 11'd1;
		if (etc13>= 32'd1005)
				etc13 <= 11'd0;
		end
		rock1_shot:
		begin
			xPosRock13 <= 11'd700;
			yPosRock13 <= 11'd400;
			if (update == 1'b1)
				etc13 <= etc13 + 11'd1;
			else
				etc13 <= etc13;
		end
		IDKWhatTocallThis:
		begin
			xPosRock13 <= 11'd599;
			if (update == 1'b1)
				etc13 <= etc13 + 11'd1;
			else
				etc13 <= etc13;
				if (etc13 >= 32'd1005)
				etc13 <= 11'd0;
		end
		endcase
		
	end	
end

always @(posedge UPD or negedge rst)
begin
	if (rst == 1'd0) //FSM for motion. 
	begin	//Starting position. Change it to mix things up
		xPos <= 11'd40; 
		yPos <= 11'd240;
	end
	else
	begin
		case(direction) //case based on which buttons are pushed
			3'b100: //Don't move
			begin
				if (x_wout == 11'd177 && y_wout == 11'd245 && xPos < 11'd640)
				begin
					xPos <= xPos + 11'd1; 
				end
				else if (xPos >= 11'd640)
				begin
						xPos = 11'd700;
						yPos = 11'd495;
						end
				else
				begin
					xPos <= xPos;
				end
			end
			3'b000: //left (A)
			begin
				if(hitShipA2r == 1'd1 || hitShipA1r == 1'd1 || hitShipA3r == 1'd1 || hitShipA4r == 1'd1 || hitShipA5r == 1'd1 || hitShipA6r == 1'd1 || hitShipA7r == 1'd1 || hitShipA8r == 1'd1 || hitShipA9r == 1'd1 || hitShipA10r == 1'd1 || hitShipA11r == 1'd1 || hitShipA12r == 1'd1 || hitShipA13r == 1'd1)
					xPos <= xPos;
				else if(hit_ship_hr == 1'd1)
					xPos <= 11'd121;
				else if(hit_ship_ler == 1'd1)
					xPos <= 11'd61;
				else if (xPos <= 11'd26) //screen wrapping conditional
					xPos = 11'd580;
				else if(xPos > 11'd25) // prevents teleportation
					xPos <= xPos - 11'd2; //Mvmt spd. to the left. Higher val = higher movement, although I wouldn't advise it. The ship is already pretty quick. Danger mode is when you set each speed value differently.
				else
					xPos <= 11'd25;
			end
			3'b001: //right (D)
			begin
				if(xPos < 11'd590) // Warp drives don't exist yet. This is so the ship doesn't instantly jump across the map
					xPos <= xPos + 11'd2; //Mvmt spd. to the right. Higher val = higher movement, although I wouldn't advise it.
				else if (xPos >= 11'd580) //Screen wrapping conditional
					xPos = 11'd25;
				else if(hitShipA2l == 1'd1 || hitShipA1l == 1'd1 || hitShipA3l == 1'd1 || hitShipA4l == 1'd1 || hitShipA5l == 1'd1 || hitShipA6l == 1'd1 || hitShipA7l == 1'd1 || hitShipA8l == 1'd1 || hitShipA9l == 1'd1 || hitShipA10l == 1'd1 || hitShipA11l == 1'd1 || hitShipA12l == 1'd1 || hitShipA13l == 1'd1)
					xPos <= xPos;
				else
					xPos <= 11'd590;
			end
			3'b010: //Up (W)
			begin
				if(yPos > 11'd25) // You're not Han Solo. You can't make the Kessel Run in 12 parsecs. This is so the ship doesn't instantly jump across the map
					yPos <= yPos - 11'd2; //Mvmt spd. up. Higher val = higher movement, although I wouldn't advise it.
					else if (yPos <= 11'd26) //screen wrapping conditional
					yPos = 11'd434;
				else if(hitShipA2b == 1'd1 || hitShipA1b == 1'd1 || hitShipA3b == 1'd1 || hitShipA4b == 1'd1 || hitShipA5b == 1'd1 || hitShipA6b == 1'd1 || hitShipA7b == 1'd1 || hitShipA8b == 1'd1 || hitShipA9b == 1'd1 || hitShipA10b == 1'd1 || hitShipA11b == 1'd1 || hitShipA12b == 1'd1 || hitShipA13b == 1'd1)
					yPos <= yPos;
				else
					yPos <= 11'd25;
			end
			3'b011: //Down (S)
			begin
				if(hitShipA2t == 1'd1 || hitShipA1t == 1'd1 || hitShipA3t == 1'd1 || hitShipA4t == 1'd1 || hitShipA5t == 1'd1 || hitShipA6t == 1'd1 || hitShipA7t == 1'd1 || hitShipA8t == 1'd1 || hitShipA9t == 1'd1 || hitShipA10t == 1'd1 || hitShipA11t == 1'd1 || hitShipA12t == 1'd1 || hitShipA13t == 1'd1)
					yPos <= yPos;
				else if(hit_ship_ht == 1'd1)
					yPos <= 11'd370;
				else if(hit_ship_let == 1'd1)
					yPos <= 11'd330;
				else if (yPos >= 11'd434) //screen wrapping conditional
					yPos = 11'd0;
				else if(yPos < 11'd435) // "I am speed." Not in my game you aren't. This is so the ship doesn't instantly jump across the map
					yPos <= yPos + 11'd2; //Mvmt spd. downwards. Higher val = higher movement, although I wouldn't advise it.
				else
					yPos <= 11'd435;
			end
			default: 
				begin
				xPos <= xPos;
				yPos <= yPos;
				end
		endcase
	end
end

	always @(posedge VGA_clk) //colors. To this day, I still don't understand it fully.
begin 
	
	VGA_R = {8{R}};
	VGA_G = {8{G}};
	VGA_B = {8{B}};
end 

assign R = 1'b1 && screen_border && ~rock1 && ~rock2 && ~rock3 && ~rock4 && ~rock5 && ~rock6 && ~rock7 && ~rock8 && ~rock9 && ~rock10 && ~rock11 && ~rock12 && ~rock13 && ~body && ~wing && ~wing2 && ~cockpit && ~shipBody
				&& ~gin && ~onswitch && ~gin2 && ~ain2 && ~ain && ~min2 && ~min && ~e2in2 && ~e2in1 && ~ein2 && ~ein && ~nin2 && ~nin && ~oin && ~shipBody
				&& ~leaves && ~deaded && ~vin2 && ~vin && ~rin3 && ~rin2 && ~rin && ~LeftSideOfOnSw && ~RightSideOfOnSw && ~bot1b && ~bot2b && ~top2b && ~iout && ~iin && ~iin2 && ~wout  
				&& ~health1 && ~outb && ~leftb && ~middleb && ~rightb && ~outrb && ~topb && ~midb && ~botb && ~health2 && ~health3 && ~health4 && ~health5 && ~health6 && ~health7 && ~health8 && ~health9 && ~health10;
assign B = 1'b1 && screen_border  && ~rock1 && ~rock2 && ~rock3 && ~rock4 && ~rock5 && ~rock6 && ~rock7 && ~rock8 && ~rock9 && ~rock10 && ~rock11 && ~rock12 && ~rock13 && ~laser 
				&& ~onswitch && ~gin && ~gin2 && ~ain2 && ~ain && ~min2 && ~min && ~e2in2 && ~e2in1 && ~ein2 && ~ein && ~vin2 && ~vin && ~nin && ~nin2 && ~oin && ~iin && ~iin2 && ~return1 && ~return2 && ~return3
				&& ~rin3 && ~rin2 && ~rin && ~topb && ~midb && ~botb  && ~LeftSideOfOnSw && ~RightSideOfOnSw && ~bot1b && ~bot2b && ~top2b /*&& ~goodbye */&& ~startScreen
				&& ~health1 && ~outb && ~leftb && ~middleb && ~rightb && ~outrb && ~health2 && ~health3 && ~health4 && ~health5 && ~health6 && ~health7 && ~health8 && ~health9 && ~health10;
assign G = 1'b1 && screen_border && ~body && ~laser && ~startScreen && ~vin2 && ~vin 
				&&  ~onswitch && ~gin && ~gin2 && ~ain2 && ~ain && ~min2 && ~min && ~ein2 && ~ein && ~bot1b && ~bot2b && ~top2b
				&& ~rin3 && ~rin2 && ~rin && ~topb && ~midb && ~botb && ~outb && ~leftb && ~middleb && ~rightb && ~outrb && ~LeftSideOfOnSw && ~RightSideOfOnSw && ~iout && ~wing && ~wing2
				&& ~e2in2 && ~e2in1 && ~nin2 && ~nin && ~oin && ~iin && ~iin2 && ~rock1 && ~rock2 && ~rock3 && ~rock4 && ~rock5 && ~rock6 && ~rock7 && ~rock8 && ~rock9 && ~rock10 && ~rock11 && ~rock12 && ~rock13;

	
endmodule
