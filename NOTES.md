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

## 双环境工作流（macOS 开发 + Windows 实现）

### 总体分工
- **macOS = 开发环境**：编码 + RTL 快速验证。逻辑正确性在这侧闭环（iverilog 秒级仿真）。
- **Windows = 实现环境**：综合/实现/上板调试。物理验证在这侧完成。
- **同步方式**：GitHub 仓库。macOS 写好源码 commit+push，Windows pull 下来跑 Vivado。

### 各侧工具链

| 环节 | macOS | Windows |
|------|-------|---------|
| 编码 | VS Code + Verilog 插件 | —（只拉代码，不改） |
| RTL 快速仿真 | iverilog + vvp（`run_sim.sh`） | iverilog + vvp（`run_sim.bat`） |
| 波形查看 | Surfer | Surfer / GTKWave |
| 综合 / 实现 / 时序 | — | **Vivado 2021.1**（xsim 综合后/时序仿真） |
| 上板 / 片内调试 | — | Vivado Hardware Manager + **ILA** |
| 串口调试 | `screen` / `minicom` | PuTTY / SSCOM（115200 8-N-1） |
| 版本控制 | git CLI | git CLI |

### 每轮迭代流程

```
 macOS: 写/改 RTL → bash eda/iverilog/scripts/run_sim.sh → Surfer 看波形
   │            ↑ (逻辑错误 → 回改)
   │        逻辑正确 → git commit + push
   ▼
 Windows: git pull → source eda/vivado/scripts/create_project.tcl
        → 综合 + 实现 + Generate Bitstream → 上板下载
        → ILA / 串口验证 → 有问题回 macOS 改 → 循环
```

### 关键原则
- **源码唯一修改点在 macOS**；Windows 只跑流程，临时调试改动用 `git stash` 或直接不提交。
- **仿真分工**：日常 RTL 功能验证用 iverilog（秒级）；综合后/时序/Xilinx 原语仿真用 Vivado xsim；上板片内调试用 ILA。
- **生成物永不入库**：`eda/*/workspace/`、`.runs/`、`.xpr`、`.bit` 已在根 `.gitignore` 忽略。
- **commit/push 时机**：用户在 macOS 写完源码后可提示提交，但**是否提交由用户决定**（用户说"提交"才操作）。

### git 同步约定（双环境核心纪律）
- **改完即 push、别攒**：一个逻辑变更完成后立即 commit+push。攒得越多，两端分叉越大、冲突概率越高。
- **同一份被跟踪文件，同一时刻只允许一台机器改**：RTL 源码统一在 macOS 改；Windows 只跑编译/仿真/下载，临时调试改动用 `git stash` 或直接不提交。
- **生成物永不入库**：Vivado 的 `workspace/`、`.runs/`、`.xpr`、`.bit` 已被根 `.gitignore` 忽略。git 只同步"设计决策"，不同步"机器状态"。
- **标准操作序列：**
  ```bash
  # 工作结束后（本机提交推送）
  git add <要共享的文件>      # 精确 add，别 git add .
  git commit -m "描述改动"
  git push

  # 另一台机器开工前（先设一次默认 merge，免带参数）
  git config pull.rebase false
  git pull
  ```
- **pull 报 "divergent branches"**：git 2.27+ 要求明确协调方式——`--no-rebase`=merge（保留合并提交）、`--rebase`=抹平历史变直线、`--ff-only`=只接受快进。设了 `pull.rebase false` 后直接 `git pull`。
- **冲突处理**：`git pull` 报冲突 → `git status` 找冲突文件 → 打开删掉 `<<<<<<< / ======= / >>>>>>>` 标记手动合并 → `git add` + `git commit`。或 `git checkout --ours/--theirs <文件>` 以某一方为准。
- **关键机制速记：**
  - `origin/main` 是**书签**——记录"上次 fetch 时远程的样子"，`git fetch` 才刷新；`git pull` = `fetch` + `merge`。
  - **三区模型**：工作区 → `git add` → 暂存区 → `git commit` → 仓库历史。
  - **分叉**（两端各有提交，`[ahead N, behind M]`）无法 fast-forward，必须 merge；merge 自动找共同祖先合并，文件不重叠则零冲突、自动生成合并提交。
- **网络**：GitHub 连接时通时断（`SSL_ERROR_SYSCALL`），pull/push 失败重试即可，失败无损。

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
  ├── rtl/             RTL 源码            ← 与板卡/工具解耦, git 提交
  ├── tb/              testbench           ← git 提交
  ├── fpga/<板卡名>/    板卡 BSP 层          ← xdc/pinmap/README, git 提交
  ├── eda/
  │   ├── vivado/
  │   │   ├── scripts/ TCL 自动化脚本       ← create_project.tcl 等, git 提交
  │   │   └── workspace/ Vivado 工程实体    ← Windows 生成, gitignore
  │   └── iverilog/
  │       ├── scripts/ run_sim.bat / .sh   ← 轻量仿真, git 提交
  │       └── workspace/ 仿真产物           ← gitignore
  └── doc/             工程笔记/截图
  ```
- **解耦原则：** `rtl/` `tb/` 不依赖任何板卡和工具；换板卡只动 `fpga/`，换工具链只动 `eda/`。
- **工程创建：** 不手动点 GUI、不提交 `*.xpr`——在 Windows 上 `source eda/vivado/scripts/create_project.tcl` 一键重建（脚本用相对路径引用外部源码）。
- **首次体验：** 想体验手动建工程时，建完后用 `write_project_tcl -force -no_copy_sources -paths_relative_to <工程根> <输出.tcl>` 导出为脚本，作为该工程的自动化方案。
- **提交注意：** Vivado 生成物已在根 `.gitignore` 忽略（`.runs/` `.cache/` `.gen/` `*.xpr` `*.bit` 等），只提交源码、约束、脚本。请勿 `git add -f` 强制添加生成物。

## 设计系统 — "Precision Instrument"
- **浅色/深色双模式**，通过 `assets/theme.js` 实现。每个 HTML 文件需要在 `<head>` 中包含内联的 theme init 脚本（防闪烁），并在 `</body>` 前引入 `theme.js`。
- **配色：** Signal Blue on Silicon — 强调色为蓝灰色系（浅色 #1a6fb5 / 深色 #4da8e8）。
- **字体：** Inter（正文）+ JetBrains Mono（代码）。
- **新增 HTML 模板：** 参考已有的 lesson / reference / knowledge 文件，复制 `<head>` 中的 theme init 和 `<body>` 末尾的 `<script>` 标签。
- **切换开关：** 页面右上角的固定小拨动开关，点击切换并持久化到 localStorage。
