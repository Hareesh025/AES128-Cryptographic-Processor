module inv_sub_bytes(
    input wire [127:0] state_in,
    output wire [127:0] state_out
);

    aes_inv_sbox sbox0 (.a(state_in[127:120]), .d(state_out[127:120]));
    aes_inv_sbox sbox1 (.a(state_in[119:112]), .d(state_out[119:112]));
    aes_inv_sbox sbox2 (.a(state_in[111:104]), .d(state_out[111:104]));
    aes_inv_sbox sbox3 (.a(state_in[103:96]),  .d(state_out[103:96]));
    aes_inv_sbox sbox4 (.a(state_in[95:88]),   .d(state_out[95:88]));
    aes_inv_sbox sbox5 (.a(state_in[87:80]),   .d(state_out[87:80]));
    aes_inv_sbox sbox6 (.a(state_in[79:72]),   .d(state_out[79:72]));
    aes_inv_sbox sbox7 (.a(state_in[71:64]),   .d(state_out[71:64]));
    aes_inv_sbox sbox8 (.a(state_in[63:56]),   .d(state_out[63:56]));
    aes_inv_sbox sbox9 (.a(state_in[55:48]),   .d(state_out[55:48]));
    aes_inv_sbox sbox10(.a(state_in[47:40]),   .d(state_out[47:40]));
    aes_inv_sbox sbox11(.a(state_in[39:32]),   .d(state_out[39:32]));
    aes_inv_sbox sbox12(.a(state_in[31:24]),   .d(state_out[31:24]));
    aes_inv_sbox sbox13(.a(state_in[23:16]),   .d(state_out[23:16]));
    aes_inv_sbox sbox14(.a(state_in[15:8]),    .d(state_out[15:8]));
    aes_inv_sbox sbox15(.a(state_in[7:0]),     .d(state_out[7:0]));

endmodule