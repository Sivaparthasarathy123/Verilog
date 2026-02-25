// 4-bit Multiplier (array)
module array_multiplier_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output [7:0] P
);

  wire [3:0] pp0, pp1, pp2, pp3;
  wire [5:0] s1;
  wire [6:0] s2;

  assign pp0 = A & {4{B[0]}};
  assign pp1 = A & {4{B[1]}};
  assign pp2 = A & {4{B[2]}};
  assign pp3 = A & {4{B[3]}};

  assign s1 = {1'b0,pp0} + {pp1,1'b0};     
  assign s2 = s1 + {pp2,2'b00};            
  assign P  = s2 + {pp3,3'b000};           

endmodule

// Testbench
module array_multiplier_tb;

  reg [3:0] A,B;
  wire [7:0] P;

  array_multiplier_4bit dut(A,B,P);

  initial begin
    $monitor(" A = %d B = %d -> P = %d", A,B,P);
    
    A = 4'd3; B = 4'd5; #10;
    A = 4'd7; B = 4'd8; #10;
    A = 4'd15; B = 4'd15; #10;
    
    $finish;
  end

endmodule  
