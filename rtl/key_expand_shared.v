module key_expand_shared(
    input wire clk,
    input wire rst,
    input wire start,
    input wire [127:0] key_in,
    output reg [127:0] key_out,
    output reg valid
);

wire [7:0] rcon [0:9];
assign rcon[0] = 8'h01;
assign rcon[1] = 8'h02;
assign rcon[2] = 8'h04;
assign rcon[3] = 8'h08;
assign rcon[4] = 8'h10;
assign rcon[5] = 8'h20;
assign rcon[6] = 8'h40;
assign rcon[7] = 8'h80;
assign rcon[8] = 8'h1b;
assign rcon[9] = 8'h36;

localparam S_IDLE = 2'b00;
localparam S_GEN  = 2'b01;
localparam S_OUT  = 2'b10;

reg [1:0] state;
reg [3:0] round_cnt;
reg [127:0] current_key;
reg [127:0] next_key;
reg [31:0] w0, w1, w2, w3;
reg [31:0] w4, w5, w6, w7;
reg [7:0] sbox_in;
wire [7:0] sbox_out;

aes_sbox sbox_inst (.a(sbox_in), .d(sbox_out));

always @(posedge clk) begin
    if (rst) begin
        state <= S_IDLE;
        round_cnt <= 4'd0;
        current_key <= 128'd0;
        key_out <= 128'd0;
        valid <= 1'b0;
        w0 <= 32'd0; w1 <= 32'd0; w2 <= 32'd0; w3 <= 32'd0;
        w4 <= 32'd0; w5 <= 32'd0; w6 <= 32'd0; w7 <= 32'd0;
    end else begin
        case (state)
            S_IDLE: begin
                valid <= 1'b0;
                if (start) begin
                    current_key <= key_in;
                    {w0, w1, w2, w3} <= key_in;
                    round_cnt <= 4'd0;
                    key_out <= key_in;
                    valid <= 1'b1;
                    state <= S_GEN;
                end else begin
                    valid <= 1'b0;
                end
            end
            
            S_GEN: begin
                // Generate next round key using shared S-box
                // w4 = w0 ^ SubWord(RotWord(w3)) ^ Rcon
                // w5 = w1 ^ w4
                // w6 = w2 ^ w5
                // w7 = w3 ^ w6
                
                sbox_in <= w3[7:0];
                #1;
                w4 <= w0 ^ {sbox_out, w3[31:8]} ^ {rcon[round_cnt], 24'h000000};
                w5 <= w1 ^ w4;
                w6 <= w2 ^ w5;
                w7 <= w3 ^ w6;
                
                next_key <= {w4, w5, w6, w7};
                current_key <= next_key;
                round_cnt <= round_cnt + 1'b1;
                key_out <= next_key;
                valid <= 1'b1;
                
                if (round_cnt == 4'd9) begin
                    state <= S_IDLE;
                end
            end
            
            default: state <= S_IDLE;
        endcase
    end
end

endmodule