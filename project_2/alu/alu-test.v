`timescale 1ns / 1ps

module alu_tb;

    // --- Testbench signals ---
    reg         clk;
    reg         reset;
    reg         enable;
    reg [15:0]  a_in;
    reg [15:0]  b_in;
    reg [3:0]   op_code_in;

    wire [15:0] result_out;
    wire        zero_out;
    wire        carry_out;
    wire        overflow_out;
    
    // --- Opcodes for readability ---
    parameter ADD = 4'b0000, SUB = 4'b0001, AND = 4'b0010, SHL = 4'b0110, SHR = 4'b0111;

    // --- Instantiate the ALU (Device Under Test) ---
    alu dut (
        .clk(clk), .reset(reset), .enable(enable), .a(a_in), .b(b_in),
        .op_code(op_code_in), .result(result_out), .zero_flag(zero_out),
        .carry_flag(carry_out), .overflow_flag(overflow_out)
    );

    // --- Clock Generator ---
    always #5 clk = ~clk;

    // --- Test Sequence ---
    initial begin
        $dumpfile("alu_waveform.vcd");
        $
