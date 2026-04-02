# AI Skills 目录

## 概述
本目录包含项目的 AI 协作技能（Skills）体系，分为通用技能（common/）和工具专属技能（codex/、claude/、opencode/）。

## 目录结构
```
doc/ai-skills/
  README.md              # 本文件，包含技能体系说明
  common/                # 跨工具复用的通用技能
  codex/                 # Codex 专属技能
  claude/                # Claude 专属技能
  opencode/              # Opencode 专属技能
```

## 技能设计原则
- 入口轻量化：`SKILL.md` 只保留触发条件、目标、硬规则、下钻入口
- 渐进式披露：详细信息放在 `references/`，确定性检查放在 `scripts/`，模板放在 `assets/`，示例放在 `examples/`
- 优先脚本化：能脚本化的动作优先写成脚本
- 沉淀 Gotchas：维护失败经验，避免重复踩坑

## 技能执行流程
1. 扫描 `doc/ai-skills/` 并匹配任务相关 Skill
2. 命中后先读 `SKILL.md`
3. 根据入口指引按需阅读 `references/`
4. 如存在 `scripts/`，优先运行确定性检查
5. 信息不足时先确认，不直接假设
6. 命中异常时按本文件备用方案处理

## 备用方案
如未命中匹配 Skill 或执行异常：
1. 检查任务是否符合项目整体目标
2. 遵循 `README.md` 中的协作规范
3. 联系项目 owner 确认方案
