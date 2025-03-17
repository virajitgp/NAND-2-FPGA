// Testbench for DMUX4WAY
module dmux4way_tb;
    reg in;
    reg [1:0] sel;
    wire out0, out1, out2, out3;
    
    // Instantiate the module
    dmux4way dut(in, sel, out0, out1, out2, out3);
    
    initial begin
        // Monitor the results
        $monitor("Time=%0t in=%b sel=%b out0=%b out1=%b out2=%b out3=%b", 
                 $time, in, sel, out0, out1, out2, out3);
        
        // Test cases with in=0
        in = 0; sel = 2'b00; #10;
        in = 0; sel = 2'b01; #10;
        in = 0; sel = 2'b10; #10;
        in = 0; sel = 2'b11; #10;
        
        // Test cases with in=1
        in = 1; sel = 2'b00; #10;
        in = 1; sel = 2'b01; #10;
        in = 1; sel = 2'b10; #10;
        in = 1; sel = 2'b11; #10;
        
        $finish;
    end
endmodule
