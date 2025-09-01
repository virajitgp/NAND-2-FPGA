module basys3_top(
    input         clk,      // Board clock
    input  [15:0] sw,       // 16 switches
    input         btnc,     // Center button for reset
    input         btnu,
    input         btnl,
    input         btnd,
    input         btnr,
    output [7:0]  led,      // 8 LEDs for ALU result
    output        flag_zero_led,
    output        flag_carry_led,
    output        flag_overflow_led
);
    wire [3:0] op_code = {btnu, btnl, btnd, btnr};
    wire [15:0] alu_result;
    wire zero_flag, carry_flag, overflow_flag;
    
    alu my_alu (
        .clk(clk),
        .reset(btnc),
        .enable(1'b1),
        .a(sw[15:8]),           // Upper 8 switches as operand A
        .b(sw[7:0]),            // Lower 8 switches as operand B
        .op_code(op_code),
        .result(alu_result),
        .zero_flag(zero_flag),
        .carry_flag(carry_flag),
        .overflow_flag(overflow_flag)
    );
    
    assign led = alu_result[7:0];       // Use lower 8 bits for LED output
    assign flag_zero_led = zero_flag;   // Single LED for zero flag
    assign flag_carry_led = carry_flag; // Single LED for carry flag
    assign flag_overflow_led = overflow_flag; // Single LED for overflow flag
endmodule
