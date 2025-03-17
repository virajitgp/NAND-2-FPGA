// owner:virajitgp;a verilog imp of a 16 input and16 chip
module and16(
    input [15:0] a,
    input [15:0] b,
    output [15:0] out
);
    assign out = a & b;
endmodule
