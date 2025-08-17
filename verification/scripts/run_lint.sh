#!/bin/bash

# =============================================================================
# ## Linting Script for Trencadís-RTL
# =============================================================================

# Exit immediately if any command fails.
set -e

# --- 1. Project Structure Check ---
echo "📂 Verifying project file structure..."
ALLOWED_PATHS=("./rtl/" "./verification/tb/")
MISPLACED_FILES=$(find . -path "./rtl" -prune -o -path "./verification/tb" -prune -o -name "*.sv" -print)

if [ -n "$MISPLACED_FILES" ]; then
    echo "   ❌ ERROR: Found SystemVerilog files in non-approved locations:"
    echo "$MISPLACED_FILES"
    echo "   All '.sv' files must be located in one of the following directories: ${ALLOWED_PATHS[*]}"
    exit 1
fi
echo "✅ Project structure is correct."
echo ""

# Define the directories to be checked
CHECK_DIRS="rtl/ verification/tb/"

# --- 2. Verilator Linting ---
echo "🧹 Running Verilator Linter..."
# Create include paths from all subdirectories of the directories to be checked
INCLUDE_PATHS=$(find ${CHECK_DIRS} -type d -exec printf " -I%s" {} \;)
find ${CHECK_DIRS} -name "*.sv" -print0 | while IFS= read -r -d $'\0' file; do
  echo "   Verilator checking: ${file}"
  verilator --lint-only -sv ${INCLUDE_PATHS} "${file}"
done
echo "✅ Verilator linting complete."
echo ""

# --- 3. Custom Convention & Design Rule Checks ---
echo "🔎 Checking custom conventions..."
EXIT_CODE=0

find ${CHECK_DIRS} -name "*.sv" -print0 | while IFS= read -r -d $'\0' file; do
  echo "   Convention checking: ${file}"

  # --- Rules for RTL files (inside rtl/) ---
  if [[ "$file" == rtl/* ]]; then
    # Module and Port naming checks
    if grep -E "^\s*module\s+" "$file" | grep -v "//" | grep -E -v "\s+trencadis_[a-z0-9_]+\s*[(#]?"; then
        echo "   ❌ ERROR: RTL Module name in ${file} does not follow 'trencadis_*' snake_case." && EXIT_CODE=1; fi
    if grep -E "^\s*input\s+" "$file" | grep -v "//" | grep -E -v "\w+(_i|_ni)\s*[,;)]\s*($|//)"; then
        echo "   ❌ ERROR: Input port name invalid in ${file}." && EXIT_CODE=1; fi
    if grep -E "^\s*output\s+" "$file" | grep -v "//" | grep -E -v "\w+_o\s*[,;)]\s*($|//)"; then
        echo "   ❌ ERROR: Output port name invalid in ${file}." && EXIT_CODE=1; fi
    if grep -E "^\s*inout\s+" "$file" | grep -v "//" | grep -E -v "\w+_io\s*[,;)]\s*($|//)"; then
        echo "   ❌ ERROR: Inout port name invalid in ${file}." && EXIT_CODE=1; fi

    # Parameter naming check (UPPER_CASE)
    if grep -E "^\s*parameter\s+" "$file" | grep -v "//" | grep -E "\s+[a-zA-Z0-9_]*[a-z][a-zA-Z0_]*\s*="; then
        echo "   ❌ ERROR: Parameter in ${file} is not UPPER_CASE." && EXIT_CODE=1; fi

    # Signal/Variable naming check (snake_case)
    if grep -E "^\s*(logic|wire|reg|bit)\s+" "$file" | grep -v "//" | grep -E "\s+[a-zA-Z0-9_]*[A-Z][a-zA-Z0-9_]*\s*[;\[]"; then
        echo "   ❌ ERROR: Signal/variable in ${file} is not snake_case." && EXIT_CODE=1; fi

  # --- Rules for Testbench files (inside verification/tb/) ---
  elif [[ "$file" == verification/tb/* ]]; then
    # Module naming and no-port checks
    if grep -E "^\s*module\s+" "$file" | grep -v "//" | grep -E -v "\s+tb_trencadis_[a-z0-9_]+\s*[(#]?"; then
        echo "   ❌ ERROR: Testbench Module name in ${file} does not follow 'tb_trencadis_*' snake_case." && EXIT_CODE=1; fi
    if grep -qE "^\s*module\s+\w+\s*\(" "$file" | grep -v "//"; then
        echo "   ❌ ERROR: Testbench module in ${file} appears to have a port list '()'." && EXIT_CODE=1; fi

    # Check for mandatory DPI call
    if ! grep -q "set_test_status(test_failed);" "$file"; then
        echo "   ❌ ERROR: Testbench ${file} is missing the 'set_test_status(test_failed);' call." && EXIT_CODE=1; fi
  fi
done

# --- Final Verdict ---
if [ ${EXIT_CODE} -ne 0 ]; then
  echo ""
  echo "⛔ Linting, convention, or coverage checks failed."
  exit 1
fi
echo ""
echo "✅ All checks passed successfully!"
