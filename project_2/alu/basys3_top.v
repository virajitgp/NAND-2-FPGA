module basys3_top(
    input         clk,      // Board clock
    input  [15:0] sw,       // 16 switches
    input         btnc,     // Center button for reset
    input         btnu,
    input         btnl,
    input         btnd,
    input         btnr,
    output [15:0] led       // 16 LEDs
);

    // Use buttons for the opcode
    wire [3:0] op_code = {btnu, btnl, btnd, btnr};

    // Instantiate your ALU
    alu my_alu (
        .clk(clk),
        .reset(btnc), // Use center button for reset
        .enable(1'b1), // Keep it always enabled for this simple test
        .a({sw[15:8], 8'b0}), // Use top 8 switches for 'a', pad with zeros
        .b({8'b0, sw[7:0]}),   // Use bottom 8 switches for 'b'
        .op_code(op_code),
        .result(led), // Connect result directly to the LEDs
        
        // We aren't displaying the flags on LEDs in this example
        .zero_flag(),
        .carry_flag(),
        .overflow_flag()
    );

endmodule
