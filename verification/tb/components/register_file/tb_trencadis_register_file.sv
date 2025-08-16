// ===============================================================================
//
// Module/File Name    : tb_trencadis_register_file
// Project Name        : Trencadís RTL
// Description         : Testbench for the trencadis_register_file module.
//                       Instantiates multiple DUTs with different parameter
//                       configurations to verify functionality.
//
// Author              : Adrià Babiano Novella
// Create Date         : 2025-08-14
// Revision            : v1.0
// Revision history:
//   v1.0 - Initial Version
// ================================================================================

`timescale 1ns/1ps

// Include the design under test.
`include "trencadis_register_file.sv"

module tb_trencadis_register_file;

    import "DPI-C" function void set_test_status(input bit fail);

    // --- Testbench Parameters ---
    localparam CLK_PERIOD = 10; // Clock period in ns

    // --- Test Status ---
    logic test_failed;

    // --- Global Signals ---
    logic clk_i;
    logic rst_ni;

    // ============================================================================
    // --- Signals for DUT 1: 2 Read Ports, 32 Regs, 32-bit, Zero-Reg ON ---
    // ============================================================================
    localparam DUT1_NUM_READ_PORTS = 2;
    localparam DUT1_REG_COUNT      = 32;
    localparam DUT1_DEPTH          = 32;
    localparam DUT1_ADDR_WIDTH     = $clog2(DUT1_REG_COUNT);

    logic [DUT1_ADDR_WIDTH-1:0]                           dut1_waddr_i;
    logic [DUT1_DEPTH-1:0]                                dut1_wdata_i;
    logic                                                 dut1_wen_i;
    logic [DUT1_NUM_READ_PORTS-1:0][DUT1_ADDR_WIDTH-1:0]  dut1_raddr_i;
    logic [DUT1_NUM_READ_PORTS-1:0][DUT1_DEPTH-1:0]       dut1_rdata_o;

    // ============================================================================
    // --- Signals for DUT 2: 2 Read Ports, 32 Regs, 32-bit, Zero-Reg OFF ---
    // ============================================================================
    localparam DUT2_NUM_READ_PORTS = 2;
    localparam DUT2_REG_COUNT      = 32;
    localparam DUT2_DEPTH          = 32;
    localparam DUT2_ADDR_WIDTH     = $clog2(DUT2_REG_COUNT);

    logic [DUT2_ADDR_WIDTH-1:0]                           dut2_waddr_i;
    logic [DUT2_DEPTH-1:0]                                dut2_wdata_i;
    logic                                                 dut2_wen_i;
    logic [DUT2_NUM_READ_PORTS-1:0][DUT2_ADDR_WIDTH-1:0]  dut2_raddr_i;
    logic [DUT2_NUM_READ_PORTS-1:0][DUT2_DEPTH-1:0]       dut2_rdata_o;

    // ============================================================================
    // --- Signals for DUT 3: 4 Read Ports, 16 Regs, 64-bit, Zero-Reg ON ---
    // ============================================================================
    localparam DUT3_NUM_READ_PORTS = 4;
    localparam DUT3_REG_COUNT      = 16;
    localparam DUT3_DEPTH          = 64;
    localparam DUT3_ADDR_WIDTH     = $clog2(DUT3_REG_COUNT);

    logic [DUT3_ADDR_WIDTH-1:0]                           dut3_waddr_i;
    logic [DUT3_DEPTH-1:0]                                dut3_wdata_i;
    logic                                                 dut3_wen_i;
    logic [DUT3_NUM_READ_PORTS-1:0][DUT3_ADDR_WIDTH-1:0]  dut3_raddr_i;
    logic [DUT3_NUM_READ_PORTS-1:0][DUT3_DEPTH-1:0]       dut3_rdata_o;


    // ============================================================================
    // --- DUT Instantiations ---
    // ============================================================================

    // DUT 1: RISC-V style (32-bit, 32 regs, 2 read ports, zero reg is hardwired zero)
    trencadis_register_file #(
        .NUM_READ_PORTS(DUT1_NUM_READ_PORTS),
        .REG_COUNT(DUT1_REG_COUNT),
        .DEPTH(DUT1_DEPTH),
        .ZERO_REG_IS_ZERO(1)
    ) dut1 (
        .clk_i(clk_i),
        .rst_ni(rst_ni),
        .waddr_i(dut1_waddr_i),
        .wdata_i(dut1_wdata_i),
        .wen_i(dut1_wen_i),
        .raddr_i(dut1_raddr_i),
        .rdata_o(dut1_rdata_o)
    );

    // DUT 2: Standard register file (zero reg is NOT hardwired)
    trencadis_register_file #(
        .NUM_READ_PORTS(DUT2_NUM_READ_PORTS),
        .REG_COUNT(DUT2_REG_COUNT),
        .DEPTH(DUT2_DEPTH),
        .ZERO_REG_IS_ZERO(0)
    ) dut2 (
        .clk_i(clk_i),
        .rst_ni(rst_ni),
        .waddr_i(dut2_waddr_i),
        .wdata_i(dut2_wdata_i),
        .wen_i(dut2_wen_i),
        .raddr_i(dut2_raddr_i),
        .rdata_o(dut2_rdata_o)
    );

    // DUT 3: Custom config (64-bit, 16 regs, 4 read ports, zero reg is hardwired)
    trencadis_register_file #(
        .NUM_READ_PORTS(DUT3_NUM_READ_PORTS),
        .REG_COUNT(DUT3_REG_COUNT),
        .DEPTH(DUT3_DEPTH),
        .ZERO_REG_IS_ZERO(1)
    ) dut3 (
        .clk_i(clk_i),
        .rst_ni(rst_ni),
        .waddr_i(dut3_waddr_i),
        .wdata_i(dut3_wdata_i),
        .wen_i(dut3_wen_i),
        .raddr_i(dut3_raddr_i),
        .rdata_o(dut3_rdata_o)
    );

    // --- Clock Generator ---
    initial begin
        clk_i = 0;
        forever #(CLK_PERIOD / 2) clk_i = ~clk_i;
    end

    // --- VCD Dump Generation ---
    initial begin
        $dumpfile("tb_trencadis_register_file.vcd");
        $dumpvars(0, tb_trencadis_register_file);
    end

    // --- Test Sequence ---
    initial begin
        // Declare all local variables at the top of the block
        reg [DUT1_DEPTH-1:0] dut1_reg5_val;

        $display("========================================================");
        $display("--- Starting Register File Testbench ---");
        $display("========================================================");

        // 1. Initialize and Reset
        rst_ni = 1'b0; // Assert reset
        test_failed = 1'b0;
        dut1_wen_i = 1'b0; dut2_wen_i = 1'b0; dut3_wen_i = 1'b0;
        // Initialize all read addresses to a known value to prevent UNDRIVEN warnings
        dut1_raddr_i = '0;
        dut2_raddr_i = '0;
        dut3_raddr_i = '0;
        # (2 * CLK_PERIOD);
        rst_ni = 1'b1; // De-assert reset
        $display("[%0t] Reset released.", $time);
        @(posedge clk_i);

        // 2. Test 1: Basic Write and Read
        $display("\n--- Test 1: Basic Write and Read ---");
        dut1_wen_i = 1'b1; dut1_waddr_i = 5; dut1_wdata_i = 32'hDEADBEEF;
        dut2_wen_i = 1'b1; dut2_waddr_i = 5; dut2_wdata_i = 32'hCAFEBABE;
        dut3_wen_i = 1'b1; dut3_waddr_i = 5; dut3_wdata_i = 64'hFEEDF00D_BAADF00D;
        @(posedge clk_i);
        #1; // FIX: Allow DUT to update before changing inputs
        dut1_wen_i = 1'b0; dut2_wen_i = 1'b0; dut3_wen_i = 1'b0;
        dut1_raddr_i[0] = 5; dut2_raddr_i[0] = 5; dut3_raddr_i[0] = 5;
        #1; // Allow async read to propagate
        if (dut1_rdata_o[0] != 32'hDEADBEEF) begin $display("ERROR: [%0t] DUT1 T1 FAIL", $time); test_failed = 1; end
        if (dut2_rdata_o[0] != 32'hCAFEBABE) begin $display("ERROR: [%0t] DUT2 T1 FAIL", $time); test_failed = 1; end
        if (dut3_rdata_o[0] != 64'hFEEDF00D_BAADF00D) begin $display("ERROR: [%0t] DUT3 T1 FAIL", $time); test_failed = 1; end
        $display("[%0t] Test 1 Finished.", $time);

        // 3. Test 2: Zero Register Behavior
        $display("\n--- Test 2: Zero Register Behavior ---");
        dut1_wen_i = 1'b1; dut1_waddr_i = 0; dut1_wdata_i = 32'hFFFFFFFF;
        dut2_wen_i = 1'b1; dut2_waddr_i = 0; dut2_wdata_i = 32'h12345678;
        dut3_wen_i = 1'b1; dut3_waddr_i = 0; dut3_wdata_i = 64'hFFFFFFFF_FFFFFFFF;
        @(posedge clk_i);
        #1; // FIX: Allow DUT to update before changing inputs
        dut1_wen_i = 1'b0; dut2_wen_i = 1'b0; dut3_wen_i = 1'b0;
        dut1_raddr_i[0] = 0; dut2_raddr_i[0] = 0; dut3_raddr_i[0] = 0;
        #1;
        if (dut1_rdata_o[0] != 32'h0) begin $display("ERROR: [%0t] DUT1 T2 FAIL", $time); test_failed = 1; end
        if (dut2_rdata_o[0] != 32'h12345678) begin $display("ERROR: [%0t] DUT2 T2 FAIL", $time); test_failed = 1; end
        if (dut3_rdata_o[0] != 64'h0) begin $display("ERROR: [%0t] DUT3 T2 FAIL", $time); test_failed = 1; end
        $display("[%0t] Test 2 Finished.", $time);

        // 4. Test 3: Multiple Read Ports
        $display("\n--- Test 3: Multiple Read Ports ---");
        dut3_wen_i = 1'b1;
        dut3_waddr_i = 1; dut3_wdata_i = 64'h1111_1111_1111_1111; @(posedge clk_i); #1;
        dut3_waddr_i = 2; dut3_wdata_i = 64'h2222_2222_2222_2222; @(posedge clk_i); #1;
        dut3_waddr_i = 8; dut3_wdata_i = 64'h8888_8888_8888_8888; @(posedge clk_i); #1;
        dut3_waddr_i = 15; dut3_wdata_i = 64'hFFFF_FFFF_FFFF_FFFF; @(posedge clk_i); #1;
        dut3_wen_i = 1'b0;
        dut3_raddr_i[0] = 1; dut3_raddr_i[1] = 2; dut3_raddr_i[2] = 8; dut3_raddr_i[3] = 15;
        #1;
        if (dut3_rdata_o[0] != 64'h1111_1111_1111_1111) begin $display("ERROR: [%0t] DUT3 T3 Port 0 FAIL", $time); test_failed = 1; end
        if (dut3_rdata_o[1] != 64'h2222_2222_2222_2222) begin $display("ERROR: [%0t] DUT3 T3 Port 1 FAIL", $time); test_failed = 1; end
        if (dut3_rdata_o[2] != 64'h8888_8888_8888_8888) begin $display("ERROR: [%0t] DUT3 T3 Port 2 FAIL", $time); test_failed = 1; end
        if (dut3_rdata_o[3] != 64'hFFFF_FFFF_FFFF_FFFF) begin $display("ERROR: [%0t] DUT3 T3 Port 3 FAIL", $time); test_failed = 1; end
        $display("[%0t] Test 3 Finished.", $time);

        // 5. Test 4: Write Enable Test
        $display("\n--- Test 4: Write Enable Test ---");
        dut1_raddr_i[0] = 5;
        #1;
        dut1_reg5_val = dut1_rdata_o[0];
        dut1_wen_i = 1'b0;
        dut1_waddr_i = 5;
        dut1_wdata_i = 32'h0;
        @(posedge clk_i);
        #1;
        dut1_raddr_i[0] = 5;
        #1;
        if (dut1_rdata_o[0] != dut1_reg5_val) begin $display("ERROR: [%0t] DUT1 T4 FAIL", $time); test_failed = 1; end
        $display("[%0t] Test 4 Finished.", $time);

        // 6. Test 5: Read-After-Write (Same Address)
        $display("\n--- Test 5: Read-After-Write ---");
        dut1_wen_i = 1'b1;
        dut1_waddr_i = 10;
        dut1_wdata_i = 32'hA5A5A5A5;
        dut1_raddr_i[0] = 10;
        #1;
        if (dut1_rdata_o[0] != 32'h0) begin $display("ERROR: [%0t] DUT1 T5 Pre-Write Read FAIL", $time); test_failed = 1; end
        @(posedge clk_i);
        #1;
        dut1_wen_i = 1'b0;
        #1;
        if (dut1_rdata_o[0] != 32'hA5A5A5A5) begin $display("ERROR: [%0t] DUT1 T5 Post-Write Read FAIL", $time); test_failed = 1; end
        $display("[%0t] Test 5 Finished.", $time);

        // 7. Test 6: Full Register File Walk
        $display("\n--- Test 6: Full Register File Walk ---");
        for (int i = 0; i < DUT2_REG_COUNT; i++) begin
            dut2_wen_i = 1'b1;
            dut2_waddr_i = DUT2_ADDR_WIDTH'(i);
            dut2_wdata_i = $urandom() + i;
            @(posedge clk_i);
            #1;
        end
        dut2_wen_i = 1'b0;
        for (int i = 0; i < DUT2_REG_COUNT; i++) begin
            dut2_raddr_i[0] = DUT2_ADDR_WIDTH'(i);
            #1;
            if ($isunknown(dut2_rdata_o[0])) begin
                $display("ERROR: [%0t] DUT2 T6 Readback FAIL on addr %0d", $time, i);
                test_failed = 1;
            end
        end
        $display("[%0t] Test 6 Finished.", $time);

        // --- Final Test Summary ---
        if (test_failed) begin
            $display("\n");
            $display("                              _ ._  _ , _ ._");
            $display("                            (_ ' ( `  )_  .__)");
            $display("                          ( (  (    )   `)  ) _)");
            $display("                         (__ (_   (_ . _) _) ,__)");
            $display("                             `~~`\\ ' . /`~~`");
            $display("                             ,::: ;   ; :::,");
            $display("                            ':::::::::::::::'");
            $display(" ________________________________/_____\\________________________________");
            $display("|                                                                       |");
            $display("|                              TEST FAILED                              |");
            $display("|_______________________________________________________________________|");
            $display("\n");
        end else begin
            $display("\n");
            $display("         _\\|/_");
            $display("         (o o)");
            $display(" +----oOO-{_}-OOo--------------------------------------------------------------+");
            $display(" |                                 TEST PASSED                                 |");
            $display(" +-----------------------------------------------------------------------------+");
            $display ("\n");
        end
        set_test_status(test_failed);
        $finish;
    end

endmodule
