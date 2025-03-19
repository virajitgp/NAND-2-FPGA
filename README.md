# NAND-2-FPGA
File Structore Wip
```
├── project_1
│   ├── 4-16mux
│   │   ├── 4-16mux.v
│   │   ├── 4-16.out
│   │   └── 4-16-test.v
│   ├── 4dmux
│   │   ├── 4demux.out
│   │   ├── 4demux-test.v
│   │   └── 4demux.v
│   ├── 8-16mux
│   │   ├── 8-16mux.v
│   │   ├── 8-16.out
│   │   └── 8-16-test.v
│   ├── 8demux
│   │   ├── 8demux.out
│   │   ├── 8demux-test.v
│   │   └── 8demux.v
│   ├── 8or
│   │   ├── or8.out
│   │   ├── or8-test.v
│   │   └── or8.v
│   ├── and16
│   │   ├── and16.out
│   │   ├── and16-test.v
│   │   └── and16.v
│   ├── and2
│   │   ├── and2.out
│   │   ├── and2-test.v
│   │   └── and2.v
│   ├── demux_2:1
│   │   ├── demux_2:1.out
│   │   ├── demux_2:1-test.v
│   │   └── demux_2:1.v
│   ├── mux16
│   │   ├── mux16.out
│   │   ├── mux16-test.v
│   │   └── mux16.v
│   ├── mux_2:1
│   │   ├── mux_2:1.out
│   │   ├── mux_2:1-test.v
│   │   └── mux_2:1.v
│   ├── nand
│   │   ├── nand.o
│   │   ├── nand.out
│   │   ├── nand_o.vcd
│   │   ├── nand_test.out
│   │   ├── nand-test.v
│   │   ├── nand_test.v
│   │   └── nand.v
│   ├── not16
│   │   ├── not16.out
│   │   ├── not16-test.v
│   │   └── not16.v
│   ├── not2
│   │   ├── not2.out
│   │   ├── not2-test.v
│   │   └── not2.v
│   ├── or16
│   │   ├── or16.out
│   │   ├── or16-test.v
│   │   └── or16.v
│   ├── or2
│   │   ├── or2.out
│   │   ├── or2-test.v
│   │   └── or2.v
│   └── xor
│       ├── or2.out
│       ├── xor.out
│       ├── xor-test.v
│       └── xor.v
├── project_2
│   ├── 16_adder
│   │   ├── 16_adder.out
│   │   ├── 16_adder-test.v
│   │   ├── 16_adder.v
│   │   └── waveform.vcd
│   ├── 16_inc
│   │   ├── 16_inc.out
│   │   ├── 16_inc-test.v
│   │   ├── 16_inc.v
│   │   └── waveform.vcd
│   ├── full_adder
│   │   ├── full_adder.out
│   │   ├── full_adder-test.v
│   │   ├── full_adder.v
│   │   └── full_adder.vcd
│   └── half_adder
│       ├── half_adder.out
│       ├── half_adder-test.v
│       ├── half_adder.v
│       └── half_adder.vcd
├── README.md
└── trying_verilog
    ├── counter.out
    ├── counter.v
    ├── counter.vcd
    ├── testbench.v
    ├── test.out
    ├── test.v
    └── test.vcd
```



![Nand2Tetris](https://www.nand2tetris.org/)

## Overview

NAND-2-FPGA is an educational project that implements the HACK computer architecture on an FPGA using Verilog. This project demonstrates how to build a functional CPU from the ground up, starting with basic logic gates and progressing to more complex components.

## Project Structure

The repository is organized into progressive implementation stages:

### Project 1: Basic Logic Gates and Multiplexers

Implementation of fundamental building blocks:
- Basic logic gates (NAND, NOT, AND, OR, XOR)
- Multi-bit variants (16-bit versions of NOT, AND, OR)
- Multiplexers and demultiplexers of various sizes

### Project 2: Arithmetic Components

Implementation of arithmetic units:
- Half adder
- Full adder
- 16-bit adder
- 16-bit incrementer

### Future Projects

_(Coming soon)_
- Project 3: Memory elements (Registers, RAM)
- Project 4: Machine language and assembly
- Project 5: CPU architecture
- project 6: Assembler

## Getting Started

### Prerequisites

- FPGA development board
- Verilog HDL simulator (e.g., Icarus Verilog)
- FPGA synthesis tools compatible with your board

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/NAND-2-FPGA.git
cd NAND-2-FPGA

# Run tests for specific components (using Icarus Verilog)
cd project_1/nand
iverilog -o nand.out nand-test.v nand.v
vvp nand.out
```

### Running Tests

Each component includes a test file (e.g., `component-test.v`) that verifies its functionality. Test outputs are generated as `.out` files, and waveforms are saved as `.vcd` files which can be viewed with tools like GTKWave.

```bash
# Example: Testing the 16-bit adder
cd project_2/16_adder
iverilog -o 16_adder.out 16_adder-test.v 16_adder.v
vvp 16_adder.out
gtkwave waveform.vcd
```

## Implementation Details

The project follows a bottom-up approach:

1. **NAND Gate**: The fundamental building block
2. **Basic Gates**: NOT, AND, OR, XOR built using NAND gates
3. **Multiplexers/Demultiplexers**: For data selection and routing
4. **Arithmetic Units**: Adding and incrementing numbers
5. **Memory**: Registers and RAM modules _(upcoming)_
6. **CPU**: The complete HACK CPU architecture _(upcoming)_
7. **Computer**: The fully functional HACK computer system _(upcoming)_

## Resources

- [Nand2Tetris Official Website](https://www.nand2tetris.org/)
- [The Elements of Computing Systems](https://mitpress.mit.edu/books/elements-computing-systems-second-edition) (The Nand2Tetris book)
- [FPGA Development Guide](https://example.com/fpga-dev-guide)

## Lisence
This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Noam Nisan and Shimon Schocken, creators of the Nand2Tetris course
- The open-source FPGA and Verilog communities
- MARVEL UVCE 
