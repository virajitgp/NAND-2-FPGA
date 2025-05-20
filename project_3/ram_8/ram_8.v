//owner:virajitgp; a verilog imp of a 8 Bit RAM
module RAM8(
    input wire clk,          // Clock input
    input wire load,         // Write enable
    input wire [2:0] address, // 3-bit address (0-7)
    input wire [15:0] in,    // 16-bit input data
    output reg [15:0] out    // 16-bit output data
);
    // 8 registers, each 16-bit wide
    reg [15:0] memory [0:7];
    

    // Write operation
    always @(posedge clk) begin
        if (load) begin
            memory[address] <= in;
        end
    end

    // Read operation (update on address change)
    always @(posedge) begin
        out = memory[address];
    end

endmodule

