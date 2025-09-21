
`include "CPU.v"

module CPU_d_reg_test;

    // Inputs
    reg clk;
    reg [15:0] instruction;
    reg [15:0] inM;
    reg reset;

    // Outputs
    wire [15:0] outM;
    wire writeM;
    wire [15:0] addressM;
    wire [15:0] pc;

    // Instantiate the CPU
    CPU uut (
        .clk(clk),
        .instruction(instruction),
        .inM(inM),
        .reset(reset),
        .outM(outM),
        .writeM(writeM),
        .addressM(addressM),
        .pc(pc)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        // Initialize inputs
        clk = 0;
        reset = 1;
        instruction = 0;
        inM = 0;

        // Apply reset
        #10;
        reset = 0;

        // Instruction: D=1 (C-Instruction)
        @(posedge clk);
        instruction = 16'b1110111111010000;
        @(posedge clk);
        @(posedge clk);

        $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("Time=%0t, PC=%d, Inst=%b, AddrM=%d, OutM=%d, WriteM=%b, A_reg=%d, D_reg=%d",
                 $time, pc, instruction, addressM, outM, writeM, uut.a_reg_out, uut.d_reg_out);
    end

endmodule
