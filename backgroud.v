`include "global.v"
module backgroud(
    input CLK_25M,
    input [9:0] X,
    input [9:0] Y,


    output reg [2:0] IsTitle,
    output reg IsWall,
    output reg IsLines,
    output reg IsState,
    output reg IsScore,
    output reg IsMax,
    output reg IsNum,
    output reg IsLevel,
    output reg IsOver
);

//汉字-俄罗斯方块
localparam TetrisTitleLength = 9'd160;
localparam TetrisTitleWidth = 'd32;
//左上角的位置
localparam TetrisTitleX = 'd240;
localparam TetrisTitleY = 'd16;

reg [159:0] TetrisTitle [31:0];
initial begin
    TetrisTitle[0] = 160'h0000000000000000000000000000000000000000;
    TetrisTitle[1] = 160'h0000000000000000000000000000000000000000;
    TetrisTitle[2] = 160'h0000000000000000000800000000000000000000;
    TetrisTitle[3] = 160'h0000780000000F00000F0000000F000000000000;
    TetrisTitle[4] = 160'h00007C00001FFFC0038F0080000FC0000000F000;
    TetrisTitle[5] = 160'h01C07C0001FFFFE003CF01E00007C0000000F000;
    TetrisTitle[6] = 160'h01E03DE001FE73E003FF83E00003C0000780F000;
    TetrisTitle[7] = 160'h03E3BCE001CE73C003FF8FC00001800007C0F000;
    TetrisTitle[8] = 160'h03E7BC6001EEFFC00FFF3F0000001FE007C0F000;
    TetrisTitle[9] = 160'h03CFBC0001FFFF8003CF38000007FFF007C0F700;
    TetrisTitle[10] = 160'h07DF3FC001FFFF8003FF3C0000FFFFF003C0FF80;
    TetrisTitle[11] = 160'h0787BFE000FF800003FF3C087FFFFFF803EFFFC0;
    TetrisTitle[12] = 160'h0F07FFE00003C40003EF3FFC3FFF801803F7FFC0;
    TetrisTitle[13] = 160'h1F87FC000007FF0003AF3FFC1F8F80001FE0E780;
    TetrisTitle[14] = 160'h1F8FFCC0000FFF0001FF3FC00C0FF8001F81E780;
    TetrisTitle[15] = 160'h27BF9FE0003FFF0001EF3DE0001FFC000381EF00;
    TetrisTitle[16] = 160'h078FDFE0007C1E00018F39E0003FFE000391FFF0;
    TetrisTitle[17] = 160'h07878FC000FC3E0001FFB9E0003C7C0003E7FFF0;
    TetrisTitle[18] = 160'h078F8F80018F7C001FFFF9E0007C7C0003FFFBF0;
    TetrisTitle[19] = 160'h07FF8F000007F8007FC031E000F8780003CFF000;
    TetrisTitle[20] = 160'h07BFBF800002F8003E1C71E001F0F8000F83F800;
    TetrisTitle[21] = 160'h079787C00001F00001CE61E007C0F0001F03FE00;
    TetrisTitle[22] = 160'h078783E40007E00003CFE1E00F89F0003E07BF00;
    TetrisTitle[23] = 160'h079F83FC000FC0000786C1E01C0FE0003C0F9FC0;
    TetrisTitle[24] = 160'h079F81FC001F80000F0101C00007E000181F0FF0;
    TetrisTitle[25] = 160'h038F00FC007E0000000000C00007C000003C07FC;
    TetrisTitle[26] = 160'h0302007801F80000000000C00003800000F003F0;
    TetrisTitle[27] = 160'h0000001803800000000000800000000000000000;
    TetrisTitle[28] = 160'h0000000000000000000000000000000000000000;
    TetrisTitle[29] = 160'h0000000000000000000000000000000000000000;
    TetrisTitle[30] = 160'h0000000000000000000000000000000000000000;
    TetrisTitle[31] = 160'h0000000000000000000000000000000000000000;
end

reg[8:0] TetrisTitle_count;
always@(posedge CLK_25M) begin
    if(X == TetrisTitleX) TetrisTitle_count <= TetrisTitleLength;  
    else if(X > TetrisTitleX && X <= TetrisTitleX + TetrisTitleLength)     
        TetrisTitle_count <= TetrisTitle_count - 1'b1;       //倒着输出图像信息 
end
		
reg [159:0] TetrisTitle_tmp;
always@(posedge CLK_25M) begin
    IsTitle <= 3'b0;    
    if(X > TetrisTitleX && X <= TetrisTitleX + TetrisTitleLength
    && Y - TetrisTitleY >= 0 && Y - TetrisTitleY < TetrisTitleWidth) begin
			TetrisTitle_tmp <= TetrisTitle[Y - TetrisTitleY];
        if(TetrisTitle_tmp[TetrisTitle_count]) begin
				if((X > TetrisTitleX + TetrisTitleLength / 5 * 0) && 
				(X <= TetrisTitleX + TetrisTitleLength / 5 * 1)) IsTitle <= 3'd1;
				else if((X > TetrisTitleX + TetrisTitleLength / 5 * 1) && 
				(X <= TetrisTitleX + TetrisTitleLength / 5 * 2)) IsTitle <= 3'd2;
				else if((X > TetrisTitleX + TetrisTitleLength / 5 * 2) && 
				(X <= TetrisTitleX + TetrisTitleLength / 5 * 3)) IsTitle <= 3'd3;
				else if((X > TetrisTitleX + TetrisTitleLength / 5 * 3) && 
				(X <= TetrisTitleX + TetrisTitleLength / 5 * 4)) IsTitle <= 3'd4;
				else if((X > TetrisTitleX + TetrisTitleLength / 5 * 4) && 
				(X <= TetrisTitleX + TetrisTitleLength / 5 * 5)) IsTitle <= 3'd5;
		end
    end 
end

//俄罗斯方块四周的墙壁

always@(posedge CLK_25M) begin
    if(Y >= `WallY && Y < `WallY + `BLOCK_SIZEY	) begin
        if((X - `WallX) % `BLOCK_SIZEX	 == 0) 
            IsWall <= 1'b0;
        else if(X > `WallX && X < `WallX + (`GAME_LENGTH + `APPENDIX_LENGTH + 3) * `BLOCK_SIZEX	)
            IsWall <= 1'b1;
        else IsWall <= 1'b0;
    end
    else if(Y > `WallY + (`GAME_WIDTH + 1) * `BLOCK_SIZEY	 && Y <= `WallY + (`GAME_WIDTH + 2) * `BLOCK_SIZEY	) begin
        if((X - `WallX) % `BLOCK_SIZEX	 == 0) 
            IsWall <= 1'b0;
        else if(X > `WallX && X < `WallX + (`GAME_LENGTH + `APPENDIX_LENGTH + 3) * `BLOCK_SIZEX	)
            IsWall <= 1'b1;
        else IsWall <= 1'b0;
    end
    else if(Y > `WallY + `BLOCK_SIZEY	 && Y < `WallY + (`GAME_WIDTH + 1) * `BLOCK_SIZEY	) begin
        if((Y - `WallY) % `BLOCK_SIZEY	 == 0) 
            IsWall <= 1'b0;
        else if((X > `WallX && X < `WallX + `BLOCK_SIZEX	) || 
        (X > `WallX + (`GAME_LENGTH + 1) * `BLOCK_SIZEX	 && X < `WallX + (`GAME_LENGTH + 2) * `BLOCK_SIZEX	) ||
        (X > `WallX + (`GAME_LENGTH + `APPENDIX_LENGTH + 2) * `BLOCK_SIZEX	 && X < `WallX + (`GAME_LENGTH + `APPENDIX_LENGTH + 3) * `BLOCK_SIZEX	))
            IsWall <= 1'b1;
        else IsWall <= 1'b0;
		  
		  if(Y >= `WallY + 2 * `BLOCK_SIZEY && Y <= `WallY + 6 * `BLOCK_SIZEY) begin
				if(X >= `WallX + (`GAME_LENGTH + 3) * `BLOCK_SIZEX && X <= `WallX + (`GAME_LENGTH + 7) * `BLOCK_SIZEX) 
					if(((Y - `WallY) % `BLOCK_SIZEY == 0) || ((X - `WallX) % `BLOCK_SIZEX == 0))
						IsWall <= 1'b0;
			    else IsWall <= 1'b1;
		  end	
    end
    else IsWall <= 1'b0;
end

//单词Lines
localparam LinesLength = 7'd80;
localparam LinesWidth = 'd32;
//左上角的位置
localparam LinesX = `WallX + (2 * `GAME_LENGTH + 5) * `BLOCK_SIZEX / 2;
localparam LinesY = `WallY + 7 * `BLOCK_SIZEY;

reg [79:0] Lines [31:0];
initial begin
    Lines[0] = 80'h00000000000000000000;
    Lines[1] = 80'h00000000000000000000;
    Lines[2] = 80'h00000000000000000000;
    Lines[3] = 80'h00000000000000000000;
    Lines[4] = 80'h00000000000000000000;
    Lines[5] = 80'h03F8001E000000000000;
    Lines[6] = 80'h00C0001E000000000000;
    Lines[7] = 80'h01C0001C000000000000;
    Lines[8] = 80'h01C00000000000000000;
    Lines[9] = 80'h01800000000000000000;
    Lines[10] = 80'h03800000000000000000;
    Lines[11] = 80'h03800030000000000000;
    Lines[12] = 80'h030003F00FFE00FC01FE;
    Lines[13] = 80'h07000070078E038E0306;
    Lines[14] = 80'h07000060070E07060606;
    Lines[15] = 80'h060000E0060E0E0E0600;
    Lines[16] = 80'h0E0000E00E0C0C0E0700;
    Lines[17] = 80'h0E0000C00C0C1FFE03E0;
    Lines[18] = 80'h0E0001C00C1C1C0000F0;
    Lines[19] = 80'h1C0001C01C1818000038;
    Lines[20] = 80'h1C060180181838000018;
    Lines[21] = 80'h1C0C0380183838183018;
    Lines[22] = 80'h38180380383018303830;
    Lines[23] = 80'h3838030038701C603C60;
    Lines[24] = 80'hFFF03FE0FCF807C007C0;
    Lines[25] = 80'h00000000000000000000;
    Lines[26] = 80'h00000000000000000000;
    Lines[27] = 80'h00000000000000000000;
    Lines[28] = 80'h00000000000000000000;
    Lines[29] = 80'h00000000000000000000;
    Lines[30] = 80'h00000000000000000000;
    Lines[31] = 80'h00000000000000000000;
end

reg[6:0] Lines_count;
always@(posedge CLK_25M) begin
    if(X == LinesX) Lines_count <= LinesLength;  
    else if(X > LinesX && X <= LinesX + LinesLength)     
        Lines_count <= Lines_count - 1'b1;      
end
		
reg [79:0] Lines_tmp;
always@(posedge CLK_25M) begin
    IsLines <= 1'b0;
    if(X > LinesX && X <= LinesX + LinesLength 
    && Y - LinesY >= 0 && Y - LinesY < LinesWidth) begin
		Lines_tmp <= Lines[Y - LinesY];
        if(Lines_tmp[Lines_count]) 
			IsLines <= 1'b1;
    end     
end

//单词State
localparam StateLength = 7'd80;
localparam StateWidth = 'd32;
//左上角的位置
localparam StateX = `WallX + (`GAME_LENGTH + `APPENDIX_LENGTH + 4) * `BLOCK_SIZEX;
localparam StateY = `WallY + 7 * `BLOCK_SIZEY;

reg [79:0] State [31:0];
initial begin
    State[0] = 80'h00000000000000000000;
    State[1] = 80'h00000000000000000000;
    State[2] = 80'h00000000000000000000;
    State[3] = 80'h00000000000000000000;
    State[4] = 80'h00FB0000000000000000;
    State[5] = 80'h018E0000000000000000;
    State[6] = 80'h070E0000000000000000;
    State[7] = 80'h060600C0000000C00000;
    State[8] = 80'h0C0600C0000000C00000;
    State[9] = 80'h0C0001C0000001C00000;
    State[10] = 80'h0E000380000003800000;
    State[11] = 80'h0F000FF007F00FF003F0;
    State[12] = 80'h078003801C3803800E38;
    State[13] = 80'h03E003001C3003001C18;
    State[14] = 80'h00F00700003007001838;
    State[15] = 80'h0070070007F007003838;
    State[16] = 80'h003006001C6006003FF8;
    State[17] = 80'h60300E0030600E007000;
    State[18] = 80'h60300E0060E00E007000;
    State[19] = 80'h60600C00E0E00C007000;
    State[20] = 80'hE0E00C60E1D80C607060;
    State[21] = 80'hF1C00FC0E7F00FC039C0;
    State[22] = 80'h1F0007003CE007001F00;
    State[23] = 80'h00000000000000000000;
    State[24] = 80'h00000000000000000000;
    State[25] = 80'h00000000000000000000;
    State[26] = 80'h00000000000000000000;
    State[27] = 80'h00000000000000000000;
    State[28] = 80'h00000000000000000000;
    State[29] = 80'h00000000000000000000;
    State[30] = 80'h00000000000000000000;
    State[31] = 80'h00000000000000000000;
end

reg[6:0] State_count;
always@(posedge CLK_25M) begin
    if(X == StateX) State_count <= StateLength;  
    else if(X > StateX && X <= StateX + StateLength)     
        State_count <= State_count - 1'b1;       //倒着输出图像信息 
end
		
reg [79:0] State_tmp;
always@(posedge CLK_25M) begin
    IsState <= 1'b0;
    if(X > StateX && X <= StateX + StateLength 
    && Y - StateY >= 0 && Y - StateY < StateWidth) begin
		State_tmp <= State[Y - StateY];
        if(State_tmp[State_count]) 
			IsState <= 1'b1;
    end     
end

//单词Score
localparam ScoreLength = 7'd80;
localparam ScoreWidth = 'd32;
//左上角的位置
localparam ScoreX = `WallX + (2 * `GAME_LENGTH + 5) * `BLOCK_SIZEX / 2;
localparam ScoreY = `WallY + 12 * `BLOCK_SIZEY;

reg [79:0] Score [31:0];
initial begin
    Score[0] = 80'h00000000000000000000;
    Score[1] = 80'h00000000000000000000;
    Score[2] = 80'h00000000000000000000;
    Score[3] = 80'h00000000000000000000;
    Score[4] = 80'h00000000000000000000;
    Score[5] = 80'h00FF0000000000000000;
    Score[6] = 80'h01870000000000000000;
    Score[7] = 80'h03030000000000000000;
    Score[8] = 80'h06030000000000000000;
    Score[9] = 80'h06030000000000000000;
    Score[10] = 80'h0E000000000000000000;
    Score[11] = 80'h0E000000000001800000;
    Score[12] = 80'h0F0001F803F81FBF007E;
    Score[13] = 80'h07C0071C061C036F01C7;
    Score[14] = 80'h03F00E1C0C0C07C60383;
    Score[15] = 80'h00F81C181C0C07800707;
    Score[16] = 80'h00381800380C07000607;
    Score[17] = 80'h00383800381C06000FFF;
    Score[18] = 80'h00183800701C0E000E00;
    Score[19] = 80'h6018300070180C000C00;
    Score[20] = 80'h6038700070380C001C00;
    Score[21] = 80'h6030703070301C001C0C;
    Score[22] = 80'h60603060706018000C18;
    Score[23] = 80'hF1C038C039C038000E30;
    Score[24] = 80'hDF000F801F00FF0003E0;
    Score[25] = 80'h00000000000000000000;
    Score[26] = 80'h00000000000000000000;
    Score[27] = 80'h00000000000000000000;
    Score[28] = 80'h00000000000000000000;
    Score[29] = 80'h00000000000000000000;
    Score[30] = 80'h00000000000000000000;
    Score[31] = 80'h00000000000000000000;
end

reg[6:0] Score_count;
always@(posedge CLK_25M) begin
    if(X == ScoreX) Score_count <= ScoreLength;  
    else if(X > ScoreX && X <= ScoreX + ScoreLength)     
        Score_count <= Score_count - 1'b1;       //倒着输出图像信息 
end
		
reg [79:0] Score_tmp;
always@(posedge CLK_25M) begin
    IsScore <= 1'b0;
    if(X > ScoreX && X <= ScoreX + ScoreLength 
    && Y - ScoreY >= 0 && Y - ScoreY < ScoreWidth) begin
		Score_tmp <= Score[Y - ScoreY];
        if(Score_tmp[Score_count]) 
			IsScore <= 1'b1;
    end     
end

//单词Max
localparam MaxLength = 7'd72;
localparam MaxWidth = 'd32;
//左上角的位置
localparam MaxX = `WallX + (4 * `GAME_LENGTH + 4 * `APPENDIX_LENGTH + 17) * `BLOCK_SIZEX / 4;
localparam MaxY = `WallY + 12 * `BLOCK_SIZEY;

reg [71:0] Max [31:0];
initial begin
    Max[0] = 72'h000000000000000000;
    Max[1] = 72'h000000000000000000;
    Max[2] = 72'h000000000000000000;
    Max[3] = 72'h000000000000000000;
    Max[4] = 72'h000000000000000000;
    Max[5] = 72'h000000000000000000;
    Max[6] = 72'h00F81F000000000000;
    Max[7] = 72'h00703C000000000000;
    Max[8] = 72'h00703C000000000000;
    Max[9] = 72'h00F078000000000000;
    Max[10] = 72'h00F078000000000000;
    Max[11] = 72'h00F0F8000000000000;
    Max[12] = 72'h01F1F0000000000000;
    Max[13] = 72'h01F1F0003F8001FBF0;
    Max[14] = 72'h01F37000E1C000F0C0;
    Max[15] = 72'h0363E00181C0007180;
    Max[16] = 72'h03E6E00381C0007300;
    Max[17] = 72'h03E6E00301C0007600;
    Max[18] = 72'h06EDC0000780007C00;
    Max[19] = 72'h06F9C000FF80003800;
    Max[20] = 72'h06F9C0038380003800;
    Max[21] = 72'h0CF3800E0700007800;
    Max[22] = 72'h0CF3801C070000DC00;
    Max[23] = 72'h0CE3801C0700019C00;
    Max[24] = 72'h19E700380E00031C00;
    Max[25] = 72'h19C700381EC0061C00;
    Max[26] = 72'h39CF003C7F800C1E00;
    Max[27] = 72'h7DBF801FCF007E7F00;
    Max[28] = 72'h000000000000000000;
    Max[29] = 72'h000000000000000000;
    Max[30] = 72'h000000000000000000;
    Max[31] = 72'h000000000000000000;
end

reg[6:0] Max_count;
always@(posedge CLK_25M) begin
    if(X == MaxX) Max_count <= MaxLength;  
    else if(X > MaxX && X <= MaxX + MaxLength)     
        Max_count <= Max_count - 1'b1;       //倒着输出图像信息 
end
		
reg [71:0] Max_tmp;
always@(posedge CLK_25M) begin
    IsMax <= 1'b0;
    if(X > MaxX && X <= MaxX + MaxLength 
    && Y - MaxY >= 0 && Y - MaxY < MaxWidth) begin
		Max_tmp <= Max[Y - MaxY];
        if(Max_tmp[Max_count]) 
			IsMax <= 1'b1;
    end     
end

//单词Num
localparam NumLength = 7'd72;
localparam NumWidth = 'd32;
//左上角的位置
localparam NumX = `WallX + (4 * `GAME_LENGTH + 11) * `BLOCK_SIZEX / 4;
localparam NumY = `WallY + 17 * `BLOCK_SIZEY;

reg [71:0] Num [31:0];
initial begin
    Num[0] = 72'h000000000000000000;
    Num[1] = 72'h000000000000000000;
    Num[2] = 72'h000000000000000000;
    Num[3] = 72'h000000000000000000;
    Num[4] = 72'h000000000000000000;
    Num[5] = 72'h000000000000000000;
    Num[6] = 72'h00F83F000000000000;
    Num[7] = 72'h00781C000000000000;
    Num[8] = 72'h007818000000000000;
    Num[9] = 72'h007C18000000000000;
    Num[10] =72'h00FC30000000000000;
    Num[11] =72'h00DC30000000000000;
    Num[12] =72'h00DC30006060000000;
    Num[13] =72'h019C6007C7C003DFF0;
    Num[14] =72'h019C6001C1C001FF70;
    Num[15] =72'h019C6001C1C001CE70;
    Num[16] =72'h031EC0038380039CE0;
    Num[17] =72'h031EC0038380039CE0;
    Num[18] =72'h030EC0038380039CE0;
    Num[19] =72'h060F800707000739C0;
    Num[20] =72'h060F800707000739C0;
    Num[21] =72'h060F800707000739C0;
    Num[22] =72'h0C0F000E0E000E7380;
    Num[23] =72'h0C0F000E0E000E7380;
    Num[24] =72'h0C0F000E1E000E7380;
    Num[25] =72'h1C06000E3F001EF780;
    Num[26] =72'h7E060007F8003FFF80;
    Num[27] =72'h000000000000000000;
    Num[28] =72'h000000000000000000;
    Num[29] =72'h000000000000000000;
    Num[30] =72'h000000000000000000;
    Num[31] =72'h000000000000000000;
end

reg[6:0] Num_count;
always@(posedge CLK_25M) begin
    if(X == NumX) Num_count <= NumLength;  
    else if(X > NumX && X <= NumX + NumLength)     
        Num_count <= Num_count - 1'b1;       //倒着输出图像信息 
end
		
reg [71:0] Num_tmp;
always@(posedge CLK_25M) begin
    IsNum <= 1'b0;
    if(X > NumX && X <= NumX + NumLength 
    && Y - NumY >= 0 && Y - NumY < NumWidth) begin
		Num_tmp <= Num[Y - NumY];
        if(Num_tmp[Num_count]) 
			IsNum <= 1'b1;
    end     
end


//单词Level
localparam LevelLength = 7'd80;
localparam LevelWidth = 'd32;
//左上角的位置
localparam LevelX = `WallX + (`GAME_LENGTH + `APPENDIX_LENGTH + 4) * `BLOCK_SIZEX;
localparam LevelY = `WallY + 17 * `BLOCK_SIZEY;

reg [79:0] Level [31:0];
initial begin
    Level[0] = 80'h00000000000000000000;
    Level[1] = 80'h00000000000000000000;
    Level[2] = 80'h00000000000000000000;
    Level[3] = 80'h00000000000000000000;
    Level[4] = 80'h00000000000000000006;
    Level[5] = 80'h03F800000000000000FC;
    Level[6] = 80'h00C0000000000000001C;
    Level[7] = 80'h01C0000000000000001C;
    Level[8] = 80'h01C00000000000000018;
    Level[9] = 80'h01800000000000000038;
    Level[10] = 80'h03800000000000000038;
    Level[11] = 80'h03800000000000000030;
    Level[12] = 80'h030000FC0FCF00FC0070;
    Level[13] = 80'h0700038E0706038E0070;
    Level[14] = 80'h07000706070C07060060;
    Level[15] = 80'h06000E0E070C0E0E00E0;
    Level[16] = 80'h0E000C0E03180C0E00E0;
    Level[17] = 80'h0E001FFE03301FFE00C0;
    Level[18] = 80'h0E001C0003301C0001C0;
    Level[19] = 80'h1C0018000360180001C0;
    Level[20] = 80'h1C06380003C038000180;
    Level[21] = 80'h1C0C3818038038180380;
    Level[22] = 80'h38181830038018300380;
    Level[23] = 80'h38381C6003001C600300;
    Level[24] = 80'hFFF007C0000007C03FE0;
    Level[25] = 80'h00000000000000000000;
    Level[26] = 80'h00000000000000000000;
    Level[27] = 80'h00000000000000000000;
    Level[28] = 80'h00000000000000000000;
    Level[29] = 80'h00000000000000000000;
    Level[30] = 80'h00000000000000000000;
    Level[31] = 80'h00000000000000000000;
end

reg[6:0] Level_count;
always@(posedge CLK_25M) begin
    if(X == LevelX) Level_count <= LevelLength;  
    else if(X > LevelX && X <= LevelX + LevelLength)     
        Level_count <= Level_count - 1'b1;       //倒着输出图像信息 
end
		
reg [79:0] Level_tmp;
always@(posedge CLK_25M) begin
    IsLevel <= 1'b0;
    if(X > LevelX && X <= LevelX + LevelLength 
    && Y - LevelY >= 0 && Y - LevelY < LevelWidth) begin
		Level_tmp <= Level[Y - LevelY];
        if(Level_tmp[Level_count]) 
			IsLevel <= 1'b1;
    end     
end

//单词GAME OVER
localparam OverLength = 9'd288;
localparam OverWidth = 'd64;
//左上角的位置
localparam OverX = 8'd176;
localparam OverY = 8'd208;

reg [287:0] Over [63:0];
initial begin
    Over[0] = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
    Over[1] = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
    Over[2] = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
    Over[3] = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
    Over[4] = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
    Over[5] = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
    Over[6] = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
    Over[7] = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
    Over[8] = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
    Over[9] = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
    Over[10] = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
    Over[11] = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
    Over[12] = 288'h1FFFFFC00FFFFFC0FFFE1FF8FFFFFFC0000000000FFFFF80FFFE1FFCFFFFFFC0FFFFFFC0;
    Over[13] = 288'h1FFFFFC00FFFFFC0FFFE1FF8FFFFFFC0000000000FFFFF80FFFE1FFCFFFFFFC0FFFFFFC0;
    Over[14] = 288'h1FFFFFC00FFFFFC0FFFE1FF8FFFFFFC0000000000FFFFF80FFFE1FFCFFFFFFC0FFFFFFC0;
    Over[15] = 288'hFFFFFFF80FFFFFC0FFFFFFF8FFFFFFC000000000FFFFFFF8FFFE1FFCFFFFFFC0FFFFFFF8;
    Over[16] = 288'hFFFFFFF80F0003C0F01FFC78F00003C000000000FE0003F8F01E1C7CF00003C0F00003F8;
    Over[17] = 288'hFF0003F80F0003C0F01FFC78F00003C000000000FE0003F8F01E1C7CF00003C0F00003F8;
    Over[18] = 288'hFF0003F80F0003C0F01FFC78F00003C000000000FE0003F8F01E1C78F00003C0F00003F8;
    Over[19] = 288'hFF0003F80F0003C0F01FFC78F00003C000000000FE0003F8F01E1C78F00003C0F00003F8;
    Over[20] = 288'hFFFFFFF8FFFFFFFCFFFFFFF8FFFFFFC000000000FFFFFFF8FFFE1FF8FFFFFFC0FFFFFFF8;
    Over[21] = 288'hFFFFFFF8F01FFC3CF001E078F01FFFC000000000F01FFC78F01E1C78F01FFFC0F01FFC38;
    Over[22] = 288'hF01FFC78F01FFC3CF001E078F01FFFC000000000F01FFC78F01E1C78F01FFFC0F01FFC38;
    Over[23] = 288'hF01FFC78F01FFC3CF001E078F01FFFC000000000F01FFC78F01E1C78F01FFFC0F01FFC38;
    Over[24] = 288'hFFFFFFF8F01FFC3CF001E078F01FFFC000000000F01FFC78F01E1C78F01FFFC0F01FFC38;
    Over[25] = 288'hFFFFFFF8FFFFFFFCFFFFFFF8FFFFFFC000000000FFFFFFF8FFFE1FF8FFFFFFC0FFFFFFF8;
    Over[26] = 288'hF01FFFF8F01FFC3CF01E1C78F0003C0000000000F01FFC78F01E1C78F0003C00F01FFC38;
    Over[27] = 288'hF01FFFF8F01FFC3CF01E1C78F0003C0000000000F01FFC78F01E1C78F0003C00F01FFC38;
    Over[28] = 288'hF01FFFF8F01FFC3CF01E1C78F0003C0000000000F01FFC78F01E1C78F0003C00F01FFC38;
    Over[29] = 288'hFFFFFFF8FFFFFFFCFFFFFFF8FFFFFC0000000000FFFFFFF8FFFE1FF8FFFFFC00F01FFC38;
    Over[30] = 288'hF01E0078F01FFC3CF01FFC78F01FFC0000000000F01FFC78F01FFC78F01FFC00FFFFFFF8;
    Over[31] = 288'hF01E0078F05FFC3CF01FFC78F01FFC0000000000F01FFC78F01FFC78F01FFC00F00003F8;
    Over[32] = 288'hF01E0078F01FFC3CF01FFC78F01FFC0000000000F01FFC78F01FFC78F01FFC00F00003F8;
    Over[33] = 288'hF01E0078FFFFFFFCF01FFC78F01FFC0000000000F01FFC78F01FFC78F01FFC00F00003F8;
    Over[34] = 288'hFFFFFFF8F000003CFFFFFFF8FFFFFFC000000000FFFFFFF8FFFFFFF8FFFFFFC0FFFFFFF8;
    Over[35] = 288'hF01FFC78F000003CF01E1C78F01FFFC000000000F01FFC78FE01E3F8F01FFFC0F01FC3F8;
    Over[36] = 288'hF01FFC78F000003CF01E1C78F01FFFC000000000F01FFC78FE01E3F8F01FFFC0F01FC3F8;
    Over[37] = 288'hF01FFC78F000003CF01E1C78F01FFFC000000000F01FFC78FE01E3F8F01FFFC0F01FC3F8;
    Over[38] = 288'hFFFFFFF8FFFFFFFCFFFE1FF8FFFFFFC000000000FFFFFFF8FE01E3F8FFFFFFC0FFFFFFF8;
    Over[39] = 288'hFFFFFFF8F01FFC3CFFFE1FF8FFFFFFC000000000FFFFFFF8FFFFFFF8FFFFFFC0FFFFFFF8;
    Over[40] = 288'hFF0003F8F01FFC3CF01E1C78F00003C000000000FE0003F80FE01F80F00003C0F01FFC38;
    Over[41] = 288'hFF0003F8F01FFC3CF01E1C78F00003C000000000FE0003F80FE01F80F00003C0F01FFC38;
    Over[42] = 288'hFFFFFFF8F01FFC3CF01E1C78F00003C000000000FE0003F80FE01F80F00003C0F01FFC38;
    Over[43] = 288'hFFFFFFF8FFFFFFFCFFFE1FF8FFFFFFC000000000FFFFFFF80FFFFF80FFFFFFC0FFFFFFF8;
    Over[44] = 288'h1FFFFFC0FFFE1FFCFFFE1FF8FFFFFFC0000000000FFFFF8001FFFC00FFFFFFC0FFFC3FF8;
    Over[45] = 288'h1FFFFFC0FFFE1FFCFFFE1FF8FFFFFFC0000000000FFFFF8001FFFC00FFFFFFC0FFFC3FF8;
    Over[46] = 288'h1FFFFFC0FFFE1FFCFFFE1FF8FFFFFFC0000000000FFFFF8001FFFC00FFFFFFC0FFFC3FF8;
    Over[47] = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
    Over[48] = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
    Over[49] = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
    Over[50] = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
    Over[51] = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
    Over[52] = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
    Over[53] = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
    Over[54] = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
    Over[55] = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
    Over[56] = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
    Over[57] = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
    Over[58] = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
    Over[59] = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
    Over[60] = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
    Over[61] = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
    Over[62] = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
    Over[63] = 288'h000000000000000000000000000000000000000000000000000000000000000000000000;
end

reg[8:0] Over_count;
always@(posedge CLK_25M) begin
    if(X == OverX) Over_count <= OverLength;  
    else if(X > OverX && X <= OverX + OverLength)     
        Over_count <= Over_count - 1'b1;       //倒着输出图像信息 
end
		
reg [287:0] Over_tmp;
always@(posedge CLK_25M) begin
    IsOver <= 1'b0;
    if(X > OverX && X <= OverX + OverLength 
    && Y - OverY >= 0 && Y - OverY < OverWidth) begin
		Over_tmp <= Over[Y - OverY];
        if(Over_tmp[Over_count]) 
			IsOver <= 1'b1;
    end     
end

endmodule


