module RAM16K_tb;
    // Test signals
    reg clk;
    reg reset;
    reg load;
    reg [13:0] address;
    reg [15:0] in;
    wire [15:0] out;
    wire test_pass;
    wire [15:0] debug_data;
    
    // Test variables
    reg [15:0] test_data [0:7];
    reg [13:0] test_addr [0:7];
    integer i, errors;
    
    // Instantiate DUT
    RAM16K_top dut (
        .clk(clk),
        .reset(reset),
        .load(load),
        .address(address),
        .in(in),
        .out(out),
        .test_pass(test_pass),
        .debug_data(debug_data)
    );
    
    // Clock generation (100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns period = 100MHz
    end
    
    // Test stimulus
    initial begin
        // Initialize test data
        test_data[0] = 16'hAAAA;  test_addr[0] = 14'h0000;
        test_data[1] = 16'h5555;  test_addr[1] = 14'h0001;
        test_data[2] = 16'hFFFF;  test_addr[2] = 14'h0100;
        test_data[3] = 16'h0000;  test_addr[3] = 14'h1000;
        test_data[4] = 16'h1234;  test_addr[4] = 14'h2000;
        test_data[5] = 16'hABCD;  test_addr[5] = 14'h3000;
        test_data[6] = 16'hDEAD;  test_addr[6] = 14'h3FFE;
        test_data[7] = 16'hBEEF;  test_addr[7] = 14'h3FFF; // Last address
        
        errors = 0;
        
        $display("Starting RAM16K Testbench");
        $display("========================");
        
        // Initialize signals
        reset = 1;
        load = 0;
        address = 0;
        in = 0;
        
        // Reset sequence
        repeat(3) @(posedge clk);
        reset = 0;
        @(posedge clk);
        
        // Test 1: Write operations
        $display("Test 1: Writing test patterns...");
        for (i = 0; i < 8; i = i + 1) begin
            @(posedge clk);
            load = 1;
            address = test_addr[i];
            in = test_data[i];
            $display("  Writing 0x%04X to address 0x%04X", test_data[i], test_addr[i]);
        end
        
        @(posedge clk);
        load = 0;
        
        // Test 2: Read operations and verify
        $display("\nTest 2: Reading and verifying data...");
        for (i = 0; i < 8; i = i + 1) begin
            @(posedge clk);
            address = test_addr[i];
            @(posedge clk); // Wait for read
            if (out !== test_data[i]) begin
                $display("  ERROR: Address 0x%04X - Expected 0x%04X, Got 0x%04X", 
                         test_addr[i], test_data[i], out);
                errors = errors + 1;
            end else begin
                $display("  PASS: Address 0x%04X - Data 0x%04X", test_addr[i], out);
            end
        end
        
        // Test 3: Read-modify-write
        $display("\nTest 3: Read-modify-write test...");
        address = 14'h1000;
        @(posedge clk);
        $display("  Original value at 0x1000: 0x%04X", out);
        
        load = 1;
        in = out + 16'h1111;
        @(posedge clk);
        
        load = 0;
        @(posedge clk);
        if (out !== (test_data[3] + 16'h1111)) begin
            $display("  ERROR: RMW failed - Expected 0x%04X, Got 0x%04X", 
                     test_data[3] + 16'h1111, out);
            errors = errors + 1;
        end else begin
            $display("  PASS: RMW successful - New value 0x%04X", out);
        end
        
        // Test 4: Address boundary test
        $display("\nTest 4: Address boundary test...");
        // Test address 0
        address = 14'h0000;
        @(posedge clk);
        $display("  Address 0x0000: 0x%04X", out);
        
        // Test max address
        address = 14'h3FFF;
        @(posedge clk);
        $display("  Address 0x3FFF: 0x%04X", out);
        
        // Test 5: Reset functionality
        $display("\nTest 5: Reset functionality...");
        reset = 1;
        @(posedge clk);
        @(posedge clk);
        if (out !== 16'h0000) begin
            $display("  ERROR: Reset failed - Output should be 0x0000, got 0x%04X", out);
            errors = errors + 1;
        end else begin
            $display("  PASS: Reset successful - Output is 0x0000");
        end
        
        reset = 0;
        @(posedge clk);
        
        // Summary
        $display("\n========================");
        $display("Test Summary:");
        $display("Total Errors: %0d", errors);
        if (errors == 0) begin
            $display("ALL TESTS PASSED!");
        end else begin
            $display("SOME TESTS FAILED!");
        end
        $display("========================");
        
        #100;
        $finish;
    end
    
    // Monitor critical signals
    initial begin
        $monitor("Time: %0t | CLK: %b | RST: %b | LOAD: %b | ADDR: 0x%04X | IN: 0x%04X | OUT: 0x%04X", 
                 $time, clk, reset, load, address, in, out);
    end
    
    // Generate waveform dump
    initial begin
        $dumpfile("ram16k_tb.vcd");
        $dumpvars(0, RAM16K_tb);
    end
    
endmodule
