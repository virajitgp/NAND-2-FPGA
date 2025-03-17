// owner:virajitgp;verilog implimentation of not_gate;A-I, Out-O

module not_gate (
    input  a,
    output out
);
  assign out = ~a;
endmodule
