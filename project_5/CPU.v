
`include "HackALU.v"
`include "../project_3/register/reg.v"
`include "../project_3/prog_counter/pc.v"

module CPU(
    input wire clk,
    input wire [15:0] instruction,
    input wire [15:0] inM,
    input wire reset,
    output wire [15:0] outM,
    output wire writeM,
    output wire [14:0] addressM,
    output wire [14:0] pc,
    output wire zr_out,
    output wire ng_out
);

    // Instruction decoding
    wire is_c_instruction = instruction[15];
    wire is_a_instruction = ~is_c_instruction;

    // ALU control bits from C-instruction
    wire alu_zx = instruction[11];
    wire alu_nx = instruction[10];
    wire alu_zy = instruction[9];
    wire alu_ny = instruction[8];
    wire alu_f = instruction[7];
    wire alu_no = instruction[6];
    wire alu_a_bit = instruction[12];

    // Destination bits from C-instruction
    wire dest_a = instruction[5];
    wire dest_d = instruction[4];
    wire dest_m = instruction[3];

    // Jump bits from C-instruction
    wire j1 = instruction[2]; // JGT
    wire j2 = instruction[1]; // JEQ
    wire j3 = instruction[0]; // JLT

    // ALU inputs and outputs
    wire [15:0] alu_out;
    wire alu_zr, alu_ng;
    wire [15:0] alu_y_in;

    // A Register
    wire [15:0] a_reg_out;
    wire a_reg_load;
    wire [15:0] a_reg_in;

    // D Register
    wire [15:0] d_reg_out;
    wire d_reg_load;

    // PC
    wire [15:0] pc_out;
    wire pc_load, pc_inc;

    // A-Instruction: Choose between instruction and ALU output for A-register input
    assign a_reg_in = is_a_instruction ? instruction : alu_out;
    assign a_reg_load = is_a_instruction | (is_c_instruction & dest_a);

    Register a_register (
        .clk(clk), // Using reset as a clock signal for simplicity in this model
        .load(a_reg_load),
        .in(a_reg_in),
        .out(a_reg_out)
    );

    // D-Instruction: Load D-register from ALU output
    assign d_reg_load = is_c_instruction & dest_d;

    Register d_register (
        .clk(clk), // Using reset as a clock signal
        .load(d_reg_load),
        .in(alu_out),
        .out(d_reg_out)
    );

    // Mux for ALU's y input
    assign alu_y_in = alu_a_bit ? inM : a_reg_out;

    // ALU instantiation
    HackALU alu (
        .x(d_reg_out),
        .y(alu_y_in),
        .zx(alu_zx),
        .nx(alu_nx),
        .zy(alu_zy),
        .ny(alu_ny),
        .f(alu_f),
        .no(alu_no),
        .out(alu_out),
        .zr(alu_zr),
        .ng(alu_ng)
    );

    // Memory output
    assign outM = alu_out;
    assign writeM = is_c_instruction & dest_m;
    assign addressM = a_reg_out[14:0];

    // PC logic
    wire jump_condition;
    wire jgt = ~alu_zr & ~alu_ng; // Positive
    wire jeq = alu_zr;
    wire jlt = alu_ng;

    assign jump_condition = (j1 & jgt) | (j2 & jeq) | (j3 & jlt);
    assign pc_load = is_c_instruction & jump_condition;
    assign pc_inc = ~pc_load;

    PC program_counter (
        .clk(clk), // Using reset as a clock signal
        .reset(reset),
        .inc(pc_inc),
        .load(pc_load),
        .in(a_reg_out),
        .out(pc_out)
    );

    assign pc = pc_out[14:0];

    assign zr_out = alu_zr;
    assign ng_out = alu_ng;

endmodule
