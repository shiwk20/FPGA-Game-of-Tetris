module top (
    input CLK_50M,
    input LeftKey,
    input RightKey,
    input RotateKey,
    input DropKey,
    input ResetKey,
    input StartKey,
    input PauseKey,
	input ContinueKey,
    // input IRDA_RXD,
    
    output VGA_CLK,
    output VGA_BLANK,
    output VGA_SYNC,
    output VGA_HS,
    output VGA_VS,
    output [7:0] VGA_R,
    output [7:0] VGA_G,
    output [7:0] VGA_B
);

wire CLK_25M;
wire CLK_Drop;

wire IsCur;
wire [2:0] cur_type;
wire Update;
wire Over;
wire [31:0] Level;
wire [2:0] IsMap;
wire IsLinesNum;
wire IsScoreNum;
wire IsMaxNum;
wire IsNumNum;
wire IsLevelNum;
wire IsReset;
wire IsStart;
wire IsPause;
wire IsEnd;

wire IsNext;
wire [2:0] next_type;

wire [2:0] IsTitle;
wire IsWall;
wire IsLines;
wire IsState;
wire IsScore;
wire IsMax;
wire IsNum;
wire IsLevel;
wire IsOver;

wire [23:0] color_RGB;

wire [9:0] X;
wire [9:0] Y;

wire key_left;
wire key_right;
wire key_rotate;
wire key_drop;
wire key_reset;
wire key_start;
wire key_pause;
wire key_continue;


div div (
    .CLK_50M       (CLK_50M),
    .Level         (Level),

    .CLK_25M       (CLK_25M),
    .CLK_Drop         (CLK_Drop)
);

map map(
    .CLK_25M       (CLK_25M),
    .CLK_Drop         (CLK_Drop),
    .next_type     (next_type),
    .X             (X),
    .Y             (Y),
    .key_left      (key_left),
    .key_right     (key_right),
    .key_rotate    (key_rotate),
    .key_drop      (key_drop),
    .key_reset     (key_reset),
    .key_start     (key_start),
    .key_pause     (key_pause),
	.key_continue  (key_continue),

    .IsCur         (IsCur),
    .cur_type      (cur_type),
    .Update        (Update),
    .Over          (Over),
    .Level          (Level),
    .IsMap         (IsMap),
    .IsLinesNum   (IsLinesNum),
    .IsScoreNum   (IsScoreNum),
    .IsMaxNum     (IsMaxNum),
    .IsNumNum     (IsNumNum),
    .IsLevelNum   (IsLevelNum),
    .IsReset     (IsReset),
    .IsStart    (IsStart),
    .IsPause    (IsPause),
    .IsEnd      (IsEnd)
);


next next(
	.CLK_25M        (CLK_25M),
	.Update         (Update),
    .X              (X),
    .Y              (Y),
    .key_reset      (key_reset),
	 .key_start      (key_start),
	
	.IsNext         (IsNext),
	.next_type      (next_type)
);

backgroud backgroud (
    .CLK_25M       (CLK_25M),
    .X             (X),
    .Y             (Y),

    .IsTitle       (IsTitle),
    .IsWall        (IsWall),
	.IsLines        (IsLines),
	.IsState        (IsState),
	.IsScore       (IsScore),
	.IsMax         (IsMax),
	.IsNum         (IsNum),
	.IsLevel       (IsLevel),
	.IsOver        (IsOver)
);

display display (
    .IsTitle       (IsTitle),
    .IsWall        (IsWall),
	.IsLines        (IsLines),
    .IsLinesNum    (IsLinesNum),
	.IsScore       (IsScore),
	.IsScoreNum    (IsScoreNum),
	.IsState       (IsState),
    .IsReset      (IsReset),
    .IsStart      (IsStart),
    .IsPause      (IsPause),
    .IsEnd        (IsEnd),
    .IsMax         (IsMax),
    .IsMaxNum      (IsMaxNum),
    .IsNum         (IsNum),
    .IsNumNum      (IsNumNum),
	.IsLevel       (IsLevel),
	.IsLevelNum    (IsLevelNum),
	.IsNext        (IsNext),
	.next_type     (next_type),
    .IsMap         (IsMap),
    .IsCur         (IsCur),
	.cur_type      (cur_type),
    .IsOver        (IsOver),
    .Over          (Over),

    .color_RGB     (color_RGB)
);

VGA VGA (
    .CLK_25M       (CLK_25M),
    .color_RGB     (color_RGB),
    
    .VGA_CLK       (VGA_CLK),
	.VGA_HS        (VGA_HS),
	.VGA_VS        (VGA_VS),
	.VGA_BLANK     (VGA_BLANK),
	.VGA_SYNC      (VGA_SYNC),
	.VGA_R         (VGA_R),
	.VGA_G         (VGA_G),
	.VGA_B         (VGA_B),
	.X             (X),
	.Y             (Y)
); 

key key(
    .CLK_25M       (CLK_25M),
    .LeftKey       (LeftKey),
    .RightKey      (RightKey),
    .RotateKey     (RotateKey),
    .DropKey       (DropKey),
    .ResetKey      (ResetKey),
    .StartKey      (StartKey),
    .PauseKey      (PauseKey),
	.ContinueKey   (ContinueKey),
	// .CLK_50M       (CLK_50M),
    // .IRDA_RXD      (IRDA_RXD),

    .key_left      (key_left),
    .key_right     (key_right),
    .key_rotate    (key_rotate),
    .key_drop      (key_drop),
    .key_reset     (key_reset),
    .key_start     (key_start),
    .key_pause     (key_pause),
	.key_continue  (key_continue)
);

endmodule