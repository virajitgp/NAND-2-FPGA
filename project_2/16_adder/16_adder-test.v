`timescale 1ns/1ps

module tb_full_adder_16bit;
    reg [15:0] a, b;
    reg cin;
    wire [15:0] sum;
    wire cout;

    // Instantiate the full adder
    full_adder_16bit uut (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_full_adder_16bit);

        // Test cases
        a = 16'h0001; b = 16'h0001; cin = 0;
        #10;

        a = 16'hFFFF; b = 16'h0001; cin = 0;
        #10;

        a = 16'h1234; b = 16'h5678; cin = 1;
        #10;

        a = 16'hAAAA; b = 16'h5555; cin = 0;
        #10;

        a = 16'h0000; b = 16'hFFFF; cin = 1;
        #10;

        a = 16'hABCD; b = 16'h1234; cin = 1;
        #10;

        $finish;
    end
endmodule

