module aes128_encrypt(
    input wire clk,
    input wire rst,
    input wire start,
    input wire [127:0] plaintext,
    input wire [127:0] key,
    output reg [127:0] ciphertext,
    output reg done
);

reg [127:0] state;
reg [127:0] round_key;

reg [3:0] round;
reg busy;

wire [127:0] sub_bytes_out;
wire [127:0] shift_rows_out;
wire [127:0] mix_columns_out;
wire [127:0] next_key;


// ============================================================
// AES ENCRYPTION DATAPATH
// ============================================================

sub_bytes U_SUBBYTES (
    .state_in(state),
    .state_out(sub_bytes_out)
);

shift_rows U_SHIFTROWS (
    .state_in(sub_bytes_out),
    .state_out(shift_rows_out)
);

mix_columns U_MIXCOLUMNS (
    .state_in(shift_rows_out),
    .state_out(mix_columns_out)
);

key_expand U_KEYEXPAND (
    .key_in(round_key),
    .round(round),
    .key_out(next_key)
);


// ============================================================
// AES ENCRYPTION CONTROLLER
// ============================================================

always @(posedge clk) begin

    // --------------------------------------------------------
    // RESET
    // --------------------------------------------------------

    if (rst) begin

        state      <= 128'd0;
        round_key  <= 128'd0;
        round      <= 4'd0;
        ciphertext <= 128'd0;
        done       <= 1'b0;
        busy       <= 1'b0;

    end

    // --------------------------------------------------------
    // NORMAL OPERATION
    // --------------------------------------------------------

    else begin

        // done is a one-clock pulse
        done <= 1'b0;


        // ====================================================
        // START NEW ENCRYPTION
        // ====================================================

        if (start && !busy) begin

            // Initial AddRoundKey
            state <= plaintext ^ key;

            // Initial round key
            round_key <= key;

            // Start AES round 1
            round <= 4'd1;

            busy <= 1'b1;

        end


        // ====================================================
        // AES ROUND PROCESSING
        // ====================================================

        else if (busy) begin


            // ------------------------------------------------
            // ROUNDS 1 TO 9
            // ------------------------------------------------

            if (round < 4'd10) begin

                // SubBytes
                // ShiftRows
                // MixColumns
                // AddRoundKey

                state <= mix_columns_out ^ next_key;

                // Store next round key
                round_key <= next_key;

                // Move to next round
                round <= round + 1'b1;

            end


            // ------------------------------------------------
            // FINAL ROUND - ROUND 10
            // ------------------------------------------------

            else begin

                // Final AES round does NOT use MixColumns
                //
                // SubBytes
                // ShiftRows
                // AddRoundKey

                ciphertext <= shift_rows_out ^ next_key;

                state <= shift_rows_out ^ next_key;

                round_key <= next_key;

                // Signal completion
                done <= 1'b1;

                busy <= 1'b0;

            end

        end

    end

end

endmodule