// CORDIC Algorithm
module cordic_agm #(
  parameter WIDTH = 18,
  parameter FRAC  = 14,
  parameter ITER  = 16
)(
  input clk,
  input rst,
  input start,
  input signed [WIDTH-1:0] angle_in,   
  output reg busy,
  output reg done,
  output reg signed [WIDTH-1:0] cos_out,   
  output reg signed [WIDTH-1:0] sin_out     
);

  localparam signed [WIDTH-1:0] K_INV   = 18'sd9949;   
  localparam signed [WIDTH-1:0] PI      = 18'sd51472;  
  localparam signed [WIDTH-1:0] HALF_PI = 18'sd25736;  

  reg signed [WIDTH-1:0] atan_table [0:ITER-1];

  integer i;

  initial begin
    for (i = 0; i < ITER; i = i + 1)
      atan_table[i] = 0;
  end

  reg signed [WIDTH-1:0] x, y, z;
  reg [$clog2(ITER+1)-1:0] idx;

  reg signed [WIDTH-1:0] x_next, y_next, z_next;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      busy    <= 1'b0;
      done    <= 1'b0;
      cos_out <= '0;
      sin_out <= '0;
      x       <= '0;
      y       <= '0;
      z       <= '0;
      idx     <= '0;
    end
    else begin
      done <= 1'b0;

      if (start && !busy) begin
        busy <= 1'b1;
        idx  <= 0;

        // To full quadrant handling [-pi, +pi] 
        if (angle_in > HALF_PI) begin
          x <= -K_INV;
          y <= 0;
          z <= angle_in - PI;
        end
        else if (angle_in < -HALF_PI) begin
          x <= -K_INV;
          y <= 0;
          z <= angle_in + PI;
        end
        else begin
          x <= K_INV;
          y <= 0;
          z <= angle_in;
        end
      end
      else if (busy) begin
        if (z >= 0) begin
          x_next = x - (y >>> idx);
          y_next = y + (x >>> idx);
          z_next = z - atan_table[idx];
        end
        else begin
          x_next = x + (y >>> idx);
          y_next = y - (x >>> idx);
          z_next = z + atan_table[idx];
        end

        x <= x_next;
        y <= y_next;
        z <= z_next;

        if (idx == ITER-1) begin
          busy    <= 1'b0;
          done    <= 1'b1;
          cos_out <= x_next;
          sin_out <= y_next;
        end

        idx <= idx + 1'b1;
      end
    end
  end

endmodule

// Testbench
module cordic_agm_tb;

  parameter WIDTH = 18;
  parameter FRAC  = 14;
  parameter ITER  = 16;

  reg clk;
  reg rst;
  reg start;
  reg signed [WIDTH-1:0] angle_in;
  wire busy;
  wire done;
  wire signed [WIDTH-1:0] cos_out;
  wire signed [WIDTH-1:0] sin_out;

  integer errors;

  real PI;
  real angle_real;
  real cos_real, sin_real;
  integer exp_cos, exp_sin;
  integer tol;

  cordic_agm #(.WIDTH(WIDTH),.FRAC(FRAC),.ITER(ITER)) dut (clk,rst,start,angle_in,busy,done,cos_out,sin_out);

  always #5 clk = ~clk;

  task run_angle;
    input signed [WIDTH-1:0] ang_fx;
    begin
      @(negedge clk);
      angle_in = ang_fx;
      start    = 1'b1;
      @(negedge clk);
      start    = 1'b0;

      wait(done == 1'b1);
      @(posedge clk);

      angle_real = ang_fx / (1.0 * (1 << FRAC));
      cos_real   = $cos(angle_real);
      sin_real   = $sin(angle_real);

      exp_cos = $rtoi(cos_real * (1 << FRAC));
      exp_sin = $rtoi(sin_real * (1 << FRAC));

      if ((cos_out > exp_cos + tol) || (cos_out < exp_cos - tol) ||
          (sin_out > exp_sin + tol) || (sin_out < exp_sin - tol)) begin
        $display("ERROR angle = %f rad exp_cos = %0d got_cos = %0d exp_sin = %0d got_sin = %0d",
                 angle_real, exp_cos, cos_out, exp_sin, sin_out);
        errors = errors + 1;
      end
      else begin
        $display("PASS angle = %f rad cos = %0d sin = %0d",
                 angle_real, cos_out, sin_out);
      end
    end
  endtask

  initial begin
    clk = 0;
    rst = 1;
    start = 0;
    angle_in = 0;
    errors = 0;
    tol = 8;
    PI = 3.14;

    $dumpfile("cordic.vcd");
    $dumpvars;
    #20 rst = 0;

    // 0
    run_angle(18'sd0);

    // +pi/6
    run_angle($rtoi((PI/6.0) * (1<<FRAC)));

    // +pi/4
    run_angle($rtoi((PI/4.0) * (1<<FRAC)));

    // -pi/4
    run_angle($rtoi((-PI/4.0) * (1<<FRAC)));

    // +pi/2
    run_angle($rtoi((PI/2.0) * (1<<FRAC)));

    // -pi/2
    run_angle($rtoi((-PI/2.0) * (1<<FRAC)));

    // +3pi/4
    run_angle($rtoi((3.0*PI/4.0) * (1<<FRAC)));

    // -3pi/4
    run_angle($rtoi((-3.0*PI/4.0) * (1<<FRAC)));

    if (errors == 0)
      $display("ALL CORDIC TESTS PASSED");
    else
      $display("CORDIC TEST FAILED, errors = %0d", errors);

    #20 $finish;
  end

  initial begin
    $dumpfile("cordic.vcd");
    $dumpvars;
  end

endmodule
