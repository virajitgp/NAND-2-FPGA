// owner:virajitgp; a verilog imp of a 8 way or
module or8way(
    input [7:0] in,
    output out
);
    assign out = |in;  // Reduction OR operator
endmodule
