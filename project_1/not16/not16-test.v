// Testbench for NOT16
module not16_tb;
    reg [15:0] a;
    wire [15:0] out;
    
    // Instantiate the module
    not16 dut(a, out);
    
    initial begin
        // Monitor the results
        $monitor("Time=%0t a=%b out=%b", $time, a, out);
        
        // Test cases
        a = 16'h0000; #10;
        a = 16'hFFFF; #10;
        a = 16'hAAAA; #10;
        a = 16'h5555; #10;
        
        $finish;
    end
endmodule
