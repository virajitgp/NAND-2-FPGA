`timescale 1ns/1ps
module testbench;
    reg A, B;
    wire Y;

    // Instantiate the NAND gate
    NandGate uut (.Y(Y), .A(A), .B(B));

    initial begin
        $dumpfile("output.vcd"); // Save waveform data
        $dumpvars(0, testbench);
        
        // Apply test cases
        A = 0; B = 0; #10;
        A = 0; B = 1; #10;
        A = 1; B = 0; #10;
        A = 1; B = 1; #10;

        $finish;
    end
endmodule

