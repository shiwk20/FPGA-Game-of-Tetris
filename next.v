
`include "global.v"

module next (
    input CLK_25M,
    input Update,
    input [9:0] X,
    input [9:0] Y,
    input key_reset,
	 input key_start,
    
    output reg IsNext,
    output wire [2:0] next_type

);

//注意若seed相同，则生成的序列也相同
localparam seed = 10'd490;


reg Initial;
reg[9:0] rand_type;
initial rand_type = seed;
initial Initial = 1'b1;

assign next_type = rand_type % 3'd7 + 1;

//通过LFSR(线性反馈移位寄存器)生成伪随机码
always@(posedge CLK_25M) begin
    if(key_reset == 1'b1) begin
        rand_type <= seed * rand_type + next_type * next_type;
		Initial = 1'b1;
    end
    if(Update == 1'b1 || (key_start == 1'b1 && Initial == 1'b1)) begin
		rand_type[0] <= rand_type[9];
		rand_type[1] <= rand_type[0];
		rand_type[2] <= rand_type[1] == rand_type[9];
		rand_type[3] <= rand_type[2] == rand_type[9];
		rand_type[4] <= rand_type[3] != rand_type[9];
		rand_type[5] <= rand_type[4];
		rand_type[6] <= rand_type[5] != rand_type[9];
		rand_type[7] <= rand_type[6];
		rand_type[8] <= rand_type[7] != rand_type[9];
		rand_type[9] <= rand_type[8];
		if(key_start == 1'b1 && Initial == 1'b1)
			Initial = 1'b0;
    end 
end

//通过4 × 4坐标显示
reg [3:0] next_coord [3:0];
always@(posedge CLK_25M) begin
    next_coord[0] <= 4'd0;
    next_coord[1] <= 4'd0;
    next_coord[2] <= 4'd0;
    next_coord[3] <= 4'd0;
    
    case(next_type)
        `TYPE1: begin
            next_coord[0][2] <= 1'b1;
            next_coord[1][2] <= 1'b1;
            next_coord[2][2] <= 1'b1;
            next_coord[3][2] <= 1'b1;
        end
        `TYPE2: begin
            next_coord[0][1] <= 1'b1;
            next_coord[0][2] <= 1'b1;
            next_coord[1][2] <= 1'b1;
            next_coord[2][2] <= 1'b1;
        end
        `TYPE3: begin
            next_coord[0][2] <= 1'b1;
            next_coord[1][2] <= 1'b1;
            next_coord[2][1] <= 1'b1;
            next_coord[2][2] <= 1'b1;

        end
        `TYPE4: begin
            next_coord[1][1] <= 1'b1;
            next_coord[1][2] <= 1'b1;
            next_coord[2][1] <= 1'b1;
            next_coord[2][2] <= 1'b1;
        end
        `TYPE5: begin
            next_coord[0][2] <= 1'b1;
            next_coord[1][1] <= 1'b1;
            next_coord[1][2] <= 1'b1;
            next_coord[2][1] <= 1'b1;
        end
        `TYPE6: begin
            next_coord[0][2] <= 1'b1;
            next_coord[1][1] <= 1'b1;
            next_coord[1][2] <= 1'b1;
            next_coord[2][2] <= 1'b1;

        end
        `TYPE7: begin
            next_coord[0][1] <= 1'b1;
            next_coord[1][1] <= 1'b1;
            next_coord[1][2] <= 1'b1;
            next_coord[2][2] <= 1'b1;
        end
    endcase
end

integer i;
integer j;
always@(posedge CLK_25M) begin
	IsNext <= 1'b0;
    for (i = 0; i < 4; i = i + 1) begin
        for (j = 0; j < 4; j = j + 1) begin
            if((next_coord[i][j] == 1'b1) && 
				(X > `WallX + (`GAME_LENGTH + 3 + i) * `BLOCK_SIZEX && 
				X < `WallX + (`GAME_LENGTH + 4 + i) * `BLOCK_SIZEX) && 
				(Y > `WallY + (2 + j) * `BLOCK_SIZEY && 
				Y < `WallY + (3 + j) * `BLOCK_SIZEY))
					IsNext <= 1'b1;
        end
    end
end
endmodule



