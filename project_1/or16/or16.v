// owner:virajitgp; verilog implementation of a 16 input or chip
module or16(
    input [15:0] a,
    input [15:0] b,
    output [15:0] out
);
    assign out = a | b;
endmodule
