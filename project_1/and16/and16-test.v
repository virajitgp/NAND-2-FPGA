// Testbench for AND16
module and16_tb;
    reg [15:0] a, b;
    wire [15:0] out;
    
    // Instantiate the module
    and16 dut(a, b, out);
    
    initial begin
        // Monitor the results
        $monitor("Time=%0t a=%h b=%h out=%h", $time, a, b, out);
        
        // Test cases
        a = 16'h0000; b = 16'h0000; #10;
        a = 16'hFFFF; b = 16'h0000; #10;
        a = 16'h0000; b = 16'hFFFF; #10;
        a = 16'hFFFF; b = 16'hFFFF; #10;
        a = 16'hAAAA; b = 16'h5555; #10;
        
        $finish;
    end
endmodule
