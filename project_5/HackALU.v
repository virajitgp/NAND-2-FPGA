
module HackALU(
    input [15:0] x,
    input [15:0] y,
    input zx, // Zero the x input
    input nx, // Negate the x input
    input zy, // Zero the y input
    input ny, // Negate the y input
    input f,  // Function code: 1 for add, 0 for and
    input no, // Negate the output
    output [15:0] out,
    output zr, // Zero flag
    output ng  // Negative flag
);

    wire [15:0] x_zeroed = zx ? 16'b0 : x;
    wire [15:0] x_processed = nx ? ~x_zeroed : x_zeroed;

    wire [15:0] y_zeroed = zy ? 16'b0 : y;
    wire [15:0] y_processed = ny ? ~y_zeroed : y_zeroed;

    wire [15:0] f_out = f ? (x_processed + y_processed) : (x_processed & y_processed);
    
    assign out = no ? ~f_out : f_out;
    
    // Flags
    assign zr = (out == 16'b0);
    assign ng = out[15];

endmodule
