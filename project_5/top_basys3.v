`timescale 1ns / 1ps

`include "Computer.v"
`include "ProgramROM.v"

module top_basys3(
    input wire clk_100mhz,
    input wire btnc,
    output wire [15:0] leds
);

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
        .pc(pc)
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

endmodule
