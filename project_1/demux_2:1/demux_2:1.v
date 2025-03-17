// owner:virajitgp;verilog implemnentaion of a demux 2-1 demux chip
module dmux(
    input in,
    input sel,
    output out0,
    output out1
);
    assign out0 = sel ? 0 : in;
    assign out1 = sel ? in : 0;
endmodule
