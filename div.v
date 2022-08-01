module div(
    input CLK_50M,
    input [31:0] Level,

    output reg CLK_25M,
    output reg CLK_Drop
);

reg [31:0] count;
initial count = 1'b1;

always@(posedge CLK_50M) begin
    CLK_25M <= ~CLK_25M;
end

always@(posedge CLK_25M) begin
    CLK_Drop <= 1'b0;
    if(Level >= 32'd1) begin
        count <= count + 1'b1;
        if(count >= 32'd20000000 - Level * 32'd900000) begin
            CLK_Drop <= 1'b1;
            count <= 1'b1;
        end
    end
end


endmodule