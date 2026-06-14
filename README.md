# 🔌 UART Communication System — Verilog HDL

> Design and Verification of a complete UART Communication System implemented in Verilog HDL

![Language](https://img.shields.io/badge/Language-Verilog%20HDL-blue)
![Simulator](https://img.shields.io/badge/Simulator-Icarus%20Verilog%2012.0-green)
![Waveform](https://img.shields.io/badge/Waveform-GTKWave%203.3.116-orange)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen)

---

## 📋 Project Overview

This project implements a complete UART (Universal Asynchronous 
Receiver Transmitter) communication system from scratch using 
Verilog HDL. The design includes a baud rate generator, 
transmitter FSM, receiver with 16x oversampling, and a 
top-level integration module. Full verification was done 
using testbenches and GTKWave waveform analysis.

---

## ⚙️ Specifications

| Parameter | Value |
|---|---|
| UART Format | 8N1 (8 data bits, no parity, 1 stop bit) |
| Baud Rate | 9600 |
| System Clock | 50 MHz |
| Baud Divisor | 5208 |
| Oversampling | 16x on receiver |

---

## 📁 Project Structure

---

## 🛠️ Tools Used

| Tool | Version | Purpose |
|---|---|---|
| Icarus Verilog | 12.0 | Compilation and Simulation |
| GTKWave | 3.3.116 | Waveform Analysis |
| VS Code | Latest | Code Editor |
| Ubuntu WSL | 24.04 | Linux Environment |

---

## ▶️ How to Run

### Step 1 — Compile
```bash
iverilog -o uart_top_test rtl/baud_gen.v rtl/uart_tx.v rtl/uart_rx.v rtl/uart_top.v tb/tb_uart_system.v
```

### Step 2 — Simulate
```bash
vvp uart_top_test
```

### Step 3 — View Waveform
```bash
gtkwave uart_system_dump.vcd
```

---

## ✅ Simulation Results

---

## 🔍 What Was Verified

- ✅ TX idle line stays HIGH
- ✅ Start bit goes LOW for 1 baud period
- ✅ 8 data bits transmitted LSB first at 9600 baud
- ✅ Stop bit returns HIGH after transmission
- ✅ RX detects start bit falling edge correctly
- ✅ RX samples each bit at center using 16x oversampling
- ✅ RX reconstructs received byte correctly
- ✅ Loopback test passed for 0xA5 and 0x3C

---

## 👤 Author

**Pradeep Kumar K**
B.E. VLSI Design and Technology
Karpagam College of Engineering
