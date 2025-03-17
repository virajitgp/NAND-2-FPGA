// Testbench for MUX8WAY16
module mux8way16_tb;
    reg [15:0] a, b, c, d, e, f, g, h;
    reg [2:0] sel;
    wire [15:0] out;
    
    // Instantiate the module
    mux8way16 dut(a, b, c, d, e, f, g, h, sel, out);
    
    initial begin
        // Monitor the results
        $monitor("Time=%0t sel=%b out=%h", $time, sel, out);
        
        // Initialize inputs with different values
        a = 16'hAAAA;
        b = 16'h5555;
        c = 16'hFFFF;
        d = 16'h0000;
        e = 16'h1234;
        f = 16'h4321;
        g = 16'h9876;
        h = 16'h6789;
        
        // Test cases
        sel = 3'b000; #10;
        sel = 3'b001; #10;
        sel = 3'b010; #10;
        sel = 3'b011; #10;
        sel = 3'b100; #10;
        sel = 3'b101; #10;
        sel = 3'b110; #10;
        sel = 3'b111; #10;
        
        $finish;
    end
endmodule
