# Trencadís RTL 🎨

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Build Status](https://img.shields.io/badge/CI-Pending-lightgrey)](https://github.com/Bubi2001/Trencadis-RTL/actions)

> An open-source collection of SystemVerilog IP cores, crafted with the trencadís philosophy: modular, artistic, and functional.

---

## The Trencadís Philosophy

This project is inspired by "trencadís", the iconic mosaic technique popularized by Catalan modernist architect Antoni Gaudí. The philosophy is to create a complex, beautiful, and functional whole by artfully assembling smaller, individual pieces—in this case, hardware IP cores.

![Trencadís Mosaic Inspiration](doc/assets/trencadis_stock.jpg)

Each module in this repository is designed to be one of those well-crafted fragments: robust, self-contained, and easy to integrate. They are the building blocks for creating your own custom System-on-Chip (SoC) masterpieces.

## Key Features

- **Modular Design:** Each IP core is self-contained in its own directory, designed for maximum portability.
- **Standardized Bus:** Major peripherals use the simple and robust [Wishbone (B4)](https://opencores.org/projects/wishbone) bus for easy integration.
- **Rich Component Library:** Includes not only full peripherals but also a collection of generic, reusable building blocks like FIFOs, synchronizers, and shift registers.
- **SystemVerilog Source:** Written in modern SystemVerilog for clarity, flexibility, and powerful features.
- **Open Source:** Licensed under the permissive MIT License, allowing unrestricted use in both hobbyist and commercial projects.
- **Documented & Tested:** Each module is accompanied by documentation and a dedicated testbench.

## Reusable Components

A library of smaller, general-purpose building blocks located in the `rtl/components/` directory. These are the "mortar" holding the mosaic together.

- Register Files
- Shift Registers
- Synchronizers (for Clock Domain Crossing)
- Asynchronous & Synchronous FIFOs
- Button Debouncers
- ... and more to come!

## Wishbone Peripherals

This is the collection of full-featured, bus-connected IP cores.

| Core                  |   Bus   |      Status      | Description                                  |
| :-------------------- | :------: | :---------------: | :------------------------------------------- |
| **GPIO**        | Wishbone |  ✅ Implemented  | General Purpose Input/Output controller.     |
| **UART**        | Wishbone | 🟡 In Development | Universal Asynchronous Receiver-Transmitter. |
| **SPI Master**  | Wishbone |    ❌ Planned    | Serial Peripheral Interface bus controller.  |
| **I2C Master**  | Wishbone |    ❌ Planned    | Inter-Integrated Circuit bus controller.     |
| **Vitrall CPU** | Wishbone |    ❌ Planned    | The central RISC-V core of the Gaudí suite. |

## Getting Started

Integrating a `Trencadís` module into your project is straightforward. The `rtl/` directory is organized into full-featured peripherals (e.g., `gpio/`, `i2c/`) and general-purpose building blocks found in the `rtl/components/` directory.

1. **Clone the repository:**

   ```bash
   git clone [https://github.com/Bubi2001/Trencadis-RTL.git](https://github.com/Bubi2001/Trencadis-RTL.git)
   ```

2. **Copy the core's directory or file** from the `rtl/` folder into your project's source tree.
3. **Instantiate the module** in your design.

   ```systemverilog
   // Example instantiation of a component
   generic_shift_register #(
       .WIDTH (16)
   ) i_shifter (
       .clk      (clk),
       .rst      (rst),
       .ena      (shift_enable),
       .d_in     (serial_in),
       .q_out    (parallel_out)
   );
   ```

4. For complete systems demonstrating the use of peripherals, please see the projects in the `/examples` directory.

## The Gaudí Suite

`Trencadís-RTL` is the foundational library for a larger suite of projects that follow the "Electronic Modernism" philosophy:

- [**`Vitrall`**](https://github.com/Bubi2001/Vitrall): A RISC-V CPU core, the artistic and logical centerpiece of the system.
- [**`La Pedrera`**](https://github.com/Bubi2001/La-Pedrera): A complete SoC built with `Vitrall` and `Trencadís` cores, implemented on FPGA as a functional masterpiece.
- [**`La Sagrada Familia`**](https://github.com/Bubi2001/La-Sagrada-Familia): The ASIC implementation of the SoC, representing the permanent, magnum opus of the design effort.

## Roadmap Extendido de Trencadís RTL y la Suite Modernista

### Fase 1: El Cimiento (Q4 2025 - Q1 2026)

*Objetivo: Establecer una base sólida para el proyecto, con los primeros componentes funcionales y una estructura impecable.*

- **[✔] Infraestructura del Proyecto:**
  - [ ] Finalizar y asentar la estructura de directorios (`rtl`, `verification`, `doc`, `examples`).
  - [ ] Crear y pulir los archivos `README.md` (EN/CA), `LICENSE` y `CONTRIBUTING.md`.
  - [ ] Configurar un flujo de simulación base con una herramienta (ej. Verilator, GHDL) y automatizarlo con scripts.
- **[✔] Componentes Fundamentales (`components/`):**
  - [ ] Implementar y verificar un `Shift Register` paramétrico.
  - [ ] Implementar y verificar un `Register File` genérico.
  - [ ] Implementar y verificar Sincronizadores para CDC (Clock Domain Crossing).
  - [ ] Escribir las datasheets para estos componentes iniciales.
- **[✔] Primer Periférico (`peripherals/`):**
  - [ ] Implementar y verificar completamente el periférico `GPIO` con su interfaz Wishbone.
  - [ ] Redactar una datasheet exhaustiva para el `GPIO`.
- **[✔] Publicación Inicial:**
  - [ ] Crear un primer ejemplo funcional para una placa iCE40 o similar (ej. "blinky" usando el GPIO).
  - [ ] Publicar la **`v0.1.0`** en las "Releases" de GitHub.

### Fase 2: El Mosaico (Q2 2026 - Q4 2026)

*Objetivo: Expandir la librería con periféricos de comunicación clave y unidades aritméticas, empezando a formar un sistema más complejo.*

- **[✔] Expansión de Componentes:**
  - [ ] Añadir un `FIFO` síncrono y asíncrono genérico.
  - [ ] Añadir un `Debouncer` para pulsadores.
- **[✔] Periféricos de Comunicación:**
  - [ ] Implementar y verificar el periférico `UART`.
  - [ ] Implementar y verificar el periférico `SPI Master`.
  - [ ] Crear un ejemplo de sistema que combine `UART` y `SPI` (ej. controlar un sensor SPI desde una terminal de PC).
- **[✔] Unidades Aritméticas (`arithmetic/`):**
  - [ ] Diseñar e implementar un `ALU` (Unidad Aritmético-Lógica) básica.
  - [ ] Diseñar e implementar un `Multiplier` hardware dedicado.
- **[✔] Hitos de Publicación:**
  - [ ] Publicar la **`v0.2.0`** (incluyendo UART).
  - [ ] Publicar la **`v0.3.0`** (incluyendo SPI y ALU).

### Fase 3: El Vitrall - El Núcleo del Sistema (2027)

*Objetivo: Dedicar un esfuerzo concentrado en el diseño, implementación y verificación de la pieza central, la CPU `Vitrall`.*

- **[✔] Diseño de la CPU `Vitrall`:**
  - [ ] Definir la microarquitectura (ej. pipeline clásico de 5 etapas).
  - [ ] Implementar cada una de las etapas del pipeline (Fetch, Decode, Execute, Memory, Writeback).
  - [ ] Diseñar la interfaz de bus Wishbone para las etapas de memoria e instrucciones.
- **[✔] Verificación Rigurosa:**
  - [ ] Construir un entorno de testbench avanzado para la CPU.
  - [ ] Superar el set de tests de compatibilidad de RISC-V (`riscv-compliance`).
- **[✔] Hito de Publicación:**
  - [ ] Publicar la **`v0.4.0`** con la primera versión funcional de `Vitrall`.

### Fase 4: La Obra Maestra y el Legado (2028+)

*Objetivo: Integrar todo en los SoCs finales, explorar la fabricación física y consolidar el proyecto para la comunidad.*

- **[✔] `La Pedrera` - SoC en FPGA:**
  - [ ] Diseñar y construir un SoC completo integrando `Vitrall`, `GPIO`, `UART`, `SPI` y una controladora de memoria.
  - [ ] Escribir un pequeño "monitor" o "BIOS" en ensamblador/C para probar el sistema.
  - [ ] Hacer un "port" de una aplicación simple (una terminal de comandos, un intérprete de Forth, o el juego "Pong" sobre VGA).
- **[✔] `La Sagrada Familia` - El Reto del ASIC:**
  - [ ] Adaptar el diseño de `La Pedrera` para un flujo de ASIC de código abierto (OpenROAD, Sky130).
  - [ ] Superar las fases de síntesis, place & route, y verificación física (DRC/LVS).
  - [ ] Generar el GDSII final, la culminación del proyecto.
- **[✔] Madurez y Comunidad:**
  - [ ] Publicar la versión  **`v1.0.0`** , considerada la primera versión "estable y completa" de la librería.
  - [ ] Seguir añadiendo IPs avanzados (`I2C`, `DMA Controller`, `FPU`).
  - [ ] Mantener el proyecto, corregir bugs y revisar contribuciones de la comunidad.

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
