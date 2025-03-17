// owner:virajitgp; a verilog imp of 4 way demux chip
// 4-way Demultiplexer
module dmux4way(
    input in,
    input [1:0] sel,
    output out0,
    output out1,
    output out2,
    output out3
);
    assign out0 = (sel == 2'b00) ? in : 0;
    assign out1 = (sel == 2'b01) ? in : 0;
    assign out2 = (sel == 2'b10) ? in : 0;
    assign out3 = (sel == 2'b11) ? in : 0;
endmodule
