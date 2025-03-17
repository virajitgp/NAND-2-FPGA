// owner:virajitgp; verilog implementation of a xor xor_gate;a,b-input;out is out 
module xor_gate(
    input a,
    input b,
    output out
);
    assign out = a ^ b;
endmodule
