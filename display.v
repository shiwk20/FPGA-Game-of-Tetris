`include "global.v"
module display (
    input [2:0] IsTitle,
    input IsWall,
	 input IsLines,
    input IsLinesNum,
    input IsState,
    input IsReset,
    input IsStart,
    input IsPause,
    input IsEnd,
	 input IsScore,
	 input IsScoreNum,
    input IsMax,
	 input IsMaxNum,
	 input IsNum,
	 input IsNumNum,
    input IsLevel,
    input IsLevelNum,
	 input IsNext,
	 input [2:0] next_type,
	 input [2:0] IsMap,
	 input IsCur,
    input [2:0] cur_type,
	 input IsOver,
	 input Over,

    output wire [23:0] color_RGB
);

reg [23:0] color_block_type [0:6];
initial begin 
    color_block_type[`TYPE1 - 1] = `Turquoise;
    color_block_type[`TYPE2 - 1] = `BLUE;
    color_block_type[`TYPE3 - 1] = `GOLD;
    color_block_type[`TYPE4 - 1] = `YELLOW;
    color_block_type[`TYPE5 - 1] = `GREEN;
    color_block_type[`TYPE6 - 1] = `PURPLE;
    color_block_type[`TYPE7 - 1] = `RED;
end

reg [23:0] color_title_type [0:4];
initial begin
    color_title_type[0] = `RED;
    color_title_type[1] = `GREEN;
    color_title_type[2] = `GOLD;
    color_title_type[3] = `PURPLE;
    color_title_type[4] = `Turquoise;
end

assign color_RGB = (Over == 1'b1 && IsOver == 1'b1)? `BLACK :
	 (IsTitle >= 3'd1)? color_title_type[IsTitle - 1] :
	 (IsLines == 1'd1)? `BLACK :
    (IsLinesNum == 1'd1)? `DimGrey :
    (IsState == 1'd1)? `BLACK :
    (IsReset == 1'd1)? `DimGrey :
    (IsStart == 1'd1)? `DimGrey :
    (IsPause == 1'd1)? `DimGrey :
    (IsEnd == 1'd1)? `DimGrey :
	 (IsScore == 1'd1)? `BLACK :
	 (IsScoreNum == 1'd1)? `DimGrey :
    (IsMax == 1'd1)? `BLACK :
	 (IsMaxNum == 1'd1)? `DimGrey :
    (IsNum == 1'd1)? `BLACK :
	 (IsNumNum == 1'd1)? `DimGrey :
	 (IsLevel == 1'd1)? `BLACK :
	 (IsLevelNum == 1'd1)? `DimGrey :
    (IsNext == 1'b1)? color_block_type[next_type - 1] :
	 (IsWall == 1'd1)? `DimGrey :
    (IsMap > 3'd0)?  color_block_type[IsMap - 1] :
    (IsCur == 1'b1)?  color_block_type[cur_type - 1] :
    `Gainsboro;

endmodule