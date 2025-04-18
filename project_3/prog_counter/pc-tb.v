// PC_tb.v - Testbench for Program Counter
`timescale 1ns/1ps

module PC_tb;
    reg clk;
    reg reset;
    reg inc;
    reg load;
    reg [15:0] in;
    wire [15:0] out;

    // Instantiate the PC module
    PC dut (
        .clk(clk),
        .reset(reset),
        .inc(inc),
        .load(load),
        .in(in),
        .out(out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns period clock
    end

    // Test stimulus
    initial begin
        // Initialize
        reset = 0;
        inc = 0;
        load = 0;
        in = 0;
        
        // Display header
        $display("Time\treset\tinc\tload\tin\t\tout");
        $monitor("%0t\t%b\t%b\t%b\t%h\t%h", $time, reset, inc, load, in, out);
        
        // Test sequence
        #10 reset = 1;                      // Reset to 0
        #10 reset = 0; inc = 1;             // Start incrementing
        #10;                                // Continue incrementing
        #10;                                // Continue incrementing
        #10 inc = 0; load = 1; in = 16'h100; // Load value 0x100
        #10 load = 0; inc = 1;              // Start incrementing from 0x100
        #10;                                // Continue incrementing
        #10 reset = 1;                      // Reset to 0
        #10 reset = 0;                      // Stay at 0
        
        // End simulation
        #10 $finish;
    end
endmodule

