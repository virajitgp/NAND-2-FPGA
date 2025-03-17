// Testbench for MUX16
module mux16_tb;
    reg [15:0] a, b;
    reg sel;
    wire [15:0] out;
    
    // Instantiate the module
    mux16 dut(a, b, sel, out);
    
    initial begin
        // Monitor the results
        $monitor("Time=%0t a=%h b=%h sel=%b out=%h", $time, a, b, sel, out);
        
        // Test cases
        a = 16'hAAAA; b = 16'h5555; sel = 0; #10;
        a = 16'hAAAA; b = 16'h5555; sel = 1; #10;
        a = 16'h0000; b = 16'hFFFF; sel = 0; #10;
        a = 16'h0000; b = 16'hFFFF; sel = 1; #10;
        
        $finish;
    end
endmodule
