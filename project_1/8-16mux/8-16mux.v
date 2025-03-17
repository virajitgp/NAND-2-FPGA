// owner:virajitgp; verilog imp of a 8 way 16 inp Multiplexer
// 8-way 16-bit Multiplexer
module mux8way16(
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    input [15:0] d,
    input [15:0] e,
    input [15:0] f,
    input [15:0] g,
    input [15:0] h,
    input [2:0] sel,
    output [15:0] out
);
    assign out = (sel == 3'b000) ? a :
                 (sel == 3'b001) ? b :
                 (sel == 3'b010) ? c :
                 (sel == 3'b011) ? d :
                 (sel == 3'b100) ? e :
                 (sel == 3'b101) ? f :
                 (sel == 3'b110) ? g : h;
endmodule
