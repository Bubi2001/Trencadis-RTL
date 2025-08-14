# Trencadís RTL 🎨

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

[![Build Status](https://github.com/Bubi2001/Trencadis-RTL/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/Bubi2001/Trencadis-RTL/actions/workflows/ci.yml)

[![GitHub release (latest by date)](https://img.shields.io/github/v/release/Bubi2001/Trencadis-RTL)](https://github.com/Bubi2001/Trencadis-RTL/releases)

[![GitHub last commit](https://img.shields.io/github/last-commit/Bubi2001/Trencadis-RTL)](https://github.com/Bubi2001/Trencadis-RTL/commits/main)

[![GitHub repo size](https://img.shields.io/github/repo-size/Bubi2001/Trencadis-RTL)](https://github.com/Bubi2001/Trencadis-RTL)

[![GitHub contributors](https://img.shields.io/github/contributors/Bubi2001/Trencadis-RTL)](https://github.com/Bubi2001/Trencadis-RTL/graphs/contributors)

> An open-source collection of SystemVerilog IP cores, crafted with the trencadís philosophy: modular, artistic, and functional.

---

## The Trencadís Philosophy

This project is inspired by "trencadís", the iconic mosaic technique popularized by Catalan modernist architect Antoni Gaudí. The philosophy is to create a complex, beautiful, and functional whole by artfully assembling smaller, individual pieces—in this case, hardware IP cores.

![Trencadís Mosaic Inspiration](doc/assets/trencadis_stock.jpg)

Each module in this repository is designed to be one of those well-crafted fragments: robust, self-contained, and easy to integrate. They are the building blocks for creating your own custom System-on-Chip (SoC) masterpieces.

## Key Features

-**Core/Wrapper Architecture:** Peripherals are decoupled into a bus-agnostic core and bus-specific wrappers (Wishbone, APB, etc.) for maximum reusability.

-**Multi-Bus Support:** Designed for broad compatibility, natively supporting Wishbone and planned support for AMBA buses like APB and AXI4-Lite.

-**Hierarchical IP Library:** Organized into five distinct categories: Peripherals, Drivers, Algorithms, Arithmetic, and Components.

-**Highly Configurable:** Utilizes SystemVerilog generate and parameters to create flexible and silicon-efficient modules.

-**Open Source:** Licensed under the permissive MIT License, allowing unrestricted use in both hobbyist and commercial projects.

-**Documented & Tested:** Each module is accompanied by documentation and a dedicated testbench.

## Reusable Components

A library of smaller, general-purpose building blocks located in the `rtl/components/` directory. These are the "mortar" holding the mosaic together.

- Register Files
- Shift Registers
- Synchronizers (for Clock Domain Crossing)
- Asynchronous & Synchronous FIFOs
- Button Debouncers
- ... and more to come!

## IP Library Structure

The Trencadís library is organized into five logical categories, representing a full stack of hardware design needs.

> **Status Legend:** ❌ Planned | 🟡 In Development | ✅ Implemented & Verified

### Peripherals

General-purpose peripherals that provide standard functionalities in an SoC. Each consists of a `core` and at least one bus `wrapper`.

<table>

### Drivers

Hardware offload engines designed to manage complex communication with specific external ICs, freeing up the CPU.

<table>

### Algorithms

Complex, application-specific hardware accelerators for computationally intensive tasks.

|    Algorithm    |   Status   |                      Descriprion                      |

| :--------------: | :--------: | :----------------------------------------------------: |

|  **FFT**  | ❌ Planned |      Fast Fourier Transform for signal processing      |

|  **EKF**  | ❌ Planned |  Extended Kalman Filter for sensor fusion (e.g., IMU)  |

| **CORDIC** | ❌ Planned | Computes trigonometric functions using shifts and adds |

### Arithmetic & Components

The fundamental building blocks (components) and computational units (arithmetic) used to construct the higher-level modules. This includes FIFOs, Synchronizers, Shift Registers, ALUs, FPUs, and more.

## Getting Started

Integrating a `Trencadís` module into your project is straightforward. The `rtl/` directory is organized into full-featured peripherals (e.g., `gpio/`, `i2c/`) and general-purpose building blocks found in the `rtl/components/` directory.

1.**Clone the repository:**

```bash

   git clone https://github.com/Bubi2001/Trencadis-RTL.git

```

2.**Copy the core's directory or file** from the `rtl/` folder into your project's source tree.

3.**Instantiate the module** in your design.

```systemverilog

    // Example 1: Instantiating a simple component

    trencadis_shift_register #(

        .WIDTH (16)

    ) i_shifter (

    .clk      (clk),

    .rst      (rst),

    /*...*/

    );


    // Example 2: Instantiating a Wishbone-wrapped peripheral

    trencadis_uart_wb #(

        .DEFAULT_BAUD (115200)

    ) i_uart (

        // Wishbone Bus Interface

        .wb_clk_i   (clk),

        .wb_rst_i   (rst),

        /*...*/

        // UART Physical Interface

        .uart_txd_o (uart_tx),

        .uart_rxd_i (uart_rx)

    );

```

4. For complete systems demonstrating the use of peripherals, please see the projects in the `/examples` directory.

## The Gaudí Suite

`Trencadís-RTL` is the foundational library for a larger suite of projects that follow the "Electronic Modernism" philosophy:

- [**`Vitrall`**](https://github.com/Bubi2001/Vitrall): A RISC-V CPU core, the artistic and logical centerpiece of the system.
- [**`La Pedrera`**](https://github.com/Bubi2001/La-Pedrera): A complete SoC built with `Vitrall` and `Trencadís` cores, implemented on FPGA as a functional masterpiece.
- [**`Badalot`**](https://github.com/Bubi2001/Badalot): An example implementation of the full library as a balancing robot on a single chip (SoC: *Seesaw-on-Chip*). This design handles the entire control loop in hardware—from IMU sensor fusion with an EKF to PID control and BLDC motor driving—Leaving the CPU free for high-level tasks.
- [**`La Sagrada Familia`**](https://github.com/Bubi2001/La-Sagrada-Familia): The ASIC implementation of the SoC, representing the permanent, magnum opus of the design effort.

## Contributing

Contributions are what make the open-source community amazing. If you have ideas for new modules, improvements, or bug fixes, you are welcome to:

1. Open an issue to discuss your idea.
2. Fork the repository and submit a pull request.

Please adhere to the existing coding style for consistency.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgements

- To Antoni Gaudí, for an endless source of inspiration where art and engineering converge.
- To the open-source hardware community (FOSSi Foundation, The OpenROAD Project, OpenCores) for democratizing silicon design.
