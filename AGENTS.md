# Repository Guidelines

## 项目结构与模块组织
`STORY_BIBLE.md` 是项目设定、基调与长期连续性的最高准则。主要写作资料集中在 `docs/`：`docs/characters/` 存放核心人物设定，`docs/outlines/` 存放卷纲、回目与逐章细纲，`docs/rankings/` 存放能力体系与讨论维度，`docs/review/` 存放审读提示词，`docs/superpowers/specs/` 存放设计规格。`reviews/` 用于审读流程归档，其中 `reviews/requirements/` 存放可复用要求，`reviews/records/` 存放实际生成的报告。自动化脚本位于 `scripts/`，当前主要入口是 `scripts/auto-review.sh`。

## 构建、测试与开发命令
本仓库没有传统构建流程，日常主要使用以下命令：

- `bash -n scripts/auto-review.sh`：检查审读脚本语法是否正确。
- `bash scripts/auto-review.sh`：在本地执行一次 Codex 审读流程。
- `git status`：确认本次只修改了预期的文档、提示词或审读记录。
- `rg --files docs reviews scripts`：快速查看当前资料与脚本文件集合。

所有命令默认在仓库根目录执行。

## 编码风格与命名约定
Markdown 文档应保持标题清晰、段落简短、说明直接。文件名延续现有模式，尽量做到可读、稳定、可检索，例如 `chapter-01-scene-outline.md`、`codex-review-agent-short-prompt.md`、`codex-review-YYYY-MM-DD-HHMM.md`。Shell 脚本使用 Bash，配置类变量保持全大写命名，控制块内部沿用现有 4 空格缩进风格。

## 测试指南
当前没有正式自动化测试套件。修改文档后，应对照 `STORY_BIBLE.md` 及相关 `docs/` 文件检查设定一致性。修改脚本后，至少执行一次 `bash -n scripts/auto-review.sh`；如果环境允许，再补一次本地手动运行。新生成的审读报告必须带时间戳，并仅放入 `reviews/records/`。

## 提交与合并请求规范
仓库历史提交采用简短的约定式前缀，如 `feat: ...`、`refactor: ...`、`docs: ...`，后续保持一致。每次提交只聚焦一个明确改动。提交 PR 时应说明影响范围、列出关键文件、写明执行过的检查命令；如果改动了审读脚本或报告格式，附上示例输出或说明结果差异。

## 贡献说明
默认将 `STORY_BIBLE.md` 与既有大纲视为项目 canon。不要覆盖旧审读记录，应新增带时间戳的文件以保留演进过程。
