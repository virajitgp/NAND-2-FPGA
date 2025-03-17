// owner:virajirgp;verilog implemntation of a 2 input and and_gate;a,b-I;out-O
module and_gate(
    input a,
    input b,
    output out
);
    assign out = a & b;
endmodule
