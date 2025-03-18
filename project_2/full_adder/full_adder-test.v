`timescale 1ns/1ps

module FullAdder_tb();
    // Inputs
    reg a, b, cin;
    
    // Outputs
    wire sum, cout;
    
    // Instantiate the Unit Under Test (UUT)
    FullAdder uut (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );
    
    // For GTKWave
    initial begin
        $dumpfile("full_adder.vcd");
        $dumpvars(0, FullAdder_tb);
    end
    
    // Test sequence
    initial begin
        // Initialize inputs
        a = 0; b = 0; cin = 0;
        #10;
        
        a = 0; b = 0; cin = 1;
        #10;
        
        a = 0; b = 1; cin = 0;
        #10;
        
        a = 0; b = 1; cin = 1;
        #10;
        
        a = 1; b = 0; cin = 0;
        #10;
        
        a = 1; b = 0; cin = 1;
        #10;
        
        a = 1; b = 1; cin = 0;
        #10;
        
        a = 1; b = 1; cin = 1;
        #10;
        
        // End simulation
        $finish;
    end
    
    // Monitor changes
    initial begin
        $monitor("Time = %0t: a = %b, b = %b, cin = %b, sum = %b, cout = %b", 
                 $time, a, b, cin, sum, cout);
    end
endmodule

