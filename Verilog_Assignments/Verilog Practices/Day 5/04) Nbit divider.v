// N bit Divider
module divider_Nbit #(parameter N = 8)(
  input [N-1:0] dividend,
  input [N-1:0] divisor,
  output reg [N-1:0] quotient,
  output reg [N-1:0] remainder
);

  always @(*) begin
    if(divisor != 0) begin
        quotient  = dividend / divisor;
        remainder = dividend % divisor;
    end
    else begin
        quotient = 0;
        remainder = 0;
    end
  end

endmodule

// Testbench
module divider_Nbit_tb;
  parameter N = 8;
  
  reg [N-1:0] dividend;
  reg [N-1:0] divisor;
  wire [N-1:0] quotient;
  wire [N-1:0] remainder;

  divider_Nbit #(N) dut (
    .dividend(dividend),
    .divisor(divisor),
    .quotient(quotient),
    .remainder(remainder)
 );

  // Test sequence
  initial begin
    $monitor("Time = %0t Dividend = %d Divider = %d Quotient = %d Remainder = %d", $time, dividend, divisor, quotient, remainder);

    // Normal division
    dividend = 8'd100; divisor = 8'd5; #10;

    // Dividend smaller than divisor
    dividend = 8'd7; divisor = 8'd10; #10;
    
    // Dividend equal to divisor
    dividend = 8'd25; divisor = 8'd25; #10;

    // Divisor is 1
    dividend = 8'd123; divisor = 8'd1; #10;

    // Divisor is 0 
    dividend = 8'd50; divisor = 8'd0; #10;

    // Maximum N-bit numbers
    dividend = {N{1'b1}}; divisor = 8'd15; #10; 

    $finish;
  end

endmodule
