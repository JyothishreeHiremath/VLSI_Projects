`timescale 1ns/1ps

module tb_trafficlight;

  // Testbench signals
  reg clk;
  reg rst;
  wire [3:0] present_state, next_state;
  wire [3:0] out, out2, out3;

  // Instantiate DUT
  trafficlight dut (
    .clk(clk),
    .rst(rst),
    .present_state(present_state),
    .next_state(next_state),
    .out(out),
    .out2(out2),
    .out3(out3)
  );

  // Clock generation: 10ns period
  initial begin
    clk = 0;
    forever #5 clk = ~clk;  // 100MHz clock
  end

  // Stimulus
  initial begin
    // Monitor signals
    $monitor("Time=%0t | PS=%d | NS=%d | Road1(out)=%d | Road2(out2)=%d | Road3(out3)=%d | count=%0d",
             $time, present_state, next_state, out, out2, out3, dut.count);

    // Reset sequence
    rst = 1;
    #20;
    rst = 0;

    // Run simulation long enough to see multiple transitions
    #300;
    $finish;
  end

endmodule
