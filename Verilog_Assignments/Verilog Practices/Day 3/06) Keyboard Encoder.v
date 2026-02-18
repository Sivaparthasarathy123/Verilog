// Keyboard encoder (4x4 matrix)
module keyboard_encoder(
    input  [3:0] R,
    input  [3:0] C,
    output reg [3:0] key
);

always @(*) begin
    case ({R, C})
        8'b0001_0001: key = 4'd0;
        8'b0001_0010: key = 4'd1;
        8'b0001_0100: key = 4'd2;
        8'b0001_1000: key = 4'd3;

        8'b0010_0001: key = 4'd4;
        8'b0010_0010: key = 4'd5;
        8'b0010_0100: key = 4'd6;
        8'b0010_1000: key = 4'd7;

        8'b0100_0001: key = 4'd8;
        8'b0100_0010: key = 4'd9;
        8'b0100_0100: key = 4'd10;
        8'b0100_1000: key = 4'd11;

        8'b1000_0001: key = 4'd12;
        8'b1000_0010: key = 4'd13;
        8'b1000_0100: key = 4'd14;
        8'b1000_1000: key = 4'd15;

        default: key = 4'd0;
    endcase
end

endmodule

// Testbench
module keyboard_encoder_tb;

    reg  [3:0] R;
    reg  [3:0] C;
    wire [3:0] key;
  
    keyboard_encoder dut (
        .R(R),
        .C(C),
        .key(key)
    );
    
    integer i, j;
    initial begin
        $display("----------- 4x4 Keyboard Encoder Test -----------");
        $monitor(" Time = %0t | R = %b | C = %b |Key = %d", $time, R, C, key);

        R = 4'b0000;
        C = 4'b0000;
        #10;

      for (i = 0; i < 4; i++) begin
        for (j = 0; j < 4; j++) begin
                R = 4'b0001 << i;  
                C = 4'b0001 << j;  
                #10;
            end
        end

        #10;
        $finish;
    end

endmodule
