`timescale 1ns/1ps

module alu_tb();
    // Test signals
    reg [7:0] a;
    reg [7:0] b;
    reg [3:0] op_code;
    wire [7:0] result;
    wire zero_flag;
    wire carry_flag;
    wire overflow_flag;
    
    // Instantiate the ALU
    alu dut(
        .a(a),
        .b(b),
        .op_code(op_code),
        .result(result),
        .zero_flag(zero_flag),
        .carry_flag(carry_flag),
        .overflow_flag(overflow_flag)
    );
    
    // Helper tasks
    task display_result;
        input [7:0] expected_result;
        input expected_zero;
        input expected_carry;
        input expected_overflow;
        begin
            #1; // Wait for signals to propagate
            
            $display("Operation: %b, A: %d, B: %d", op_code, a, b);
            $display("Result: %d (Expected: %d)", result, expected_result);
            $display("Zero Flag: %b (Expected: %b)", zero_flag, expected_zero);
            $display("Carry Flag: %b (Expected: %b)", carry_flag, expected_carry);
            $display("Overflow Flag: %b (Expected: %b)", overflow_flag, expected_overflow);
            
            if (result !== expected_result || zero_flag !== expected_zero || 
                carry_flag !== expected_carry || overflow_flag !== expected_overflow) begin
                $display("TEST FAILED!");
            end else begin
                $display("Test passed.");
            end
            
            $display("---------------------------");
        end
    endtask
    
    // Test stimulus
    initial begin
        $display("Starting ALU Testbench");
        
        // Test addition
        a = 8'd10; b = 8'd20; op_code = 4'b0000;
        #10 display_result(8'd30, 0, 0, 0);
        
        // Test addition with carry
        a = 8'd200; b = 8'd100; op_code = 4'b0000;
        #10 display_result(8'd44, 0, 1, 0); // 300 % 256 = 44, with carry
        
        // Test addition with overflow
        a = 8'd100; b = 8'd100; op_code = 4'b0000;
        #10 display_result(8'd200, 0, 0, 0);
        
        a = 8'h7F; b = 8'h01; op_code = 4'b0000; // 127 + 1 = 128 (overflow)
        #10 display_result(8'h80, 0, 0, 1);
        
        // Test subtraction
        a = 8'd50; b = 8'd20; op_code = 4'b0001;
        #10 display_result(8'd30, 0, 0, 0);
        
        // Test subtraction with borrow
        a = 8'd10; b = 8'd20; op_code = 4'b0001;
        #10 display_result(8'd246, 0, 1, 0); // -10 = 246 in two's complement
        
        // Test subtraction with overflow
        a = 8'h80; b = 8'h01; op_code = 4'b0001; // -128 - 1 = -129 (overflow)
        #10 display_result(8'h7F, 0, 1, 1);
        
        // Test logical operations
        a = 8'hAA; b = 8'h55; op_code = 4'b0010; // AND
        #10 display_result(8'h00, 1, 0, 0);
        
        a = 8'hAA; b = 8'h55; op_code = 4'b0011; // OR
        #10 display_result(8'hFF, 0, 0, 0);
        
        a = 8'hAA; b = 8'h55; op_code = 4'b0100; // XOR
        #10 display_result(8'hFF, 0, 0, 0);
        
        a = 8'hAA; b = 8'h00; op_code = 4'b0101; // NOT
        #10 display_result(8'h55, 0, 0, 0);
        
        // Test shifts
        a = 8'h01; b = 8'h03; op_code = 4'b0110; // SHL
        #10 display_result(8'h08, 0, 0, 0);
        
        a = 8'h80; b = 8'h03; op_code = 4'b0111; // SHR
        #10 display_result(8'h10, 0, 0, 0);
        
        // Test comparisons
        a = 8'd10; b = 8'd10; op_code = 4'b1000; // CMPEQ
        #10 display_result(8'h01, 0, 0, 0);
        
        a = 8'd5; b = 8'd10; op_code = 4'b1001; // CMPLT
        #10 display_result(8'h01, 0, 0, 0);
        
        a = 8'd10; b = 8'd10; op_code = 4'b1010; // CMPLE
        #10 display_result(8'h01, 0, 0, 0);
        
        // Test multiplication
        a = 8'd10; b = 8'd5; op_code = 4'b1011; // MUL
        #10 display_result(8'd50, 0, 0, 0);
        
        a = 8'd20; b = 8'd20; op_code = 4'b1011; // MUL with carry
        #10 display_result(8'd144, 0, 1, 0); // 400 % 256 = 144, with carry
        
        $display("ALU Testbench Complete");
        $finish;
    end
    
    // GTKWave dump
    initial begin
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, alu_tb);
    end

endmodule
