`timescale 1ns/1ps

module Register_tb;
    reg clk;
    reg load;
    reg [15:0] in;
    wire [15:0] out;

    // Instantiate the Register module
    Register dut (
        .clk(clk),
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
        load = 0;
        in = 0;
        
        // Display header
        $display("Time\tload\tin\t\tout");
        $monitor("%0t\t%b\t%h\t%h", $time, load, in, out);
        
        // Test sequence
        #10 load = 1; in = 16'hAAAA;  // Load 0xAAAA
        #10 load = 0; in = 16'h5555;  // Should maintain 0xAAAA
        #10 load = 1; in = 16'h5555;  // Load 0x5555
        #10 load = 0; in = 16'hFFFF;  // Should maintain 0x5555
        #10 load = 1; in = 16'h1234;  // Load 0x1234
        
        // End simulation
        #10 $finish;
    end
endmodule

