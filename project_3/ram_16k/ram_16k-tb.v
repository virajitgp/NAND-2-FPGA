// RAM16K_tb.v - Testbench for 16K-Register Memory
`timescale 1ns/1ps

module RAM16K_tb;
    reg clk;
    reg load;
    reg [13:0] address;
    reg [15:0] in;
    wire [15:0] out;

    // Instantiate the RAM16K module
    RAM16K dut (
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
        #10 load = 1; address = 4000; in = 16'hB111;
        #10 load = 1; address = 8000; in = 16'hC222;
        #10 load = 1; address = 16383; in = 16'hDFFF;
        
        // Read back
        #10 load = 0; address = 0;     // Should read 0xA000
        #10 load = 0; address = 4000;  // Should read 0xB111
        #10 load = 0; address = 8000;  // Should read 0xC222
        #10 load = 0; address = 16383; // Should read 0xDFFF
        
        // Update an existing address
        #10 load = 1; address = 8000; in = 16'hEEEE;
        #10 load = 0; address = 8000; // Should read 0xEEEE
        
        // End simulation
        #10 $finish;
    end
endmodule

