// owner:virajitgp; a verilog ip of a 16 bit incrementor 
module full_adder_1bit (
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    assign {cout, sum} = a + b + cin;
endmodule

module incrementor_16bit (
    input [15:0] a,
    output [15:0] sum,
    output cout
);
    wire [15:0] carry;

    // Inint 16 full adders, increment by 1
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : adder
            if (i == 0)
                full_adder_1bit fa (
                    .a(a[i]),
                    .b(1'b1),   // Increment by 1
                    .cin(1'b0),
                    .sum(sum[i]),
                    .cout(carry[i])
                );
            else
                full_adder_1bit fa (
                    .a(a[i]),
                    .b(1'b0),
                    .cin(carry[i-1]),
                    .sum(sum[i]),
                    .cout(carry[i])
                );
        end
    endgenerate

    assign cout = carry[15];
endmodule

