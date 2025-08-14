#!/bin/bash

# =============================================================================
# ## Verification Script for Trencadís-RTL
# ##
# ## This script finds and runs all project testbenches using
# ## Verilator. It's designed for a CI environment:
# ##  - Exits immediately if any command fails (set -e).
# ##  - Iterates over all found testbenches.
# ##  - Prints clear progress information.
# =============================================================================

# Exit immediately if a command fails. Essential for CI.
set -e

echo "🚀 Starting Full Verification of Trencadís-RTL..."

# Find all testbench files (following the tb_*.sv convention)
# and iterate over each of them.
for tb_file in $(find verification/tb -name "tb_*.sv"); do
    
    # Extract the module name from the filename for later use.
    # e.g.: verification/tb/components/fifo/tb_fifo.sv -> tb_fifo
    module_name=$(basename "$tb_file" .sv)

    echo ""
    echo "===================================================="
    echo "🔬 Verifying Module: $module_name"
    echo "===================================================="

    # --- STEP 1: Compile (Verilate) ---
    # Compile the testbench to C++ and then into an executable.
    # It is crucial that the testbench file (`tb_file`) includes (`include`)
    # the module it is testing (DUT - Device Under Test).
    # We add all rtl folders as include paths (-I).
    echo "   1. Compiling with Verilator..."
    verilator -Wall --cc --exe --build -j 0 -sv \
              -Irtl/peripherals \
              -Irtl/components \
              -Irtl/arithmetic \
              "$tb_file"

    # --- STEP 2: Run the Simulation ---
    # The executable is created in the obj_dir/ directory with a V prefix.
    echo "   2. Running the simulation..."
    ./obj_dir/V$module_name
    
    echo "✅ Verification of $module_name PASSED."

done

echo ""
echo "===================================================="
echo "🎉 ALL TESTS PASSED SUCCESSFULLY! 🎉"
echo "===================================================="