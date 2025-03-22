// owner: virajitgp; ALU behavioral verilog
module alu(
    input [7:0] a,         // 8-bit input operand A
    input [7:0] b,         // 8-bit input operand B
    input [3:0] op_code,   // 4-bit operation code
    output reg [7:0] result,   // 8-bit output result
    output reg zero_flag,      // Set when result is zero
    output reg carry_flag,     // Set when operation produces a carry
    output reg overflow_flag   // Set when operation produces an overflow
);

    // Operation codes
    parameter ADD = 4'b0000;   // Addition
    parameter SUB = 4'b0001;   // Subtraction
    parameter AND = 4'b0010;   // Bitwise AND
    parameter OR  = 4'b0011;   // Bitwise OR
    parameter XOR = 4'b0100;   // Bitwise XOR
    parameter NOT = 4'b0101;   // Bitwise NOT (of operand A)
    parameter SHL = 4'b0110;   // Shift left A by B bits
    parameter SHR = 4'b0111;   // Shift right A by B bits
    parameter CMPEQ = 4'b1000; // Compare equal
    parameter CMPLT = 4'b1001; // Compare less than
    parameter CMPLE = 4'b1010; // Compare less than or equal
    parameter MUL = 4'b1011;   // Multiplication

    // Temporary variables for calculations
    reg [8:0] temp;    // 9-bit temp for carry detection
    reg [15:0] mul_temp; // 16-bit temp for multiplication

    always @(*) begin
        // Default flag values
        zero_flag = 0;
        carry_flag = 0;
        overflow_flag = 0;
        
        case(op_code)
            ADD: begin
                temp = a + b;
                result = temp[7:0];
                carry_flag = temp[8];
                // Overflow occurs when adding two numbers of the same sign
                // and the result has a different sign
                overflow_flag = (a[7] == b[7]) && (result[7] != a[7]);
            end
            
            SUB: begin
                temp = a - b;
                result = temp[7:0];
                carry_flag = temp[8];
                // Overflow occurs when subtracting numbers of different signs
                // and the result has a different sign than the first operand
                overflow_flag = (a[7] != b[7]) && (result[7] != a[7]);
            end
            
            AND: begin
                result = a & b;
            end
            
            OR: begin
                result = a | b;
            end
            
            XOR: begin
                result = a ^ b;
            end
            
            NOT: begin
                result = ~a;
            end
            
            SHL: begin
                result = a << b[2:0]; // Use only lower 3 bits of B for shift amount
                // Carry is the last bit shifted out
                if (b[2:0] > 0)
                    carry_flag = (b[2:0] > 7) ? 0 : a[8-b[2:0]];
            end
            
            SHR: begin
                result = a >> b[2:0]; // Use only lower 3 bits of B for shift amount
                // Carry is the last bit shifted out
                if (b[2:0] > 0)
                    carry_flag = (b[2:0] > 7) ? 0 : a[b[2:0]-1];
            end
            
            CMPEQ: begin
                result = (a == b) ? 8'h01 : 8'h00;
            end
            
            CMPLT: begin
                result = ($signed(a) < $signed(b)) ? 8'h01 : 8'h00;
            end
            
            CMPLE: begin
                result = ($signed(a) <= $signed(b)) ? 8'h01 : 8'h00;
            end
            
            MUL: begin
                mul_temp = a * b;
                result = mul_temp[7:0];
                // Carry flag if upper bits are non-zero
                carry_flag = |mul_temp[15:8];
                // No defined overflow for multiplication in this ALU
            end
            
            default: begin
                result = 8'h00;
            end
        endcase
        
        // Set zero flag if result is zero
        zero_flag = (result == 8'h00);
    end

endmodule
