
module VGA (
	 input CLK_25M,    
    input [23:0] color_RGB,

    output VGA_CLK,    //VGA自时钟
	 output reg VGA_HS,     //行同步信号
	 output reg VGA_VS,     //场同步信号
	 //复合空白信号控制信号  当BLANK为低电平时模拟视频输出消隐电平，此时从R9~R0,G9~G0,B9~B0输入的所有数据被忽略
	 output VGA_BLANK,  
	 output VGA_SYNC,   //复合同步控制信号      行时序和场时序都要产生同步脉冲
	 output wire [7:0] VGA_R,      //VGA绿色
	 output wire [7:0] VGA_G,      //VGA绿色
	 output wire [7:0] VGA_B,       //VGA蓝色
    output reg [9:0] X,          //当前行第几个像素点
    output reg [9:0] Y           //当前场第几行
);  


 //这里分辨率是640×480,相应的参数如下：
localparam H_FRONT = 16;     //行同步前沿信号周期长
localparam H_SYNC = 96;      //行同步信号周期长
localparam H_BACK = 48;      //行同步后沿信号周期长
localparam H_ACT = 640;      //行显示周期长
localparam H_BLANK = H_FRONT+H_SYNC+H_BACK;        //行空白信号总周期长160
localparam H_TOTAL = H_FRONT+H_SYNC+H_BACK+H_ACT;  //行总周期长耗时800
localparam V_FRONT = 11;     //场同步前沿信号周期长
localparam V_SYNC = 2;       //场同步信号周期长
localparam V_BACK = 31;      //场同步后沿信号周期长
localparam V_ACT = 480;      //场显示周期长
localparam V_BLANK = V_FRONT+V_SYNC+V_BACK;        //场空白信号总周期长44
localparam V_TOTAL = V_FRONT+V_SYNC+V_BACK+V_ACT;  //场总周期长耗时524

reg [9:0] H_count;        //行周期计数器
reg [9:0] V_count;        //场周期计数器


assign VGA_SYNC = 1'b0;   //同步信号低电平
//当行计数器小于行空白总长或场计数器小于场空白总长时，空白信号低电平
assign VGA_BLANK = ~((H_count<H_BLANK)||(V_count<V_BLANK));  
assign VGA_CLK = ~CLK_25M;  //VGA时钟等于CLK_25M取反

always@(posedge CLK_25M) begin
    if(H_count<H_TOTAL)           //如果行计数器小于行总时长
        H_count<=H_count+1'b1;      //行计数器+1
    else H_count<=0;              //否则行计数器清零
    if(H_count==H_FRONT-1)        //如果行计数器等于行前沿空白时间-1
        VGA_HS<=1'b0;             //行同步信号置0
    if(H_count==H_FRONT+H_SYNC-1) //如果行计数器等于行前沿+行同步-1
        VGA_HS<=1'b1;             //行同步信号置1
    if(H_count>=H_BLANK)          //如果行计数器大于等于行空白总时长
        X<=H_count-H_BLANK;        //X等于行计数器-行空白总时长   （X为当前行第几个像素点）  1-640
    else X<=0;                    //否则X为0
end 

//只有每次一行开始时才开始计数场
always@(posedge VGA_HS) begin
    if(V_count<V_TOTAL)           //如果场计数器小于行总时长
        V_count<=V_count+1'b1;      //场计数器+1
    else V_count<=0;              //否则场计数器清零
    if(V_count==V_FRONT-1)       //如果场计数器等于场前沿空白时间-1
        VGA_VS<=1'b0;             //场同步信号置0
    if(V_count==V_FRONT+V_SYNC-1) //如果场计数器等于行前沿+场同步-1
        VGA_VS<=1'b1;             //场同步信号置1
    if(V_count>=V_BLANK)          //如果场计数器大于等于场空白总时长
        Y<=V_count-V_BLANK;        //Y等于场计数器-场空白总时长    （Y为当前场第几行）  1-480
    else Y<=0;                   //否则Y为0
end
        
assign VGA_R = color_RGB[23:16];
assign VGA_G = color_RGB[15:8];
assign VGA_B = color_RGB[7:0];


endmodule