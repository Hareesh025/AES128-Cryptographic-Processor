module aes_sbox_opt(
    input wire [7:0] a,
    output wire [7:0] d
);

wire [7:0] a_inv;
wire [3:0] y0, y1, y2, y3;

// Composite field inversion in GF(2^4)^2
// Using tower field GF(2^8) = GF((2^4)^2)
// Irreducible polynomials:
// GF(2^4): x^4 + x + 1 (0x13)
// GF(2^8): x^2 + x + 0xE (using GF(2^4) elements)

// Step 1: Map to composite field
wire [3:0] ah = a[7:4];
wire [3:0] al = a[3:0];

// Inversion in GF(2^4) for subfield elements
function [3:0] gf16_inv;
    input [3:0] x;
    reg [3:0] y;
    begin
        case (x)
            4'h0: y = 4'h0;
            4'h1: y = 4'h1;
            4'h2: y = 4'h9;
            4'h3: y = 4'hE;
            4'h4: y = 4'hD;
            4'h5: y = 4'hB;
            4'h6: y = 4'h7;
            4'h7: y = 4'h6;
            4'h8: y = 4'hF;
            4'h9: y = 4'h2;
            4'hA: y = 4'hC;
            4'hB: y = 4'h5;
            4'hC: y = 4'hA;
            4'hD: y = 4'h4;
            4'hE: y = 4'h3;
            4'hF: y = 4'h8;
            default: y = 4'h0;
        endcase
        gf16_inv = y;
    end
endfunction

// GF(2^4) multiplication by constant
function [3:0] gf16_mul2;
    input [3:0] x;
    begin
        gf16_mul2 = (x[3] == 1'b0) ? (x << 1) : ((x << 1) ^ 4'h3);
    end
endfunction

function [3:0] gf16_mul4;
    input [3:0] x;
    begin
        gf16_mul4 = gf16_mul2(gf16_mul2(x));
    end
endfunction

function [3:0] gf16_mul8;
    input [3:0] x;
    begin
        gf16_mul8 = gf16_mul2(gf16_mul4(x));
    end
endfunction

// Composite field operations
wire [3:0] t1, t2, t3, t4, t5, t6, t7, t8, t9;
wire [3:0] delta, delta_inv;

// ah * al in GF(2^4)
assign t1 = ah ^ al;
assign t2 = gf16_mul2(ah) ^ al;
assign t3 = ah ^ gf16_mul2(al);

// Delta = ah*al + ah^2 + al^2 (in GF(2^4))
// Using normal basis or polynomial basis
assign delta = gf16_mul2(ah) ^ gf16_mul2(al) ^ ah ^ al; // Simplified

// Delta inverse
assign delta_inv = gf16_inv(delta);

// Multiplications with delta_inv
assign t4 = gf16_mul2(delta_inv) ^ delta_inv; // * 3
assign t5 = gf16_mul4(delta_inv) ^ delta_inv; // * 5
assign t6 = gf16_mul8(delta_inv) ^ gf16_mul4(delta_inv) ^ delta_inv; // * D

// Final coordinates
assign y0 = t4 ^ t1;
assign y1 = t5 ^ t2;
assign y2 = t6 ^ t3;
assign y3 = t4 ^ t1 ^ t2 ^ t3;

// Affine transformation
assign a_inv = {y0, y1, y2, y3};

// AES affine transformation
assign d[0] = a_inv[0] ^ a_inv[4] ^ a_inv[5] ^ a_inv[6] ^ a_inv[7] ^ 1'b1;
assign d[1] = a_inv[0] ^ a_inv[1] ^ a_inv[5] ^ a_inv[6] ^ a_inv[7] ^ 1'b1;
assign d[2] = a_inv[0] ^ a_inv[1] ^ a_inv[2] ^ a_inv[6] ^ a_inv[7] ^ 1'b0;
assign d[3] = a_inv[0] ^ a_inv[1] ^ a_inv[2] ^ a_inv[3] ^ a_inv[7] ^ 1'b0;
assign d[4] = a_inv[0] ^ a_inv[1] ^ a_inv[2] ^ a_inv[3] ^ a_inv[4] ^ 1'b0;
assign d[5] = a_inv[1] ^ a_inv[2] ^ a_inv[3] ^ a_inv[4] ^ a_inv[5] ^ 1'b1;
assign d[6] = a_inv[2] ^ a_inv[3] ^ a_inv[4] ^ a_inv[5] ^ a_inv[6] ^ 1'b1;
assign d[7] = a_inv[3] ^ a_inv[4] ^ a_inv[5] ^ a_inv[6] ^ a_inv[7] ^ 1'b0;

endmodule