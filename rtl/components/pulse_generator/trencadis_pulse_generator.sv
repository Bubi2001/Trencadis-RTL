// ================================================================================
// 
// Module/File Name    : trencadis_pulse_generator
// Project Name        : Trencadís RTL
// Description         : This module generates a pulse 1 clk long each 
//                       max_count + 1 cycles
// 
// Author              : Adrià Babiano Novella
// Create Date         : 2025-08-16
// Revision            : v1.0
// Revision history:
//   v1.0 - Initial Version
// ================================================================================

module trencadis_pulse_generator #(
    parameter SIZE = 8
) (
    input  logic            clk_i,
    input  logic            rst_ni,
    input  logic [SIZE-1:0] max_count_i,
    output logic            pulse_o
);

    logic [SIZE-1:0] counter_q;

    // Combined counter and pulse logic into a single block for efficiency and clarity.
    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
            counter_q <= '0;
            pulse_o   <= 1'b0;
        end else begin
            // Default assignment for the pulse is low
            pulse_o <= 1'b0;
            // Check if the max_count has been reached
            if (counter_q == max_count_i) begin
                counter_q <= '0;
                // Generate a pulse ONLY if the max_count is not zero.
                // This fixes the bug where the pulse was stuck high for max_count_i = 0.
                if (|max_count_i) begin
                    pulse_o <= 1'b1;
                end
            end else begin
                counter_q <= counter_q + 1;
            end
        end
    end

endmodule
