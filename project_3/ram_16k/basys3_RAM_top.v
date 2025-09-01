module RAM16K_Basys3_top(
    // Clock - connected to 100MHz oscillator on Basys3
    input wire clk,                 
    
    // Buttons - Basys3 has 5 buttons: BTNC (center), BTNU, BTND, BTNL, BTNR
    input wire btnc,                // Center button - System Reset
    input wire btnu,                // Up button - Address Latch
    input wire btnd,                // Down button - Address Mode Toggle
    
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
    
    // Button synchronization and edge detection
    reg [2:0] btnc_sync, btnu_sync, btnd_sync;
    reg btnu_prev, btnd_prev;
    
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
    
    // Button synchronization to prevent metastability
    // This is crucial for reliable operation with mechanical buttons
    always @(posedge clk) begin
        // Synchronize reset button (center button)
        btnc_sync <= {btnc_sync[1:0], btnc};
        reset <= btnc_sync[2];  // Reset is active when button is pressed
        
        // Synchronize address latch button (up button)
        btnu_sync <= {btnu_sync[1:0], btnu};
        btnu_prev <= btnu_sync[2];
        
        // Synchronize mode toggle button (down button)  
        btnd_sync <= {btnd_sync[1:0], btnd};
        btnd_prev <= btnd_sync[2];
    end
    
    // Address mode control using down button
    always @(posedge clk) begin
        if (reset) begin
            addr_mode <= 1'b0;  // Start with low address mode
        end else if (btnd_sync[2] && !btnd_prev) begin // Rising edge detection
            addr_mode <= ~addr_mode;  // Toggle between low and high address input
        end
    end
    
    // Address latching using up button
    // This allows building a 14-bit address using the 16 switches in two steps
    always @(posedge clk) begin
        if (reset) begin
            addr_reg <= 14'h0000;
        end else if (btnu_sync[2] && !btnu_prev) begin // Rising edge of up button
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
            // Use switch 15 as load enable (write when high, read when low)
            load <= sw[15];
            
            // Use the latched address
            address <= addr_reg;
            
            // Use switches [14:0] for input data (15-bit data, padded to 16-bit)
            in_data <= {1'b0, sw[14:0]};
        end
    end
    
    // LED display shows the complete 16-bit output
    always @(posedge clk) begin
        if (reset) begin
            led <= 16'h0000;
        end else begin
            led <= out_data;
        end
    end
    
    // 7-segment display multiplexing
    // The Basys3 uses common anode displays, so we need to invert the anode signals
    always @(posedge clk) begin
        if (reset) begin
            display_counter <= 17'h00000;
            display_digit <= 2'b00;
        end else begin
            display_counter <= display_counter + 1;
            // Change digit every 131072 clock cycles (763Hz refresh)
            if (display_counter == 17'h00000) begin
                display_digit <= display_digit + 1;
            end
        end
    end
    
    // Anode control - only one digit active at a time (active low for common anode)
    always @(*) begin
        case (display_digit)
            2'b00: an = 4'b1110;  // Enable rightmost digit (ones place)
            2'b01: an = 4'b1101;  // Enable second digit (sixteens place) 
            2'b10: an = 4'b1011;  // Enable third digit (256s place)
            2'b11: an = 4'b0111;  // Enable leftmost digit (4096s place)
            default: an = 4'b1111; // All digits off
        endcase
    end
    
    // Segment control - extract the appropriate 4-bit hex digit and decode it
    reg [3:0] current_hex_digit;
    always @(*) begin
        case (display_digit)
            2'b00: current_hex_digit = out_data[3:0];   // Rightmost hex digit
            2'b01: current_hex_digit = out_data[7:4];   // Second hex digit
            2'b10: current_hex_digit = out_data[11:8];  // Third hex digit  
            2'b11: current_hex_digit = out_data[15:12]; // Leftmost hex digit
            default: current_hex_digit = 4'h0;
        endcase
    end
    
    // 7-segment decoder for common anode display (segments are active low)
    always @(*) begin
        case (current_hex_digit)
            4'h0: seg = 7'b1000000;  // Display "0"
            4'h1: seg = 7'b1111001;  // Display "1" 
            4'h2: seg = 7'b0100100;  // Display "2"
            4'h3: seg = 7'b0110000;  // Display "3"
            4'h4: seg = 7'b0011001;  // Display "4"
            4'h5: seg = 7'b0010010;  // Display "5"
            4'h6: seg = 7'b0000010;  // Display "6"
            4'h7: seg = 7'b1111000;  // Display "7"
            4'h8: seg = 7'b0000000;  // Display "8"
            4'h9: seg = 7'b0010000;  // Display "9"
            4'hA: seg = 7'b0001000;  // Display "A"
            4'hB: seg = 7'b0000011;  // Display "b"  
            4'hC: seg = 7'b1000110;  // Display "C"
            4'hD: seg = 7'b0100001;  // Display "d"
            4'hE: seg = 7'b0000110;  // Display "E"
            4'hF: seg = 7'b0001110;  // Display "F"
            default: seg = 7'b1111111; // All segments off
        endcase
    end
    
endmodule
