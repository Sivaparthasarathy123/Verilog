// Decoder based full adder
module full_adder_decoder (
    input  A,
    input  B,
    input  Cin,
    output Sum,
    output Carry
);

  wire [7:0] D;

  assign D = 1 << {A,B,Cin};

  assign Sum   = D[1] | D[2] | D[4] | D[7];
  assign Carry = D[3] | D[5] | D[6] | D[7];

endmodule

// Testbench 
module full_adder_decoder_tb;

reg A, B, Cin;
wire Sum, Carry;

full_adder_decoder dut (
    .A(A),
    .B(B),
    .Cin(Cin),
    .Sum(Sum),
    .Carry(Carry)
);

integer i;
initial begin
    $display("------- Decoder based full adder -------- ");
    $monitor("A = %b | B = %b | C = %b | Sum =  %b | Carry = %b", A, B, Cin, Sum, Carry);
    for (i = 0; i < 8; i++) begin
        {A, B, Cin} = i;
        #10;

        if (Sum !== (A ^ B ^ Cin))
            $display("ERROR in SUM");

        if (Carry !== ((A&B) | (B&Cin) | (A&Cin)))
            $display("ERROR in CARRY");
    end

    $display("Simulation Completed");
    $finish;
end

endmodule
