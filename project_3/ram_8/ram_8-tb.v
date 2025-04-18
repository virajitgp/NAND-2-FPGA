`timescale 1ns/1ps

module RAM8_tb;
    reg clk;
    reg load;
    reg [2:0] address;
    reg [15:0] in;
    wire [15:0] out;

    // Instantiate the RAM8 module
    RAM8 dut (
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
        
        // Test sequence - write to different addresses
        #10 load = 1; address = 0; in = 16'h1111;
        #10 load = 1; address = 1; in = 16'h2222;
        #10 load = 1; address = 2; in = 16'h3333;
        
        // Test sequence - read from different addresses
        #10 load = 0; address = 0; // Should read 0x1111
        #10 load = 0; address = 1; // Should read 0x2222
        #10 load = 0; address = 2; // Should read 0x3333
        
        // Write to an address that already has data
        #10 load = 1; address = 1; in = 16'hAAAA;
        #10 load = 0; address = 1; // Should read 0xAAAA
        
        // End simulation
        #10 $finish;
    end
endmodule

