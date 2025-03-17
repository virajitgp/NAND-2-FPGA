// owner:virajitgp; implemntaton of a 2 input or_gate; a,b-I;out- O
module or_gate(
    input a,
    input b,
    output out
);
    assign out = a | b;
endmodule
