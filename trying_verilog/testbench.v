`timescale 1ns / 1ps

module testbench;
  reg clk, rst;
  wire [3:0] count;

  // Instantiate the counter
  counter uut (
      .clk  (clk),
      .rst  (rst),
      .count(count)
  );

  // Clock generation
  always #5 clk = ~clk;  // 10ns period

  initial begin
    $dumpfile("counter.vcd");
    $dumpvars(0, testbench);

    clk = 0;
    rst = 1;  // Reset the counter
    #10 rst = 0;  // Release reset

    #100;  // Run simulation for 100ns
    $finish;
  end
endmodule
