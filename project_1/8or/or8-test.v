// Testbench for OR8WAY
module or8way_tb;
    reg [7:0] in;
    wire out;
    
    // Instantiate the module
    or8way dut(in, out);
    
    initial begin
        // Monitor the results
        $monitor("Time=%0t in=%b out=%b", $time, in, out);
        
        // Test cases
        in = 8'h00; #10;
        in = 8'h01; #10;
        in = 8'h10; #10;
        in = 8'hFF; #10;
        in = 8'h55; #10;
        
        $finish;
    end
endmodule
