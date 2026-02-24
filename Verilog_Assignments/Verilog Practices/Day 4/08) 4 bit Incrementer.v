// 4-bit Incrementer
module incrementer_4bit (
    input  [3:0] A,
    output [3:0] Y
);
    assign Y = A + 1;
endmodule

// Testbench
module incrementer_4bit_tb;

    reg  [3:0] A;
    wire [3:0] Y;

    incrementer_4bit DUT (.A(A), .Y(Y));

    initial begin
      $monitor("A = %d -> Y = %d", A, Y);

        A = 4'd0;  #10;
        A = 4'd5;  #10;
        A = 4'd15; #10;

        $finish;
    end
endmodule
