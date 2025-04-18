// RAM4K_tb.v - Testbench for 4K-Register Memory
`timescale 1ns/1ps

module RAM4K_tb;
    reg clk;
    reg load;
    reg [11:0] address;
    reg [15:0] in;
    wire [15:0] out;

    // Instantiate the RAM4K module
    RAM4K dut (
        .clk(clk),
        .load(load),
        .address(address),
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
        address = 0;
        in = 0;
        
        // Display header
        $display("Time\tload\taddress\t\tin\t\tout");
        $monitor("%0t\t%b\t%d\t%h\t%h", $time, load, address, in, out);
        
        // Test various addresses across the range
        #10 load = 1; address = 0; in = 16'hA000;
        #10 load = 1; address = 1000; in = 16'hB111;
        #10 load = 1; address = 2500; in = 16'hC222;
        #10 load = 1; address = 4095; in = 16'hD333;
        
        // Read back
        #10 load = 0; address = 0;    // Should read 0xA000
        #10 load = 0; address = 1000; // Should read 0xB111
        #10 load = 0; address = 2500; // Should read 0xC222
        #10 load = 0; address = 4095; // Should read 0xD333
        
        // Update an existing address
        #10 load = 1; address = 2500; in = 16'hEEEE;
        #10 load = 0; address = 2500; // Should read 0xEEEE
        
        // End simulation
        #10 $finish;
    end
endmodule

