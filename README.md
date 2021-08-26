# Fachprojekt Pipelined-MIPS

## Overview

In this repository three different MIPS CPUs were implemented. First, a basic single cycle CPU, which can be found in `/SCP`. Secondly, a pipelined CPU, complete with a Hazard unit implementing both stalls and forwarding. It can be found in `/Pipelined`. Lastly, the same pipelined CPU is implemented again, with the only difference being, that rather than forwarding data when hazards occur, the whole CPU always stalls until the data has reached the registers file (found in `/Pipelined-Only-Stalls`).

## Prerequisites

To be able to run the code in this repository, the following programs have to be installed on the device:

* GHDL (github.com/ghdl/ghdl)
* GTKWave (gtkwave.sourceforge.net/)
* The C++ compiler (to compile Assembler.cpp)

The script `runEverything.sh` can be run on Windows using the GitBash.

## Usage

The script `runEverything.sh` can be used for testing and receives one parameter. The parameter defines the path to a test program. The test program will be simulated and the signals will be visualized in GTKWave. The number of cycles needed for completion of the program are displayed in the console.

## Supported Instructions

All CPUs support the following instructions:

| Instruction | Example | Explanation |
| --- | --- | --- |
| `lw` | `lw $2 4($3)` | Loads a value from memory into a register. In the example the value in memory at address value of `$3` + 4 is loaded into register `$2` |
| `sw` | `lw $2 4($3)` | Stores a value from a register into memory. In the example the value in register `$2` is stored in memory at address value of `$3` + 4 |
| `beq` | `beq $2 $3 .Label` | Compares the values in two registers and jumps to the given label if the values are equal. |
| `j` | `j .Label` | Jumps to the label |
| `addi` | `addi $2 $3 5` | Adds an immediate value (5) to the value in the source register (`$3`) and stores the result in the destination register (`$2`) |
| `add` | `add $2 $3 $4` | adds the values in the two source registers (`$3, $4`) and stores the result in the destination register (`$2`) |
| `sub` | `sub $2 $3 $4` | subtracts the values in the two source registers (`$3, $4`) and stores the result in the destination register (`$2`) |
| `and` | `and $2 $3 $4` | Performs bitwise and on the values in the two source registers (`$3, $4`) and stores the result in the destination register (`$2`) |
| `or` | `or $2 $3 $4` | Performs bitwise or on the values in the two source registers (`$3, $4`) and stores the result in the destination register (`$2`) |
| `slt` | `slt $2 $3 $4` | If the value in first source register (`$3`) is smaller than the value in the second source register (`$4`) a 1 is stores the result in the destination register (`$2`), a 0 is stored otherwise |
| `idle` | `idle` | Used to do let the processor do nothing for one cycle |
| `exit` | `exit` | Used to mark the end of the program for the testbench |
