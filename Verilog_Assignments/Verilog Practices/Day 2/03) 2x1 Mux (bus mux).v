// 2:1 MUX with tri-state buffer and 4-bit 2:1 MUX (bus mux)
module mux2x1_4bit(
    input [3:0] A, B,
    input S,
    output [3:0] Y
);
    assign Y = S ? B : A;
endmodule

// Testbench
module mux2x1_4bit_tb;

  reg [3:0] A, B;
  reg S;
  wire [3:0] Y;

  mux2x1_4bit dut(A, B, S, Y);

  integer i;
  initial begin
    $display("----------- 2x1 4-bit bus MUX -----------");
    $monitor("Time = %0t | A = %b | B = %b | S = %b | Y = %b", $time, A, B, S, Y);

    for(i = 0; i < 16; i++) begin
        A = $urandom & 4'b1111; 
        B = $urandom & 4'b1111;  
        S = $urandom % 2;        
        #10;
    end
    $finish;
  end

endmodule
