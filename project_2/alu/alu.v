<<<<<<< Updated upstream
// owner:virajitgp; verilog implemnetation of a alu(not hack arch btw)
module alu(
    input [15:0] a,        // 16-bit input operand A
    input [15:0] b,        // 16-bit input operand B
    input [3:0] op_code,   // 4-bit operation code
    input clk,             // Clock signal
    input enable,          // Enable signal
    output reg [15:0] result,  // 16-bit output result
    output reg zero_flag,      // Set when result is zero
    output reg carry_flag,     // Set when operation produces a carry
    output reg overflow_flag   // Set when operation produces an overflow
);
    // Operation codes
    parameter ADD = 4'b0000;
    parameter SUB = 4'b0001;
    parameter AND = 4'b0010;
    parameter OR  = 4'b0011;
    parameter XOR = 4'b0100;
    parameter NOT = 4'b0101;
    parameter SHL = 4'b0110;
    parameter SHR = 4'b0111;
    parameter CMPEQ = 4'b1000;
    parameter CMPLT = 4'b1001;
    parameter CMPLE = 4'b1010;
    parameter MUL = 4'b1011;
    
    // Internal registers
    reg [16:0] temp;       // 17-bit temp for carry detection
    reg [31:0] mul_temp;   // 32-bit temp for multiplication
    
    // Changed from combinational (@*) to sequential (clocked) logic
    always @(posedge clk) begin
        if (enable) begin
            // Default flag values
            zero_flag = 0;
            carry_flag = 0;
            overflow_flag = 0;
            
            case(op_code)
                ADD: begin
                    temp = a + b;
                    result = temp[15:0];
                    carry_flag = temp[16];
                    overflow_flag = (a[15] == b[15]) && (result[15] != a[15]);
                end
                
                SUB: begin
                    temp = a - b;
                    result = temp[15:0];
                    carry_flag = (a < b); // Correct carry flag for subtraction
                    overflow_flag = (a[15] != b[15]) && (result[15] != a[15]);
                end
                
                AND: result = a & b;
                OR: result = a | b;
                XOR: result = a ^ b;
                NOT: result = ~a;
                
                SHL: begin
                    result = a << b[3:0];
                    carry_flag = (b[3:0] > 0) ? a[15 - (b[3:0] - 1)] : 0;
                end
                
                SHR: begin
                    result = a >> b[3:0];
                    carry_flag = (b[3:0] > 0) ? a[b[3:0] - 1] : 0;
                end
                
                CMPEQ: result = (a == b) ? 16'h0001 : 16'h0000;
                CMPLT: result = ($signed(a) < $signed(b)) ? 16'h0001 : 16'h0000;
                CMPLE: result = ($signed(a) <= $signed(b)) ? 16'h0001 : 16'h0000;
                
                MUL: begin
                    mul_temp = a * b;
                    result = mul_temp[15:0];
                    carry_flag = |mul_temp[31:16];
                    overflow_flag = (mul_temp[31:16] != {16{mul_temp[15]}});
                end
                
                default: result = 16'h0000;
            endcase
            
            zero_flag = (result == 16'h0000);
        end
    end
=======
module alu (
    input      [15:0] a,             // 16-bit input operand A
    input      [15:0] b,             // 16-bit input operand B
    input      [ 3:0] op_code,       // 4-bit operation code
    output reg [15:0] result,        // 16-bit output result
    output reg        zero_flag,     // Set when result is zero
    output reg        carry_flag,    // Set when operation produces a carry
    output reg        overflow_flag  // Set when operation produces an overflow
);

  // Operation codes
  parameter ADD = 4'b0000;  // Addition
  parameter SUB = 4'b0001;  // Subtraction
  parameter AND = 4'b0010;  // Bitwise AND
  parameter OR = 4'b0011;  // Bitwise OR
  parameter XOR = 4'b0100;  // Bitwise XOR
  parameter NOT = 4'b0101;  // Bitwise NOT (of operand A)
  parameter SHL = 4'b0110;  // Shift left A by B bits
  parameter SHR = 4'b0111;  // Shift right A by B bits
  parameter CMPEQ = 4'b1000;  // Compare equal
  parameter CMPLT = 4'b1001;  // Compare less than
  parameter CMPLE = 4'b1010;  // Compare less than or equal
  parameter MUL = 4'b1011;  // Multiplication

  // Temporary variables for calculations
  reg [16:0] temp;  // 17-bit temp for carry detection
  reg [31:0] mul_temp;  // 32-bit temp for multiplication

  always @(*) begin
    // Default flag values
    zero_flag = 0;
    carry_flag = 0;
    overflow_flag = 0;

    case (op_code)
      ADD: begin
        temp = a + b;
        result = temp[15:0];
        carry_flag = temp[16];
        // Overflow occurs when adding two numbers of the same sign
        // and the result has a different sign
        overflow_flag = (a[15] == b[15]) && (result[15] != a[15]);
      end

      SUB: begin
        temp = a - b;
        result = temp[15:0];
        carry_flag = temp[16];
        // Overflow occurs when subtracting numbers of different signs
        // and the result has a different sign than the first operand
        overflow_flag = (a[15] != b[15]) && (result[15] != a[15]);
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
        result = a << b[3:0];  // Use only lower 4 bits of B for shift amount (max 16 positions)
        // Carry is the last bit shifted out
        if (b[3:0] > 0) carry_flag = (b[3:0] > 15) ? 0 : a[16-b[3:0]];
      end

      SHR: begin
        result = a >> b[3:0];  // Use only lower 4 bits of B for shift amount (max 16 positions)
        // Carry is the last bit shifted out
        if (b[3:0] > 0) carry_flag = (b[3:0] > 15) ? 0 : a[b[3:0]-1];
      end

      CMPEQ: begin
        result = (a == b) ? 16'h0001 : 16'h0000;
      end

      CMPLT: begin
        result = ($signed(a) < $signed(b)) ? 16'h0001 : 16'h0000;
      end

      CMPLE: begin
        result = ($signed(a) <= $signed(b)) ? 16'h0001 : 16'h0000;
      end

      MUL: begin
        mul_temp = a * b;
        result = mul_temp[15:0];
        // Carry flag if upper bits are non-zero
        carry_flag = |mul_temp[31:16];
        // No defined overflow for multiplication in this ALU
      end

      default: begin
        result = 16'h0000;
      end
    endcase

    // Set zero flag if result is zero
    zero_flag = (result == 16'h0000);
  end

>>>>>>> Stashed changes
endmodule
