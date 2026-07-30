# Storage Devices & Memory Chips — Resources

## Knowledge

### Books (foundational)

- [Book: _Memory Systems: Cache, DRAM, Disk_ — Bruce Jacob, David Wang, Spencer Ng (2008)](https://www.amazon.com/Memory-Systems-Cache-DRAM-Disk/dp/0123797519)
  The encyclopedia of memory systems. Use for: deep reference on DRAM architecture, memory controllers, address mapping, and the full memory hierarchy. Dense — best used as a reference, not read cover-to-cover.

- [Book: _Inside NAND Flash Memories_ — Micheloni, Crippa, Marelli (2010)](https://link.springer.com/book/10.1007/978-90-481-9431-5)
  Comprehensive coverage of NAND Flash from cell physics through controller design to SSDs. Use for: understanding FTL, wear leveling, ECC, and NAND reliability challenges.

- [Book: _Nonvolatile Memory Technologies with Emphasis on Flash_ — Brewer & Gill (2008)](https://ieeexplore.ieee.org/book/5361023)
  IEEE Press volume covering the full landscape of non-volatile memory. Use for: comparing NOR vs NAND, understanding floating-gate physics at a working level, and emerging memories.

### Standards & Specifications (primary sources)

- [JEDEC Standards](https://www.jedec.org/standards-documents)
  Primary source for DDR (JESD79 family), LPDDR (JESD209), eMMC (JESD84), UFS (JESD220), and GDDR specifications. Registration required but free. Use for: authoritative timing, command, and electrical specs.

- [ONFI (Open NAND Flash Interface) Specifications](https://onfi.org/specifications/)
  The standard NAND Flash interface spec. Use for: NAND command sets, timing parameters, and pin definitions. Version 5.0+ covers Toggle DDR as well.

### Online Courses & References

- [SNIA Educational Library](https://www.snia.org/education)
  Storage Networking Industry Association tutorials and webcasts. Use for: practical overviews of SSD architecture, NAND fundamentals, and storage system concepts. High-quality and vendor-neutral.

- [DDR4 / DDR5 Basics — Micron Technical Notes (TN-40-07 series)](https://www.micron.com/support/~/media/micron/repository/products/technical-note/dram/tn4007_ddr4_basics.pdf)
  Micron's guides are clear, practical, and written for engineers integrating their parts. Use for: DDR command truth tables, initialization sequences, and timing parameter explanations.

### Reference Sites

- [AnandTech SSD/Memory Coverage](https://www.anandtech.com/tag/memory)
  Deep-dive reviews that explain the "why" behind SSD and memory technology choices. Useful for seeing how theory translates to real products.

## Wisdom (Communities)

- [r/chipdesign](https://reddit.com/r/chipdesign)
  Practicing ASIC/FPGA/memory engineers. Use for: questions about memory controller design, PHY implementation, and industry practices.

- [r/embedded](https://reddit.com/r/embedded)
  Broader embedded systems community. Use for: practical questions about interfacing with memory chips on PCBs, signal integrity, and layout considerations.

- [EEVblog Electronics Community Forum](https://www.eevblog.com/forum/)
  Active hardware engineering forum with experienced members. Use for: hands-on debugging, oscilloscope measurements, and practical PCB-level questions.

## Gaps

- No Chinese-language resources yet — important given the storage industry's strong presence in China/Taiwan/Korea
- No direct mentor or internal training materials linked yet (to be added as the user discovers them)
- LPDDR / mobile memory resources are thinner than DDR — need to find quality references
