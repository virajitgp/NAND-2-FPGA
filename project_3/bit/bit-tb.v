`timescale 1ns / 1ps

module Bit_tb;
  reg  clk;
  reg  load;
  reg  in;
  wire out;

  // Instantiate the Bit module
  Bit dut (
      .clk (clk),
      .load(load),
      .in  (in),
      .out (out)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;  // 10ns period clock
  end

  // Test stimulus
  initial begin
    // Initialize
    load = 0;
    in   = 0;

    // Display header
    $display("Time\tload\tin\tout");
    $monitor("%0t\t%b\t%b\t%b", $time, load, in, out);

    // Test sequence
    #10 load = 1;
    in = 1;  // Load a 1
    #10 load = 0;
    in = 0;  // Should maintain the 1
    #10 load = 1;
    in = 0;  // Load a 0
    #10 load = 0;
    in = 1;  // Should maintain the 0
    #10 load = 1;
    in = 1;  // Load a 1 again

    // End simulation
    #10 $finish;
  end
endmodule
