// owner:virajitgp;verilog code for a half adder; a,b in; c_out and sum are output``
module HalfAdder(
    input a, b,
    output sum, carry
);
    // Sum is XOR of inputs
    assign sum = a ^ b;
    
    // Carry is AND of inputs
    assign carry = a & b;
endmodule
