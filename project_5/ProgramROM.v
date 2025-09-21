module ProgramROM(
    input wire [14:0] address,
    output reg [15:0] data
);

    always @(*) begin
        case (address)
            15'h0000: data = 16'h0002; // @2
            15'h0001: data = 16'hec10; // D=A
            15'h0002: data = 16'h0003; // @3
            15'h0003: data = 16'he090; // D=D+A
            15'h0004: data = 16'h0000; // @0
            15'h0005: data = 16'he308; // M=D
            default: data = 16'h0000; // Default to NOP (or @0)
        endcase
    end

endmodule
