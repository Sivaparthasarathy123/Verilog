// Barrel Shifter
module barrel_shifter (
  input  [7:0] data_in,
  input  [2:0] shift,     
  input  dir,       
  output reg [7:0] data_out
);

  always @(*) begin
    case (dir)
      1'b0: data_out = data_in << shift;  // left shift
      1'b1: data_out = data_in >> shift;  // right shift
    endcase
  end

endmodule

// Testbench
module barrel_shifter_tb;

  reg [7:0] data_in;
  reg [2:0] shift;
  reg dir;
  wire [7:0] data_out;

  barrel_shifter dut (data_in,shift,dir,data_out);

  integer i;
  initial begin
    $monitor("Time = %0t | data_in = %0b | shift = %0d | dir = %0b | data_out = %0b", $time, data_in, shift, dir, data_out);

    // left & right shifts
    data_in = $urandom;
    dir = $urandom; 
    for(i=0; i<8; i++)begin
      shift = i;
      #10;
    end

    #100;
    $finish;
  end

endmodule
