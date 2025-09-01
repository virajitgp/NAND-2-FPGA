// RAM16K Top Module for FPGA with Onboard I/O
module RAM16K_FPGA_top(
    // Clock and Reset
    input wire clk,                 // System clock (typically 100MHz)
    input wire reset_btn,           // Reset button (active low)
    
    // Control switches
    input wire load_sw,             // Load enable switch
    input wire [7:0] switches,      // 8-bit switches for data input
    
    // Address input via buttons/switches
    input wire addr_mode,           // 0: low byte, 1: high byte
    input wire addr_latch,          // Button to latch address
    
    // Data display
    output reg [7:0] leds,          // 8 LEDs for data display
    output reg [6:0] seg_display,   // 7-segment display
    output reg [3:0] digit_sel,     // 4-digit select for 7-seg
    
    // Status indicators
    output wire write_led,          // Write operation indicator
    output wire ready_led           // System ready indicator
);

    // Internal signals
    reg reset;
    reg load;
    reg [13:0] address;
    reg [15:0] in_data;
    wire [15:0] out_data;
    
    // Address latching registers
    reg [13:0] addr_reg;
    reg addr_latch_prev;
    
    // Display control
    reg [1:0] display_sel;
    reg [15:0] display_counter;
    
    // Button debouncing
    reg [2:0] reset_sync;
    reg [2:0] latch_sync;
    
    // Instantiate RAM16K
    RAM16K ram_inst (
        .clk(clk),
        .reset(reset),
        .load(load),
        .address(address),
        .in(in_data),
        .out(out_data)
    );
    
    // Reset synchronization (button is active low)
    always @(posedge clk) begin
        reset_sync <= {reset_sync[1:0], ~reset_btn};
        reset <= reset_sync[2];
    end
    
    // Address latch synchronization
    always @(posedge clk) begin
        latch_sync <= {latch_sync[1:0], addr_latch};
        addr_latch_prev <= latch_sync[2];
    end
    
    // Address input logic
    always @(posedge clk) begin
        if (reset) begin
            addr_reg <= 14'h0000;
        end else if (latch_sync[2] && !addr_latch_prev) begin // Rising edge
            if (addr_mode == 1'b0) begin
                // Latch low 8 bits
                addr_reg[7:0] <= switches;
            end else begin
                // Latch high 6 bits (14-bit address)
                addr_reg[13:8] <= switches[5:0];
            end
        end
    end
    
    // Control signal mapping
    always @(posedge clk) begin
        if (reset) begin
            load <= 1'b0;
            address <= 14'h0000;
            in_data <= 16'h0000;
        end else begin
            load <= load_sw;
            address <= addr_reg;
            in_data <= {switches, switches}; // Duplicate 8-bit input to make 16-bit
        end
    end
    
    // LED display (show lower 8 bits of output)
    always @(posedge clk) begin
        if (reset) begin
            leds <= 8'h00;
        end else begin
            leds <= out_data[7:0];
        end
    end
    
    // 7-segment display controller
    reg [3:0] hex_digit;
    always @(*) begin
        case (display_sel)
            2'b00: hex_digit = out_data[3:0];     // Digit 0 (LSB)
            2'b01: hex_digit = out_data[7:4];     // Digit 1
            2'b10: hex_digit = out_data[11:8];    // Digit 2
            2'b11: hex_digit = out_data[15:12];   // Digit 3 (MSB)
            default: hex_digit = 4'h0;
        endcase
    end
    
    // 7-segment decoder
    always @(*) begin
        case (hex_digit)
            4'h0: seg_display = 7'b1000000; // 0
            4'h1: seg_display = 7'b1111001; // 1
            4'h2: seg_display = 7'b0100100; // 2
            4'h3: seg_display = 7'b0110000; // 3
            4'h4: seg_display = 7'b0011001; // 4
            4'h5: seg_display = 7'b0010010; // 5
            4'h6: seg_display = 7'b0000010; // 6
            4'h7: seg_display = 7'b1111000; // 7
            4'h8: seg_display = 7'b0000000; // 8
            4'h9: seg_display = 7'b0010000; // 9
            4'hA: seg_display = 7'b0001000; // A
            4'hB: seg_display = 7'b0000011; // b
            4'hC: seg_display = 7'b1000110; // C
            4'hD: seg_display = 7'b0100001; // d
            4'hE: seg_display = 7'b0000110; // E
            4'hF: seg_display = 7'b0001110; // F
            default: seg_display = 7'b1111111; // blank
        endcase
    end
    
    // Display multiplexing (1kHz refresh rate)
    always @(posedge clk) begin
        if (reset) begin
            display_counter <= 16'h0000;
            display_sel <= 2'b00;
            digit_sel <= 4'b1110;
        end else begin
            display_counter <= display_counter + 1;
            if (display_counter == 16'h0000) begin // Overflow every 655us at 100MHz
                display_sel <= display_sel + 1;
                case (display_sel)
                    2'b00: digit_sel <= 4'b1110; // Enable digit 0
                    2'b01: digit_sel <= 4'b1101; // Enable digit 1
                    2'b10: digit_sel <= 4'b1011; // Enable digit 2
                    2'b11: digit_sel <= 4'b0111; // Enable digit 3
                    default: digit_sel <= 4'b1111; // All off
                endcase
            end
        end
    end
    
    // Status LEDs
    assign write_led = load;
    assign ready_led = ~reset;
    
endmodule
