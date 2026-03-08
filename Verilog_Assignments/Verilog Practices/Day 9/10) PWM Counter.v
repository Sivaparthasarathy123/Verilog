// PWM Counter
module pwm(
  input clk,
  input rst,
  input [7:0] duty_cycle,
  output reg pwm_out
);

  reg [7:0] counter;

  always @(posedge clk or posedge rst) begin
    if(rst)
      counter <= 0;
    else
      counter <= counter + 1;
  end

  always @(posedge clk) begin
    if(counter < duty_cycle)
      pwm_out <= 1;
    else
      pwm_out <= 0;
  end

endmodule

// Testbench
module pwm_tb;

  reg clk, rst;
  reg [7:0] duty_cycle;
  wire pwm_out;

  pwm dut(clk, rst, duty_cycle, pwm_out);

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $monitor("Time = %0t duty = %d pwm = %b", $time, duty_cycle, pwm_out);

    rst = 1;
    duty_cycle = 128;  

    #10 rst = 0;

    #100 duty_cycle = 64;   
    #100 duty_cycle = 192;  

    #200 $finish;
  end

endmodule
