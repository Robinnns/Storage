# Mission: Storage Devices & Memory Chips

## Why
I'm a newly hired hardware engineer tasked with system integration of storage devices — getting NAND Flash, DRAM, and related chips working reliably inside larger systems (SSDs, embedded storage, memory subsystems on PCBs). I need to quickly build the foundational mental models so I can read datasheets, understand interface specifications, and reason about system-level trade-offs without getting lost.

## Success looks like
- Reading a NAND Flash or DDR datasheet and understanding the pinout, timing diagrams, and command sequences
- Explaining the fundamental operation of SRAM, DRAM, NAND Flash, and NOR Flash to a colleague from first principles
- Comparing memory technologies across speed, density, cost, power, and volatility to make or validate system-level selections
- Understanding what a memory controller does and how it talks to memory chips over standard interfaces (DDR, ONFI, eMMC/UFS)
- Debugging integration issues by reasoning about signal integrity, timing, and protocol-level behavior

## Constraints
- EE/CE background with a digital/logic focus; strong on computer architecture, weaker on analog and device physics
- Learning on the job — lessons should be consumable in 15-20 minute sessions
- Prefers structured, buildable knowledge over isolated facts
- Ongoing reference — this workspace grows with the role

## Out of scope
- Detailed transistor-level device physics (only what's needed to understand cell operation)
- DRAM/CAM design at the circuit-schematic level
- Fab process engineering
- Storage networking (SAN, NVMe-oF) — for now
- Enterprise storage architecture above the device level
