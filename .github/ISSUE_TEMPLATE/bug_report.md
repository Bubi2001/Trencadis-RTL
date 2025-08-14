name: 🐛 Bug Report
description: Create a report to help us improve.
labels: ["bug"]
body:

- type: markdown
  attributes:
  value: "Thank you for taking the time to fill out this bug report!"
- type: textarea
  id: description
  attributes:
  label: Describe the bug
  description: A clear and concise description of what the bug is.
  validations:
  required: true
- type: textarea
  id: reproduce
  attributes:
  label: Steps to Reproduce
  description: "Please provide the exact steps to reproduce the behavior."
  placeholder: |
  1. Instantiate the '...' module with these parameters...
  2. Run the simulation with '...' testbench...
  3. See error...
     validations:
     required: true
- type: textarea
  id: expected
  attributes:
  label: Expected Behavior
  description: "A clear and concise description of what you expected to happen."
  validations:
  required: true
- type: textarea
  id: environment
  attributes:
  label: Your Environment
  description: "Please provide details about your environment."
  placeholder: |
  - Simulator: [e.g., Verilator v5.0, QuestaSim 2023.1]
  - OS: [e.g., Ubuntu 22.04, Windows 11 with WSL]
