module Traffic_signal_4way(
  input clk, rst,
  output reg [2:0] way1, way2, way3, way4);
  
parameter GREEN_SIGNAL   = 30;          // 30 seconds
parameter YELLOW_SIGNAL  = 5;           // 5 seconds
parameter TOTAL_TIME     = GREEN_SIGNAL + YELLOW_SIGNAL;  //35 seconds

parameter [2:0] S_OFF = 3'b000,
                S_W1  = 3'b001,
                S_W2  = 3'b010,
                S_W3  = 3'b011,
                S_W4  = 3'b100;

reg [2:0] state, next_state;
reg [31:0] timer;

// state transition
always@(posedge clk)begin
    if (!rst)
        state <= S_OFF;
    else
        state <= next_state;
end

// timer logic
always@(posedge clk)begin
    if (!rst)
        timer <= 0;
    else if (timer >= TOTAL_TIME)
        timer <= 0;
    else
        timer <= timer + 1;
end

// next state logic
always @(*) begin
    next_state = state;
    case (state)
        S_OFF: next_state = S_W1;
        S_W1: if (timer >= TOTAL_TIME) next_state = S_W2;
        S_W2: if (timer >= TOTAL_TIME) next_state = S_W3;
        S_W3: if (timer >= TOTAL_TIME) next_state = S_W4;
        S_W4: if (timer >= TOTAL_TIME) next_state = S_W1;
        default: next_state = S_OFF;
    endcase
end

// output logic
always@(*)begin
    way1 = 3'b000; way2 = 3'b000; way3 = 3'b000; way4 = 3'b000;
    case (state)
        S_W1: begin
            way1 = (timer < GREEN_SIGNAL) ? 3'b001 :
                   (timer < TOTAL_TIME) ? 3'b010 : 3'b100;
            way2 = 3'b100; way3 = 3'b100; way4 = 3'b100;
        end
        S_W2: begin
            way2 = (timer < GREEN_SIGNAL) ? 3'b001 :
                   (timer < TOTAL_TIME) ? 3'b010 : 3'b100;
            way1 = 3'b100; way3 = 3'b100; way4 = 3'b100;
        end
        S_W3: begin
            way3 = (timer < GREEN_SIGNAL) ? 3'b001 :
                   (timer < TOTAL_TIME) ? 3'b010 : 3'b100;
            way1 = 3'b100; way2 = 3'b100; way4 = 3'b100;
        end
        S_W4: begin
            way4 = (timer < GREEN_SIGNAL) ? 3'b001 :
                   (timer < TOTAL_TIME) ? 3'b010 : 3'b100;
            way1 = 3'b100; way2 = 3'b100; way3 = 3'b100;
        end
    endcase
end

endmodule

