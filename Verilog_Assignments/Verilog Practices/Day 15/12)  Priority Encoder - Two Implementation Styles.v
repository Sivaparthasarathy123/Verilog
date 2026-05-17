// Priority Encoder - Two Implementation Styles
module priority_encoder_ifelse (
  input [3:0] in,
  output reg [1:0] y,
  output reg valid
);

  always @(*) begin
    valid = 1'b1;

    if (in[3])
      y = 2'd3;
    else if (in[2])
      y = 2'd2;
    else if (in[1])
      y = 2'd1;
    else if (in[0])
      y = 2'd0;
    else begin
      y = 2'd0;
      valid = 1'b0;
    end
  end

endmodule

module priority_encoder_case (
  input [3:0] in,
  output reg [1:0] y,
  output reg valid
);

  always @(*) begin
    valid = 1'b1;

    casez (in)
      4'b1???: y = 2'd3;
      4'b01??: y = 2'd2;
      4'b001?: y = 2'd1;
      4'b0001: y = 2'd0;
      default: begin
        y = 2'd0;
        valid = 1'b0;
      end
    endcase
  end

endmodule

// Testbench
module priority_encoder_4bit_tb;

  reg  [3:0] in;

  wire [1:0] y_ifelse;
  wire       valid_ifelse;

  wire [1:0] y_case;
  wire       valid_case;

  reg  [1:0] expected_y;
  reg        expected_valid;

  integer i;

  priority_encoder_ifelse dut_ifelse (
    .in(in),
    .y(y_ifelse),
    .valid(valid_ifelse)
  );

  priority_encoder_case dut_case (
    .in(in),
    .y(y_case),
    .valid(valid_case)
  );

  initial begin
    $dumpfile("priority_encoder_4bit.vcd");
    $dumpvars;
    for (i = 0; i < 16; i = i + 1) begin
      in = i[3:0];
      #10;
      calculate_expected();
      check_result();
    end

    #20;
    $finish;
  end

  task calculate_expected;
    begin
      if (in[3]) begin
        expected_y = 2'd3;
        expected_valid = 1'b1;
      end
      else if (in[2]) begin
        expected_y = 2'd2;
        expected_valid = 1'b1;
      end
      else if (in[1]) begin
        expected_y = 2'd1;
        expected_valid = 1'b1;
      end
      else if (in[0]) begin
        expected_y = 2'd0;
        expected_valid = 1'b1;
      end
      else begin
        expected_y = 2'd0;
        expected_valid = 1'b0;
      end
    end
  endtask

  task check_result;
    begin
      $display("Time = %0t | in = %b | y_ifelse = %0d | valid_ifelse = %b |   y_case = %0d | valid_case = %b | expected_y = %0d | expected_valid = %b",
               $time, in, y_ifelse, valid_ifelse, y_case, valid_case, expected_y, expected_valid);

      if ((y_ifelse == expected_y) && (valid_ifelse == expected_valid) && (y_case == expected_y) && (valid_case == expected_valid))
        $display("PASS");
      else
        $display("FAIL");
    end
  endtask

endmodule
