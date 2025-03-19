`timescale 1ns/1ps

module tb_incrementor_16bit;
    reg [15:0] a;
    wire [15:0] sum;
    wire cout;

    // Instantiate the incrementer
    incrementor_16bit uut (
        .a(a),
        .sum(sum),
        .cout(cout)
    );

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_incrementor_16bit);

        // Test cases
        a = 16'h0000; // 0 + 1
        #10;

        a = 16'h0001; // 1 + 1
        #10;

        a = 16'h7FFF; // 32767 + 1 (boundary case)
        #10;

        a = 16'hFFFF; // 65535 + 1 -> overflow
        #10;

        a = 16'h1234; // Arbitrary value
        #10;

        a = 16'hABCD; // Another arbitrary value
        #10;

        $finish;
    end
endmodule

