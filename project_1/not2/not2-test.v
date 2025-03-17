// Testbench for NOT gate
module not_gate_tb;
    reg a;
    wire out;
    
    // Instantiate the module
    not_gate dut(a, out);
    
    initial begin
        // Monitor the results
        $monitor("Time=%0t a=%b out=%b", $time, a, out);
        
        // Test cases
        a = 0; #10;
        a = 1; #10;
        
        $finish;
    end
endmodule
