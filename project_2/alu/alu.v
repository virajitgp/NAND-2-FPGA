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
  reg [16:0] temp;
  reg [31:0] mul_temp;
  wire [15:0] next_result;
  wire next_zero_flag;
  wire next_carry_flag;
  wire next_overflow_flag;
  
  // Combinational logic for next state calculation
  always @* begin
    // Default values
    temp = 17'h00000;
    mul_temp = 32'h00000000;
    
    case (op_code)
      ADD: begin
        temp = {1'b0, a} + {1'b0, b};
      end
      SUB: begin
        temp = {1'b0, a} - {1'b0, b};
      end
      MUL: begin
        mul_temp = a * b;
        temp[15:0] = mul_temp[15:0];
        temp[16] = |mul_temp[31:16]; // Set carry if upper bits non-zero
      end
      AND:  temp = {1'b0, a & b};
      OR:   temp = {1'b0, a | b};
      XOR:  temp = {1'b0, a ^ b};
      NOT:  temp = {1'b0, ~a};
      SHL:  temp = {1'b0, a << b[3:0]};
      SHR:  temp = {1'b0, a >> b[3:0]};
      CMPEQ: temp = {16'h0000, (a == b)};
      CMPLT: temp = {16'h0000, ($signed(a) < $signed(b))};
      CMPLE: temp = {16'h0000, ($signed(a) <= $signed(b))};
      default: temp = 17'h00000;
    endcase
  end
  
  // Assign next state values
  assign next_result = (op_code == MUL) ? mul_temp[15:0] : temp[15:0];
  assign next_zero_flag = (next_result == 16'h0000);
  
  // Carry flag calculation
  assign next_carry_flag = (op_code == SUB) ? (a < b) : 
                          (op_code == MUL) ? |mul_temp[31:16] : 
                          temp[16];
  
  // Overflow flag calculation
  assign next_overflow_flag = (op_code == ADD) ? ((a[15] == b[15]) && (temp[15] != a[15])) :
                             (op_code == SUB) ? ((a[15] != b[15]) && (temp[15] != a[15])) :
                             (op_code == MUL) ? |mul_temp[31:16] :
                             1'b0;
  
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
