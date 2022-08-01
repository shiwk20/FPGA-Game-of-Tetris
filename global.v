//颜色
`define BLACK     24'h000000
`define RED       24'hF00100
`define GREEN     24'h00F000
`define BLUE      24'h0101F0
`define YELLOW    24'hF0F001
`define GOLD      24'hEFA000
`define SKY_BULE  24'h00FFFF
`define PURPLE    24'hA000F1
`define GREY      24'hC0C0C0
`define WHITE     24'hFFFFFF
`define DimGrey   24'h696969
`define Gainsboro 24'hA1A1A1
`define Turquoise 24'h01F0F1



//方块大小
`define BLOCK_SIZEX    'd16
`define BLOCK_SIZEY    'd16
//游戏范围10×20,多出一行用来判断游戏结束
`define GAME_LENGTH 'd10
`define GAME_WIDTH 'd21
//附录范围
`define APPENDIX_LENGTH 'd6
//墙壁左上角坐标   
`define WallX 'd168
`define WallY 'd88

//总共7种图形，每一种对应一种颜色
`define TYPE1 3'd1     //....

`define TYPE2 3'd2     //.
                       //...
                
`define TYPE3 3'd3     //  .
                       //...
                    
`define TYPE4 3'd4     //..
                       //..
                    
`define TYPE5 3'd5     // ..
                       //..
                    
`define TYPE6 3'd6     // . 
                       //...
                    
`define TYPE7 3'd7     //..
                       // ..

`define ON 1'b1
`define OFF 1'b0