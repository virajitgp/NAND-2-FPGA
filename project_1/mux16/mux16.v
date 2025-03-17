// owner:virajitgp; a verilog imp of a 16 input mux
module mux16(
    input [15:0] a,
    input [15:0] b,
    input sel,
    output [15:0] out
);
    assign out = sel ? b : a;
endmodule
