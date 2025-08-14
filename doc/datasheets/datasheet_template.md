# Datasheet: trencadis_[Module Name]

**Version:** vX.X.X
**Last Updated:** YYYY-MM-DD

---

## 1. Overview

A brief, one-paragraph description of what the module is and its main purpose. This should be the "elevator pitch" for your module, explaining its function and benefits at a high level.

---

## 2. Features

A bulleted list of the key features and capabilities. This allows a user to quickly assess if the module meets their needs.

- Comprehensive Documentation: A single, unified datasheet describes the core logic, bus-agnostic register map, and all available bus wrappers.
- Feature A (e.g., "Wishbone B4 compliant interface")
- Feature B (e.g., "Fully synchronous design with a single clock domain")
- Feature C (e.g., "Parameterizable data width")
- ...

---

## 3. Block Diagram

*(Optional, but highly recommended)*
A simple block diagram showing the main internal functional blocks and the primary I/O. This provides a clear visual representation of the module's architecture. You can create this with a free tool like [diagrams.net](https://app.diagrams.net/).

`![Block Diagram](assets/[module_name]_diagram.png)`

---

## 4. Logic Core Parameters (Generics)

A table describing the parameters that can be set at instantiation time to configure the module's behavior or size.

| Parameter | Type | Default | Description |
| -------------- | ------- | ------- | --------------------------------------------- |
| `WIDTH` | `int` | `8` | Defines the primary data width of the module. |
| `FIFO_DEPTH` | `int` | `32` | Defines the number of entries in the FIFO. |
| ... | | | |

---

## 5. Logic Core Port Descriptions

A detailed table of all input and output ports. This is a critical section for any hardware designer who will be instantiating your module.

| Port Name | Direction | Width | Description |
| ---------- | ---------- | --------- | ------------------------------------------------------------ |
| `clk_i` | `input` | `1` | System clock. All synchronous logic is clocked on this edge. |
| `rst_i` | `input` | `1` | System reset, synchronous, active-high. |
| `data_i` | `input` | `WIDTH` | Input data bus. |
| `data_o` | `output` | `WIDTH` | Output data bus. |
| ... | | | |

---

## 6. Register Map*

*\* (This entire section is only for bus-connected peripherals like GPIO, UART, etc.)*

This section defines the complete, **bus-agnostic** memory map for the peripheral. The address offsets are defined by the core logic and are consistent across all bus wrappers.

| Address Offset | Register Name | R/W | Description |
| -------------- | -------------- | ------- | ----------------------------------------- |
| `0x00` | `DATA_REG` | `R/W` | Data register for I/O operations. |
| `0x04` | `CTRL_REG` | `R/W` | Control and configuration register. |
| `0x08` | `STATUS_REG` | `R` | Status register for flags and interrupts. |

### 6.1. Register: DATA_REG (Offset: `0x00`)

| Bits | Field Name | R/W | Reset Value | Description |
| ---------- | -------------- | ------- | ----------- | --------------------------------------------- |
| `[7:0]` | `DATA_FIELD` | `R/W` | `0x00` | Read/Write data field. |
| `[31:8]` | `RESERVED` | `R` | `0x0` | Reserved. Reads as `0`. Writes are ignored. |

### 6.2. Register: CTRL_REG (Offset: `0x04`)

| Bits | Field Name | R/W | Reset Value | Description |
| ------- | -------------- | ------- | ----------- | --------------------------------------- |
| `[0]` | `ENABLE` | `R/W` | `0b0` | `1`: Enables the module's core logic. |
| `[1]` | `INT_ENABLE` | `R/W` | `0b0` | `1`: Enables interrupt generation. |
| ... | | | | |

---

## 7. Functional Description

A detailed explanation in prose of how the module operates. This section should cover the core logic, state machines, operational modes, and any other behaviors a user needs to understand to use the module correctly.

---

## 8. Core Timing Diagrams

Visual diagrams showing signal interactions for key operations. Example UART output. Tools like [WaveDrom](https://wavedrom.com/) are excellent for creating these directly in Markdown.

`![UART cts](assets/uart_cts_out.png)`

---

## 9. Bus Wrappers

This section provides the necessary information to instantiate and use the core with a specific standard bus. It is purely a **translation guide** to the core's native interface.

### 9.1. Wishbone Wrapper (`trencadis_[module_name]_wb`)

#### 9.1.1. Wrapper Parameters

*\*(Parameters specific to this wrapper, if any)*

#### 9.1.2. Wrapper Port Descriptions

This table lists the external ports of the **Wishbone-wrapped module**.

| Port Name | Direction | Width | Description |
|:----------|:---------:|:-----:|:------------|
| `wb_clk_i`| `input` | `1` | Wishbone bus clock. |
| `wb_rst_i`| `input` | `1` | Wishbone bus reset. |
| `wb_adr_i`| `input` | `32` | Wishbone address bus. |
| ... | | | |
| `uart_txd_o`| `output` | `1` | Physical UART transmit pin. |

#### 9.1.3. Wishbone Timing Diagrams

Visual diagrams showing signal interactions for key operations. A Wishbone read/write cycle is a perfect example for peripherals. Tools like [WaveDrom](https://wavedrom.com/) are excellent for creating these directly in Markdown.

`![Wishbone Write Cycle](assets/[module_name]_wb_write.png)`

### 9.2. APB Wrapper (`trencadis_[module_name]_apb`)

*\*(This section would be structured identically to the Wishbone one, containing only the wrapper's parameters, ports, and bus-specific timing diagrams.)*

*\*(Add as many sections 9.x as necessary depending on the amount of bus wrappers implemented.)*

---

## 10. Revision History

A log of changes to this document and the corresponding RTL module. This is critical for tracking versions and understanding what has changed over time.

| Version | Date | Author(s) | Changes |
| ---------- | ---------- | --------- | ----------------------------------------------- |
| `v0.1.0` | YYYY-MM-DD | Your Name | Initial draft of the datasheet. |
| `v1.0.0` | YYYY-MM-DD | Your Name | Updated register map and added timing diagrams. |
