// 3-bit Gray Code Counter
module gray_counter_3bit (
    input clk,
    input rst,
    output reg [2:0] gray
);

    reg [2:0] binary;

    // Binary counter
    always @(posedge clk or posedge rst) begin
        if (rst)
            binary <= 3'b000;
        else
            binary <= binary + 1;
    end

    // Binary to Gray conversion
    always @(*) begin
        gray = binary ^ (binary >> 1);
    end

endmodule

// Testbench
module gray_counter_tb;

    reg clk;
    reg rst;
    wire [2:0] gray;

  gray_counter_3bit dut (clk,rst,dray);

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
      $monitor("Time = %0t clk = %b rst = %b gray = %b",$time,clk,rst,gray);

        rst = 1;
        #15 rst = 0;

        #100 $finish;
    end

endmodule
