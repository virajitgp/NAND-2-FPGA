`timescale 1ns/1ps

module RAM64_tb;
    reg clk;
    reg load;
    reg [5:0] address;
    reg [15:0] in;
    wire [15:0] out;

    // Instantiate the RAM64 module
    RAM64 dut (
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
        $display("Time\tload\taddress\tin\t\tout");
        $monitor("%0t\t%b\t%d\t%h\t%h", $time, load, address, in, out);
        
        // Test various addresses
        #10 load = 1; address = 0; in = 16'hA000;
        #10 load = 1; address = 10; in = 16'hB111;
        #10 load = 1; address = 20; in = 16'hC222;
        #10 load = 1; address = 63; in = 16'hDFFF;
        
        // Read back
        #10 load = 0; address = 0;  // Should read 0xA000
        #10 load = 0; address = 10; // Should read 0xB111
        #10 load = 0; address = 20; // Should read 0xC222
        #10 load = 0; address = 63; // Should read 0xDFFF
        
        // Write to an existing address
        #10 load = 1; address = 10; in = 16'hEEEE;
        #10 load = 0; address = 10; // Should read 0xEEEE
        
        // End simulation
        #10 $finish;
    end
endmodule
