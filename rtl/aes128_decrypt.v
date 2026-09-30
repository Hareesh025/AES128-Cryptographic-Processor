module aes128_decrypt(
    input wire clk,
    input wire rst,
    input wire start,
    input wire [127:0] ciphertext,
    input wire [127:0] key,
    output reg [127:0] plaintext,
    output reg done
);

localparam IDLE   = 3'd0;
localparam KEYGEN = 3'd1;
localparam INIT   = 3'd2;
localparam ROUND  = 3'd3;
localparam FINAL  = 3'd4;
localparam DONE   = 3'd5;

reg [2:0] state;

reg [3:0] keygen_counter;
reg [3:0] round_counter;

reg [127:0] keygen_state;
reg [127:0] current_state;

reg [127:0] round_keys [0:10];

wire [127:0] key_expand_out;

wire [127:0] inv_shift_rows_out;
wire [127:0] inv_sub_bytes_out;
wire [127:0] add_round_key_out;
wire [127:0] inv_mix_columns_out;


// ============================================================
// KEY EXPANSION
// ============================================================

key_expand ke_inst (
    .key_in  (keygen_state),
    .round   (keygen_counter),
    .key_out (key_expand_out)
);


// ============================================================
// INVERSE AES DATAPATH
// ============================================================

inv_shift_rows isr_inst (
    .state_in  (current_state),
    .state_out (inv_shift_rows_out)
);

inv_sub_bytes isb_inst (
    .state_in  (inv_shift_rows_out),
    .state_out (inv_sub_bytes_out)
);


// IMPORTANT:
// AES inverse round order is:
//
// InvShiftRows
// InvSubBytes
// AddRoundKey
// InvMixColumns
//

assign add_round_key_out =
    inv_sub_bytes_out ^ round_keys[round_counter];


inv_mix_columns imc_inst (
    .state_in  (add_round_key_out),
    .state_out (inv_mix_columns_out)
);


// ============================================================
// SEQUENTIAL CONTROL
// ============================================================

always @(posedge clk) begin

    if (rst) begin

        state          <= IDLE;

        keygen_counter <= 4'd0;
        round_counter  <= 4'd0;

        keygen_state   <= 128'd0;
        current_state  <= 128'd0;

        plaintext      <= 128'd0;
        done           <= 1'b0;

    end
    else begin

        done <= 1'b0;

        case (state)

            // ------------------------------------------------
            // IDLE
            // ------------------------------------------------
            IDLE: begin

                if (start) begin

                    // Store original AES key
                    round_keys[0] <= key;

                    // Start key expansion from round 1
                    keygen_state   <= key;
                    keygen_counter <= 4'd1;

                    state <= KEYGEN;

                end

            end


            // ------------------------------------------------
            // KEY GENERATION
            // ------------------------------------------------
            KEYGEN: begin

                round_keys[keygen_counter] <= key_expand_out;

                keygen_state <= key_expand_out;

                if (keygen_counter == 4'd10) begin

                    state <= INIT;

                end
                else begin

                    keygen_counter <= keygen_counter + 1'b1;

                end

            end


            // ------------------------------------------------
            // INITIAL ADD ROUND KEY
            // ------------------------------------------------
            INIT: begin

                // Ciphertext XOR round key 10
                current_state <= ciphertext ^ round_keys[10];

                // Start inverse rounds from round 9
                round_counter <= 4'd9;

                state <= ROUND;

            end


            // ------------------------------------------------
            // DECRYPTION ROUNDS 9 -> 1
            // ------------------------------------------------
            ROUND: begin

                current_state <= inv_mix_columns_out;

                if (round_counter == 4'd1) begin

                    state <= FINAL;

                end
                else begin

                    round_counter <= round_counter - 1'b1;

                end

            end


            // ------------------------------------------------
            // FINAL AES ROUND
            // ------------------------------------------------
            FINAL: begin

                // Final round does NOT use InvMixColumns
                plaintext <= inv_sub_bytes_out ^ round_keys[0];

                current_state <= inv_sub_bytes_out ^ round_keys[0];

                state <= DONE;

            end


            // ------------------------------------------------
            // DONE
            // ------------------------------------------------
            DONE: begin

                done <= 1'b1;

                state <= IDLE;

            end


            default: begin

                state <= IDLE;

            end

        endcase

    end

end

endmodule