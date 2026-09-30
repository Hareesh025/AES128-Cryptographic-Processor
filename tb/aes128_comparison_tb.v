`timescale 1ns / 1ps

module aes128_comparison_tb;

reg clk;
reg rst;
reg start;
reg mode;
reg use_opt;
reg [127:0] data_in;
reg [127:0] key;
wire [127:0] data_out;
wire done;

aes128_top_optimized dut (
    .clk(clk),
    .rst(rst),
    .start(start),
    .mode(mode),
    .data_in(data_in),
    .key(key),
    .use_opt(use_opt),
    .data_out(data_out),
    .done(done)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

task test_operation;
    input [127:0] test_data;
    input [127:0] test_key;
    input test_mode;
    input test_use_opt;
    input [127:0] expected;
    input [100*8:0] test_name;
    begin
        data_in = test_data;
        key = test_key;
        mode = test_mode;
        use_opt = test_use_opt;
        start = 1'b1;
        #10;
        start = 1'b0;
        
        wait(done);
        #10;
        
        $display("%s", test_name);
        $display("  Mode: %s, Opt: %s", mode ? "DECRYPT" : "ENCRYPT", use_opt ? "YES" : "NO");
        $display("  Expected: %h", expected);
        $display("  Actual:   %h", data_out);
        if (data_out == expected) begin
            $display("  RESULT: PASSED");
        end else begin
            $display("  RESULT: FAILED");
        end
        $display("");
    end
endtask

initial begin
    rst = 1;
    start = 0;
    mode = 0;
    use_opt = 0;
    data_in = 128'h0;
    key = 128'h0;
    
    #20;
    rst = 0;
    #10;
    
    $display("========================================");
    $display("AES-128 Baseline vs Optimized Comparison");
    $display("========================================");
    
    // Test baseline encryption
    test_operation(
        128'h00112233445566778899aabbccddeeff,
        128'h000102030405060708090a0b0c0d0e0f,
        1'b0, 1'b0,
        128'h69c4e0d86a7b0430d8cdb78070b4c55a,
        "Baseline Encryption"
    );
    
    // Test baseline decryption
    test_operation(
        128'h69c4e0d86a7b0430d8cdb78070b4c55a,
        128'h000102030405060708090a0b0c0d0e0f,
        1'b1, 1'b0,
        128'h00112233445566778899aabbccddeeff,
        "Baseline Decryption"
    );
    
    // Test optimized encryption (same as baseline for now)
    test_operation(
        128'h00112233445566778899aabbccddeeff,
        128'h000102030405060708090a0b0c0d0e0f,
        1'b0, 1'b1,
        128'h69c4e0d86a7b0430d8cdb78070b4c55a,
        "Optimized Encryption"
    );
    
    // Test optimized decryption
    test_operation(
        128'h69c4e0d86a7b0430d8cdb78070b4c55a,
        128'h000102030405060708090a0b0c0d0e0f,
        1'b1, 1'b1,
        128'h00112233445566778899aabbccddeeff,
        "Optimized Decryption"
    );
    
    $display("========================================");
    $display("Comparison tests completed");
    $display("========================================");
    
    #20;
    $finish;
end

initial begin
    $dumpfile("C:/Users/yarab/AES128-Cryptographic-Processor/sim/waveforms/comparison_tb.vcd");
    $dumpvars(0, aes128_comparison_tb);
end

endmodule