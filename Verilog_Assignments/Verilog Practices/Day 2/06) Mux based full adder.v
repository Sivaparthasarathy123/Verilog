// MUX-based Full Adder
module full_adder_mux(
    input A, B, Cin,
    output Sum, Cout
);
    // Sum 
    assign Sum  = (A) ? (~B ^ Cin) : (B ^ Cin);
    // Cout
    assign Cout = (A & B) | (B & Cin) | (A & Cin);
endmodule

module full_adder_mux_tb;

    reg A, B, Cin;
    wire Sum, Cout;

    // Instantiate the DUT
    full_adder_mux dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Sum(Sum),
        .Cout(Cout)
    );

    integer i;
    initial begin
        $display("------- mux based full adder -------------");
        $monitor("Time = %0t | A = %b | B = %b | Cin = %b | Sum = %b | Cout = %b",$time, A, B, Cin, Sum, Cout);
        for (i = 0; i < 8; i++) begin
            {A, B, Cin} = i;   
            #5;                
        end

        $finish;
    end

endmodule

