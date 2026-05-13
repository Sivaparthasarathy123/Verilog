// case equal vs logical equal 
module equality_operators;

  reg [3:0] a;
  reg [3:0] b;

  reg result_equal;
  reg result_case_equal;

  initial begin
    $dumpfile("equality_operators.vcd");
    $dumpvars;

    $display("Time |    a    |    b    |  a==b  | a===b ");

    // Normal equal values
    a = 4'b1010;
    b = 4'b1010;
    #10;
    check_result();

    // Normal different values
    a = 4'b1010;
    b = 4'b1000;
    #10;
    check_result();

    // Same X position
    a = 4'b10x1;
    b = 4'b10x1;
    #10;
    check_result();

    // Different because X compared with 0
    a = 4'b10x1;
    b = 4'b1001;
    #10;
    check_result();

    // Same Z position
    a = 4'b1z01;
    b = 4'b1z01;
    #10;
    check_result();

    // Z compared with X
    a = 4'b1z01;
    b = 4'b1x01;
    #10;
    check_result();

    // All unknown same
    a = 4'bxxxx;
    b = 4'bxxxx;
    #10;
    check_result();

    // All high impedance same
    a = 4'bzzzz;
    b = 4'bzzzz;
    #10;
    check_result();

    #20;
    $finish;
  end

  task check_result;
    begin
      result_equal      = (a == b);
      result_case_equal = (a === b);

      $display("%0t |  %b  |  %b  |   %b    |   %b",
               $time, a, b, result_equal, result_case_equal);
    end
  endtask

endmodule
