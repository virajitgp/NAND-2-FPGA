// onwer:virajitgp;verilog implementaion of a not16 chip;
module not16 (
    input  [15:0] a,
    output [15:0] out
);
  assign out = ~a;
endmodule
