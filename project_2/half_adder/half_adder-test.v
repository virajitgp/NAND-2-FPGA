// owner virajitgp; verilog test for a half adder
`timescale 1ns/1ps

module HalfAdder_tb();
    // Inputs
    reg a, b;
    
    // Outputs
    wire sum, carry;
    
    // Instantiate the Unit Under Test (UUT)
    HalfAdder uut (
        .a(a),
        .b(b),
        .sum(sum),
        .carry(carry)
    );
    
    // For GTKWave
    initial begin
        $dumpfile("half_adder.vcd");
        $dumpvars(0, HalfAdder_tb);
    end
    
    // Test sequence
    initial begin
        // Initialize inputs
        a = 0; b = 0;
        #10;
        
        a = 0; b = 1;
        #10;
        
        a = 1; b = 0;
        #10;
        
        a = 1; b = 1;
        #10;
        
        // End simulation
        $finish;
    end
    
    // Monitor changes
    initial begin
        $monitor("Time = %0t: a = %b, b = %b, sum = %b, carry = %b", 
                 $time, a, b, sum, carry);
    end
endmodule
