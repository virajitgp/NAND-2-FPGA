// Testbench for the ALU module
`timescale 1ns / 1ps // Specifies simulation time units

module alu_tb;

    // 1. Declare signals to connect to the ALU
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
    
    // Operation codes from your ALU file for readability
    parameter ADD = 4'b0000;
    parameter SUB = 4'b0001;
    parameter AND = 4'b0010;

    // 2. Instantiate the Device Under Test (DUT)
    alu dut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .a(a_in),
        .b(b_in),
        .op_code(op_code_in),
        .result(result_out),
        .zero_flag(zero_out),
        .carry_flag(carry_out),
        .overflow_flag(overflow_out)
    );

    // Create a clock signal for the simulation (100 MHz, 10ns period)
    always #5 clk = ~clk;

    // 3. Provide a sequence of inputs to test functionality
    initial begin
        // --- Start of Test Sequence ---
        $display("Starting ALU Testbench...");
        
        // Initialize all inputs
        clk     = 0;
        reset   = 1;    // Assert reset
        enable  = 0;
        a_in    = 16'd0;
        b_in    = 16'd0;
        op_code_in = 4'd0;
        #20; // Wait for a couple of clock cycles
        
        reset = 0;      // De-assert reset
        enable = 1;     // Enable the ALU
        @(posedge clk); // Wait for the next clock edge

        // --- TEST CASE 1: Addition (10 + 5 = 15) ---
        a_in       <= 16'd10;
        b_in       <= 16'd5;
        op_code_in <= ADD;
        @(posedge clk); // Wait one cycle for the result to be calculated
        #1; // Wait a tiny bit for signals to settle before checking
        $display("ADD Test: a=10, b=5, result=%d", result_out);
        
        // --- TEST CASE 2: Subtraction (20 - 30 = -10) ---
        a_in       <= 16'd20;
        b_in       <= 16'd30;
        op_code_in <= SUB;
        @(posedge clk);
        #1;
        // %h prints in hex. -10 in 16-bit 2's complement is FFF6
        $display("SUB Test: a=20, b=30, result=%h, overflow=%b", result_out, overflow_out);

        // --- Add more test cases here for AND, OR, MUL, etc. ---


        // --- End of Test Sequence ---
        #100; // Run simulation for a bit longer
        $display("Testbench finished.");
        $finish; // End the simulation
    end

endmodule
