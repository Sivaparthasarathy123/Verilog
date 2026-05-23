// for loop registers
module shift_register_for #(
  parameter N = 8
)(
  input clk,
  input rst,
  input din,
  output dout,
  output reg [N-1:0] shift_reg
);

  integer i;

  always @(posedge clk) begin
    if (rst) begin
      shift_reg <= {N{1'b0}};
    end
    else begin
      shift_reg[0] <= din;

      for (i = 1; i < N; i = i + 1) begin
        shift_reg[i] <= shift_reg[i-1];
      end
    end
  end

  assign dout = shift_reg[N-1];

endmodule

// Testbench
module shift_register_for_tb;

  parameter N = 8;

  reg clk;
  reg rst;
  reg din;

  wire dout;
  wire [N-1:0] shift_reg;

  reg [N-1:0] expected_shift;
  integer i;

  shift_register_for #(
    .N(N)
  ) dut (
    .clk(clk),
    .rst(rst),
    .din(din),
    .dout(dout),
    .shift_reg(shift_reg)
  );

  always #5 clk = ~clk;

  initial begin
    $dumpfile("shift_register_for.vcd");
    $dumpvars;

    clk = 0;
    rst = 1;
    din = 0;
    expected_shift = 0;

    #12;
    rst = 0;

    // register pattern
    apply_bit(1'b1);
    apply_bit(1'b0);
    apply_bit(1'b1);
    apply_bit(1'b1);
    apply_bit(1'b0);
    apply_bit(1'b1);
    apply_bit(1'b0);
    apply_bit(1'b1);

    // shifting zeros continously
    apply_bit(1'b0);
    apply_bit(1'b0);
    apply_bit(1'b0);

    #20;
    $finish;
  end

  task apply_bit;
    input bit_value;
    begin
      @(negedge clk);
      din = bit_value;

      @(posedge clk);
      expected_shift = {expected_shift[N-2:0], bit_value};

      #1;
      check_result();
    end
  endtask

  task check_result;
    begin
      $display("Time = %0t | din = %b | shift_reg = %b | dout = %b | expected = %b", $time, din, shift_reg, dout, expected_shift);

      if (shift_reg == expected_shift)
        $display("PASS");
      else
        $display("FAIL");
    end
  endtask

endmodule
