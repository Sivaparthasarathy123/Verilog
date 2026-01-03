// Elevator Controller
`timescale 1ns/1ps
module elevator_controller(
    input clk,
    input rst,
    input [1:0] x,          
    input [1:0] current_floor, 
    output reg [1:0] floor_display,
    output reg door_open,
    output reg moving_up,
    output reg moving_down);

    parameter IDLE       = 3'd0,
              MOVE_UP    = 3'd1,
              MOVE_DOWN  = 3'd2,
              DOOR_OPEN  = 3'd3,
              DOOR_CLOSE = 3'd4,
              DOOR_TIME  = 3'd5;
    reg [2:0] state, next_state;
    reg [3:0] timer;   

    always@(posedge clk)begin
        if(!rst)begin
            state <= IDLE;
            timer <= 0;
        end
        else begin
            state <= next_state;

            if (state == DOOR_OPEN)
                timer <= timer + 1;
            else
                timer <= 0;
        end
    end

    always@(*)begin
        next_state = state; //Default states
        door_open  = 0;
        moving_up  = 0;
        moving_down = 0;
        floor_display = current_floor;

        case(state)
            IDLE: begin
                if (x > current_floor)
                    next_state = MOVE_UP;
                else if (x < current_floor)
                    next_state = MOVE_DOWN;
                else
                    next_state = DOOR_OPEN; 
            end

            MOVE_UP: begin
                moving_up = 1;
                if (x == current_floor)
                    next_state = DOOR_OPEN;
                else
                    next_state = MOVE_UP;
            end

            MOVE_DOWN: begin
                moving_down = 1;
                if (x == current_floor)
                    next_state = DOOR_OPEN;
                else
                    next_state = MOVE_DOWN;
            end

            DOOR_OPEN: begin
                door_open = 1;
                if (timer > DOOR_TIME)
                    next_state = DOOR_CLOSE;
            end

            DOOR_CLOSE: begin
                door_open = 0;
                next_state = IDLE;
            end
        endcase
    end

endmodule

          
           
         
                

