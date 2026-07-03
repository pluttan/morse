<div align="center">

# Morse

**Hardware Morse code recogniser for FPGA, outputting to a 16-segment display**

</div>

Synthesisable Verilog implementation of a Morse code decoder for FPGA. A one-bit key input is decoded in real time by a timing-based FSM that distinguishes dots, dashes, letter gaps and word gaps — with three selectable pause-detection variants for manual keying tolerance. The recognised symbol is translated to a 17-bit 16-segment display encoding covering A–Z, 0–9, and common punctuation. Includes a testbench that simulates "HELLO WORLD".

## ■ Features

- ❖ **Real-time decoding** — dot/dash detection by pulse-duration measurement at 10 kHz clock
- ❖ **Debounce handling** — 10 ms input filter for mechanical key contacts
- ❖ **Three pause-detection variants** — v1 (long press), v2 (long silence), v3/default (adaptive auto-switching)
- ❖ **Full charset** — A–Z, 0–9 and 14 punctuation/special characters
- ❖ **16-segment display output** — 17-bit encoding (16 segments + decimal point) per decoded character
- ❖ **FPGA-ready** — synchronous design with clock and reset; PLL-tunable for any target frequency

## ■ Stack

<div align="center">

| Component | Technology |
|-----------|------------|
| HDL | Verilog |
| Target | FPGA (any; PLL-tunable clock) |
| Simulation | Icarus Verilog + VCD |
| Waveforms | GTKWave |
| Clock | 10 kHz (`frq` macro) |

</div>

## ■ How It Works

```
1. The key input is filtered through a 10 ms debounce window to eliminate contact bounce.
2. morseio FSM samples the debounced signal at 10 kHz, measuring pulse and gap durations to classify each press as a dot or dash.
3. When a character-end gap is detected (per the selected pause-detection variant), the accumulated dot/dash sequence is passed to morseTR.
4. morseTR maps the sequence length and pattern to a 17-bit 16-segment display code covering A-Z, 0-9, and punctuation.
5. morseMain latches the encoded output and drives the display when a valid symbol is available.
```

## ■ Usage

```bash
# Simulate (default variant v3)
iverilog -o a.out morseMain.v morseIO.v morseTR.v morseTest.v && vvp a.out

# Open waveforms
gtkwave dump.vcd

# Select variant at compile time
iverilog -D v1 -o a.out morseMain.v morseIO.v morseTR.v morseTest.v && vvp a.out
```

## ■ Modules

<div align="center">

| Module | File | Description |
|--------|------|-------------|
| `morseio` | `morseIO.v` | Timing FSM — measures pulse/gap lengths and extracts dot/dash sequence |
| `morseTR` | `morseTR.v` | Translator — maps (length, pattern) to 17-bit 16-segment display code |
| `morseMain` | `morseMain.v` | Top-level — connects `morseio` and `morseTR`, latches output on valid |
| `morse_tb` | `morseTest.v` | Testbench — simulates "HELLO WORLD" in all three variants |

</div>

## ■ Timing Parameters

<div align="center">

| Parameter | Default | Description |
|-----------|---------|-------------|
| `Ns` | 10 ms | Minimum dot duration |
| `Nl` | 300 ms | Minimum dash duration |
| `Nw` | 600 ms | Word/letter gap threshold |
| `Nsw` | 2000 ms | Auto-pause mode reset timeout |
| `Nd` | 10 ms | Debounce window |
| `frq` | 10 kHz | Clock frequency (adjust via `define`) |

</div>

## ■ Pause Detection Variants

- **v1** — a key press longer than `Nw` (600 ms) marks the end of a character
- **v2** — a silence longer than `Nw` (600 ms) after any press marks the end of a character
- **v3** *(default)* — adaptive: starts in v2 mode; switches to v1 mode when a long press (`>= Nw`) is detected, reverts to v2 after a very long press (`>= Nsw`)

---

pluttan
