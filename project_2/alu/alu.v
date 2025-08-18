//owner:virajitgp
// Final version of the 16-bit ALU
// Includes fixes such as uisng non-blocking assignments
module alu (
    input                 clk,
    input                 reset,
    input                 enable,
    input        [15:0]   a,
    input        [15:0]   b,             // Note: 'b' is ignored for shift operations
    input        [3:0]    op_code,
    output reg   [15:0]   result,
    output                zero_flag,      // Now a wire driven by an 'assign' statement
    output reg            carry_flag,
    output reg            overflow_flag
);

  // --- Operation Codes ---
  parameter ADD   = 4'b0000; // Add 
  parameter SUB   = 4'b0001; // subtract stuff
  parameter AND   = 4'b0010; // bitwise and
  parameter OR    = 4'b0011; // bitwise or
  parameter XOR   = 4'b0100; // bitwise xor
  parameter NOT   = 4'b0101; // bitwise not
  parameter SHL   = 4'b0110; // Shift Left by 1
  parameter SHR   = 4'b0111; // Shift Right Logical by 1
  parameter CMPEQ = 4'b1000; //
  parameter CMPLT = 4'b1001;
  parameter CMPLE = 4'b1010;
  parameter MUL   = 4'b1011;

  // Internal temporary registers for multi-bit results
  reg [16:0] temp;
  reg [31:0] mul_temp;

  // --- combi logic --- //
  // The zero_flag is combinational, always shows the state of the 'result' register.
  assign zero_flag = (result == 16'h0000);
 
  // --- sync logic --- //
  always @(posedge clk) begin
    if (reset) begin
      // Default state on reset
      result        <= 16'h0000;
      carry_flag    <= 1'b0;
      overflow_flag <= 1'b0;
    end else if (enable) begin
      
      // Each instruction explicitly defines its effect on the flags.
      case (op_code)
        ADD: begin
          temp = {1'b0, a} + {1'b0, b};
          result        <= temp[15:0];
          carry_flag    <= temp[16];
          overflow_flag <= (a[15] == b[15]) && (temp[15] != a[15]);
        end

        SUB: begin
          temp = {1'b0, a} - {1'b0, b};
          result        <= temp[15:0];
          carry_flag    <= (a < b); // Carry acts as a borrow flag
          overflow_flag <= (a[15] != b[15]) && (temp[15] != a[15]);
        end
        
        MUL: begin
          mul_temp = a * b;
          result        <= mul_temp[15:0];
          carry_flag    <= |mul_temp[31:16]; // Set if result exceeds 16 bits (unsigned)
          overflow_flag <= |mul_temp[31:16]; 
        end

        AND: begin
          result        <= a & b;
          carry_flag    <= 1'b0;
          overflow_flag <= 1'b0;
        end

        OR: begin
          result        <= a | b;
          carry_flag    <= 1'b0;
          overflow_flag <= 1'b0;
        end

        XOR: begin
          result        <= a ^ b;
          carry_flag    <= 1'b0;
          overflow_flag <= 1'b0;
        end

        NOT: begin
          result        <= ~a;
          carry_flag    <= 1'b0;
          overflow_flag <= 1'b0;
        end

        SHL: begin
          result        <= a << 1;
          carry_flag    <= a[15]; // Capture the last bit shifted out
          overflow_flag <= 1'b0;
        end

        SHR: begin // Logical shift for unsigned numbers
          result        <= a >> 1;
          carry_flag    <= a[0]; // Capture the last bit shifted out
          overflow_flag <= 1'b0;
        end

        CMPEQ: begin
          result        <= (a == b) ? 16'h0001 : 16'h0000;
          carry_flag    <= 1'b0;
          overflow_flag <= 1'b0;
        end

        CMPLT: begin
          result        <= ($signed(a) < $signed(b)) ? 16'h0001 : 16'h0000;
          carry_flag    <= 1'b0;
          overflow_flag <= 1'b0;
        end

        CMPLE: begin
          result        <= ($signed(a) <= $signed(b)) ? 16'h0001 : 16'h0000;
          carry_flag    <= 1'b0;
          overflow_flag <= 1'b0;
        end

        default: begin
          result        <= 16'hDEAD; // Use a distinct value for debugging unknown opcodes
          carry_flag    <= 1'b0;
          overflow_flag <= 1'b0;
        end
      endcase
    end
  end
endmodule
