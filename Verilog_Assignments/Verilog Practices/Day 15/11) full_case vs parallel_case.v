// Full vs Parallel Case - Synthesis Directives
module full_case_danger (
  input [1:0] sel,
  output reg [3:0] y
);

  always @(*) begin
    case (sel) // synthesis full_case
      2'b00: y = 4'b0001;
      2'b01: y = 4'b0010;
      2'b10: y = 4'b0100;
      // 2'b11 is not placed
    endcase
  end

endmodule

module full_case_safe (
  input [1:0] sel,
  output reg [3:0] y
);

  always @(*) begin
    case (sel)
      2'b00: y = 4'b0001;
      2'b01: y = 4'b0010;
      2'b10: y = 4'b0100;
      2'b11: y = 4'b1000;
      default: y = 4'b0000;
    endcase
  end

endmodule

module parallel_case_danger (
  input [3:0] irq,
  output reg [1:0] grant
);

  always @(*) begin
    casez (irq) // synthesis parallel_case
      4'b1???: grant = 2'd3;
      4'b?1??: grant = 2'd2;
      4'b??1?: grant = 2'd1;
      4'b???1: grant = 2'd0;
      default: grant = 2'd0;
    endcase
  end

endmodule

module priority_encoder_safe (
  input  wire [3:0] irq,
  output reg  [1:0] grant
);

  always @(*) begin
    if (irq[3])
      grant = 2'd3;
    else if (irq[2])
      grant = 2'd2;
    else if (irq[1])
      grant = 2'd1;
    else
      grant = 2'd0;
  end

endmodule

// Testbench
module case_pragmas;

  reg [1:0] sel;
  reg [3:0] irq;

  wire [3:0] y_full_danger;
  wire [3:0] y_full_safe;

  wire [1:0] grant_parallel_danger;
  wire [1:0] grant_safe;

  full_case_danger u_full_danger (
    .sel(sel),
    .y(y_full_danger)
  );

  full_case_safe u_full_safe (
    .sel(sel),
    .y(y_full_safe)
  );

  parallel_case_danger u_parallel_danger (
    .irq(irq),
    .grant(grant_parallel_danger)
  );

  priority_encoder_safe u_priority_safe (
    .irq(irq),
    .grant(grant_safe)
  );

  initial begin
    $dumpfile("case_pragmas.vcd");
    $dumpvars;

    $display("FULL_CASE TEST");
    $display("Time | sel | danger_y | safe_y");

    sel = 2'b00; #10;
    show_full_case();

    sel = 2'b01; #10;
    show_full_case();

    sel = 2'b10; #10;
    show_full_case();

    sel = 2'b11; #10;
    show_full_case();

    $display("");
    $display("PARALLEL_CASE TEST");
    $display("Time | irq  | parallel_case_grant | safe_priority_grant");

    irq = 4'b0001; #10;
    show_parallel_case();

    irq = 4'b0010; #10;
    show_parallel_case();

    irq = 4'b0100; #10;
    show_parallel_case();

    irq = 4'b1000; #10;
    show_parallel_case();

    irq = 4'b1100; #10;
    show_parallel_case();

    irq = 4'b0110; #10;
    show_parallel_case();

    #20;
    $finish;
  end

  task show_full_case;
    begin
      $display("%4t |  %b  |   %b   | %b",
               $time, sel, y_full_danger, y_full_safe);
    end
  endtask

  task show_parallel_case;
    begin
      $display("%4t | %b |        %0d          |        %0d",
               $time, irq, grant_parallel_danger, grant_safe);
    end
  endtask

endmodule
