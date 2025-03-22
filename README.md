


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


