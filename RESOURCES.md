# 存储器件与存储芯片 — 学习资源

## 知识（Knowledge）

### 书籍（基础）

- [书籍：_Memory Systems: Cache, DRAM, Disk_ — Bruce Jacob, David Wang, Spencer Ng (2008)](https://www.amazon.com/Memory-Systems-Cache-DRAM-Disk/dp/0123797519)
  存储系统的百科全书。用于：DRAM 架构、内存控制器、地址映射、完整存储层次结构的深入参考。内容密集——适合当参考书查阅，不适合从头通读。

- [书籍：_Inside NAND Flash Memories_ — Micheloni, Crippa, Marelli (2010)](https://link.springer.com/book/10.1007/978-90-481-9431-5)
  从单元物理到控制器设计再到 SSD 的 NAND Flash 全面覆盖。用于：理解 FTL、磨损均衡（Wear Leveling）、ECC 和 NAND 可靠性挑战。

- [书籍：_Nonvolatile Memory Technologies with Emphasis on Flash_ — Brewer & Gill (2008)](https://ieeexplore.ieee.org/book/5361023)
  IEEE Press 出版物，覆盖非易失存储器的完整版图。用于：对比 NOR 与 NAND、在工作层面理解浮栅物理、了解新兴存储器。

### 标准与规范（第一手资料）

- [JEDEC 标准](https://www.jedec.org/standards-documents)
  DDR（JESD79 系列）、LPDDR（JESD209）、eMMC（JESD84）、UFS（JESD220）、GDDR 规范的第一手来源。需免费注册。用于：权威的时序、命令和电气规格。

- [ONFI（开放 NAND Flash 接口）规范](https://onfi.org/specifications/)
  NAND Flash 接口的标准规范。用于：NAND 命令集、时序参数和引脚定义。5.0 以上版本也覆盖 Toggle DDR。

### 在线课程与参考资料

- [SNIA 教育库](https://www.snia.org/education)
  存储网络行业协会的教程和网络研讨会。用于：SSD 架构、NAND 基础和存储系统概念的实用概述。质量高且厂商中立。

- [DDR4 / DDR5 基础 — Micron 技术笔记（TN-40-07 系列）](https://www.micron.com/support/~/media/micron/repository/products/technical-note/dram/tn4007_ddr4_basics.pdf)
  Micron 的指南清晰实用，专门写给集成其器件的工程师。用于：DDR 命令真值表、初始化序列和时序参数解释。

### 参考网站

- [AnandTech SSD/内存报道](https://www.anandtech.com/tag/memory)
  深入评测，解释 SSD 和内存技术选择背后的"为什么"。用于：看理论如何转化为真实产品。

## 智慧（Wisdom / 社区）

- [r/chipdesign](https://reddit.com/r/chipdesign)
  一线 ASIC/FPGA/存储工程师社区。用于：内存控制器设计、PHY 实现和行业实践的问题。

- [r/embedded](https://reddit.com/r/embedded)
  更广泛的嵌入式系统社区。用于：PCB 上与存储芯片接口、信号完整性、布局考虑的实用问题。

- [EEVblog 电子论坛](https://www.eevblog.com/forum/)
  活跃的硬件工程论坛，成员经验丰富。用于：动手调试、示波器测量、PCB 层级的实操问题。

## 缺口（Gaps）

- 尚无中文资源——考虑到存储产业在韩国/台湾/中国大陆的强势地位，这很重要
- 尚无直接的导师或内部培训资料链接（待用户发现后补充）
- LPDDR / 移动存储的资源比 DDR 少——需要找高质量参考
