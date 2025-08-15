#!/bin/bash

# =============================================================================
# ## Verification Script for Trencadís-RTL
# ##
# ## This script is cross-platform and works on both Linux (CI) and
# ## Windows (Git Bash/MSYS2). It detects the OS and adjusts paths
# ## accordingly. It runs all testbenches or a specific one if provided.
# =============================================================================

# Exit immediately if a command fails. Essential for CI.
set -e

# --- OS Detection and Platform-Specific Configuration ---
# Detect the operating system and set paths and executable extensions.
if [[ "$(uname -s)" == *"MINGW"* ]]; then
    echo "-> Detected Windows (MINGW) environment."
    VERILATOR_INCLUDE_DIR="/mingw64/share/verilator/include"
    EXE_EXT=".exe"
else
    echo "-> Detected Linux/Unix environment."
    VERILATOR_INCLUDE_DIR="/usr/share/verilator/include"
    EXE_EXT=""
fi

# --- Shared Configuration ---
# Dynamically find all subdirectories in rtl/ and create -I flags for them.
INCLUDE_PATHS=$(find rtl/ -type d -exec printf " -I%s" {} \;)

# --- Function to run a single test ---
run_single_test() {
    local tb_file=$1
    # Extract the module name from the filename (e.g., tb_register_file)
    local module_name=$(basename "$tb_file" .sv)
    local top_module_name="V${module_name}"

    echo ""
    echo "===================================================="
    echo "🔬 Verifying Module: $module_name"
    echo "===================================================="

    # Clean previous run to avoid conflicts
    rm -rf obj_dir

    # --- STEP 1: Verilate (Convert SV to C++) ---
    echo "   1. Verilating with Verilator..."
    verilator --trace --timing -Wall -Wno-UNUSEDSIGNAL \
              --cc -sv ${INCLUDE_PATHS} "${tb_file}"

    # --- STEP 2: Generate a custom C++ main file for this testbench ---
    echo "   2. Generating C++ test harness..."
    # This creates a C++ file inside obj_dir that is tailored to the specific
    # testbench module being compiled.
    cat > ./obj_dir/sim_main.cpp <<EOF
#include "${top_module_name}.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "svdpi.h" // Include the DPI header
#include <cstdio>

// Global variable to hold the final test result from Verilog
static bool global_test_failed = false;

// DPI export function that Verilog can call to report its status
extern "C" void set_test_status(svBit fail) {
    if (fail) {
        global_test_failed = true;
    }
}

// Dummy function to satisfy linker dependency
double sc_time_stamp() { return 0; }

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    ${top_module_name}* tb = new ${top_module_name};

    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    tb->trace(tfp, 99);
    
    char vcd_filename[256];
    snprintf(vcd_filename, sizeof(vcd_filename), "verification/waves/${module_name}.vcd");
    tfp->open(vcd_filename);

    while (!Verilated::gotFinish()) {
        tb->eval();
        tfp->dump(Verilated::time());
        Verilated::timeInc(1);
    }

    // Call final model cleanup
    tb->final();

    // Clean up
    tfp->close();
    delete tb;

    // Return the appropriate exit code based on the DPI call
    return global_test_failed ? 1 : 0;
}
EOF

    # --- STEP 3: Compile C++ Model ---
    echo "   3. Compiling C++ model with g++..."
    # Create a list of all C++ files to compile, excluding the main harness
    # to prevent "multiple definition" errors.
    CPP_SOURCES=$(find ./obj_dir -name "*.cpp" ! -name "sim_main.cpp")

    g++ -std=c++20 -fcoroutines -Wno-attributes \
        -I"${VERILATOR_INCLUDE_DIR}" \
        -I"${VERILATOR_INCLUDE_DIR}/vltstd" \
        -Iobj_dir \
        ./obj_dir/sim_main.cpp ${CPP_SOURCES} \
        "${VERILATOR_INCLUDE_DIR}/verilated.cpp" \
        "${VERILATOR_INCLUDE_DIR}/verilated_vcd_c.cpp" \
        "${VERILATOR_INCLUDE_DIR}/verilated_timing.cpp" \
        "${VERILATOR_INCLUDE_DIR}/verilated_threads.cpp" \
        -o ./obj_dir/${top_module_name}${EXE_EXT}

    # --- STEP 4: Run the Simulation ---
    echo "   4. Running the simulation executable..."
    # The script will exit here if the simulation returns a non-zero (failure) code
    ./obj_dir/${top_module_name}${EXE_EXT}
    
    echo "✅ Verification of $module_name PASSED."
}


# --- Main Logic ---
# Check if a command-line argument (a path to a testbench) was provided.
if [ -n "$1" ]; then
    # A specific testbench path was provided, run only that test.
    mkdir -p verification/waves
    run_single_test "$1"
else
    # No argument was provided, so find and run all testbenches.
    echo "🚀 Starting Full Verification of Trencadís-RTL..."
    mkdir -p verification/waves
    
    find verification/tb -name "tb_*.sv" -print0 | while IFS= read -r -d $'\0' tb_file; do
        run_single_test "$tb_file"
    done

    echo ""
    echo "===================================================="
    echo "🎉 ALL TESTS PASSED SUCCESSFULLY! 🎉"
    echo "===================================================="
fi
