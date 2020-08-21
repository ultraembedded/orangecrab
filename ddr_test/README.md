## DDR Test

Run a full 128MB read / write test of the DDR3 memory on the OrangeCrab ECP5 FPGA board.

Tests:
* All 128MB of memory is written, read back, and verified (twice)
* Patterns (incrementing patterns, all ones)

Not tested:
* Data mask (DM) pins (currently).
* High speed PCB routing (tests are run @ 24MHz DDR clock).

### Output

LEDs:
* Blue = Test in progress
* Red = Failed
* Green = Pass