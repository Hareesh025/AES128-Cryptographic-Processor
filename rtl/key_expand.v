module key_expand(
    input  wire [127:0] key_in,
    input  wire [3:0] round,
    output wire [127:0] key_out
);

wire [31:0] w0;
wire [31:0] w1;
wire [31:0] w2;
wire [31:0] w3;

assign w0 = key_in[127:96];
assign w1 = key_in[95:64];
assign w2 = key_in[63:32];
assign w3 = key_in[31:0];

wire [7:0] s0;
wire [7:0] s1;
wire [7:0] s2;
wire [7:0] s3;

aes_sbox S0 (
    .a(w3[23:16]),
    .d(s0)
);

aes_sbox S1 (
    .a(w3[15:8]),
    .d(s1)
);

aes_sbox S2 (
    .a(w3[7:0]),
    .d(s2)
);

aes_sbox S3 (
    .a(w3[31:24]),
    .d(s3)
);

function [7:0] rcon;
    input [3:0] r;

    begin
        case (r)
            4'd1:  rcon = 8'h01;
            4'd2:  rcon = 8'h02;
            4'd3:  rcon = 8'h04;
            4'd4:  rcon = 8'h08;
            4'd5:  rcon = 8'h10;
            4'd6:  rcon = 8'h20;
            4'd7:  rcon = 8'h40;
            4'd8:  rcon = 8'h80;
            4'd9:  rcon = 8'h1b;
            4'd10: rcon = 8'h36;
            default: rcon = 8'h00;
        endcase
    end
endfunction

wire [31:0] t;
wire [31:0] n0;
wire [31:0] n1;
wire [31:0] n2;
wire [31:0] n3;

assign t  = {s0 ^ rcon(round), s1, s2, s3};

assign n0 = w0 ^ t;
assign n1 = w1 ^ n0;
assign n2 = w2 ^ n1;
assign n3 = w3 ^ n2;

assign key_out = {n0, n1, n2, n3};

endmodule