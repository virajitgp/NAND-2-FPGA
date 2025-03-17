// Testbench for DMUX
module dmux_tb;
    reg in, sel;
    wire out0, out1;
    
    // Instantiate the module
    dmux dut(in, sel, out0, out1);
    
    initial begin
        // Monitor the results
        $monitor("Time=%0t in=%b sel=%b out0=%b out1=%b", $time, in, sel, out0, out1);
        
        // Test cases
        in = 0; sel = 0; #10;
        in = 1; sel = 0; #10;
        in = 0; sel = 1; #10;
        in = 1; sel = 1; #10;
        
        $finish;
    end
endmodule
