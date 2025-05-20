module RAM512(
    input wire clk,            // Clock input
    input wire load,           // Write enable
    input wire [8:0] address,  // 9-bit address (0-511)
    input wire [15:0] in,      // 16-bit input data
    output reg [15:0] out      // 16-bit output data
);
    // 512 registers, each 16-bit wide
    reg [15:0] memory [0:511];
    

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

