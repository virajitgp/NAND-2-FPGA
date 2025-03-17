// Testbench for MUX4WAY16
module mux4way16_tb;
    reg [15:0] a, b, c, d;
    reg [1:0] sel;
    wire [15:0] out;
    
    // Instantiate the module
    mux4way16 dut(a, b, c, d, sel, out);
    
    initial begin
        // Monitor the results
        $monitor("Time=%0t sel=%b out=%h", $time, sel, out);
        
        // Initialize inputs with different values
        a = 16'hAAAA;
        b = 16'h5555;
        c = 16'hFFFF;
        d = 16'h0000;
        
        // Test cases
        sel = 2'b00; #10;
        sel = 2'b01; #10;
        sel = 2'b10; #10;
        sel = 2'b11; #10;
        
        $finish;
    end
endmodule
