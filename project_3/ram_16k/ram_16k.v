// RAM16
//K Module - FPGA Ready
module RAM16K(
    input wire clk,             // Clock input
    input wire reset,           // Reset input (added for FPGA)
    input wire load,            // Write enable
    input wire [13:0] address,  // 14-bit address (0-16383)
    input wire [15:0] in,       // 16-bit input data
    output reg [15:0] out       // 16-bit output data
);
    // 16384 registers, each 16-bit wide
    reg [15:0] memory [0:16383];
    
    // Memory is not initialized at power-up. 
    // The system should be reset after programming the FPGA.
    // Synthesis tools will infer block RAM, which is uninitialized.
    
    // Synchronous read/write operation
    always @(posedge clk) begin
        if (reset) begin
            out <= 16'h0000;
        end else begin
            if (load) begin
                memory[address] <= in;
            end
            out <= memory[address];  // Read operation
        end
    end
endmodule
