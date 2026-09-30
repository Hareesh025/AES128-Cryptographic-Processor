module mix_columns_pipelined(
    input wire clk,
    input wire rst,
    input wire valid_in,
    input wire [127:0] state_in,
    output reg valid_out,
    output reg [127:0] state_out
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

// Stage 1: Register inputs and compute xtime
reg [7:0] s0_s1, s1_s1, s2_s1, s3_s1;
reg [7:0] s4_s1, s5_s1, s6_s1, s7_s1;
reg [7:0] s8_s1, s9_s1, s10_s1, s11_s1;
reg [7:0] s12_s1, s13_s1, s14_s1, s15_s1;

reg [7:0] xt0_s1, xt1_s1, xt2_s1, xt3_s1;
reg [7:0] xt4_s1, xt5_s1, xt6_s1, xt7_s1;
reg [7:0] xt8_s1, xt9_s1, xt10_s1, xt11_s1;
reg [7:0] xt12_s1, xt13_s1, xt14_s1, xt15_s1;

reg [7:0] m3_0_s1, m3_1_s1, m3_2_s1, m3_3_s1;
reg [7:0] m3_4_s1, m3_5_s1, m3_6_s1, m3_7_s1;
reg [7:0] m3_8_s1, m3_9_s1, m3_10_s1, m3_11_s1;
reg [7:0] m3_12_s1, m3_13_s1, m3_14_s1, m3_15_s1;

reg valid_s1;

// Stage 2: Compute column outputs
reg [7:0] c0_s2, c1_s2, c2_s2, c3_s2;
reg [7:0] c4_s2, c5_s2, c6_s2, c7_s2;
reg [7:0] c8_s2, c9_s2, c10_s2, c11_s2;
reg [7:0] c12_s2, c13_s2, c14_s2, c15_s2;
reg valid_s2;

always @(posedge clk) begin
    if (rst) begin
        valid_s1 <= 1'b0;
        valid_s2 <= 1'b0;
        valid_out <= 1'b0;
    end else begin
        // Stage 1
        valid_s1 <= valid_in;
        if (valid_in) begin
            s0_s1  <= state_in[127:120];  s1_s1  <= state_in[119:112];
            s2_s1  <= state_in[111:104];  s3_s1  <= state_in[103:96];
            s4_s1  <= state_in[95:88];    s5_s1  <= state_in[87:80];
            s6_s1  <= state_in[79:72];    s7_s1  <= state_in[71:64];
            s8_s1  <= state_in[63:56];    s9_s1  <= state_in[55:48];
            s10_s1 <= state_in[47:40];    s11_s1 <= state_in[39:32];
            s12_s1 <= state_in[31:24];    s13_s1 <= state_in[23:16];
            s14_s1 <= state_in[15:8];     s15_s1 <= state_in[7:0];
            
            xt0_s1  <= xtime(state_in[127:120]);  xt1_s1  <= xtime(state_in[119:112]);
            xt2_s1  <= xtime(state_in[111:104]);  xt3_s1  <= xtime(state_in[103:96]);
            xt4_s1  <= xtime(state_in[95:88]);    xt5_s1  <= xtime(state_in[87:80]);
            xt6_s1  <= xtime(state_in[79:72]);    xt7_s1  <= xtime(state_in[71:64]);
            xt8_s1  <= xtime(state_in[63:56]);    xt9_s1  <= xtime(state_in[55:48]);
            xt10_s1 <= xtime(state_in[47:40]);    xt11_s1 <= xtime(state_in[39:32]);
            xt12_s1 <= xtime(state_in[31:24]);    xt13_s1 <= xtime(state_in[23:16]);
            xt14_s1 <= xtime(state_in[15:8]);     xt15_s1 <= xtime(state_in[7:0]);
            
            m3_0_s1  <= mul3(state_in[127:120]);  m3_1_s1  <= mul3(state_in[119:112]);
            m3_2_s1  <= mul3(state_in[111:104]);  m3_3_s1  <= mul3(state_in[103:96]);
            m3_4_s1  <= mul3(state_in[95:88]);    m3_5_s1  <= mul3(state_in[87:80]);
            m3_6_s1  <= mul3(state_in[79:72]);    m3_7_s1  <= mul3(state_in[71:64]);
            m3_8_s1  <= mul3(state_in[63:56]);    m3_9_s1  <= mul3(state_in[55:48]);
            m3_10_s1 <= mul3(state_in[47:40]);    m3_11_s1 <= mul3(state_in[39:32]);
            m3_12_s1 <= mul3(state_in[31:24]);    m3_13_s1 <= mul3(state_in[23:16]);
            m3_14_s1 <= mul3(state_in[15:8]);     m3_15_s1 <= mul3(state_in[7:0]);
        end
        
        // Stage 2
        valid_s2 <= valid_s1;
        if (valid_s1) begin
            c0_s2  <= xt0_s1  ^ m3_1_s1 ^ s2_s1  ^ s3_s1;
            c1_s2  <= s0_s1   ^ xt1_s1  ^ m3_2_s1 ^ s3_s1;
            c2_s2  <= s0_s1   ^ s1_s1   ^ xt2_s1  ^ m3_3_s1;
            c3_s2  <= m3_0_s1 ^ s1_s1   ^ s2_s1   ^ xt3_s1;
            
            c4_s2  <= xt4_s1  ^ m3_5_s1 ^ s6_s1  ^ s7_s1;
            c5_s2  <= s4_s1   ^ xt5_s1  ^ m3_6_s1 ^ s7_s1;
            c6_s2  <= s4_s1   ^ s5_s1   ^ xt6_s1  ^ m3_7_s1;
            c7_s2  <= m3_4_s1 ^ s5_s1   ^ s6_s1   ^ xt7_s1;
            
            c8_s2  <= xt8_s1  ^ m3_9_s1 ^ s10_s1 ^ s11_s1;
            c9_s2  <= s8_s1   ^ xt9_s1  ^ m3_10_s1 ^ s11_s1;
            c10_s2 <= s8_s1   ^ s9_s1   ^ xt10_s1 ^ m3_11_s1;
            c11_s2 <= m3_8_s1 ^ s9_s1   ^ s10_s1  ^ xt11_s1;
            
            c12_s2 <= xt12_s1 ^ m3_13_s1 ^ s14_s1 ^ s15_s1;
            c13_s2 <= s12_s1  ^ xt13_s1  ^ m3_14_s1 ^ s15_s1;
            c14_s2 <= s12_s1  ^ s13_s1   ^ xt14_s1  ^ m3_15_s1;
            c15_s2 <= m3_12_s1 ^ s13_s1   ^ s14_s1  ^ xt15_s1;
        end
        
        // Output stage
        valid_out <= valid_s2;
        if (valid_s2) begin
            state_out <= {c0_s2, c1_s2, c2_s2, c3_s2, c4_s2, c5_s2, c6_s2, c7_s2,
                         c8_s2, c9_s2, c10_s2, c11_s2, c12_s2, c13_s2, c14_s2, c15_s2};
        end
    end
end

endmodule