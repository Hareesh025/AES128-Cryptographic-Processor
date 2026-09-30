module inv_mix_columns(
    input wire [127:0] state_in,
    output wire [127:0] state_out
);

function [7:0] gf_mul;
    input [7:0] a;
    input [7:0] b;
    reg [7:0] p;
    reg [7:0] a_reg;
    reg [7:0] b_reg;
    integer i;
    begin
        p = 8'h00;
        a_reg = a;
        b_reg = b;
        for (i = 0; i < 8; i = i + 1) begin
            if (b_reg[0] == 1'b1)
                p = p ^ a_reg;
            a_reg = (a_reg[7] == 1'b1) ? (a_reg << 1) ^ 8'h1b : (a_reg << 1);
            b_reg = b_reg >> 1;
        end
        gf_mul = p;
    end
endfunction

wire [7:0] s0, s1, s2, s3;
wire [7:0] s4, s5, s6, s7;
wire [7:0] s8, s9, s10, s11;
wire [7:0] s12, s13, s14, s15;

assign s0  = state_in[127:120];
assign s1  = state_in[119:112];
assign s2  = state_in[111:104];
assign s3  = state_in[103:96];
assign s4  = state_in[95:88];
assign s5  = state_in[87:80];
assign s6  = state_in[79:72];
assign s7  = state_in[71:64];
assign s8  = state_in[63:56];
assign s9  = state_in[55:48];
assign s10 = state_in[47:40];
assign s11 = state_in[39:32];
assign s12 = state_in[31:24];
assign s13 = state_in[23:16];
assign s14 = state_in[15:8];
assign s15 = state_in[7:0];

wire [7:0] c0, c1, c2, c3;
wire [7:0] c4, c5, c6, c7;
wire [7:0] c8, c9, c10, c11;
wire [7:0] c12, c13, c14, c15;

assign c0  = gf_mul(s0, 8'h0e) ^ gf_mul(s1, 8'h0b) ^ gf_mul(s2, 8'h0d) ^ gf_mul(s3, 8'h09);
assign c1  = gf_mul(s0, 8'h09) ^ gf_mul(s1, 8'h0e) ^ gf_mul(s2, 8'h0b) ^ gf_mul(s3, 8'h0d);
assign c2  = gf_mul(s0, 8'h0d) ^ gf_mul(s1, 8'h09) ^ gf_mul(s2, 8'h0e) ^ gf_mul(s3, 8'h0b);
assign c3  = gf_mul(s0, 8'h0b) ^ gf_mul(s1, 8'h0d) ^ gf_mul(s2, 8'h09) ^ gf_mul(s3, 8'h0e);

assign c4  = gf_mul(s4, 8'h0e) ^ gf_mul(s5, 8'h0b) ^ gf_mul(s6, 8'h0d) ^ gf_mul(s7, 8'h09);
assign c5  = gf_mul(s4, 8'h09) ^ gf_mul(s5, 8'h0e) ^ gf_mul(s6, 8'h0b) ^ gf_mul(s7, 8'h0d);
assign c6  = gf_mul(s4, 8'h0d) ^ gf_mul(s5, 8'h09) ^ gf_mul(s6, 8'h0e) ^ gf_mul(s7, 8'h0b);
assign c7  = gf_mul(s4, 8'h0b) ^ gf_mul(s5, 8'h0d) ^ gf_mul(s6, 8'h09) ^ gf_mul(s7, 8'h0e);

assign c8  = gf_mul(s8, 8'h0e) ^ gf_mul(s9, 8'h0b) ^ gf_mul(s10, 8'h0d) ^ gf_mul(s11, 8'h09);
assign c9  = gf_mul(s8, 8'h09) ^ gf_mul(s9, 8'h0e) ^ gf_mul(s10, 8'h0b) ^ gf_mul(s11, 8'h0d);
assign c10 = gf_mul(s8, 8'h0d) ^ gf_mul(s9, 8'h09) ^ gf_mul(s10, 8'h0e) ^ gf_mul(s11, 8'h0b);
assign c11 = gf_mul(s8, 8'h0b) ^ gf_mul(s9, 8'h0d) ^ gf_mul(s10, 8'h09) ^ gf_mul(s11, 8'h0e);

assign c12 = gf_mul(s12, 8'h0e) ^ gf_mul(s13, 8'h0b) ^ gf_mul(s14, 8'h0d) ^ gf_mul(s15, 8'h09);
assign c13 = gf_mul(s12, 8'h09) ^ gf_mul(s13, 8'h0e) ^ gf_mul(s14, 8'h0b) ^ gf_mul(s15, 8'h0d);
assign c14 = gf_mul(s12, 8'h0d) ^ gf_mul(s13, 8'h09) ^ gf_mul(s14, 8'h0e) ^ gf_mul(s15, 8'h0b);
assign c15 = gf_mul(s12, 8'h0b) ^ gf_mul(s13, 8'h0d) ^ gf_mul(s14, 8'h09) ^ gf_mul(s15, 8'h0e);

assign state_out = {c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15};

endmodule