# Contributing to Trencadís RTL

First off, thank you for considering contributing to Trencadís RTL! It’s people like you that make the open-source hardware community such an amazing place to learn, create, and inspire.

This document provides a set of guidelines for contributing to this project. These are mostly guidelines, not strict rules. Use your best judgment, and feel free to propose changes to this document in a pull request.

## Code of Conduct

This project and everyone participating in it is governed by our [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior.

## How Can I Contribute?

There are many ways to contribute, from writing code and documentation to submitting bug reports and feature requests.

### Reporting Bugs

If you find a bug, please ensure the bug was not already reported by searching on GitHub under [Issues](https://github.com/Bubi2001/Trencadis-RTL/issues). If you're unable to find an open issue addressing the problem, open a new one. Be sure to include a **title and clear description**, as much relevant information as possible, and a **code sample or test case** demonstrating the expected behavior that is not occurring.

### Suggesting Enhancements

If you have an idea for a new feature or a new module, please open an issue first to discuss it. This allows us to coordinate our efforts and prevent duplicated work. This is the best way to ensure your suggestion aligns with the project's philosophy and roadmap.

### Pull Requests

We welcome pull requests for bug fixes, new features, and documentation improvements.

## Development Workflow

1. **Fork** the repository to your own GitHub account.
2. **Clone** your fork to your local machine.
3. Create a new **branch** for your changes from the `main` branch. Please use a descriptive branch name (e.g., `feature/i2c-master` or `fix/gpio-interrupt-bug`).
4. Make your changes, adhering to the style guides below.
5. **Verify your changes.** Ensure your module passes its own self-checking testbench.
6. **Commit** your changes with a clear and descriptive commit message.
7. **Push** your branch to your fork on GitHub.
8. Open a **Pull Request (PR)** to the `main` branch of the original repository. Provide a clear description of the changes and link to any relevant issues.

## Style Guides

### SystemVerilog Coding Style

Consistency is key. Please adhere to the following style guides for all SystemVerilog code.

- **File Naming:** Use `snake_case.sv` (e.g., `trencadis_gpio.sv`).
- **Module Naming:** Use `snake_case` with a `trencadis_` prefix (e.g., `module trencadis_gpio (...)`).
- **Signal & Variable Naming:** Use `snake_case` (e.g., `logic [7:0] data_bus;`).
- **Port Naming:** Use `snake_case` with suffixes: `_i` for input, `_o` for output, `_io` for inout.
- **Parameters:** Use `UPPER_CASE` (e.g., `parameter DATA_WIDTH = 8;`).
- **Clocking:** All logic must be synchronous to a single clock named `clk_i`.
- **Reset:** Use a single, active-low, asynchronous reset named `nrst_i`.

### Verification Requirements

- **Every new module** must be accompanied by a corresponding self-checking testbench in the `verification/tb/` directory.
- The testbench must report a clear `[PASS]` or `[FAIL]` message at the end of the simulation.
- Any bug fix must include a test case that specifically targets the bug to demonstrate it has been fixed.

### Documentation Requirements

- New peripherals or complex components must have a corresponding datasheet in Markdown format in the `doc/` directory.
- The main `README.md` file should be updated to list any new modules.

## Final Note

Thank you again for your interest in contributing. Your work helps to build a better and more open hardware ecosystem for everyone.
