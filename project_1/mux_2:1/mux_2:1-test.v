// Testbench for MUX
module mux_tb;
    reg a, b, sel;
    wire out;
    
    // Instantiate the module
    mux dut(a, b, sel, out);
    
    initial begin
        // Monitor the results
        $monitor("Time=%0t a=%b b=%b sel=%b out=%b", $time, a, b, sel, out);
        
        // Test cases
        a = 0; b = 0; sel = 0; #10;
        a = 0; b = 1; sel = 0; #10;
        a = 1; b = 0; sel = 0; #10;
        a = 1; b = 1; sel = 0; #10;
        a = 0; b = 0; sel = 1; #10;
        a = 0; b = 1; sel = 1; #10;
        a = 1; b = 0; sel = 1; #10;
        a = 1; b = 1; sel = 1; #10;
        
        $finish;
    end
endmodule
