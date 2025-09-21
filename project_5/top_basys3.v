`timescale 1ns / 1ps

`include "Computer.v"
`include "ProgramROM.v"

module top_basys3(
    input wire clk_100mhz,
    input wire btnc,
    output wire [15:0] leds,
    output wire [6:0] seg,
    output wire [3:0] an
);

    wire zr_flag;
    wire ng_flag;

    wire reset;
    wire [15:0] instruction;
    wire [15:0] outM;
    wire writeM;
    wire [14:0] pc;

    // The computer core
    Computer computer (
        .clk(clk_100mhz),
        .reset(reset),
        .instruction(instruction),
        .outM(outM),
        .writeM(writeM),
        .pc(pc),
        .zr_out(zr_flag),
        .ng_out(ng_flag)
    );

    // The program ROM
    ProgramROM rom (
        .address(pc),
        .data(instruction)
    );

    // Assign reset from the center button
    assign reset = btnc;

    // Map outputs to LEDs
    // leds[14:0] show the value being written to RAM
    // leds[15] shows the writeM signal
    assign leds[14:0] = outM[14:0];
    assign leds[15] = writeM;

    // 7-segment display logic
    // Display Z (zero flag) on segment a, N (negative flag) on segment b of the first digit
    assign seg[0] = zr_flag; // Segment a for Zero Flag
    assign seg[1] = ng_flag; // Segment b for Negative Flag
    assign seg[2] = 1'b1;    // Segment c off
    assign seg[3] = 1'b1;    // Segment d off
    assign seg[4] = 1'b1;    // Segment e off
    assign seg[5] = 1'b1;    // Segment f off
    assign seg[6] = 1'b1;    // Segment g off

    assign an[0] = 1'b0; // Enable first digit
    assign an[1] = 1'b1; // Disable second digit
    assign an[2] = 1'b1; // Disable third digit
    assign an[3] = 1'b1; // Disable fourth digit

endmodule
