// Testbench for OR gate
module or_gate_tb;
    reg a, b;
    wire out;
    
    // Instantiate the module
    or_gate dut(a, b, out);
    
    initial begin
        // Monitor the results
        $monitor("Time=%0t a=%b b=%b out=%b", $time, a, b, out);
        
        // Test cases
        a = 0; b = 0; #10;
        a = 0; b = 1; #10;
        a = 1; b = 0; #10;
        a = 1; b = 1; #10;
        
        $finish;
    end
endmodule
