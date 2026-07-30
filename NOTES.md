# Teaching Notes

## User Preferences
- Learning on the job as a system integration engineer (storage devices/chips)
- EE/CE background, digital/systems focus
- Sessions should fit in 15-20 minute windows
- Prefers structured knowledge building
- This is ongoing reference material that grows with their role
- **Do NOT auto-open HTML files in browser** after creating/editing — user will open them manually when needed
- **Do NOT commit/push to git** unless explicitly asked — only when the user says "提交" or "push"

## Style Notes
- Chinese/English bilingual teaching is welcome — the user communicates in Chinese
- Use concrete, datasheet-level examples where possible
- Each lesson should answer "why does this matter for my job?"

## Workspace Conventions

### `knowledges/` 目录
- **用途：** 随手记录的小知识点，作为 lessons 的轻量补充。适合记录一个概念、一个公式、一个 datasheet 阅读技巧等。
- **命名规则：** `YYMMDD_Topic.html`（如 `260731_F-squared.html`）
- **索引维护：** 每次新增知识点时，必须同时更新两个地方：
  1. `knowledges/index.html` — 在 `<script>` 标签内的 `entries` 数组最前面添加一条新记录
  2. 新知识点文件本身必须包含 "← 返回知识点总表" 的链接（即与 index 形成双向链接）
- **内容范围：** 不适合单独成为一课，但值得记住的东西。如果某个知识点展开了 3 个以上子话题，考虑升级为 lesson。

## Design System — "Precision Instrument"
- **浅色/深色双模式**，通过 `assets/theme.js` 实现。每个 HTML 文件需要在 `<head>` 中包含内联的 theme init 脚本（防闪烁），并在 `</body>` 前引入 `theme.js`。
- **配色：** Signal Blue on Silicon — 强调色为蓝灰色系（浅色 #1a6fb5 / 深色 #4da8e8）。
- **字体：** Inter（正文）+ JetBrains Mono（代码）。
- **新增 HTML 模板：** 参考已有的 lesson / reference / knowledge 文件，复制 `<head>` 中的 theme init 和 `<body>` 末尾的 `<script>` 标签。
- **切换开关：** 页面右上角的固定小拨动开关，点击切换并持久化到 localStorage。
