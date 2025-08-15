// ================================================================================
// 
// Module/File Name    : trencadis_register_file
// Project Name        : Trencadís RTL
// Description         : This module defines a register file with a parameterized
//                       number of read ports, a single write port, and an optional
//                       RISC-V style zero register.
// 
// Author              : Adrià Babiano Novella
// Create Date         : 2025-08-14
// Revision            : v1.0
// Revision history:
//   v1.0 - Initial Version
// ================================================================================

module trencadis_register_file #(
    // --- Parameters ---
    parameter int NUM_READ_PORTS     = 2,    // Number of read ports (configurable)
    parameter int REG_COUNT          = 32,   // Number of registers in the file
    parameter int DEPTH              = 32,   // Width of each register in bits
    parameter bit ZERO_REG_IS_ZERO   = 1,    // If 1, register 0 is hardwired to zero (RISC-V style)

    // --- Local Parameters ---
    // Calculate the required width for the address bus
    localparam int ADDR_WIDTH = $clog2(REG_COUNT)
) (
    // --- Global Signals ---
    input  logic                            clk_i,
    input  logic                            rst_ni,  // Active-low asynchronous reset

    // --- Write Port ---
    input  logic [ADDR_WIDTH-1:0]           waddr_i,  // Write address
    input  logic [DEPTH-1:0]                wdata_i,  // Write data
    input  logic                            wen_i,    // Write enable

    // --- Read Ports (Parameterized) ---
    // Read addresses are now a packed array.
    input  logic [NUM_READ_PORTS-1:0][ADDR_WIDTH-1:0] raddr_i,  // Read addresses
    // Read data is also a packed array, corresponding to each read port.
    output logic [NUM_READ_PORTS-1:0][DEPTH-1:0]     rdata_o   // Read data
);

    // --- Register Storage ---
    // This declares an array of REG_COUNT registers, where each register is DEPTH bits wide.
    logic [DEPTH-1:0] regs [REG_COUNT];

    // --- Synchronous Write Logic ---
    // This block handles the write operation on the rising edge of the clock.
    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
            // On reset, initialize all registers to zero.
            for (int i = 0; i < REG_COUNT; i++) begin
                regs[i] <= '0;
            end
        end else if (wen_i) begin
            // When write enable is high, write wdata_i to the specified waddr_i.
            // If ZERO_REG_IS_ZERO is enabled, we prevent writes to address 0.
            if (!ZERO_REG_IS_ZERO || (waddr_i != '0)) begin
                regs[waddr_i] <= wdata_i;
            end
        end
    end

    // --- Asynchronous Read Logic (Generated) ---
    // The 'generate' block creates multiple instances of hardware at elaboration time.
    // We use it here to create a continuous assignment for each read port,
    // with special handling for the zero register if enabled.
    genvar i; // The loop variable for a generate block must be a 'genvar'.
    generate
        // This 'if' is evaluated at elaboration time. The synthesis tool will only
        // generate one of the two blocks below based on the parameter value.
        if (ZERO_REG_IS_ZERO) begin : zero_reg_active_logic
            // Logic for when the zero register feature is ON.
            for (i = 0; i < NUM_READ_PORTS; i = i + 1) begin : read_ports_gen_zero
                // If the read address is 0, output all zeros ('0).
                // Otherwise, output the value from the register file.
                assign rdata_o[i] = (raddr_i[i] == '0) ? '0 : regs[raddr_i[i]];
            end
        end else begin : zero_reg_inactive_logic
            // Logic for when the zero register feature is OFF.
            // All registers behave normally.
            for (i = 0; i < NUM_READ_PORTS; i = i + 1) begin : read_ports_gen_std
                assign rdata_o[i] = regs[raddr_i[i]];
            end
        end
    endgenerate

endmodule
