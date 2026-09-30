module aes128_top(
    input wire clk,
    input wire rst,
    input wire start,
    input wire mode,
    input wire [127:0] data_in,
    input wire [127:0] key,
    output wire [127:0] data_out,
    output wire done
);

wire [127:0] encrypt_out;
wire encrypt_done;
wire [127:0] decrypt_out;
wire decrypt_done;

aes128_encrypt encrypt_inst (
    .clk(clk),
    .rst(rst),
    .start(start & ~mode),
    .plaintext(data_in),
    .key(key),
    .ciphertext(encrypt_out),
    .done(encrypt_done)
);

aes128_decrypt decrypt_inst (
    .clk(clk),
    .rst(rst),
    .start(start & mode),
    .ciphertext(data_in),
    .key(key),
    .plaintext(decrypt_out),
    .done(decrypt_done)
);

assign data_out = mode ? decrypt_out : encrypt_out;
assign done = mode ? decrypt_done : encrypt_done;

endmodule