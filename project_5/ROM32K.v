
module ROM32K(
    input wire [14:0] address,
    output reg [15:0] out
);

    reg [15:0] rom [0:32767];

    initial begin
        // Pre-load the ROM with a simple program
        // @100
        rom[0] = 16'b0000000001100100;
        // M=1
        rom[1] = 16'b1110111111001000;
    end

    always @* begin
        out = rom[address];
    end

endmodule
