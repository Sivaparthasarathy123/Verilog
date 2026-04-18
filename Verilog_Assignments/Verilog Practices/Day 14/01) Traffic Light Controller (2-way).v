// Traffic Light Controller (2-way)
module traffic_light_2way (
  input clk,
  input rst,
  output reg [1:0] ns_light,  
  output reg [1:0] ew_light
);

  parameter S_NS_GREEN  = 2'd0,
            S_NS_YELLOW = 2'd1,
            S_EW_GREEN  = 2'd2,
            S_EW_YELLOW = 2'd3;

  parameter GREEN_TIME  = 5;
  parameter YELLOW_TIME = 2;

  reg [1:0] state;
  reg [3:0] count;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      state <= S_NS_GREEN;
      count <= 0;
    end
    else begin
      case (state)
        S_NS_GREEN: begin
          if (count == GREEN_TIME-1) begin
            state <= S_NS_YELLOW;
            count <= 0;
          end 
          else
            count <= count + 1;
        end

        S_NS_YELLOW: begin
          if (count == YELLOW_TIME-1) begin
            state <= S_EW_GREEN;
            count <= 0;
          end 
          else 
            count <= count + 1;
        end

        S_EW_GREEN: begin
          if (count == GREEN_TIME-1) begin
            state <= S_EW_YELLOW;
            count <= 0;
          end
          else
            count <= count + 1;
        end

        S_EW_YELLOW: begin
          if (count == YELLOW_TIME-1) begin
            state <= S_NS_GREEN;
            count <= 0;
          end
          else
            count <= count + 1;
        end

        default: begin
          state <= S_NS_GREEN;
          count <= 0;
        end
      endcase
    end
  end

  always @(*) begin
    ns_light = 2'b00;
    ew_light = 2'b00;
    case (state)
      S_NS_GREEN: begin
        ns_light = 2'b10;
        ew_light = 2'b00;
      end
      S_NS_YELLOW: begin
        ns_light = 2'b01;
        ew_light = 2'b00;
      end
      S_EW_GREEN: begin
        ns_light = 2'b00;
        ew_light = 2'b10;
      end
      S_EW_YELLOW: begin
        ns_light = 2'b00;
        ew_light = 2'b01;
      end
    endcase
  end

endmodule

// Testbench
module traffic_light_2way_tb;

  reg clk, rst;
  wire [1:0] ns_light, ew_light;

  traffic_light_2way dut (clk,rst,ns_light,ew_light);

  always #5 clk = ~clk;

  initial begin
    clk = 0; rst = 1;
    #12 rst = 0;

    #150;
    $finish;
  end

  initial begin
    $monitor("T = %0t rst = %b NS = %b EW = %b", $time, rst, ns_light, ew_light);
    $dumpfile("2way.vcd");
    $dumpvars;
  end

endmodule
