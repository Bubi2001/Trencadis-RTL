#!/bin/bash

# =============================================================================
# ## Linting Script for Trencadís-RTL
# ##
# ## This script finds all SystemVerilog source files in the 'rtl/' directory
# ## and runs Verilator in lint-only mode to check for syntax and style issues.
# ## It is designed to be called from the Makefile or a CI workflow.
# =============================================================================

# Exit immediately if any command fails. This is crucial for CI.
set -e

echo "🧹 Running Linter on all RTL files..."

# --- Configuration ---
# Define all directories containing RTL modules that might be instantiated.
# This ensures Verilator can find any submodule referenced in your code.
# Recursively find all subdirectories under rtl/ and add them as include paths
INCLUDE_PATHS=$(find rtl/ -type d -exec printf " -I%s" {} \;)

# --- Main Loop ---
# Find all SystemVerilog files in the rtl directory and check them one by one.
# The -print0 and IFS=... part ensures that this works even if you have
# filenames with spaces (which you shouldn't, but it's robust).
find rtl/ -name "*.sv" -print0 | while IFS= read -r -d $'\0' file; do

  echo "   Checking: ${file}"

  # Run Verilator in lint-only mode on the file.
  # The script will exit here with an error if Verilator finds any issues.
  verilator --lint-only -sv ${INCLUDE_PATHS} "${file}"

done

echo ""
echo "✅ Linting complete. All files passed successfully!"
