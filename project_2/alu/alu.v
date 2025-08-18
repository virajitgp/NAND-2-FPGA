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

  // Internal temporary registers
  reg [16:0] temp;
  reg [31:0] mul_temp;
  reg [15:0] next_result; // Use an intermediate wire/reg for clarity

  // Main synchronous logic block
  always @(posedge clk) begin
    if (reset) begin
      // Default state on reset
      result        <= 16'h0000;
      zero_flag     <= 1'b1;
      carry_flag    <= 1'b0;
      overflow_flag <= 1'b0;
    end else if (enable) begin
      // Assign all outputs on every enabled clock cycle
      result        <= next_result;
      zero_flag     <= (next_result == 16'h0000); // Zero flag is based on the result
      carry_flag    <= temp[16]; // Default to carry from temp
      overflow_flag <= 1'b0;    // Default to no overflow

      case (op_code)
        ADD: begin
          // temp holds the intermediate 17-bit result
          temp            <= {1'b0, a} + {1'b0, b};
          overflow_flag   <= (a[15] == b[15]) && (temp[15] != a[15]);
        end

        SUB: begin
          temp            <= {1'b0, a} - {1'b0, b};
          carry_flag      <= (a < b); // For subtraction, carry is a borrow
          overflow_flag   <= (a[15] != b[15]) && (temp[15] != a[15]);
        end

        MUL: begin
          mul_temp        <= a * b; // Will be mapped to a DSP slice
          temp[15:0]      <= mul_temp[15:0]; // Lower 16 bits of result
          carry_flag      <= |mul_temp[31:16]; // Unsigned overflow if upper bits are non-zero
          overflow_flag   <= |mul_temp[31:16]; // Can be the same for signed/unsigned
        end

        AND:  temp <= {1'b0, a & b};
        OR:   temp <= {1'b0, a | b};
        XOR:  temp <= {1'b0, a ^ b};
        NOT:  temp <= {1'b0, ~a};

        // Note: For logical shifts, carry is typically the last bit shifted out.
        // This is complex to implement generically with a variable shift amount.
        // Often, it's simplified or handled differently.
        SHL:  temp <= {1'b0, a << b[3:0]};
        SHR:  temp <= {1'b0, a >> b[3:0]}; // Logical shift right

        CMPEQ: temp <= {16'h0, (a == b)};
        CMPLT: temp <= {16'h0, ($signed(a) < $signed(b))};
        CMPLE: temp <= {16'h0, ($signed(a) <= $signed(b))};

        default: temp <= 17'h00000;
      endcase
    end
  end

  // Combinational logic to determine the next result based on the temp value
  // This is clearer than calculating it inside the clocked block
  always @* begin
      next_result = temp[15:0];
      // Special handling for MUL result if needed, but this is fine.
      if (op_code == MUL) begin
          next_result = mul_temp[15:0];
      end
  end

endmodule
