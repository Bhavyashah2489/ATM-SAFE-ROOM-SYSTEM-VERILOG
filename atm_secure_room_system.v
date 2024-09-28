`timescale 1ns / 1ps
module atm_secure_room_system( 
                input clk,reset_n,
 input sensor_entry, sensor_exit, 
 input [1:0] passcode_digit_1, passcode_digit_2,
 output wire GREEN_LIGHT,RED_LIGHT,
 output reg [6:0] DISPLAY_1, DISPLAY_2
    );


parameter IDLE = 3'b000, WAIT_PASSCODE = 3'b001, INVALID_PASSCODE = 3'b010, VALID_PASSCODE = 3'b011, ROOM_LOCKED = 3'b100;
// Moore FSM : output just depends on the current state
reg[2:0] current_state, next_state;
reg[31:0] counter_wait;
reg red_light_tmp, green_light_tmp;

// Next state
always @(posedge clk or negedge reset_n)
begin
    if(~reset_n) 
        current_state = IDLE;
    else
        current_state = next_state;
end

// counter_wait
always @(posedge clk or negedge reset_n) 
begin
    if(~reset_n) 
        counter_wait <= 0;
    else if(current_state==WAIT_PASSCODE)
        counter_wait <= counter_wait + 1;
    else 
        counter_wait <= 0;
end

// change state
always @(*)
begin
    case(current_state)
        IDLE: begin
            if(sensor_entry == 1)
                next_state = WAIT_PASSCODE;
            else
                next_state = IDLE;
        end
        WAIT_PASSCODE: begin
            if(counter_wait <= 3)
                next_state = WAIT_PASSCODE;
            else begin
                if((passcode_digit_1==2'b01)&&(passcode_digit_2==2'b10))
                    next_state = VALID_PASSCODE;
                else 
                    next_state = INVALID_PASSCODE;
              
            end
        end
        INVALID_PASSCODE: begin
            if((passcode_digit_1==2'b01)&&(passcode_digit_2==2'b10))
                next_state = VALID_PASSCODE;
            else
                next_state = INVALID_PASSCODE;
        end
        VALID_PASSCODE: begin
            if(sensor_entry==1 && sensor_exit == 1)
                next_state = ROOM_LOCKED;
            else if(sensor_exit == 1)
                next_state = IDLE;
            else
                next_state = VALID_PASSCODE;
        end
        ROOM_LOCKED: begin
            if((passcode_digit_1==2'b01)&&(passcode_digit_2==2'b10))
                next_state = VALID_PASSCODE;
            else
                next_state = ROOM_LOCKED;
        end
        default: next_state = IDLE;
    endcase
end

// LEDs and output, change the period of blinking LEDs here
always @(posedge clk) begin 
    case(current_state)
        IDLE: begin
            green_light_tmp = 1'b0;
            red_light_tmp = 1'b0;
            DISPLAY_1 = 7'b1111111; // off
            DISPLAY_2 = 7'b1111111; // off
        end
        WAIT_PASSCODE: begin
            green_light_tmp = 1'b0;
            red_light_tmp = 1'b1;
            DISPLAY_1 = 7'b000_0110; // E
            DISPLAY_2 = 7'b010_1011; // n 
        end
        INVALID_PASSCODE: begin
            green_light_tmp = 1'b0;
            red_light_tmp = ~red_light_tmp;
            DISPLAY_1 = 7'b000_0110; // E
            DISPLAY_2 = 7'b000_0110; // E 
        end
        VALID_PASSCODE: begin
            green_light_tmp = ~green_light_tmp;
            red_light_tmp = 1'b0;
            DISPLAY_1 = 7'b000_0010; // O
            DISPLAY_2 = 7'b100_0000; // K 
        end
        ROOM_LOCKED: begin
            green_light_tmp = 1'b0;
            red_light_tmp = ~red_light_tmp;
            DISPLAY_1 = 7'b001_0010; // N
            DISPLAY_2 = 7'b000_1100; // O
        end
    endcase
end

assign RED_LIGHT = red_light_tmp;
assign GREEN_LIGHT = green_light_tmp;

endmodule
