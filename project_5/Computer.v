`include "CPU.v"
`include "RAM16K.v"

module Computer(
    input wire clk,
    input wire reset,
    input wire [15:0] instruction,
    output wire [15:0] outM,
    output wire writeM,
    output wire [14:0] pc
);

    // Wires
    wire [15:0] inM;
    wire [14:0] addressM;

    // CPU
    CPU cpu (
        .clk(clk),
        .reset(reset),
        .instruction(instruction),
        .inM(inM),
        .outM(outM),
        .writeM(writeM),
        .addressM(addressM),
        .pc(pc)
    );

    // Data Memory
    RAM16K ram (
        .clk(clk),
        .address(addressM[13:0]),
        .in(outM),
        .load(writeM),
        .out(inM)
    );

endmodule