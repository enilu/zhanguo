# Reviews Directory

这个目录用于存放本项目的审核相关文件，分为两类：

## 目录说明

- `requirements/`
  - 存放给 Codex 或其他 AI 审读 agent 的审核要求、提示词、执行消息。

- `records/`
  - 存放实际产生的审核记录、点评报告、审读结果。

## 建议约定

- 审核要求文件放入 `requirements/`
- 审核记录文件放入 `records/`
- 审核记录建议带时间戳，便于追踪，例如：
  - `review-YYYY-MM-DD-HHMM.md`
  - `codex-review-YYYY-MM-DD-HHMM.md`

## 当前用途

该目录主要用于：

- 保存可复用的审读提示词
- 保存不同轮次的 AI 审读结果
- 方便后续对比不同阶段的结构问题与修改建议
