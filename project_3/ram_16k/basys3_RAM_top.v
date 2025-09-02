// Debouncer Module
module debouncer(
    input wire clk,
    input wire noisy_in,
    output reg clean_out
);
    parameter DEBOUNCE_LIMIT = 50000; // 0.5ms debounce time at 100MHz

    reg [15:0] counter = 0;
    reg intermediate = 0;

    always @(posedge clk) begin
        if (noisy_in != intermediate) begin
            counter <= counter + 1;
            if (counter == DEBOUNCE_LIMIT) begin
                intermediate <= ~intermediate;
                counter <= 0;
            end
        end else begin
            counter <= 0;
        end
        clean_out <= intermediate;
    end
endmodule

module RAM16K_Basys3_top(
    // Clock - connected to 100MHz oscillator on Basys3
    input wire clk,                 
    
    // Buttons - Basys3 has 5 buttons: BTNC (center), BTNU, BTND, BTNL, BTNR
    input wire btnc,                // Center button - System Reset
    input wire btnu,                // Up button - Address Latch
    input wire btnd,                // Down button - Address Mode Toggle
    input wire btnl,                // Left button - Load Enable
    
    // Switches - Basys3 has 16 switches (sw[15:0])
    input wire [15:0] sw,           // All 16 switches available
    
    // LEDs - Basys3 has 16 LEDs (led[15:0])  
    output reg [15:0] led,          // Display the 16-bit output data
    
    // 7-Segment Display - Basys3 has 4-digit common anode display
    output reg [6:0] seg,           // 7-segment segments (CA, CB, CC, CD, CE, CF, CG)
    output reg [3:0] an             // 4 anodes (AN3, AN2, AN1, AN0) - active low
);

    // Internal RAM signals
    reg reset;
    reg load;
    reg [13:0] address;
    reg [15:0] in_data;
    wire [15:0] out_data;
    
    // Address input control
    reg addr_mode;                  // 0: input low address bits, 1: input high address bits
    reg [13:0] addr_reg;
    
    // Debounced button signals
    wire btnc_clean, btnu_clean, btnd_clean, btnl_clean;
    reg btnu_prev, btnd_prev;

    // Instantiate debouncers for each button
    debouncer btnc_debouncer(.clk(clk), .noisy_in(btnc), .clean_out(btnc_clean));
    debouncer btnu_debouncer(.clk(clk), .noisy_in(btnu), .clean_out(btnu_clean));
    debouncer btnd_debouncer(.clk(clk), .noisy_in(btnd), .clean_out(btnd_clean));
    debouncer btnl_debouncer(.clk(clk), .noisy_in(btnl), .clean_out(btnl_clean));

    // Display multiplexing - runs at ~760Hz for flicker-free display
    reg [16:0] display_counter;     // 17-bit counter for 100MHz/131072 ≈ 763Hz
    reg [1:0] display_digit;
    
    // Instantiate the RAM16K module
    RAM16K ram_inst (
        .clk(clk),
        .reset(reset),
        .load(load),
        .address(address),
        .in(in_data),
        .out(out_data)
    );
    
    // Reset generation
    always @(posedge clk) begin
        reset <= btnc_clean;  // Reset is active when button is pressed
    end

    // Edge detection for buttons
    always @(posedge clk) begin
        btnu_prev <= btnu_clean;
        btnd_prev <= btnd_clean;
    end

    // Address mode control using down button
    always @(posedge clk) begin
        if (reset) begin
            addr_mode <= 1'b0;  // Start with low address mode
        end else if (btnd_clean && !btnd_prev) begin // Rising edge detection
            addr_mode <= ~addr_mode;  // Toggle between low and high address input
        end
    end
    
    // Address latching using up button
    // This allows building a 14-bit address using the 16 switches in two steps
    always @(posedge clk) begin
        if (reset) begin
            addr_reg <= 14'h0000;
        end else if (btnu_clean && !btnu_prev) begin // Rising edge of up button
            if (addr_mode == 1'b0) begin
                // Latch lower 8 bits from switches[7:0]
                addr_reg[7:0] <= sw[7:0];
            end else begin
                // Latch upper 6 bits from switches[5:0] (14-bit address total)
                addr_reg[13:8] <= sw[5:0];
            end
        end
    end
    
    // RAM control signals
    always @(posedge clk) begin
        if (reset) begin
            load <= 1'b0;
            address <= 14'h0000;
            in_data <= 16'h0000;
        end else begin
            // Use the debounced left button as load enable
            load <= btnl_clean;
            
            // Use the latched address
            address <= addr_reg;
            
            // Use all 16 switches for input data
            in_data <= sw;
        end
    end
    
    // LED display shows the complete 16-bit output
    always @(posedge clk) begin
        if (reset) begin
            led <= 16'h0000;
        end else begin
