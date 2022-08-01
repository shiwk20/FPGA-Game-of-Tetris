
`include "global.v"

module key (
    input CLK_25M,
    
    input LeftKey,
    input RightKey,
    input RotateKey,
    input DropKey,
    input ResetKey,
    input StartKey,
    input PauseKey,
	 input ContinueKey,

    output reg key_left,
    output reg key_right,
    output reg key_rotate,
    output reg key_drop,
    output reg key_reset,
    output reg key_start,
    output reg key_pause,
	 output reg key_continue
);

reg last_LeftKey;
reg last_RightKey;
reg last_RotateKey;
reg last_DropKey;

reg last_ResetKey;
reg last_StartKey;
reg last_PauseKey;
reg last_ContinueKey;

initial begin
    last_LeftKey = `OFF; 
    last_RightKey = `OFF; 
    last_RotateKey = `OFF; 
    last_DropKey = `OFF; 

    last_ResetKey = `OFF; 
    last_StartKey = `OFF;
    last_PauseKey = `OFF;
	last_PauseKey = `OFF;


    key_left = `OFF;
    key_right = `OFF;
    key_rotate = `OFF;
    key_drop = `OFF;
    key_reset = `OFF;
    key_start = `OFF;
    key_pause = `OFF;
	key_continue = `OFF;
end

//Key
always @(posedge CLK_25M) begin
    if(RightKey != last_RightKey) begin
        if(RightKey == `ON) begin
            key_right <= `ON;
        end
        last_RightKey <= RightKey;
    end
    else key_right <= `OFF;
end

always @(posedge CLK_25M) begin
    if(LeftKey != last_LeftKey) begin
        if(LeftKey == `ON) begin
            key_left <= `ON;
        end
        last_LeftKey <= LeftKey;
    end
    else key_left <= `OFF;
end

always @(posedge CLK_25M) begin
    if(DropKey != last_DropKey) begin
        if(DropKey == `ON) begin
            key_drop <= `ON;
        end
        last_DropKey <= DropKey;
    end
    else key_drop <= `OFF;
end

always @(posedge CLK_25M) begin
    if(RotateKey != last_RotateKey) begin
        if(RotateKey == `ON) begin
            key_rotate <= `ON;
        end
        last_RotateKey <= RotateKey;
    end
    else key_rotate <= `OFF;
end

//SW
integer start_count = 0;
always @(posedge CLK_25M) begin
	key_start <= `OFF;
    if(start_count == 0 && StartKey != last_StartKey) begin
		start_count = 1;

	end
	if(start_count >= 1) 
	    start_count = start_count + 1;
	if(start_count == 2500000) begin
		start_count = 0;
        key_start <= `ON;
		last_StartKey <= StartKey;
    end
end

integer reset_count = 0;
always @(posedge CLK_25M) begin
    key_reset <= `OFF;
    if(reset_count == 0 && ResetKey != last_ResetKey) begin
		  reset_count = 1;
	 end
	 if(reset_count >= 1) 
	     reset_count = reset_count + 1;
	 if(reset_count == 2500000) begin
		  reset_count = 0;
        key_reset <= `ON; 
		  last_ResetKey <= ResetKey;		  
    end
end

integer pause_count = 0;
always @(posedge CLK_25M) begin
    key_pause <= `OFF;
    if(pause_count == 0 && PauseKey != last_PauseKey) begin
		  pause_count = 1;
	 end
	 if(pause_count >= 1) 
	     pause_count = pause_count + 1;
	 if(pause_count == 2500000) begin
		  pause_count = 0;
        key_pause <= `ON;
		  last_PauseKey <= PauseKey;
    end
end

integer continue_count = 0;
always @(posedge CLK_25M) begin
    key_continue <= `OFF;
    if(continue_count == 0 && ContinueKey != last_ContinueKey) begin
		  continue_count = 1;
	 end
	 if(continue_count >= 1) 
	     continue_count = continue_count + 1;
	 if(continue_count == 2500000) begin
		  continue_count = 0;
        key_continue <= `ON;
		  last_ContinueKey <= ContinueKey;
    end
end
endmodule

