// Elevator Controller (4 floors)
module elevator_4floor (
  input clk,
  input rst,
  input [3:0] request,
  output reg [1:0] floor,
  output reg moving,
  output reg door_open
);

  parameter IDLE = 2'd0,
            MOVE = 2'd1,
            DOOR = 2'd2;

  reg [1:0] state;
  reg [1:0] target_floor;
  reg [1:0] door_cnt;

  function [1:0] first_request;
    input [3:0] req;
    begin
      if (req[0])
        first_request = 2'd0;
      else if (req[1])
        first_request = 2'd1;
      else if (req[2])
        first_request = 2'd2;
      else if (req[3])
        first_request = 2'd3;
      else
        first_request = 2'd0;
    end
  endfunction

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      state       <= IDLE;
      floor       <= 2'd0;
      target_floor<= 2'd0;
      moving      <= 1'b0;
      door_open   <= 1'b0;
      door_cnt    <= 2'd0;
    end 
    else begin
      case (state)
        IDLE: begin
          moving    <= 0;
          door_open <= 0;
          door_cnt  <= 0;

          if (request != 4'b0000) begin
            target_floor <= first_request(request);
            if (first_request(request) == floor) begin
              state <= DOOR;
              door_open <= 1;
            end
            else begin
              state <= MOVE;
              moving <= 1;
            end
          end
        end

        MOVE: begin
          moving <= 1;
          if (floor < target_floor)
            floor <= floor + 1;
          else if (floor > target_floor)
            floor <= floor - 1;

          if (((floor + 1) == target_floor && floor < target_floor) ||
              ((floor - 1) == target_floor && floor > target_floor)) begin
            state     <= DOOR;
            moving    <= 0;
            door_open <= 1;
            door_cnt  <= 0;
          end
        end

        DOOR: begin
          door_open <= 1;
          if (door_cnt == 2) begin
            door_open <= 0;
            state <= IDLE;
            door_cnt <= 0;
          end 
          else begin
            door_cnt <= door_cnt + 1;
          end
        end

        default: state <= IDLE;
      endcase
    end
  end

endmodule

// Testbench
module elevator_4floor_tb;

  reg clk, rst;
  reg [3:0] request;
  wire [1:0] floor;
  wire moving, door_open;

  elevator_4floor dut (
    .clk(clk),
    .rst(rst),
    .request(request),
    .floor(floor),
    .moving(moving),
    .door_open(door_open)
  );

  always #5 clk = ~clk;

  initial begin
    clk = 0; rst = 1; request = 4'b0000;
    #12 rst = 0;

    // request floor 2
    #10 request = 4'b0100;
    #10 request = 4'b0000;

    // request floor 3
    #60 request = 4'b1000;
    #10 request = 4'b0000;

    // request floor 0
    #70 request = 4'b0001;
    #10 request = 4'b0000;

    #120 $finish;
  end

  initial begin
    $monitor("T = %0t request = %b floor = %0d moving = %b door = %b",
             $time, request, floor, moving, door_open);
    $dumpfile("ele_4floors.vcd");
    $dumpvars;
  end

endmodule
