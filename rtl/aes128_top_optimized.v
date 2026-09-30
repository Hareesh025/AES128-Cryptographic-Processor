module aes128_top_optimized(
    input wire clk,
    input wire rst,
    input wire start,
    input wire mode,
    input wire [127:0] data_in,
    input wire [127:0] key,
    input wire use_opt,  // 0 = baseline, 1 = optimized
    output wire [127:0] data_out,
    output wire done
);

wire [127:0] encrypt_out_base, encrypt_out_opt;
wire encrypt_done_base, encrypt_done_opt;
wire [127:0] decrypt_out_base, decrypt_out_opt;
wire decrypt_done_base, decrypt_done_opt;

// Baseline instances
aes128_encrypt encrypt_base (
    .clk(clk), .rst(rst), .start(start & ~mode & ~use_opt),
    .plaintext(data_in), .key(key),
    .ciphertext(encrypt_out_base), .done(encrypt_done_base)
);

aes128_decrypt decrypt_base (
    .clk(clk), .rst(rst), .start(start & mode & ~use_opt),
    .ciphertext(data_in), .key(key),
    .plaintext(decrypt_out_base), .done(decrypt_done_base)
);

// Optimized instances (using composite field S-box, shared key expand, pipelined MixColumns)
// Note: These would need corresponding optimized encrypt/decrypt modules
// For now, we instantiate the same modules - replace with optimized versions when available

assign encrypt_out_opt = encrypt_out_base;
assign encrypt_done_opt = encrypt_done_base;
assign decrypt_out_opt = decrypt_out_base;
assign decrypt_done_opt = decrypt_done_base;

// Output mux
assign data_out = use_opt ? (mode ? decrypt_out_opt : encrypt_out_opt) : (mode ? decrypt_out_base : encrypt_out_base);
assign done = use_opt ? (mode ? decrypt_done_opt : encrypt_done_opt) : (mode ? decrypt_done_base : encrypt_done_base);

endmodule