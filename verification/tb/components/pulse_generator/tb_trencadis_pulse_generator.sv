// ================================================================================
// 
// Module/File Name    : tb_trencadis_pulse_generator
// Project Name        : Trencadís RTL
// Description         : Testbench for the trencadis_pulse_generator module.
//                       generates multiple randomized test pattern
//                       configurations to verify functionality.
// 
// Author              : Adrià Babiano Novella
// Email               : ababiano7@alumnes.ub.edu
// Create Date         : 2025-08-17
// Revision            : v1.0
// Revision history:
//   v1.0 - Initial Version
// ================================================================================

`timescale 1ns/1ps

`include "trencadis_pulse_generator.sv"

module tb_trencadis_pulse_generator;

    // Import the DPI-C function to communicate test status to a C++ harness
    import "DPI-C" function void set_test_status(input bit fail);

    //================================================================
    // Parameters
    //================================================================
    localparam SIZE       = 8;
    localparam CLK_PERIOD = 10; // 10ns period -> 100MHz clock

    //================================================================
    // Signals
    //================================================================
    logic                  clk;
    logic                  rst_ni;
    logic [SIZE-1:0]       max_count;
    logic                  pulse;
    logic                  test_failed;

    //================================================================
    // DUT Instantiation
    //================================================================
    trencadis_pulse_generator #(
        .SIZE(SIZE)
    ) dut (
        .clk_i       (clk),
        .rst_ni      (rst_ni),
        .max_count_i (max_count),
        .pulse_o     (pulse)
    );

    //================================================================
    // Clock Generator
    //================================================================
    initial begin
        clk = 1'b0;
        forever #(CLK_PERIOD / 2) clk = ~clk;
    end

    //================================================================
    // Reusable Verification Task
    //================================================================
    // This task verifies the pulse generator for a given max_count over
    // a specified number of cycles.
    task automatic check_pulse_period(
        input logic [SIZE-1:0] count_to_check,
        input int              periods_to_verify = 2
    );
    begin
        string test_name;
        int period;

        $sformat(test_name, "Verifying for max_count = %0d", count_to_check);
        $display("[INFO] %s", test_name);

        max_count = count_to_check;
        period = int'(count_to_check) + 1;

        // Special case for max_count = 0, where pulse should never be high.
        if (count_to_check == 0) begin
            repeat(20) @(posedge clk) begin
                if (pulse !== 1'b0) begin
                    $display("[%s] FAIL: Pulse went high when max_count was 0.", test_name);
                    test_failed = 1'b1;
                end
            end
            return; // End this task instance
        end

        // For non-zero counts, check the period over several cycles.
        repeat(periods_to_verify) begin
            // Pulse should be LOW while the counter is running.
            for (int i = 0; i < count_to_check; i++) begin
                @(posedge clk);
                if (pulse !== 1'b0) begin
                    $display("[%s] FAIL: Pulse was high prematurely at count %0d.", test_name, i);
                    test_failed = 1'b1;
                end
            end

            // Pulse should be HIGH for exactly one cycle when the counter reaches max_count.
            @(posedge clk);
            if (pulse !== 1'b1) begin
                $display("[%s] FAIL: Pulse did not go high on schedule.", test_name);
                test_failed = 1'b1;
            end
        end
    end
    endtask

    // --- VCD Dump Generation ---
    initial begin
        $dumpfile("tb_trencadis_pulse_generator.vcd");
        $dumpvars(0, tb_trencadis_pulse_generator);
    end

    //================================================================
    // Main Test Sequence
    //================================================================
    initial begin
        test_failed = 1'b0;
        $display("\n[INFO] Starting extended test for trencadis_pulse_generator...");

        // 1. Apply reset
        rst_ni    = 1'b0;
        max_count = '0;
        repeat(2) @(posedge clk);
        rst_ni = 1'b1;
        @(posedge clk);
        $display("[INFO] Reset sequence completed.");

        //----------------------------------------------------------------
        // DIRECTED TEST CASES
        //----------------------------------------------------------------
        check_pulse_period(0);          // Edge case: Never pulses
        check_pulse_period(1);          // Edge case: Minimum period
        check_pulse_period(5);          // A typical prime number value
        check_pulse_period(2**SIZE-1);  // Edge case: Maximum value

        //----------------------------------------------------------------
        // RANDOMIZED TEST CASES
        //----------------------------------------------------------------
        $display("\n[INFO] Starting randomized testing...");
        repeat(10) begin
            logic [SIZE-1:0] random_count;
            random_count = SIZE'($urandom_range(1, 2**SIZE - 2));
            check_pulse_period(random_count);
        end

        //----------------------------------------------------------------
        // FINAL SUMMARY
        //----------------------------------------------------------------
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
