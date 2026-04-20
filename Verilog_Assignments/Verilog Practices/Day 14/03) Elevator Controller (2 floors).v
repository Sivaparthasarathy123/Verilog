// Elevator Controller (2 floors)
module elevator_2floor (
  input clk,
  input rst,
  input req0,
  input req1,
  output reg  floor,      // 0 or 1
  output reg  moving,
  output reg  door_open
);

  parameter IDLE      = 2'd0,
            MOVE_UP   = 2'd1,
            MOVE_DOWN = 2'd2,
            DOOR      = 2'd3;

  reg [1:0] state;
  reg [1:0] door_cnt;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      state    <= IDLE;
      floor    <= 1'b0;
      moving   <= 1'b0;
      door_open<= 1'b0;
      door_cnt <= 0;
    end 
    else begin
      case (state)
        IDLE: begin
          moving    <= 0;
          door_open <= 0;
          door_cnt  <= 0;

          if (floor == 0 && req1) begin
            state  <= MOVE_UP;
            moving <= 1;
          end
          else if (floor == 1 && req0) begin
            state  <= MOVE_DOWN;
            moving <= 1;
          end
          else if ((floor == 0 && req0) || (floor == 1 && req1)) begin
            state <= DOOR;
            door_open <= 1;
          end
        end

        MOVE_UP: begin
          floor     <= 1'b1;
          moving    <= 0;
          state     <= DOOR;
          door_open <= 1;
          door_cnt  <= 0;
        end

        MOVE_DOWN: begin
          floor     <= 1'b0;
          moving    <= 0;
          state     <= DOOR;
          door_open <= 1;
          door_cnt  <= 0;
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
      endcase
    end
  end

endmodule

// Testbench
module elevator_2floor_tb;

  reg clk, rst, req0, req1;
  wire floor, moving, door_open;

  elevator_2floor dut (
    .clk(clk),
    .rst(rst),
    .req0(req0),
    .req1(req1),
    .floor(floor),
    .moving(moving),
    .door_open(door_open)
  );

  always #5 clk = ~clk;

  initial begin
    clk = 0; rst = 1; req0 = 0; req1 = 0;
    #12 rst = 0;

    // request floor 1
    #10 req1 = 1;
    #10 req1 = 0;

    // request floor 0
    #50 req0 = 1;
    #10 req0 = 0;

    #80 $finish;
  end

  initial begin
    $monitor("T = %0t req0 = %b req1 = %b floor = %b moving = %b door = %b",$time, req0, req1, floor, moving, door_open);
    $dumpfile("elevator.vcd");
    $dumpvars;
  end

endmodule
