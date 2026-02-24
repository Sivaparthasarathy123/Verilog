// 8-bit Adder-Subtractor
module add_sub_8bit (
    input  [7:0] A, B,
    input  mode,   
    output [7:0] Result,
    output Cout
);

    wire [7:0] B_mod;

    assign B_mod = mode ? ~B : B;

    rca_8bit ADD_SUB (
        .A(A),
        .B(B_mod),
        .Cin(mode),
        .Sum(Result),
        .Cout(Cout)
    );

endmodule

// Testbench
module add_sub_8bit_tb;

    reg  [7:0] A, B;
    reg  mode;   
    wire [7:0] Result;
    wire Cout;

    add_sub_8bit DUT (
        .A(A),
        .B(B),
        .mode(mode),
        .Result(Result),
        .Cout(Cout)
    );

    initial begin
      $monitor("mode = %b A = %d B = %d -> Result = %d Cout = %b",
                  mode, A, B, Result, Cout);

        mode = 0; A = 8'd20; B = 8'd10; #10;  // Add
        mode = 1; A = 8'd20; B = 8'd10; #10;  // Sub
        mode = 0; A = 8'd255; B = 8'd1; #10;
        mode = 1; A = 8'd50;  B = 8'd100; #10;

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

// 8-bit Full Adder using generate
module rca_8bit (
    input  [7:0] A,
    input  [7:0] B,
    input  Cin,
    output [7:0] Sum,
    output Cout
);

    wire [8:0] carry;
    assign carry[0] = Cin;

    genvar i;
    generate
        for(i=0; i<8; i=i+1) begin : FA8
            full_adder FA (
                .a(A[i]),
                .b(B[i]),
                .cin(carry[i]),
                .sum(Sum[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate

    assign Cout = carry[8];

endmodule
