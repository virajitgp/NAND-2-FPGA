module PC(
    input wire clk,         // Clock input
    input wire reset,       // Reset signal
    input wire inc,         // Increment signal
    input wire load,        // Load signal
    input wire [15:0] in,   // Input value
    output reg [15:0] out   // Output value
);


    // Program counter logic
    always @(posedge clk) begin
        if (reset) begin
            out <= 16'b0;           // Reset to 0
        end
        else if (load) begin
            out <= in;              // Load a new value
        end
        else if (inc) begin
            out <= out + 16'b1;     // Increment
        end
        // Otherwise, maintain the current value
    end

endmodule

