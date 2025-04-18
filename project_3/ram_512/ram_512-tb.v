`timescale 1ns/1ps

module RAM512_tb;
    reg clk;
    reg load;
    reg [8:0] address;
    reg [15:0] in;
    wire [15:0] out;

    // Instantiate the RAM512 module
    RAM512 dut (
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
        
        // Test various addresses across the range
        #10 load = 1; address = 0; in = 16'h0AAA;
        #10 load = 1; address = 100; in = 16'h1BBB;
        #10 load = 1; address = 255; in = 16'h2CCC;
        #10 load = 1; address = 511; in = 16'h3DDD;
        
        // Read back
        #10 load = 0; address = 0;   // Should read 0x0AAA
        #10 load = 0; address = 100; // Should read 0x1BBB
        #10 load = 0; address = 255; // Should read 0x2CCC
        #10 load = 0; address = 511; // Should read 0x3DDD
        
        // Update an existing address
        #10 load = 1; address = 255; in = 16'hFFFF;
        #10 load = 0; address = 255; // Should read 0xFFFF
        
        // End simulation
        #10 $finish;
    end
endmodule

