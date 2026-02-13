// NAND, NOR, XOR, XNOR gates
module basic_gates_2 (
    input  a,
    input  b,
    output reg y_nand,
    output reg y_nor,
    output reg y_xor,
    output reg y_xnor
);

    always @(*) begin
        y_nand = ~(a & b);
        y_nor  = ~(a | b);
        y_xor  =   a ^ b;
        y_xnor = ~(a ^ b);
    end

endmodule

module basic_gates_2tb;

    reg a, b;
    wire y_nand, y_nor, y_xor, y_xnor;

    basic_gates_2 dut (
        .a(a),
        .b(b),
        .y_nand(y_nand),
        .y_nor(y_nor),
        .y_xor(y_xor),
        .y_xnor(y_xnor)
       );

    initial begin
      $display("a b | NAND NOR XOR XNOR");
      $monitor("%b %b |  %b   %b   %b   %b", a, b, y_nand, y_nor, y_xor, y_xnor);

        a = 0; b = 0; #10; 
        a = 0; b = 1; #10;
        a = 1; b = 0; #10;
        a = 1; b = 1; #10; 

        $finish;
    end

endmodule
