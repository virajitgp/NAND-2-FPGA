module full_adder_1bit (
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);
  assign {cout, sum} = a + b + cin;
endmodule

module full_adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input cin,
    output [15:0] sum,
    output cout
);
  wire [15:0] carry;

  // Instantiate 16 full adders
  genvar i;
  generate
    for (i = 0; i < 16; i = i + 1) begin : adder
      if (i == 0)
        full_adder_1bit fa (
            .a(a[i]),
            .b(b[i]),
            .cin(cin),
            .sum(sum[i]),
            .cout(carry[i])
        );
      else
        full_adder_1bit fa (
            .a(a[i]),
            .b(b[i]),
            .cin(carry[i-1]),
            .sum(sum[i]),
            .cout(carry[i])
        );
    end
  endgenerate

  assign cout = carry[15];
endmodule
