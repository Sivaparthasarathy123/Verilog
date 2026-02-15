// 1:8 Demux with enable
module demux1x8(
    input D,          
    input EN,         
    input [2:0] S,    
    output reg [7:0] Y
);
    always @(*) begin
      if (EN) begin
            Y = 8'b0;       
            Y[S] = D;
      end
      else
            Y = 8'b0;     
    end
endmodule

// Testbench
module demux1x8_tb;
    reg D, EN;
    reg [2:0] S;
    wire [7:0] Y;

    demux1x8 dut(D, EN, S, Y);

    integer i;
    initial begin
        $display("------ 1x8 Demux ------");
        $monitor("Time=%0t | D=%b | EN=%b | S=%b | Y=%b", $time, D, EN, S, Y);

      for(i = 0; i < 16; i++) begin
            D  = $urandom % 2;           
            EN = $urandom % 2;          
            S  = $urandom & 3'b111;     
            #10;
        end
        $finish;
    end
endmodule
