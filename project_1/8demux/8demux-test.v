// Testbench for DMUX8WAY
module dmux8way_tb;
    reg in;
    reg [2:0] sel;
    wire out0, out1, out2, out3, out4, out5, out6, out7;
    
    // Instantiate the module
    dmux8way dut(in, sel, out0, out1, out2, out3, out4, out5, out6, out7);
    
    initial begin
        // Monitor the results
        $monitor("Time=%0t in=%b sel=%b out0=%b out1=%b out2=%b out3=%b out4=%b out5=%b out6=%b out7=%b", 
                 $time, in, sel, out0, out1, out2, out3, out4, out5, out6, out7);
        
        // Test cases with in=0
        in = 0;
        sel = 3'b000; #10;
        sel = 3'b001; #10;
        sel = 3'b010; #10;
        sel = 3'b011; #10;
        sel = 3'b100; #10;
        sel = 3'b101; #10;
        sel = 3'b110; #10;
        sel = 3'b111; #10;
        
        // Test cases with in=1
        in = 1;
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
