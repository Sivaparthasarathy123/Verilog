// MUX-based AND gate & MUX-based OR gate & MUX-based XOR gate

// MUX-based AND gate
module and_using_mux(
    input A, B,
    output Y
);
    assign Y = (A) ? B : 1'b0;
endmodule

// MUX-based OR gate
module or_using_mux(
    input A, B,
    output Y
);
    assign Y = (A) ? 1'b1 : B;
endmodule

// MUX-based XOR gate
module xor_using_mux(
    input A, B,
    output Y
);
    assign Y = (A) ? ~B : B;
endmodule

// Testbench
module mux_logic_tb;

    reg A, B;
    wire Y_and, Y_or, Y_xor;

    // Instantiate the MUX based gates
    and_using_mux u_and (.A(A), .B(B), .Y(Y_and));
    or_using_mux  u_or  (.A(A), .B(B), .Y(Y_or));
    xor_using_mux u_xor (.A(A), .B(B), .Y(Y_xor));

    integer i;
    initial begin
      $display("---------- MUX based Gates ----------------");

        for(i = 0; i < 4; i = i + 1) begin
            {A, B} = i;   
            #5;           
          $display("Time = %0t | A = %b | B = %b | AND = %b | OR = %b | XOR = %b", $time, A, B, Y_and, Y_or, Y_xor);
        end

        $finish;
    end

endmodule
