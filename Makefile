# Makefile for the Trencadís-RTL Project

# --- Configuration ---
# List all testbench top-level files here
TESTBENCHES := $(shell find verification/tb -name "tb_*.sv")
PYTHON ?= python3

# --- Core Tasks ---

.PHONY: help lint test docs clean

help:
	@echo "Trencadís-RTL Makefile"
	@echo "--------------------------"
	@echo " lint         - Run Verilator linter on all RTL files."
	@echo " test         - Run all verification testbenches."
	@echo " docs         - Serve the documentation website locally for preview."
	@echo " clean        - Remove all generated build and simulation files."

lint:
	@echo "🧹 Running Linter..."
	@verification/scripts/run_lint.sh # Assuming you create a script for the lint command

test:
	@echo "🔬 Running Verification..."
	@./verification/scripts/run_all_tests.sh

docs:
	@echo "📚 Serving documentation at http://127.0.0.1:8000"
	@$(PYTHON) -m mkdocs serve

clean:
	@echo "🧼 Cleaning up generated files..."
	@rm -rf obj_dir/
	@rm -rf site/
	@find . -name "*.vcd" -delete
	@find . -name "*.log" -delete