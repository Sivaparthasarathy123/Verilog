// 4-bit Subtractor using 2's complement
module subtractor_4bit (
    input  [3:0] A, B,
    output [3:0] Diff,
    output Borrow
);

    wire [3:0] B_comp;
    assign B_comp = ~B;

    rca_4bit ADD (
        .A(A),
        .B(B_comp),
        .Cin(1'b1),
        .Sum(Diff),
        .Cout(Borrow)
    );

endmodule

// Testbench
module subtractor_4bit_tb;

    reg  [3:0] A, B;
    wire [3:0] Diff;
    wire Borrow;

    subtractor_4bit DUT (
        .A(A),
        .B(B),
        .Diff(Diff),
        .Borrow(Borrow)
    );

    initial begin
      $monitor("A = %d B = %d -> Diff = %d Borrow = %b", A, B, Diff, Borrow);

        A = 4'd10; B = 4'd3;  #10;
        A = 4'd5;  B = 4'd7;  #10;
        A = 4'd15; B = 4'd15; #10;
        A = 4'd8;  B = 4'd2;  #10;

        $finish;
    end
endmodule

// 1-bit Full Adder
module full_adder (
    input  a, b, cin,
    output sum, cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

// 4-bit Ripple Carry Adder using generate
module rca_4bit (
    input  [3:0] A,
    input  [3:0] B,
    input  Cin,
    output [3:0] Sum,
    output Cout
);

    wire [4:0] carry;
    assign carry[0] = Cin;

    genvar i;
    generate
        for(i=0; i<4; i=i+1) begin : FA_BLOCK
            full_adder FA (
                .a(A[i]),
                .b(B[i]),
                .cin(carry[i]),
                .sum(Sum[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate

    assign Cout = carry[4];

endmodule
