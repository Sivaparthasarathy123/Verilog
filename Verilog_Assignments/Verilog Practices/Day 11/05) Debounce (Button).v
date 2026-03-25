// Debounce (Button)
module debounce_button #(parameter COUNT_MAX = 500000)(
  input  clk,
  input  rst,
  input  noisy_btn,
  output reg pulse_out
);

  reg sync_0, sync_1;
  always @(posedge clk) begin
    sync_0 <= noisy_btn;
    sync_1 <= sync_0;
  end

  reg [$clog2(COUNT_MAX):0] count;
  reg clean_btn;
  reg btn_d;

  // Debounce logic
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      count     <= 0;
      clean_btn <= 0;
    end 
    else if (sync_1 != clean_btn) begin
      count <= count + 1;
      if (count >= COUNT_MAX) begin
        clean_btn <= sync_1;
        count <= 0;
      end
    end 
    else begin
      count <= 0;
    end
  end

  // Rising edge detector
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      btn_d     <= 0;
      pulse_out <= 0;
    end else begin
      pulse_out <= clean_btn & ~btn_d;
      btn_d     <= clean_btn;
    end
  end

endmodule


// Testbench
module debounce_button_tb;

  reg clk, rst;
  reg noisy_btn;
  wire pulse_out;

  debounce_button #(10) DUT (clk,rst,noisy_btn,pulse_out);

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    rst=1; noisy_btn=0;
    #20 rst=0;

    #10 noisy_btn=1;
    #10 noisy_btn=0;
    #10 noisy_btn=1;
    #100;

    #50 noisy_btn=0;
    #200 $finish;
  end

  initial begin
    $monitor("Time=%0t noisy=%b pulse=%b", $time, noisy_btn, pulse_out);
    $dumpfile("switch.vcd");
    $dumpvars;
  end

endmodule
