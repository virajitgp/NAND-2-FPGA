`timescale 1ns/1ps

module alu_tb();
    // Test signals
    reg [15:0] a;
    reg [15:0] b;
    reg [3:0] op_code;
    wire [15:0] result;
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
        input [15:0] expected_result;
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
        $display("Starting 16-bit ALU Testbench");
        
        // Test addition
        a = 16'd1000; b = 16'd2000; op_code = 4'b0000;
        #10 display_result(16'd3000, 0, 0, 0);
        
        // Test addition with carry
        a = 16'd40000; b = 16'd30000; op_code = 4'b0000;
        #10 display_result(16'd4464, 0, 1, 0); // 70000 % 65536 = 4464, with carry
        
        // Test addition with overflow
        a = 16'h7FFF; b = 16'h0001; op_code = 4'b0000; // 32767 + 1 = 32768 (overflow)
        #10 display_result(16'h8000, 0, 0, 1);
        
        // Test subtraction
        a = 16'd5000; b = 16'd2000; op_code = 4'b0001;
        #10 display_result(16'd3000, 0, 0, 0);
        
        // Test subtraction with borrow
        a = 16'd1000; b = 16'd2000; op_code = 4'b0001;
        #10 display_result(16'd64536, 0, 1, 0); // -1000 = 64536 in two's complement
        
        // Test subtraction with overflow
        a = 16'h8000; b = 16'h0001; op_code = 4'b0001; // -32768 - 1 = -32769 (overflow)
        #10 display_result(16'h7FFF, 0, 1, 1);
        
        // Test logical operations
        a = 16'hAAAA; b = 16'h5555; op_code = 4'b0010; // AND
        #10 display_result(16'h0000, 1, 0, 0);
        
        a = 16'hAAAA; b = 16'h5555; op_code = 4'b0011; // OR
        #10 display_result(16'hFFFF, 0, 0, 0);
        
        a = 16'hAAAA; b = 16'h5555; op_code = 4'b0100; // XOR
        #10 display_result(16'hFFFF, 0, 0, 0);
        
        a = 16'hAAAA; b = 16'h0000; op_code = 4'b0101; // NOT
        #10 display_result(16'h5555, 0, 0, 0);
        
        // Test shifts
        a = 16'h0001; b = 16'h0008; op_code = 4'b0110; // SHL
        #10 display_result(16'h0100, 0, 0, 0);
        
        a = 16'h8000; b = 16'h0008; op_code = 4'b0111; // SHR
        #10 display_result(16'h0080, 0, 0, 0);
        
        // Test comparisons
        a = 16'd1000; b = 16'd1000; op_code = 4'b1000; // CMPEQ
        #10 display_result(16'h0001, 0, 0, 0);
        
        a = 16'd500; b = 16'd1000; op_code = 4'b1001; // CMPLT
        #10 display_result(16'h0001, 0, 0, 0);
        
        a = 16'd1000; b = 16'd1000; op_code = 4'b1010; // CMPLE
        #10 display_result(16'h0001, 0, 0, 0);
        
        // Test multiplication
        a = 16'd100; b = 16'd50; op_code = 4'b1011; // MUL
        #10 display_result(16'd5000, 0, 0, 0);
        
        a = 16'd1000; b = 16'd1000; op_code = 4'b1011; // MUL with carry
        #10 display_result(16'd16960, 0, 1, 0); // 1000000 % 65536 = 16960, with carry
        
        $display("16-bit ALU Testbench Complete");
        $finish;
    end
    
    // GTKWave dump
    initial begin
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, alu_tb);
    end

endmodule
