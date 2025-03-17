// owner:virajitgp; implemntation of a 2:1 mux; sel,a,b is input; out is output
module mux(
    input a,
    input b,
    input sel,
    output out
);
    assign out = sel ? b : a;
endmodule

