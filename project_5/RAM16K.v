
module RAM16K(
    input wire [13:0] address,
    input wire [15:0] in,
    input wire load,
    input wire clk,
    output reg [15:0] out
);

    reg [15:0] ram [0:16383];

    always @(posedge clk) begin
        if (load) begin
            ram[address] <= in;
        end
    end

    always @* begin
        out = ram[address];
    end

endmodule
