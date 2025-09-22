
module ROM32K(
    input wire [14:0] address,
    output reg [15:0] out
);

    reg [15:0] rom [0:32767];

    always @* begin
        out = rom[address];
    end

endmodule
