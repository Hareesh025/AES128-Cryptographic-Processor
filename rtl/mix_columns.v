module mix_columns(
    input wire [127:0] state_in,
    output wire [127:0] state_out
);

function [7:0] xtime;
    input [7:0] x;
    begin
        xtime = (x[7] == 1'b0) ? (x << 1) : ((x << 1) ^ 8'h1b);
    end
endfunction

function [7:0] mul3;
    input [7:0] x;
    begin
        mul3 = xtime(x) ^ x;
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

assign c0  = xtime(s0)  ^ mul3(s1) ^ s2      ^ s3;
assign c1  = s0         ^ xtime(s1) ^ mul3(s2) ^ s3;
assign c2  = s0         ^ s1       ^ xtime(s2) ^ mul3(s3);
assign c3  = mul3(s0)   ^ s1       ^ s2       ^ xtime(s3);

assign c4  = xtime(s4)  ^ mul3(s5) ^ s6      ^ s7;
assign c5  = s4         ^ xtime(s5) ^ mul3(s6) ^ s7;
assign c6  = s4         ^ s5       ^ xtime(s6) ^ mul3(s7);
assign c7  = mul3(s4)   ^ s5       ^ s6       ^ xtime(s7);

assign c8  = xtime(s8)  ^ mul3(s9) ^ s10     ^ s11;
assign c9  = s8         ^ xtime(s9) ^ mul3(s10) ^ s11;
assign c10 = s8         ^ s9       ^ xtime(s10) ^ mul3(s11);
assign c11 = mul3(s8)   ^ s9       ^ s10      ^ xtime(s11);

assign c12 = xtime(s12) ^ mul3(s13) ^ s14    ^ s15;
assign c13 = s12        ^ xtime(s13) ^ mul3(s14) ^ s15;
assign c14 = s12        ^ s13       ^ xtime(s14) ^ mul3(s15);
assign c15 = mul3(s12)  ^ s13       ^ s14      ^ xtime(s15);

assign state_out = {c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15};

endmodule