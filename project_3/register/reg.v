// owner:virajit; a register in verilog(behavioral)
module Register(
    input wire clk,          // Clock input
    input wire load,         // Load control bit
    input wire [15:0] in,    // 16-bit input
    output reg [15:0] out    // 16-bit output
);
    // Initialize output to 0
    initial begin
        out = 16'b0;
    end

    // Write operation
    always @(posedge clk) begin
        if (load) begin
            out <= in;  // If load is true, update all 16 bits
        end
        // If load is false, maintain the current value
    end

endmodule

