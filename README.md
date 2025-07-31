# Lipsi Processor with Seven Segment Display

This project implements a custom 8-bit processor (`lipsi_processor`) in Verilog, featuring a basic instruction set and integration with a 4-digit seven-segment display. The processor supports arithmetic, branching, and memory operations, and outputs its result on a display.

---

## 🔧 Project Structure

### 1. `lipsi_processor`
- **Inputs**: 
  - `clk`: Clock signal
  - `reset`: Reset signal
- **Output**:
  - `A`: The 8-bit result register

### 2. `Lipsi_seven_segment_display`
- Drives the value of `A` (from `lipsi_processor`) onto a 4-digit 7-segment display.
- Uses a clock divider (`clkdiv`) to reduce the frequency for visual display.

### 3. `clkdiv`
- A simple frequency divider that outputs a lower frequency clock (`clkout`) suitable for the processor’s timing.

---

## 💡 Features

- Supports the following instruction categories:
  - **ALU immediate**
  - **ALU register**
  - **Memory store/load**
  - **Branching**
  - **Indirect memory access**
  - **Bitwise shifts**
- Multiple pre-coded test programs (Fibonacci, factorial, etc.) are available in the `initial` block as comments.
- Displays output register `A` on a multiplexed 4-digit 7-segment display.

---

## 🧠 Instruction Format (Short Overview)

- **ALU Immediate**: Opcode `1100xxxx`
- **ALU Register**: Opcode MSB is 0
- **Store**: Opcode `1000xxxx`
- **Branch**: Opcode `1101xxxx` (conditional and unconditional)
- **Call/Return**: Opcode `1001xxxx`
- **Load Indirect**: Opcode `1010xxxx`
- **Store Indirect**: Opcode `1011xxxx`
- **Shifts**: Opcode `1110xxxx`
- **Halt**: Instruction byte `0xFF`

---

## 🔢 Example Programs (Uncomment in `initial` block)

- **Sum of first 15 numbers**
- **Sum of even numbers**
- **Nth Fibonacci number**
- **Factorial**
- **Bitwise shifts**
- **Branch and Link demo**

Uncomment the desired program under the `initial` block in `lipsi_processor`.

---

## 🚀 Simulation & Synthesis

To simulate:
1. Use any Verilog simulator like ModelSim, Icarus Verilog, Vivado, etc.
2. Provide stimulus by toggling the `reset` signal and observing output `A`.

To run on an FPGA:
- Use the `Lipsi_seven_segment_display` module as your top module.
- Connect `clock_100Mhz` and `reset` to board inputs.
- Map `Anode_Activate` and `LED_out` to the 7-segment display pins.

---

## 📁 Modules

- `lipsi_processor.v`: Custom 8-bit processor
- `Lipsi_seven_segment_display.v`: Display controller
- `clkdiv.v`: Clock divider
- `README.md`: Project documentation

---

## 👤 Authors

- Nikhil Grandhi
- Raj Vardhan
