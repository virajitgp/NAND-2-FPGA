// verilog imp of a bit;owner:virajitgp
module Bit (
    input  wire clk,   // Clock input
    input  wire load,  // Load control bit
    input  wire in,    // Input bit
    output reg  out    // Output bit
);

  // On the positive edge of the clock
  always @(posedge clk) begin
    if (load) begin
      out <= in;  // If load is true, update the stored bit
    end
    // If load is false, maintain the current value
  end

endmodule
