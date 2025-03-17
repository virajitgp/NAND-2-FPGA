// owner:virajitgp;verilog implimentation of a basic NAND gate;A,B-I;Y-O
module NandGate (
    output Y,
    input  A,
    input  B
);
  assign Y = ~(A & B);
endmodule

