// owner:virajitgp; verilog implementation of an ALU for Basys 3 (Artix-7 FPGA)
module alu (
    input                 clk,           // Clock signal (connect to 100MHz on Basys 3)
    input                 reset,         // Synchronous reset
    input                 enable,        // Enable signal
    input        [15:0]   a,             // 16-bit input operand A
    input        [15:0]   b,             // 16-bit input operand B
    input        [ 3:0]   op_code,       // 4-bit operation code
    output reg   [15:0]   result,        // 16-bit output result
    output reg            zero_flag,     // Set when result is zero
    output reg            carry_flag,    // Set when operation produces a carry
    output reg            overflow_flag  // Set when operation produces an overflow
);
  // Operation codes
  parameter ADD   = 4'b0000;
  parameter SUB   = 4'b0001;
  parameter AND   = 4'b0010;
  parameter OR    = 4'b0011;
  parameter XOR   = 4'b0100;
  parameter NOT   = 4'b0101;
  parameter SHL   = 4'b0110;
  parameter SHR   = 4'b0111; // Note: This is a LOGICAL shift
  parameter CMPEQ = 4'b1000;
  parameter CMPLT = 4'b1001;
  parameter CMPLE = 4'b1010;
  parameter MUL   = 4'b1011;
  
  // Internal registers and wires
  reg [15:0] next_result;
  reg        next_zero_flag;
  reg        next_carry_flag;
  reg        next_overflow_flag;
  reg [16:0] temp_add;
  reg [16:0] temp_sub;
  reg [31:0] mul_temp;

  // Combinational logic for next state calculation
  always @* begin
    // Default values
    next_result = 16'h0000;
    next_carry_flag = 1'b0;
    next_overflow_flag = 1'b0;
    
    case (op_code)
      ADD: begin
        temp_add = {1'b0, a} + {1'b0, b};
        next_result = temp_add[15:0];
        next_carry_flag = temp_add[16];
        next_overflow_flag = (a[15] == b[15]) && (next_result[15] != a[15]);
      end
      SUB: begin
        temp_sub = {1'b0, a} - {1'b0, b};
        next_result = temp_sub[15:0];
        next_carry_flag = (a < b); // Borrow
        next_overflow_flag = (a[15] != b[15]) && (next_result[15] != a[15]);
      end
      MUL: begin
        mul_temp = a * b;
        next_result = mul_temp[15:0];
        next_carry_flag = |mul_temp[31:16];
        next_overflow_flag = |mul_temp[31:16];
      end
      AND:  next_result = a & b;
      OR:   next_result = a | b;
      XOR:  next_result = a ^ b;
      NOT:  next_result = ~a;
      SHL:  next_result = a << b[3:0];
      SHR:  next_result = a >> b[3:0];
      CMPEQ: next_result = {15'h0, (a == b)};
      CMPLT: next_result = {15'h0, ($signed(a) < $signed(b))};
      CMPLE: next_result = {15'h0, ($signed(a) <= $signed(b))};
      default: next_result = 16'h0000;
    endcase
    
    next_zero_flag = (next_result == 16'h0000);
  end
  
  // Main synchronous logic block
  always @(posedge clk) begin
    if (reset) begin
      result        <= 16'h0000;
      zero_flag     <= 1'b1;
      carry_flag    <= 1'b0;
      overflow_flag <= 1'b0;
    end else if (enable) begin
      result        <= next_result;
      zero_flag     <= next_zero_flag;
      carry_flag    <= next_carry_flag;
      overflow_flag <= next_overflow_flag;
    end
  end

endmodule












