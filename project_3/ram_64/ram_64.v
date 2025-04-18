module RAM64(
    input wire clk,           // Clock input
    input wire load,          // Write enable
    input wire [5:0] address, // 6-bit address (0-63)
    input wire [15:0] in,     // 16-bit input data
    output reg [15:0] out     // 16-bit output data
);
    // 64 registers, each 16-bit wide
    reg [15:0] memory [0:63];
    
    // Initialize memory to all zeros
    integer i;
    initial begin
        for (i = 0; i < 64; i = i + 1) begin
            memory[i] = 16'b0;
        end
        out = 16'b0;
    end

    // Write operation
    always @(posedge clk) begin
        if (load) begin
            memory[address] <= in;
        end
    end

    // Read operation (update on address change)
    always @(address) begin
        out = memory[address];
    end

endmodule

