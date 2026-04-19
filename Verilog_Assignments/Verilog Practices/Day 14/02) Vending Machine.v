// Vending Machine
module vending_machine (
  input clk,
  input rst,
  input coin5,
  input coin10,
  output reg dispense,
  output reg change
);

  parameter S0  = 2'd0,  // 0
            S5  = 2'd1,  // 5
            S10 = 2'd2,  // 10
            S15 = 2'd3;  // temporary dispense state

  reg [1:0] state, next_state;

  always @(posedge clk or posedge rst) begin
    if (rst)
      state <= S0;
    else
      state <= next_state;
  end

  always @(*) begin
    next_state = state;
    dispense   = 1'b0;
    change     = 1'b0;

    case (state)
      S0: begin
        if (coin5) 
          next_state = S5;
        else if 
          (coin10) next_state = S10;
      end

      S5: begin
        if (coin5)
          next_state = S10;
        else if
          (coin10) next_state = S15;
      end

      S10: begin
        if (coin5) begin
          next_state = S15;
        end
        else if 
          (coin10) begin
          next_state = S15;
          change = 1'b1;
        end
      end

      S15: begin
        dispense   = 1'b1;
        next_state = S0;
      end

      default: next_state = S0;
    endcase
  end

endmodule

// Testbench
module vending_machine_tb;

  reg clk, rst, coin5, coin10;
  wire dispense, change;

  vending_machine dut (clk,rst,coin5,coin10,dispense,change);

  always #5 clk = ~clk;

  task insert_5;
    begin
      coin5 = 1; coin10 = 0;
      #10;
      coin5 = 0; coin10 = 0;
      #10;
    end
  endtask

  task insert_10;
    begin
      coin5 = 0; coin10 = 1;
      #10;
      coin5 = 0; coin10 = 0;
      #10;
    end
  endtask

  initial begin
    clk = 0; rst = 1; coin5 = 0; coin10 = 0;
    #12 rst = 0;

    // 5 + 10 = 15
    insert_5;
    insert_10;

    // 10 + 10 = 20 => dispense + change
    insert_10;
    insert_10;

    // 5 + 5 + 5 = 15
    insert_5;
    insert_5;
    insert_5;

    #30 $finish;
  end

  initial begin
    $monitor("T = %0t coin5 = %b coin10 = %b dispense = %b change = %b",
             $time, coin5, coin10, dispense, change);
    $dumpfile("vending.vcd");
    $dumpvars;
  end

endmodule
