
`include "global.v"
module map(
    input CLK_25M,
    input CLK_Drop, 
    
    input [2:0] next_type,
    input [9:0] X,
    input [9:0] Y,
    input key_left,
    input key_right,
    input key_rotate,
    input key_drop,
    input key_reset,
    input key_start,
    input key_pause,
	 input key_continue,

    output reg IsCur,
    output reg [2:0] cur_type,
    output reg Update,
    output reg Over,
    output reg [31:0] Level,
    output reg [2:0] IsMap,
    output reg IsLinesNum,
    output reg IsScoreNum,
    output reg IsMaxNum,
    output reg IsNumNum,
    output reg IsLevelNum,
    output reg IsReset,
    output reg IsStart,
    output reg IsPause,
    output reg IsEnd
);

reg Initial;
reg Start;
initial begin
    Over = 1'b0;
    Start = 1'b0;
	 Initial = 1'b1;
    Update = 1'b0;
end

reg [3:0] cur_coordX[3:0];
reg [4:0] cur_coordY[3:0];
reg [1:0] rotation_type;
initial begin
    cur_coordX[0] = 4'd0;
    cur_coordX[1] = 4'd0;
    cur_coordX[2] = 4'd0;
    cur_coordX[3] = 4'd0;
    cur_coordY[0] = 5'd0;
    cur_coordY[1] = 5'd0;
    cur_coordY[2] = 5'd0;
    cur_coordY[3] = 5'd0;
end

//-1表示不打印
integer Lines;
integer LastLines;
integer Score;
integer Max;
integer LastScore;
integer Num;
integer LastNum;
reg [31:0] LastLevel;
initial begin
	 Lines = -1;
    LastLines = -1;
	 Score = -1;
	 Max = -1;
    LastScore = -1;
    Num = -1;
    LastNum = -1;
    Level = 0;
    LastLevel = 0;
end

//map的大小是21×10,注意这里为了方便采用了map[y][x]
//map[0]无意义，专门用来判断game over
integer i;
integer j;
reg [2:0] map [20:0] [9:0];
initial begin
    for(i = 20; i >= 0; i = i - 1) 
        for(j = 9; j >= 0; j = j - 1)
            map[i][j] = 3'd0;
end

integer k;
reg flag;
integer count;
always@(posedge CLK_25M) begin
    if(key_start == 1'b1 && Initial == 1'b1) begin
        Start = 1'b1;
		  Initial = 1'b0; 
        Lines = 0;
	     Score = 0;
	     Num = 1;
        Level = 1;
	 end
    if(key_pause == 1'b1 || Over == 1'b1) 
        Start = 1'b0;
	 if(key_continue == 1'b1 && Initial == 1'b0)
		  Start = 1'b1;
    if(key_reset == 1'b1) begin
        Over = 1'b0;
		  Initial = 1'b1;
        Start = 1'b0;
		
	     Lines = -1; 
	     Score = -1;
        Num = -1;
        Level = 0;
		  Update = 1'b0;
        cur_coordX[0] = 4'd0;
        cur_coordX[1] = 4'd0;
        cur_coordX[2] = 4'd0;
        cur_coordX[3] = 4'd0;
        cur_coordY[0] = 5'd0;
        cur_coordY[1] = 5'd0;
        cur_coordY[2] = 5'd0;
        cur_coordY[3] = 5'd0;

        for(i = 20; i >= 0; i = i - 1) 
            for(j = 9; j >= 0; j = j - 1)
                map[i][j] = 3'd0;
    end
    if((Update == 1'b1) || 
    (cur_coordX[0] == cur_coordX[1] && cur_coordY[0] == cur_coordY[1] && Start == 1'b1)) begin
        cur_type = next_type;
        rotation_type = 2'd0;
        //都把中心点放在第0个位置，方便旋转
        if(cur_type == `TYPE1) begin
            cur_coordX[0] = 4'd3;
            cur_coordX[1] = 4'd4;
            cur_coordX[2] = 4'd5;
            cur_coordX[3] = 4'd6;
            cur_coordY[0] = 5'd0;
            cur_coordY[1] = 5'd0;
            cur_coordY[2] = 5'd0;
            cur_coordY[3] = 5'd0;
        end
        else if(cur_type == `TYPE2) begin
            cur_coordX[0] = 4'd5;
            cur_coordX[1] = 4'd4;
            cur_coordX[2] = 4'd4;
            cur_coordX[3] = 4'd6;
            cur_coordY[0] = 5'd1;
            cur_coordY[1] = 5'd0;
            cur_coordY[2] = 5'd1;
            cur_coordY[3] = 5'd1;
        end
        else if(cur_type == `TYPE3) begin
            cur_coordX[0] = 4'd5;
            cur_coordX[1] = 4'd4;
            cur_coordX[2] = 4'd6;
            cur_coordX[3] = 4'd6;
            cur_coordY[0] = 5'd1;
            cur_coordY[1] = 5'd1;
            cur_coordY[2] = 5'd1;
            cur_coordY[3] = 5'd0;
        end
        else if(cur_type == `TYPE4) begin
            cur_coordX[0] = 4'd4;
            cur_coordX[1] = 4'd4;
            cur_coordX[2] = 4'd5;
            cur_coordX[3] = 4'd5;
            cur_coordY[0] = 5'd0;
            cur_coordY[1] = 5'd1;
            cur_coordY[2] = 5'd1;
            cur_coordY[3] = 5'd0;
        end
        else if(cur_type == `TYPE5) begin
            cur_coordX[0] = 4'd5;
            cur_coordX[1] = 4'd4;
            cur_coordX[2] = 4'd5;
            cur_coordX[3] = 4'd6;
            cur_coordY[0] = 5'd1;
            cur_coordY[1] = 5'd1;
            cur_coordY[2] = 5'd0;
            cur_coordY[3] = 5'd0;
        end
        else if(cur_type == `TYPE6) begin
            cur_coordX[0] = 4'd5;
            cur_coordX[1] = 4'd4;
            cur_coordX[2] = 4'd5;
            cur_coordX[3] = 4'd6;
            cur_coordY[0] = 5'd1;
            cur_coordY[1] = 5'd1;
            cur_coordY[2] = 5'd0;
            cur_coordY[3] = 5'd1;
        end
        else if(cur_type == `TYPE7) begin
            cur_coordX[0] = 4'd5;
            cur_coordX[1] = 4'd4;
            cur_coordX[2] = 4'd5;
            cur_coordX[3] = 4'd6;
            cur_coordY[0] = 5'd1;
            cur_coordY[1] = 5'd0;
            cur_coordY[2] = 5'd0;
            cur_coordY[3] = 5'd1;
        end
    end

	Update = 1'b0;
    if(Start == 1'b1) begin
        if(CLK_Drop == 1'b1 || key_drop == 1'b1) begin
            flag = 1'b1; // flag = 1'b0表示处在初始态
            for(i = 0; i < 4; i = i + 1) 
                if(cur_coordY[i] == 0) 
                    flag = 1'b0;

            for(i = 0; i < 4; i = i + 1) begin
                if(map[cur_coordY[i]][cur_coordX[i]] > 0) Over = 1'b1;
                else if(cur_coordY[i] == 5'd20) Update = 1'b1;
                else if(map[cur_coordY[i] + 1][cur_coordX[i]] > 0) begin
                    if(flag == 1'b0) Over = 1'b1;
                    else if(flag == 1'b1) Update = 1'b1;
                end
            end

            if(Over != 1'b1 && Update != 1'b1) begin
                cur_coordY[0] = cur_coordY[0] + 1;
                cur_coordY[1] = cur_coordY[1] + 1;
                cur_coordY[2] = cur_coordY[2] + 1;
                cur_coordY[3] = cur_coordY[3] + 1;
                for(i = 0; i < 4; i = i + 1) begin
                    if(cur_coordY[i] == 5'd20 || map[cur_coordY[i] + 1][cur_coordX[i]] > 3'd0) begin
                        Update = 1'b1;
                    end
                end
            end
        end

        else if(key_left == 1'b1 && cur_coordX[0] != 'd0 
        && map[cur_coordY[0]][cur_coordX[0] - 1] == 3'd0 
        && cur_coordX[1] != 'd0 && map[cur_coordY[1]][cur_coordX[1] - 1] == 3'd0 
        && cur_coordX[2] != 'd0 && map[cur_coordY[2]][cur_coordX[2] - 1] == 3'd0 
        && cur_coordX[3] != 'd0 && map[cur_coordY[3]][cur_coordX[3] - 1] == 3'd0) begin
            cur_coordX[0] = cur_coordX[0] - 1;
            cur_coordX[1] = cur_coordX[1] - 1;
            cur_coordX[2] = cur_coordX[2] - 1;
            cur_coordX[3] = cur_coordX[3] - 1;
        end

        else if(key_right == 1'b1 && cur_coordX[0] != 'd9 
        && map[cur_coordY[0]][cur_coordX[0] + 1] == 3'd0 
        && cur_coordX[1] != 'd9 && map[cur_coordY[1]][cur_coordX[1] + 1] == 3'd0 
        && cur_coordX[2] != 'd9 && map[cur_coordY[2]][cur_coordX[2] + 1] == 3'd0 
        && cur_coordX[3] != 'd9 && map[cur_coordY[3]][cur_coordX[3] + 1] == 3'd0) begin
            cur_coordX[0] = cur_coordX[0] + 1;
            cur_coordX[1] = cur_coordX[1] + 1;
            cur_coordX[2] = cur_coordX[2] + 1;
            cur_coordX[3] = cur_coordX[3] + 1;
        end

        else if(key_rotate == 1'b1) begin
            if(cur_type == `TYPE1) begin
                if(rotation_type == 2'd0) begin
                    flag = 1'b1;
                    if((cur_coordX[0] > 4'd6) || (cur_coordY[0] <= 5'd1) || (cur_coordY[0] > 5'd18)) 
                        flag = 1'b0;
                    for(i = 0; i <= 3; i = i + 1) begin
                        for(j = -1; j <= 2; j = j + 1) begin
                            if(map[cur_coordY[0] + j][cur_coordX[0] + i] > 3'd0) flag = 1'b0;
                        end
                    end
                    if(flag == 1'b1) begin
                        cur_coordX[0] = cur_coordX[0] + 2;
                        cur_coordX[1] = cur_coordX[1] + 1;
                        cur_coordX[2] = cur_coordX[2];
                        cur_coordX[3] = cur_coordX[3] - 1;

                        cur_coordY[0] = cur_coordY[0] - 1;
                        cur_coordY[1] = cur_coordY[1];
                        cur_coordY[2] = cur_coordY[2] + 1;
                        cur_coordY[3] = cur_coordY[3] + 2;

                        rotation_type = 2'd1;
                    end
                end
                else if(rotation_type == 2'd1) begin
                    flag = 1'b1;
                    if((cur_coordX[0] < 4'd2) || (cur_coordX[0] > 4'd8) || (cur_coordY[0] < 5'd1) || (cur_coordY[0] > 5'd17)) 
                        flag = 1'b0;
                    for(i = -2; i <= 1; i = i + 1)
                        for(j = 0; j <= 3; j = j + 1) 
                            if(map[cur_coordY[0] + j][cur_coordX[0] + i] > 3'd0) flag = 1'b0;
                    if(flag == 1'b1) begin
                        cur_coordX[0] = cur_coordX[0] - 2;
                        cur_coordX[1] = cur_coordX[1] - 1;
                        cur_coordX[2] = cur_coordX[2];
                        cur_coordX[3] = cur_coordX[3] + 1;

                        cur_coordY[0] = cur_coordY[0] + 2;
                        cur_coordY[1] = cur_coordY[1] + 1;
                        cur_coordY[2] = cur_coordY[2];
                        cur_coordY[3] = cur_coordY[3] - 1;
                        rotation_type = 2'd2;
                    end
                end
                else if(rotation_type == 2'd2) begin
                    flag = 1'b1;
                    if((cur_coordX[0] < 4'd0) || (cur_coordX[0] + 4'd3 > 4'd9) || (cur_coordY[0] - 5'd2 < 5'd1) || (cur_coordY[0] + 5'd1 > 5'd20)) 
                        flag = 1'b0;
                    for(i = 0; i <= 3; i = i + 1)
                        for(j = -2; j <= 1; j = j + 1) 
                            if(map[cur_coordY[0] + j][cur_coordX[0] + i] > 3'd0) flag = 1'b0;
                    if(flag == 1'b1) begin
                        cur_coordX[0] = cur_coordX[0] + 1;
                        cur_coordX[1] = cur_coordX[1];
                        cur_coordX[2] = cur_coordX[2] - 1;
                        cur_coordX[3] = cur_coordX[3] - 2;

                        cur_coordY[0] = cur_coordY[0] - 2;
                        cur_coordY[1] = cur_coordY[1] - 1;
                        cur_coordY[2] = cur_coordY[2];
                        cur_coordY[3] = cur_coordY[3] + 1;
                        rotation_type = 2'd3;
                    end
                end
                else if(rotation_type == 2'd3) begin
                    flag = 1'b1;
                    if((cur_coordX[0] < 4'd1) || (cur_coordX[0] > 4'd7) || (cur_coordY[0] < 5'd1) || (cur_coordY[0] > 5'd17)) 
                        flag = 1'b0;
                    for(i = -1; i <= 2; i = i + 1)
                        for(j = 0; j <= 3; j = j + 1) 
                            if(map[cur_coordY[0] + j][cur_coordX[0] + i] > 3'd0) flag = 1'b0;
                    if(flag == 1'b1) begin
                        cur_coordX[0] = cur_coordX[0] - 1;
                        cur_coordX[1] = cur_coordX[1];
                        cur_coordX[2] = cur_coordX[2] + 1;
                        cur_coordX[3] = cur_coordX[3] + 2;

                        cur_coordY[0] = cur_coordY[0] + 1;
                        cur_coordY[1] = cur_coordY[1];
                        cur_coordY[2] = cur_coordY[2] - 1;
                        cur_coordY[3] = cur_coordY[3] - 2;
                        rotation_type = 2'd0;
                    end
                end
            end
			if(cur_type == `TYPE4) begin
			end
            else if(cur_type >= `TYPE2 && cur_type <= `TYPE7) begin
                flag = 1'b1;
                if((cur_coordX[0] < 4'd1) || (cur_coordX[0] > 4'd8) || (cur_coordY[0] < 5'd2) || (cur_coordY[0] > 5'd19)) 
                    flag = 1'b0;
                for(i = -1; i <= 1; i = i + 1)
                    for(j = -1; j <= 1; j = j + 1) 
                        if(map[cur_coordY[0] + j][cur_coordX[0] + i] > 3'd0) flag = 1'b0;
                if(flag == 1'b1) begin
                    //注意第0个一定是中心点，旋转不会改变它的位置
                    for (i = 1; i < 4; i = i + 1) begin
				        integer x_offset;
				        integer y_offset;
                        x_offset = cur_coordX[i] - cur_coordX[0];
                        y_offset = cur_coordY[i] - cur_coordY[0];

                        cur_coordX[i] = cur_coordX[0] - y_offset;
                        cur_coordY[i] = cur_coordY[0] + x_offset;
                    end
                    rotation_type = (rotation_type + 1) % 4;
                end
            end
        end

        if(Update == 1'b1) begin //更新当前方块到map中
            Num = Num + 1;
            Level = (Num + 39) / 40; 
            if(Level > 32'd20) Level = 32'd20;
            map[cur_coordY[0]][cur_coordX[0]] = cur_type;
            map[cur_coordY[1]][cur_coordX[1]] = cur_type;
            map[cur_coordY[2]][cur_coordX[2]] = cur_type;
            map[cur_coordY[3]][cur_coordX[3]] = cur_type;
            //判断消除并计数
            count = 0;
            for (i = 1; i <= 20; i = i + 1) begin
                flag = 1'b1;
                for(j = 9; j >= 0; j = j - 1) begin
                    if(map[i][j] == 3'd0) begin
                        flag = 1'b0;
                    end
                end
                if(flag == 1'b1) begin
                    count = count + 1;
                    for(j = i; j > 0; j = j - 1) begin
						map[j][0] = map[j - 1][0];
						map[j][1] = map[j - 1][1];
						map[j][2] = map[j - 1][2];
						map[j][3] = map[j - 1][3];
						map[j][4] = map[j - 1][4];
						map[j][5] = map[j - 1][5];
						map[j][6] = map[j - 1][6];
						map[j][7] = map[j - 1][7];
						map[j][8] = map[j - 1][8];
						map[j][9] = map[j - 1][9];
					end
                end
            end
            if(count >= 0) begin
                if(count == 1)
                    Score = Score + 1;
                if(count == 2)
                    Score = Score + 3;
                if(count == 3)
                    Score = Score + 6;
                if(count == 4)
                    Score = Score + 10;
                Lines = Lines + count;
            end
        end
    end
end


always@(posedge CLK_25M) begin
	IsMap <= 3'd0;
    for (i = 1; i < 21; i = i + 1) begin
        for (j = 0; j < 10; j = j + 1) begin
            if((map[i][j] > 3'd0) && 
			(X > `WallX + (1 + j) * `BLOCK_SIZEX && X < `WallX + (2 + j) * `BLOCK_SIZEX) && 
			(Y > `WallY + (1 + i) * `BLOCK_SIZEY && Y < `WallY + (2 + i) * `BLOCK_SIZEY)) begin
				IsMap <= map[i][j];
            end
        end
    end
end

always @(posedge CLK_25M) begin
    IsCur <= 1'b0;
    if(cur_coordX[0] == cur_coordX[1] && cur_coordY[0] == cur_coordY[1]) begin
    end
    else begin
        for (i = 0; i < 4; i = i + 1) begin
            if((X > `WallX + (1 + cur_coordX[i]) * `BLOCK_SIZEX && X < `WallX + (2 + cur_coordX[i]) * `BLOCK_SIZEX) 
            && (Y > `WallY + (1 + cur_coordY[i]) * `BLOCK_SIZEY && Y < `WallY + (2 + cur_coordY[i]) * `BLOCK_SIZEY)) begin
	    		IsCur <= 1'b1;
            end
        end
    end
end

//Num存放了0-9共10个数字 如0:159-144
reg [159:0] TenNums [31:0];
initial begin
    TenNums[0]  = 160'h0000000000000000000000000000000000000000;
    TenNums[1]  = 160'h0000000000000000000000000000000000000000;
    TenNums[2]  = 160'h0000000000000000000000000000000000000000;
    TenNums[3]  = 160'h0000000000000000000000000000000000000000;
    TenNums[4]  = 160'h0000000000000000000000000000000000000000;
    TenNums[5]  = 160'h0000000000000000000000000000000000000000;
    TenNums[6]  = 160'h07E001C00FE007E000301FF800E07FFE0FE00FE0;
    TenNums[7]  = 160'h0FF001C01FF80FF800701FF800E07FFE1FF01FF0;
    TenNums[8]  = 160'h1C3803C03C381C380070180001C0000E38383C78;
    TenNums[9]  = 160'h383807C0381C381C00F018000380001C301C703C;
    TenNums[10] = 160'h381C1DC0701C301C01F0180003800018301C701C;
    TenNums[11] = 160'h301C19C0001C101C01B0380007000038301C601C;
    TenNums[12] = 160'h700C11C0001C001C03B030000E000030301C601C;
    TenNums[13] = 160'h700C01C000180018073037C00E0000703838601C;
    TenNums[14] = 160'h700C01C0003800780E303FF01FF000603C78601C;
    TenNums[15] = 160'h700C01C0003803E00C3078781FF800E00FE07038;
    TenNums[16] = 160'h700C01C0007003F01C3070383C1C00C01FF07878;
    TenNums[17] = 160'h700C01C000E000783830001C380E01C03C783FF8;
    TenNums[18] = 160'h700C01C000C0001C3030001C700E01C0781C1FF0;
    TenNums[19] = 160'h700C01C001C0001C7030000C700E0180701C00E0;
    TenNums[20] = 160'h700C01C00380001CFFFE000C700E0380600C00E0;
    TenNums[21] = 160'h301C01C00700100CFFFE201C700E0380600C01C0;
    TenNums[22] = 160'h381C01C00E00701CFFFE601C700E0300700C01C0;
    TenNums[23] = 160'h381801C01C00381C0030701C380E0700701C0380;
    TenNums[24] = 160'h1C3801C03C003C38003070783C1C0700783C0380;
    TenNums[25] = 160'h1FF001C03FFC1FF800303FF01FF806003FF80700;
    TenNums[26] = 160'h07E001C03FFC0FE000301FE00FF00E001FF00600;
    TenNums[27] = 160'h01800000000001800000078001C0000003800E00;
    TenNums[28] = 160'h0000000000000000000000000000000000000000;
    TenNums[29] = 160'h0000000000000000000000000000000000000000;
    TenNums[30] = 160'h0000000000000000000000000000000000000000;
    TenNums[31] = 160'h0000000000000000000000000000000000000000;
end

//数字LinesNum
localparam LinesNumLength = 7'd80;
localparam LinesNumWidth = 'd32;
//左上角的位置
localparam LinesNumX = `WallX + (2 * `GAME_LENGTH + 5) * `BLOCK_SIZEX / 2;
localparam LinesNumY = `WallY + 9 * `BLOCK_SIZEY;

reg [3:0] LinesNumDigit [4:0];
reg [79:0] LinesNum [31:0];
integer TmpLinesNum;
always @(posedge CLK_25M) begin
	if(key_reset == 1'b1) 
			LastLines = -1;
    if(Lines != LastLines) begin
        TmpLinesNum = Lines;
        LastLines = Lines;
        for(i = 0; i < 5; i = i + 1) begin
            LinesNumDigit[i] = TmpLinesNum % 10;
            TmpLinesNum = TmpLinesNum / 10;
        end
        for(i = 0; i < 32; i = i + 1) begin
            LinesNum[i] = {TenNums[i][(16 * (10 - LinesNumDigit[4]) - 1)-:16],
                           TenNums[i][(16 * (10 - LinesNumDigit[3]) - 1)-:16],
                           TenNums[i][(16 * (10 - LinesNumDigit[2]) - 1)-:16],
                           TenNums[i][(16 * (10 - LinesNumDigit[1]) - 1)-:16],
                           TenNums[i][(16 * (10 - LinesNumDigit[0]) - 1)-:16]};
        end
    end
end

reg[6:0] LinesNum_count;
always@(posedge CLK_25M) begin
    if(Lines != -1) begin
        if(X == LinesNumX) LinesNum_count <= LinesNumLength;  
        else if(X > LinesNumX && X <= LinesNumX + LinesNumLength)     
            LinesNum_count <= LinesNum_count - 1'b1;       //倒着输出图像信息 
    end
end
		
reg [79:0] LinesNum_tmp;
always@(posedge CLK_25M) begin
    IsLinesNum <= 1'b0;
    if(Lines != -1) begin
        if(X > LinesNumX && X <= LinesNumX + LinesNumLength 
        && Y - LinesNumY >= 0 && Y - LinesNumY < LinesNumWidth) begin
	    	LinesNum_tmp <= LinesNum[Y - LinesNumY];
            if(LinesNum_tmp[LinesNum_count]) 
	    		IsLinesNum <= 1'b1;
        end     
    end
end

//数字ScoreNum
localparam ScoreNumLength = 7'd80;
localparam ScoreNumWidth = 'd32;
//左上角的位置
localparam ScoreNumX = `WallX + (2 * `GAME_LENGTH + 5) * `BLOCK_SIZEX / 2;
localparam ScoreNumY = `WallY + 14 * `BLOCK_SIZEY;

reg [3:0] ScoreNumDigit [4:0];
reg [79:0] ScoreNum [31:0];
integer TmpScoreNum;
always @(posedge CLK_25M) begin
	if(key_reset == 1'b1) 
		LastScore = -1;
    if(Score != LastScore) begin
        TmpScoreNum = Score;
        LastScore = Score;
        for(i = 0; i < 5; i = i + 1) begin
            ScoreNumDigit[i] = TmpScoreNum % 10;
            TmpScoreNum = TmpScoreNum / 10;
        end
        for(i = 0; i < 32; i = i + 1) begin
            ScoreNum[i] = {TenNums[i][(16 * (10 - ScoreNumDigit[4]) - 1)-:16],
                           TenNums[i][(16 * (10 - ScoreNumDigit[3]) - 1)-:16],
                           TenNums[i][(16 * (10 - ScoreNumDigit[2]) - 1)-:16],
                           TenNums[i][(16 * (10 - ScoreNumDigit[1]) - 1)-:16],
                           TenNums[i][(16 * (10 - ScoreNumDigit[0]) - 1)-:16]};
        end
    end
end

reg[6:0] ScoreNum_count;
always@(posedge CLK_25M) begin
    if(Score != -1) begin
        if(X == ScoreNumX) ScoreNum_count <= ScoreNumLength;  
        else if(X > ScoreNumX && X <= ScoreNumX + ScoreNumLength)     
            ScoreNum_count <= ScoreNum_count - 1'b1;       //倒着输出图像信息 
    end
end
		
reg [79:0] ScoreNum_tmp;
always@(posedge CLK_25M) begin
    IsScoreNum <= 1'b0;
    if(Score != -1) begin
        if(X > ScoreNumX && X <= ScoreNumX + ScoreNumLength 
        && Y - ScoreNumY >= 0 && Y - ScoreNumY < ScoreNumWidth) begin
	    	ScoreNum_tmp <= ScoreNum[Y - ScoreNumY];
            if(ScoreNum_tmp[ScoreNum_count]) 
	    		IsScoreNum <= 1'b1;
        end     
    end
end

//数字MaxNum
localparam MaxNumLength = 7'd80;
localparam MaxNumWidth = 'd32;
//左上角的位置
localparam MaxNumX = `WallX + (`GAME_LENGTH + `APPENDIX_LENGTH + 4) * `BLOCK_SIZEX;
localparam MaxNumY = `WallY + 14 * `BLOCK_SIZEY;

reg [3:0] MaxNumDigit [4:0];
reg [79:0] MaxNum [31:0];
integer TmpMaxNum;
always @(posedge CLK_25M) begin
    if(Over == 1'b1 && Score > Max) begin
        Max = Score;
        TmpMaxNum = Max;
        for(i = 0; i < 5; i = i + 1) begin
            MaxNumDigit[i] = TmpMaxNum % 10;
            TmpMaxNum = TmpMaxNum / 10;
        end
        for(i = 0; i < 32; i = i + 1) begin
            MaxNum[i] = {TenNums[i][(16 * (10 - MaxNumDigit[4]) - 1)-:16],
                              TenNums[i][(16 * (10 - MaxNumDigit[3]) - 1)-:16],
                              TenNums[i][(16 * (10 - MaxNumDigit[2]) - 1)-:16],
                              TenNums[i][(16 * (10 - MaxNumDigit[1]) - 1)-:16],
                              TenNums[i][(16 * (10 - MaxNumDigit[0]) - 1)-:16]};
        end
    end
end

reg[6:0] MaxNum_count;
always@(posedge CLK_25M) begin
    if(Max != -1) begin
        if(X == MaxNumX) MaxNum_count <= MaxNumLength;  
        else if(X > MaxNumX && X <= MaxNumX + MaxNumLength)     
            MaxNum_count <= MaxNum_count - 1'b1;       //倒着输出图像信息 
    end
end
		
reg [79:0] MaxNum_tmp;
always@(posedge CLK_25M) begin
    IsMaxNum <= 1'b0;
    if(Max != -1) begin
        if(X > MaxNumX && X <= MaxNumX + MaxNumLength 
        && Y - MaxNumY >= 0 && Y - MaxNumY < MaxNumWidth) begin
	    	MaxNum_tmp <= MaxNum[Y - MaxNumY];
            if(MaxNum_tmp[MaxNum_count]) 
	    		IsMaxNum <= 1'b1;
        end     
    end
end


//数字NumNum
localparam NumNumLength = 7'd80;
localparam NumNumWidth = 'd32;
//左上角的位置
localparam NumNumX = `WallX + (2 * `GAME_LENGTH + 5) * `BLOCK_SIZEX / 2;
localparam NumNumY = `WallY + 19 * `BLOCK_SIZEY;

reg [3:0] NumNumDigit [4:0];
reg [79:0] NumNum [31:0];
integer TmpNumNum;
always @(posedge CLK_25M) begin
	if(key_reset == 1'b1) 
		LastNum = -1;
    if(Num != LastNum) begin
        TmpNumNum = Num;
        LastNum = Num;
        for(i = 0; i < 5; i = i + 1) begin
            NumNumDigit[i] = TmpNumNum % 10;
            TmpNumNum = TmpNumNum / 10;
        end
        for(i = 0; i < 32; i = i + 1) begin
            NumNum[i] = {TenNums[i][(16 * (10 - NumNumDigit[4]) - 1)-:16],
                           TenNums[i][(16 * (10 - NumNumDigit[3]) - 1)-:16],
                           TenNums[i][(16 * (10 - NumNumDigit[2]) - 1)-:16],
                           TenNums[i][(16 * (10 - NumNumDigit[1]) - 1)-:16],
                           TenNums[i][(16 * (10 - NumNumDigit[0]) - 1)-:16]};
        end
    end
end

reg[6:0] NumNum_count;
always@(posedge CLK_25M) begin
    if(Num != -1) begin
        if(X == NumNumX) NumNum_count <= NumNumLength;  
        else if(X > NumNumX && X <= NumNumX + NumNumLength)     
            NumNum_count <= NumNum_count - 1'b1;       //倒着输出图像信息 
    end
end
		
reg [79:0] NumNum_tmp;
always@(posedge CLK_25M) begin
    IsNumNum <= 1'b0;
    if(Num != -1) begin
        if(X > NumNumX && X <= NumNumX + NumNumLength 
        && Y - NumNumY >= 0 && Y - NumNumY < NumNumWidth) begin
	    	NumNum_tmp <= NumNum[Y - NumNumY];
            if(NumNum_tmp[NumNum_count]) 
	    		IsNumNum <= 1'b1;
        end     
    end
end

//数字LevelNum
localparam LevelNumLength = 7'd80;
localparam LevelNumWidth = 'd32;
//左上角的位置
localparam LevelNumX = `WallX + (`GAME_LENGTH + `APPENDIX_LENGTH + 4) * `BLOCK_SIZEX;
localparam LevelNumY = `WallY + 19 * `BLOCK_SIZEY;

reg [3:0] LevelNumDigit [4:0];
reg [79:0] LevelNum [31:0];
integer TmpLevelNum;
always @(posedge CLK_25M) begin
	if(key_reset == 1'b1) 
		LastLevel = 0;
    if(Level != LastLevel) begin
        TmpLevelNum = Level;
        LastLevel = Level;
        for(i = 0; i < 5; i = i + 1) begin
            LevelNumDigit[i] = TmpLevelNum % 10;
            TmpLevelNum = TmpLevelNum / 10;
        end
        for(i = 0; i < 32; i = i + 1) begin
            LevelNum[i] = {TenNums[i][(16 * (10 - LevelNumDigit[4]) - 1)-:16],
                           TenNums[i][(16 * (10 - LevelNumDigit[3]) - 1)-:16],
                           TenNums[i][(16 * (10 - LevelNumDigit[2]) - 1)-:16],
                           TenNums[i][(16 * (10 - LevelNumDigit[1]) - 1)-:16],
                           TenNums[i][(16 * (10 - LevelNumDigit[0]) - 1)-:16]};
        end
    end
end

reg[6:0] LevelNum_count;
always@(posedge CLK_25M) begin
    if(Level != 0) begin
        if(X == LevelNumX) LevelNum_count <= LevelNumLength;  
        else if(X > LevelNumX && X <= LevelNumX + LevelNumLength)     
            LevelNum_count <= LevelNum_count - 1'b1;       //倒着输出图像信息 
    end
end
		
reg [79:0] LevelNum_tmp;
always@(posedge CLK_25M) begin
    IsLevelNum <= 1'b0;
    if(Level != 0) begin
        if(X > LevelNumX && X <= LevelNumX + LevelNumLength 
        && Y - LevelNumY >= 0 && Y - LevelNumY < LevelNumWidth) begin
	    	LevelNum_tmp <= LevelNum[Y - LevelNumY];
            if(LevelNum_tmp[LevelNum_count]) 
	    		IsLevelNum <= 1'b1;
        end     
    end
end

//单词Reset
localparam ResetLength = 7'd80;
localparam ResetWidth = 'd32;
//左上角的位置
localparam ResetX = `WallX + (`GAME_LENGTH + `APPENDIX_LENGTH + 4) * `BLOCK_SIZEX;
localparam ResetY = `WallY + 9 * `BLOCK_SIZEY;

reg [79:0] Reset [31:0];
initial begin
    Reset[0] = 80'h00000000000000000000;
    Reset[1] = 80'h00000000000000000000;
    Reset[2] = 80'h00000000000000000000;
    Reset[3] = 80'h00000000000000000000;
    Reset[4] = 80'h00000000000000000000;
    Reset[5] = 80'h3FF80000000000000000;
    Reset[6] = 80'h0E1C0000000000000000;
    Reset[7] = 80'h0E0E0000000000000000;
    Reset[8] = 80'h0E0E0000000000000300;
    Reset[9] = 80'h0E0E0000000000000300;
    Reset[10] = 80'h0E0E0000000000000700;
    Reset[11] = 80'h0E0E0000000000000700;
    Reset[12] = 80'h0E3C03F003FE03F03FF0;
    Reset[13] = 80'h0FF0071C071E071C0700;
    Reset[14] = 80'h0EE00E0C0E0E0E0C0700;
    Reset[15] = 80'h0E701C0E0E061C0E0700;
    Reset[16] = 80'h0E701C0E0F001C0E0700;
    Reset[17] = 80'h0E701FFE03E01FFE0700;
    Reset[18] = 80'h0E381C0000FC1C000700;
    Reset[19] = 80'h0E381C00001E1C000700;
    Reset[20] = 80'h0E1C1C060C0E1C060718;
    Reset[21] = 80'h0E1C0E0C0C0E0E0C0718;
    Reset[22] = 80'h0E1C071C0E1C071C07B0;
    Reset[23] = 80'h3F8F03F00FF803F003E0;
    Reset[24] = 80'h00000000000000000000;
    Reset[25] = 80'h00000000000000000000;
    Reset[26] = 80'h00000000000000000000;
    Reset[27] = 80'h00000000000000000000;
    Reset[28] = 80'h00000000000000000000;
    Reset[29] = 80'h00000000000000000000;
    Reset[30] = 80'h00000000000000000000;
    Reset[31] = 80'h00000000000000000000;
end

reg[6:0] Reset_count;
always@(posedge CLK_25M) begin
    if(Initial == 1'b1) begin
        if(X == ResetX) Reset_count <= ResetLength;  
        else if(X > ResetX && X <= ResetX + ResetLength)     
            Reset_count <= Reset_count - 1'b1;       //倒着输出图像信息
    end 
end
		
reg [79:0] Reset_tmp;
always@(posedge CLK_25M) begin
    IsReset <= 1'b0;
    if(Initial == 1'b1) begin
        if(X > ResetX && X <= ResetX + ResetLength 
        && Y - ResetY >= 0 && Y - ResetY < ResetWidth) begin
	    	Reset_tmp <= Reset[Y - ResetY];
            if(Reset_tmp[Reset_count]) 
	    		IsReset <= 1'b1;
        end    
    end 
end

//单词Start
localparam StartLength = 7'd80;
localparam StartWidth = 'd32;
//左上角的位置
localparam StartX = `WallX + (`GAME_LENGTH + `APPENDIX_LENGTH + 4) * `BLOCK_SIZEX;
localparam StartY = `WallY + 9 * `BLOCK_SIZEY;

reg [79:0] _Start [31:0];
initial begin
    _Start[0] = 80'h00000000000000000000;
    _Start[1] = 80'h00000000000000000000;
    _Start[2] = 80'h00000000000000000000;
    _Start[3] = 80'h00000000000000000000;
    _Start[4] = 80'h00000000000000000000;
    _Start[5] = 80'h07D80000000000000000;
    _Start[6] = 80'h1C780000000000000000;
    _Start[7] = 80'h18380000000000000000;
    _Start[8] = 80'h38180180000000000300;
    _Start[9] = 80'h38180180000000000300;
    _Start[10] = 80'h38000380000000000700;
    _Start[11] = 80'h3C000380000003000700;
    _Start[12] = 80'h1E001FF807E03F3C3FF0;
    _Start[13] = 80'h0F8003801C38076E0700;
    _Start[14] = 80'h03E003801C3807CE0700;
    _Start[15] = 80'h00F80380003807800700;
    _Start[16] = 80'h0038038001F807000700;
    _Start[17] = 80'h001C03800F3807000700;
    _Start[18] = 80'h301C03801C3807000700;
    _Start[19] = 80'h301C0380383807000700;
    _Start[20] = 80'h381C038C383807000718;
    _Start[21] = 80'h3838038C383E07000718;
    _Start[22] = 80'h3C3803D81CFE070007B0;
    _Start[23] = 80'h37E001F00F9C3FE003E0;
    _Start[24] = 80'h00000000000000000000;
    _Start[25] = 80'h00000000000000000000;
    _Start[26] = 80'h00000000000000000000;
    _Start[27] = 80'h00000000000000000000;
    _Start[28] = 80'h00000000000000000000;
    _Start[29] = 80'h00000000000000000000;
    _Start[30] = 80'h00000000000000000000;
    _Start[31] = 80'h00000000000000000000;
end

reg[6:0] Start_count;
always@(posedge CLK_25M) begin
    if(Start == 1'b1) begin
        if(X == StartX) Start_count <= StartLength;  
        else if(X > StartX && X <= StartX + StartLength)     
            Start_count <= Start_count - 1'b1;       //倒着输出图像信息
    end 
end
		
reg [79:0] Start_tmp;
always@(posedge CLK_25M) begin
    IsStart <= 1'b0;
    if(Start == 1'b1) begin
        if(X > StartX && X <= StartX + StartLength 
        && Y - StartY >= 0 && Y - StartY < StartWidth) begin
	    	Start_tmp <= _Start[Y - StartY];
            if(Start_tmp[Start_count]) 
	    		IsStart <= 1'b1;
        end    
    end 
end

//单词Pause
localparam PauseLength = 7'd80;
localparam PauseWidth = 'd32;
//左上角的位置
localparam PauseX = `WallX + (`GAME_LENGTH + `APPENDIX_LENGTH + 4) * `BLOCK_SIZEX;
localparam PauseY = `WallY + 9 * `BLOCK_SIZEY;

reg [79:0] Pause [31:0];
initial begin
    Pause[0] = 80'h00000000000000000000;
    Pause[1] = 80'h00000000000000000000;
    Pause[2] = 80'h00000000000000000000;
    Pause[3] = 80'h00000000000000000000;
    Pause[4] = 80'h00000000000000000000;
    Pause[5] = 80'h7FF00000000000000000;
    Pause[6] = 80'h1C3C0000000000000000;
    Pause[7] = 80'h1C1C0000000000000000;
    Pause[8] = 80'h1C0E0000000000000000;
    Pause[9] = 80'h1C0E0000000000000000;
    Pause[10] = 80'h1C0E0000000000000000;
    Pause[11] = 80'h1C0E00000C0C00000000;
    Pause[12] = 80'h1C1C07E07C7C03FE07E0;
    Pause[13] = 80'h1C3C1C381C1C071E0E38;
    Pause[14] = 80'h1FF01C381C1C0E0E1C18;
    Pause[15] = 80'h1C0000381C1C0E06381C;
    Pause[16] = 80'h1C0001F81C1C0F00381C;
    Pause[17] = 80'h1C000F381C1C03E03FFC;
    Pause[18] = 80'h1C001C381C1C00FC3800;
    Pause[19] = 80'h1C0038381C1C001E3800;
    Pause[20] = 80'h1C0038381C1C0C0E380C;
    Pause[21] = 80'h1C00383E1C1C0C0E1C18;
    Pause[22] = 80'h1C001CFE1E7F0E1C0E38;
    Pause[23] = 80'h7F000F9C0FD80FF807E0;
    Pause[24] = 80'h00000000000000000000;
    Pause[25] = 80'h00000000000000000000;
    Pause[26] = 80'h00000000000000000000;
    Pause[27] = 80'h00000000000000000000;
    Pause[28] = 80'h00000000000000000000;
    Pause[29] = 80'h00000000000000000000;
    Pause[30] = 80'h00000000000000000000;
    Pause[31] = 80'h00000000000000000000;
end

reg[6:0] Pause_count;
always@(posedge CLK_25M) begin
    if(Start == 1'b0 && Initial == 1'b0 && Over == 1'b0) begin
        if(X == PauseX) Pause_count <= PauseLength;  
        else if(X > PauseX && X <= PauseX + PauseLength)     
            Pause_count <= Pause_count - 1'b1;       //倒着输出图像信息
    end 
end
		
reg [79:0] Pause_tmp;
always@(posedge CLK_25M) begin
    IsPause <= 1'b0;
    if(Start == 1'b0 && Initial == 1'b0 && Over == 1'b0) begin
        if(X > PauseX && X <= PauseX + PauseLength 
        && Y - PauseY >= 0 && Y - PauseY < PauseWidth) begin
	    	Pause_tmp <= Pause[Y - PauseY];
            if(Pause_tmp[Pause_count]) 
	    		IsPause <= 1'b1;
        end    
    end 
end

//单词End
localparam EndLength = 6'd48;
localparam EndWidth = 'd32;
//左上角的位置
localparam EndX = `WallX + (`GAME_LENGTH + `APPENDIX_LENGTH + 5) * `BLOCK_SIZEX;
localparam EndY = `WallY + 9 * `BLOCK_SIZEY;

reg [47:0] _End [31:0];
initial begin
    _End[0] = 48'h000000000000;
    _End[1] = 48'h000000000000;
    _End[2] = 48'h000000000000;
    _End[3] = 48'h000000000000;
    _End[4] = 48'h000000000000;
    _End[5] = 48'h00000000000C;
    _End[6] = 48'h7FFC0000007C;
    _End[7] = 48'h1C1C0000001C;
    _End[8] = 48'h1C0E0000001C;
    _End[9] = 48'h1C060000001C;
    _End[10] = 48'h1C000000001C;
    _End[11] = 48'h1C000000001C;
    _End[12] = 48'h1C300C00001C;
    _End[13] = 48'h1C307DF007FC;
    _End[14] = 48'h1C701F380E3C;
    _End[15] = 48'h1FF01E1C1C1C;
    _End[16] = 48'h1C701C1C1C1C;
    _End[17] = 48'h1C301C1C381C;
    _End[18] = 48'h1C301C1C381C;
    _End[19] = 48'h1C001C1C381C;
    _End[20] = 48'h1C001C1C381C;
    _End[21] = 48'h1C061C1C381C;
    _End[22] = 48'h1C061C1C381C;
    _End[23] = 48'h1C0C1C1C1C3C;
    _End[24] = 48'h1C1C1C1C0E7F;
    _End[25] = 48'h7FFC7F7F07D8;
    _End[26] = 48'h000000000000;
    _End[27] = 48'h000000000000;
    _End[28] = 48'h000000000000;
    _End[29] = 48'h000000000000;
    _End[30] = 48'h000000000000;
    _End[31] = 48'h000000000000;
end

reg[5:0] End_count;
always@(posedge CLK_25M) begin
    if(Over == 1'b1) begin
        if(X == EndX) End_count <= EndLength;  
        else if(X > EndX && X <= EndX + EndLength)     
            End_count <= End_count - 1'b1;       //倒着输出图像信息
    end 
end
		
reg [47:0] End_tmp;
always@(posedge CLK_25M) begin
    IsEnd <= 1'b0;
    if(Over == 1'b1) begin
        if(X > EndX && X <= EndX + EndLength 
        && Y - EndY >= 0 && Y - EndY < EndWidth) begin
	    	End_tmp <= _End[Y - EndY];
            if(End_tmp[End_count]) 
	    		IsEnd <= 1'b1;
        end    
    end 
end

endmodule