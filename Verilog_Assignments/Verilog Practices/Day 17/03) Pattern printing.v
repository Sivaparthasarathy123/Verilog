// Pattern printing    
module pattern;

  integer i, j, k;
  parameter N = 5;

  initial begin

    // Upper pyramid
    for(i = 1; i <= N; i = i + 1) begin

      // spaces
      for(j = 1; j <= N - i; j = j + 1)
        $write(" ");

      // numbers
      for(k = 1; k <= i; k = k + 1)
        $write("%0d ", i);

      $display("");
    end

    // Lower pyramid
    for(i = N-1; i >= 1; i = i - 1) begin

      // spaces
      for(j = 1; j <= N - i; j = j + 1)
        $write(" ");

      // numbers
      for(k = 1; k <= i; k = k + 1)
        $write("%0d ", i);

      $display("");
    end

  end

endmodule
