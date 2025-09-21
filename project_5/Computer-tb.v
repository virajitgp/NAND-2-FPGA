`include "Computer.v"

module Computer_tb;

    // Inputs
    reg clk;
    reg reset;

    // Instantiate the Computer
    Computer uut (
        .clk(clk),
        .reset(reset)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        // Initialize inputs
        clk = 0;
        reset = 1;

        // Apply reset
        #10;
        reset = 0;

        // Run for a few cycles
        #100;

        // Check the value in RAM
        if (uut.ram.ram[100] === 1) begin
            $display("Test Passed: RAM[100] is 1");
        end else begin
            $display("Test Failed: RAM[100] is %d", uut.ram.ram[100]);
        end

        $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("Time=%0t, PC=%d, Inst=%b, AddrM=%d, OutM=%d, WriteM=%b",
                 $time, uut.pc, uut.instruction, uut.addressM, uut.outM, uut.writeM);
    end

endmodule