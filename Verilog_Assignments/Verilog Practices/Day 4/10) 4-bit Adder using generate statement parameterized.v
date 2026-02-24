// 4-bit Adder using generate statement parameterized
module adder_nbit #(parameter N=4)(
    input  [N-1:0] A, B,
    input  Cin,
    output [N-1:0] Sum,
    output Cout
);

    wire [N:0] carry;
    assign carry[0] = Cin;

    genvar i;
    generate
        for(i=0; i<N; i=i+1) begin : GEN_ADD
            full_adder FA (
                .a(A[i]),
                .b(B[i]),
                .cin(carry[i]),
                .sum(Sum[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate

    assign Cout = carry[N];

endmodule

// Testbench
module adder_nbit_tb;

    parameter N = 4;

    reg  [N-1:0] A, B;
    reg  Cin;
    wire [N-1:0] Sum;
    wire Cout;

    adder_nbit #(N) DUT (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Sum(Sum),
        .Cout(Cout)
    );

    initial begin
      $monitor("A = %b B = %b Cin = %b -> Sum = %b Cout = %b", A, B, Cin, Sum, Cout);

        A = 4'd3;  B = 4'd2;  Cin = 0; #10;
        A = 4'd7;  B = 4'd8;  Cin = 0; #10;
        A = 4'd15; B = 4'd1;  Cin = 1; #10;

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
