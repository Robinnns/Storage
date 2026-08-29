# 教学备忘

## 用户偏好
- 边工作边学，岗位是存储器件/存储芯片的系统集成工程师
- EE/CE 背景，偏数字/逻辑方向
- 单次学习窗口 15–20 分钟
- 偏好结构化、可积累的知识
- 这是持续更新的参考工作区，随职业成长而增长
- **不要**在创建/编辑 HTML 文件后自动用浏览器打开——用户需要时自行打开
- **不要**在未经明确要求时提交/推送 git——只在用户说"提交"或"push"时才操作

## 风格笔记
- 欢迎中英双语教学——用户用中文交流
- 尽量用具体、数据手册级的例子
- 每节课都要回答"这对我的工作有什么用？"

## 双环境工作流（重要）
- **macOS（当前环境）**：承载学习、记录、源码开发。在这里写 RTL/Verilog 源码、记笔记、管理工作区。
- **Windows 环境**：FPGA 仿真、编译、调试。Vivado 的综合/实现/下载/JTAG 调试、仿真都在 Windows 上做。
- **同步方式**：两套环境通过 **GitHub 仓库**同步。macOS 上写好的源码 commit+push，Windows 上 pull 下来跑 Vivado。
- **对工作流的影响：**
  - macOS 上只做**源码编写与逻辑整理**，不做 Vivado 编译（除非用户要求快速仿真）。
  - 新建工程时，`.xpr` 和约束文件在 Windows 上生成，源码在 macOS 写好后同步过去。
  - commit/push 时机：用户在 macOS 写完源码后可提示提交，但**是否提交由用户决定**（用户说"提交"才操作）。

## 工作区约定

### `knowledges/` 目录
- **用途：** 随手记录的小知识点，作为 lessons 的轻量补充。适合记录一个概念、一个公式、一个数据手册阅读技巧等。
- **命名规则：** `YYMMDD_Topic.html`（如 `260731_F-squared.html`）
- **索引维护：** 每次新增知识点时，必须同时更新两个地方：
  1. `knowledges/index.html` — 在 `<script>` 标签内的 `entries` 数组最前面添加一条新记录
  2. 新知识点文件本身必须包含 "← 返回知识点总表" 的链接（即与 index 形成双向链接）
- **内容范围：** 不适合单独成为一课，但值得记住的东西。如果某个知识点展开了 3 个以上子话题，考虑升级为 lesson。

### `plans/` 目录（规划与任务追踪）
- **用途：** 学习路径规划 + 任务勾选清单 + 会话日志。
- **文件：** `roadmap-a7lite.md`（当前主线：A7-LITE 实践路径）、`README.md`（约定）、`session-log.md`（会话记录）。
- **更新：** 任务用 `- [ ]` / `- [x]` 勾选；每完成一个阶段更新进度表，并在 `session-log.md` 追加一行。
- **工程关联：** 每个阶段对应 `projects/NN_xxx/` 一个工程。

### `projects/` 目录（工程与源码）
- **用途：** 存放 FPGA 工程和学习开发的源码，与规划分离。
- **命名：** `NN_阶段名/`，如 `01_logic_gates/`。
- **模板：** 新建工程时复制 `projects/_template/` 作为骨架，保持统一结构。
- **工程目录结构（统一约定）：**
  ```
  NN_xxx/
  ├── src/             RTL 源码            ← 与板卡/工具解耦, git 提交
  ├── sim/             testbench           ← git 提交
  ├── fpga/<板卡名>/    板卡 BSP 层          ← xdc/pinmap/README, git 提交
  ├── eda/vivado/
  │   ├── scripts/     TCL 自动化脚本       ← create_project.tcl 等, git 提交
  │   └── workspace/   Vivado 工程实体      ← Windows 生成, gitignore
  └── doc/             工程笔记/截图
  ```
- **解耦原则：** `src/` `sim/` 不依赖任何板卡和工具；换板卡只动 `fpga/`，换工具链只动 `eda/`。
- **工程创建：** 不手动点 GUI、不提交 `*.xpr`——在 Windows 上 `source eda/vivado/scripts/create_project.tcl` 一键重建（脚本用相对路径引用外部源码）。
- **首次体验：** 想体验手动建工程时，建完后用 `write_project_tcl -force -no_copy_sources -paths_relative_to <工程根> <输出.tcl>` 导出为脚本，作为该工程的自动化方案。
- **提交注意：** Vivado 生成物已在根 `.gitignore` 忽略（`.runs/` `.cache/` `.gen/` `*.xpr` `*.bit` 等），只提交源码、约束、脚本。请勿 `git add -f` 强制添加生成物。

## 设计系统 — "Precision Instrument"
- **浅色/深色双模式**，通过 `assets/theme.js` 实现。每个 HTML 文件需要在 `<head>` 中包含内联的 theme init 脚本（防闪烁），并在 `</body>` 前引入 `theme.js`。
- **配色：** Signal Blue on Silicon — 强调色为蓝灰色系（浅色 #1a6fb5 / 深色 #4da8e8）。
- **字体：** Inter（正文）+ JetBrains Mono（代码）。
- **新增 HTML 模板：** 参考已有的 lesson / reference / knowledge 文件，复制 `<head>` 中的 theme init 和 `<body>` 末尾的 `<script>` 标签。
- **切换开关：** 页面右上角的固定小拨动开关，点击切换并持久化到 localStorage。
