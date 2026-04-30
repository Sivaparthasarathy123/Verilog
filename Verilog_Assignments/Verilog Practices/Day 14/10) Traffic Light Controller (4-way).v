// Traffic Light Controller (4-way)
module traffic_light_4way (
  input clk,
  input rst,
  output reg [1:0] north_light,
  output reg [1:0] east_light,
  output reg [1:0] south_light,
  output reg [1:0] west_light
);

  parameter N_GREEN  = 3'd0,
            N_YELLOW = 3'd1,
            E_GREEN  = 3'd2,
            E_YELLOW = 3'd3,
            S_GREEN  = 3'd4,
            S_YELLOW = 3'd5,
            W_GREEN  = 3'd6,
            W_YELLOW = 3'd7;

  parameter GREEN_TIME  = 4;
  parameter YELLOW_TIME = 2;

  reg [2:0] state;
  reg [3:0] count;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      state <= N_GREEN;
      count <= 0;
    end 
    else begin
      case (state)
        N_GREEN:  if (count == GREEN_TIME-1)  begin
          state <= N_YELLOW;
          count <= 0;
        end
        else
          count <= count + 1;
        N_YELLOW: if (count == YELLOW_TIME-1) begin
          state <= E_GREEN;
          count <= 0;
        end
        else
          count <= count + 1;
        E_GREEN:  if (count == GREEN_TIME-1)  begin 
          state <= E_YELLOW;
          count <= 0;
        end
        else
          count <= count + 1;
        E_YELLOW: if (count == YELLOW_TIME-1) begin 
          state <= S_GREEN;
          count <= 0;
        end
        else
          count <= count + 1;
        S_GREEN:  if (count == GREEN_TIME-1)  begin 
          state <= S_YELLOW;
          count <= 0;
        end
        else
          count <= count + 1;
        S_YELLOW: if (count == YELLOW_TIME-1) begin
          state <= W_GREEN;
          count <= 0;
        end
        else
          count <= count + 1;
        W_GREEN:  if (count == GREEN_TIME-1)  begin
          state <= W_YELLOW;
          count <= 0;
        end
        else
          count <= count + 1;
        W_YELLOW: if (count == YELLOW_TIME-1) begin
          state <= N_GREEN;
          count <= 0;
        end
        else
          count <= count + 1;
        default: begin 
          state <= N_GREEN; 
          count <= 0;
        end
      endcase
    end
  end

  always @(*) begin
    north_light = 2'b00;
    east_light  = 2'b00;
    south_light = 2'b00;
    west_light  = 2'b00;

    case (state)
      N_GREEN:  north_light = 2'b10;
      N_YELLOW: north_light = 2'b01;
      E_GREEN:  east_light  = 2'b10;
      E_YELLOW: east_light  = 2'b01;
      S_GREEN:  south_light = 2'b10;
      S_YELLOW: south_light = 2'b01;
      W_GREEN:  west_light  = 2'b10;
      W_YELLOW: west_light  = 2'b01;
    endcase
  end

endmodule

// Testbench
module traffic_light_4way_tb;

  reg clk, rst;
  wire [1:0] north_light, east_light, south_light, west_light;

  traffic_light_4way dut (clk, rst, north_light, east_light, south_light, west_light);

  always #5 clk = ~clk;

  initial begin
    clk = 0;
    rst = 1;
    #15 rst = 0;
    #250 $finish;
  end

  initial begin
    $monitor("T = %0t N = %b E = %b S = %b W = %b",$time, north_light, east_light, south_light, west_light);
    $dumpfile("4way_traffic.vcd");
    $dumpvars;
  end

endmodule
