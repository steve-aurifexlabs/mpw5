# PSRAM Interface with PRNG

PSRAM and integration: Steve Goldsmith, Lead Instructor, Aurifex Labs, https://aurifexlabs.com
PRNG: Zhenle Cao

## Design

### PSRAM Interface
For this project I built a PSRAM interface.

Designed from the IS66/67WVH16M8ALL/BLL datasheet:
https://www.issi.com/WW/pdf/66-67WVH16M8ALL-BLL.pdf

Includes programmable latency and post-transaction delay.
For read synchronization, selectable between programmable latency or rwds strobe.

### PRNG

Thanks to Zhenle Cao for providing the random number generator.
See: https://github.com/ZhenleC/wrapped_acorn_prng

Summary (quoted from Zhenle's project):
	This project as a ACORN (Additive Congruential Random Number) generator made to fit in the group tapeout submission as part of the Zero to ASIC Course. This project was implemented according to the information here: http://acorn.wikramaratna.org/concept.html This ACORN generator is hardwired to have k = 16 and Modulus M = 2^12 (chosen due to the limitation on the number of GPIO output pins). However, it is highly scalable, and I was able to harden with at least k=16, M = 2^64. The area of the logic directly scales with k*M as the component that takes up the most space are the registers.

## Organization

Instead of worrying about mucking up the tool with config and filenames, I just modified the example as little as possible.

Should be just these files (but diff to be sure):
- verilog/rtl/user_proj_example.v
- verilog/dv/la_test2_tb.v
- verilog/dv/la_test2.c
- openlane/user_proj_example/config.tcl
- openlane/user_project_wrapper/macro.cfg

And added for unit testing with SymbiYosys
- verilog/rtl/original/hyperram.v
- verilog/rtl/unit_test/cover.sby

But I had to manually modify the original System Verilog that I had written to get hardening to work by removing always_ff, etc.

## Testing

Testing was done in two parts

### Unit Tests
Manual cover statements were visually inspected against the PSRAM datasheet.

Requires installing SymbiYosys:
https://symbiyosys.readthedocs.io/en/latest/install.html

To run:
cd verilog/rtl/unit_test
sby cover.sby

To run again:
rm -r cover && sby cover.sby

Inspect:
gtkwave cover/engine_0/trace*.png

Tests include:
- read
- write
- read and write

### Caravel Test

To run:

make verify-la_test2-rtl
make verify-la_test2-gl

This only tests that the PSRAM state machine advances to state 2.


