# Datasheet: trencadis_pulse_generator

Version: v1.0.0

Last Updated: 2025-08-17

## 1. Overview

The `trencadis_pulse_generator` is a simple, parameterizable hardware module designed to generate a single-cycle pulse at a configurable, periodic interval. It uses a free-running counter that resets upon reaching a user-defined maximum value. This core is ideal for creating periodic triggers, strobes, or enabling signals in digital logic designs.

## 2. Features

* Fully synchronous design with a single clock domain.
* Parameterizable counter width (`SIZE`) to support a wide range of periods.
* Generates a pulse that is always one clock cycle wide.
* Low resource utilization, suitable for both FPGAs and ASICs.
* Active-low asynchronous reset.

## 3. Block Diagram

A conceptual block diagram is shown below.

![Pulse Gen block diagram](/doc/assets/pulse_gen_bd.svg)

## 4. Parameters (Generics)

| **Parameter** | **Type** | **Default** | **Description** |
| -------------------- | -------------- | ----------------- | ------------------------------------------------------ |
| `SIZE` | `integer` | `8` | Defines the bit width of the internal counter and the `max_count_i`input. |

## 5. Logic Core Port Descriptions

| **Port Name** | **Direction** | **Width** | **Description** |
| ------------------- | ------------------- | ---- | ------------------------------------------------------------- |
| `clk_i` | `input` | `1` | System clock. All synchronous logic is clocked on the positive edge. |
| `rst_ni` | `input` | `1` | Asynchronous system reset, active-low. |
| `max_count_i` | `input` | `SIZE` | The maximum value the internal counter will reach. The period of the pulse is `max_count_i + 1` clock cycles. |
| `pulse_o` | `output` | `1` | Output pulse. This signal is asserted high for one clock cycle when the internal counter equals `max_count_i`. |

## 6. Register Map*

*\* (This module is a simple logic core and does not contain a bus interface or register map.)*

## 7. Functional Description

The `trencadis_pulse_generator` operates by continuously incrementing an internal counter on each rising edge of `clk_i`. The counter starts at zero and increments until it reaches the value specified by the `max_count_i` input.

When the counter is equal to `max_count_i`, the `pulse_o` output is driven high for that single clock cycle. On the following clock cycle, the counter resets to zero, and `pulse_o` returns low. The cycle then repeats.

The total period of the pulse is determined by the input `max_count_i`. The formula for the period in clock cycles is:

**Period = `max_count_i` + 1**

For example, if `max_count_i` is set to `99`, a pulse will be generated every 100 clock cycles.

If `max_count_i` is set to `0`, the counter will remain at `0` and the `pulse_o` signal will never be asserted, effectively disabling the pulse.

## 8. Core Timing Diagrams

The following timing diagram illustrates the behavior for `max_count_i = 2`. The counter cycles through 0, 1, and 2, and the pulse is asserted high for one cycle when the counter reaches 2. The period is 3 clock cycles.

![Pulse Generator behaviour](/doc/assets/pulse_gen_wavedrom.svg)

## 9. Instantiation Template

Here is an example of how to instantiate the `trencadis_pulse_generator` in SystemVerilog:

```systemverilog
    trencadis_pulse_generator #(
        .SIZE(8)
    ) i_pulse_generator (
        // System Ports
        .clk_i       (clk),
        .rst_ni      (rst_n),
        // Control Ports
        .max_count_i (max_count_value),
        // Output Ports
        .pulse_o     (periodic_pulse)
    );

```

## 10. Bus Wrappers

*\*(This module is a simple logic core and does not have any standard bus wrappers.)*

## 11. Revision History

A log of changes to this document and the corresponding RTL module.

| **Version** | **Date** | **Author(s)** | **Changes** |
| ----------------- | -------------- | ------------------- | ------------------------------- |
| `v1.0.0` | 2025-08-17 | Adrià Babiano Novella | Initial release of the datasheet. |
