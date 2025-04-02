// owner:virajitgp; a verilog imp of a full adder with basic gates

module FullAdder (
    input  a,
    b,
    cin,
    output sum,
    cout
);
  // Internal wires
  wire w1, w2, w3, w4;

  // Sum is XOR of a, b, and cin
  xor (w1, a, b);
  xor (sum, w1, cin);

  // Carry out calculation
  and (w2, a, b);  // a AND b
  and (w3, a, cin);  // a AND cin
  and (w4, b, cin);  // b AND cin

  // Carry out is OR of all partial carries
  or (cout, w2, w3, w4);
endmodule
