# Makefile for the Trencadís-RTL Project

# --- Configuration ---
PYTHON ?= python3

# --- Core Tasks ---

.PHONY: help lint test docs clean

help:
	@echo "Trencadís-RTL Makefile"
	@echo "--------------------------"
	@echo " lint                - Run Verilator linter on all RTL files."
	@echo " test                - Run all verification testbenches."
	@echo " test TB=<path>      - Run a specific testbench. e.g., make test TB=verification/tb/tb_register_file.sv"
	@echo " test TB=<path> WAVES=1 - Run a specific testbench and open GTKWave with the results."
	@echo " docs                - Serve the documentation website locally for preview."
	@echo " clean               - Remove all generated build and simulation files."

lint:
	@echo "🧹 Running Linter..."
	@./verification/scripts/run_lint.sh

# The test target now accepts optional TB and WAVES arguments.
test:
	@if [ -z "$(TB)" ]; then \
		echo "🔬 Running all verification testbenches..."; \
		./verification/scripts/run_all_tests.sh; \
	else \
		echo "🔬 Running specific testbench: $(TB)..."; \
		if [ "$(WAVES)" = "1" ]; then \
			./verification/scripts/run_all_tests.sh $(TB) --waves; \
		else \
			./verification/scripts/run_all_tests.sh $(TB); \
		fi; \
	fi

docs:
	@echo "📚 Serving documentation at http://127.0.0.1:8000"
	@$(PYTHON) -m mkdocs serve

clean:
	@echo "🧼 Cleaning up generated files..."
	@rm -rf obj_dir/
	@rm -rf site/
	@rm -rf verification/waves/
	@find . -name "*.log" -delete
