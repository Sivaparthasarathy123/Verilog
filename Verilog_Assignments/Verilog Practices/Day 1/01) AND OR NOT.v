// AND, OR, NOT gates
module basic_gates (
    input  a,
    input  b,
    output reg y_and,
    output reg y_or,
    output reg y_not
);

    always @(*) begin
        y_and = a & b;
        y_or  = a | b;
        y_not = ~a;
    end

endmodule

module basic_gates_tb;

    reg a, b;
    wire y_and, y_or, y_not;

    basic_gates dut (
        .a(a),
        .b(b),
        .y_and(y_and),
        .y_or(y_or),
        .y_not(y_not)
    );

    initial begin
      $display("a b | AND OR NOT");
      $monitor("%b %b |  %b   %b   %b", a, b, y_and, y_or, y_not);

        a = 0; b = 0; #10; 
        a = 0; b = 1; #10;
        a = 1; b = 0; #10;
        a = 1; b = 1; #10; 

        $finish;
    end

endmodule
