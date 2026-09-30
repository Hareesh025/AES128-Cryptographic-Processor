`timescale 1ns / 1ps

module aes128_tb;

reg clk;
reg rst;
reg start;
reg mode;
reg [127:0] data_in;
reg [127:0] key;

wire [127:0] data_out;
wire done;

integer i;
reg encrypt_pass;
reg decrypt_pass;

aes128_top dut (
    .clk(clk),
    .rst(rst),
    .start(start),
    .mode(mode),
    .data_in(data_in),
    .key(key),
    .data_out(data_out),
    .done(done)
);

// ============================================================
// CLOCK
// ============================================================
initial begin
    clk = 1'b0;

    forever begin
        #5 clk = ~clk;
    end
end

// ============================================================
// MAIN TEST
// ============================================================
initial begin

    encrypt_pass = 1'b0;
    decrypt_pass = 1'b0;

    // Initial conditions
    rst     = 1'b1;
    start   = 1'b0;
    mode    = 1'b0;
    data_in = 128'h00000000000000000000000000000000;
    key     = 128'h00000000000000000000000000000000;

    // ========================================================
    // RESET
    // ========================================================

    #20;

    rst = 1'b0;

    @(negedge clk);

    $display("");
    $display("========================================");
    $display("       AES-128 BASELINE TEST");
    $display("========================================");

    // ========================================================
    // ENCRYPTION TEST
    // ========================================================

    $display("");
    $display("------------- ENCRYPTION ---------------");

    data_in = 128'h00112233445566778899aabbccddeeff;
    key     = 128'h000102030405060708090a0b0c0d0e0f;
    mode    = 1'b0;

    $display("Plaintext : %h", data_in);
    $display("Key       : %h", key);
    $display("Expected  : 69c4e0d86a7b0430d8cdb78070b4c55a");

    // Start encryption
    @(negedge clk);
    start = 1'b1;

    @(negedge clk);
    start = 1'b0;

    // Wait for DONE with timeout
    i = 0;

    while ((done == 1'b0) && (i < 100)) begin
        @(posedge clk);
        #1;
        i = i + 1;
    end

    if (done == 1'b1) begin

        $display("DONE received.");
        $display("Actual    : %h", data_out);

        if (data_out == 128'h69c4e0d86a7b0430d8cdb78070b4c55a) begin
            $display("ENCRYPTION TEST: PASSED");
            encrypt_pass = 1'b1;
        end
        else begin
            $display("ENCRYPTION TEST: FAILED");
        end

    end
    else begin

        $display("ERROR: ENCRYPTION TIMEOUT.");
        $display("DONE was never asserted.");

    end

    // ========================================================
    // DECRYPTION TEST
    // ========================================================

    $display("");
    $display("------------- DECRYPTION ---------------");

    data_in = 128'h69c4e0d86a7b0430d8cdb78070b4c55a;
    key     = 128'h000102030405060708090a0b0c0d0e0f;
    mode    = 1'b1;

    $display("Ciphertext: %h", data_in);
    $display("Key       : %h", key);
    $display("Expected  : 00112233445566778899aabbccddeeff");

    // Start decryption
    @(negedge clk);
    start = 1'b1;

    @(negedge clk);
    start = 1'b0;

    // Wait for DONE with timeout
    i = 0;

    while ((done == 1'b0) && (i < 100)) begin
        @(posedge clk);
        #1;
        i = i + 1;
    end

    if (done == 1'b1) begin

        $display("DONE received.");
        $display("Actual    : %h", data_out);

        if (data_out == 128'h00112233445566778899aabbccddeeff) begin
            $display("DECRYPTION TEST: PASSED");
            decrypt_pass = 1'b1;
        end
        else begin
            $display("DECRYPTION TEST: FAILED");
        end

    end
    else begin

        $display("ERROR: DECRYPTION TIMEOUT.");
        $display("DONE was never asserted.");

    end

    // ========================================================
    // FINAL RESULT
    // ========================================================

    $display("");
    $display("========================================");

    if (encrypt_pass && decrypt_pass) begin
        $display("       AES-128 BASELINE: PASS");
    end
    else begin
        $display("       AES-128 BASELINE: FAIL");
    end

    $display("========================================");

    #20;

    $finish;

end

endmodule