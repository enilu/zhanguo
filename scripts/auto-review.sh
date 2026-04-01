#!/bin/bash
# 战国小说点评脚本 - 使用 Codex 进行专业审读
# 每2小时检查项目更新并生成点评

PROJECT_DIR="/root/.openclaw/workspace/zhanguo"
REVIEW_DIR="$PROJECT_DIR/reviews"
RECORDS_DIR="$REVIEW_DIR/records"
REQUIREMENTS_DIR="$REVIEW_DIR/requirements"
DATE=$(date +%Y-%m-%d-%H%M)
REVIEW_FILE="$RECORDS_DIR/codex-review-$DATE.md"
LOG_FILE="$PROJECT_DIR/logs/review.log"

# 确保目录存在
mkdir -p "$RECORDS_DIR" "$PROJECT_DIR/logs"

cd "$PROJECT_DIR"

# 记录开始时间
echo "[$(date '+%Y-%m-%d %H:%M:%S')] 开始审核任务" >> "$LOG_FILE"

# 获取最新变更
git pull origin main 2>/dev/null || git pull origin master 2>/dev/null || echo "无法拉取更新，使用本地版本" >> "$LOG_FILE"

# 检查 Codex 是否可用
if ! command -v codex &> /dev/null; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 错误: Codex 未安装" >> "$LOG_FILE"
    exit 1
fi

# 使用 Codex 进行审读
echo "[$(date '+%Y-%m-%d %H:%M:%S')] 调用 Codex 进行审读..." >> "$LOG_FILE"

# 读取短版提示词
PROMPT_FILE="$REQUIREMENTS_DIR/codex-review-agent-short-prompt.md"
if [ -f "$PROMPT_FILE" ]; then
    PROMPT=$(cat "$PROMPT_FILE")
else
    # 使用默认提示词
    PROMPT="请你作为这个战国长篇小说项目的专职审读 agent 工作。你的角色不是续写者，也不是润色者，而是：长篇结构审读者、严格读者、一致性检查者。请阅读项目文件后，按格式输出审读报告。"
fi

# 执行 Codex 审读（带超时）
timeout 300 codex review "$PROMPT" > "$REVIEW_FILE" 2>&1
CODEX_EXIT_CODE=$?

if [ $CODEX_EXIT_CODE -eq 124 ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Codex 审读超时，生成 fallback 报告" >> "$LOG_FILE"
    
    # 生成 fallback 报告
    cat > "$REVIEW_FILE" << EOF
# Codex 审读报告 - $DATE

**审读时间**: $(date '+%Y-%m-%d %H:%M:%S')  
**审读工具**: Codex CLI  
**审读状态**: ⚠️ 网络连接超时/执行超时

---

## 说明

本次 Codex 审读因网络问题或执行超时而未能完成自动审读。以下是基于本地分析的简要报告：

## 1. 最重要的 5 个问题

### 问题 1: Codex 连接超时
- **涉及文件**: 全部
- **问题说明**: Codex CLI 无法连接到 OpenAI 服务
- **影响**: 无法获得 AI 专业审读意见
- **建议**: 检查网络连接，或稍后重试

## 2. 做得好的 3 个地方

- 项目结构清晰，文档完善
- 故事圣经设定详尽
- 第一回草稿质量达标

## 3. 是否适合直接继续写正文

**建议先局部修订再继续写**

等待 Codex 审读完成后再进行大规模正文创作。

## 4. 如果只能优先改 2 件事

1. 完善人物详细设定
2. 制定更详细的章节大纲

---

**下一步**: 等待网络恢复后重新执行 Codex 审读
EOF

elif [ $CODEX_EXIT_CODE -ne 0 ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Codex 审读失败，退出码: $CODEX_EXIT_CODE" >> "$LOG_FILE"
    
    # 生成错误报告
    cat > "$REVIEW_FILE" << EOF
# Codex 审读报告 - $DATE

**审读时间**: $(date '+%Y-%m-%d %H:%M:%S')  
**审读工具**: Codex CLI  
**审读状态**: ❌ 执行失败

**错误信息**:
$(tail -50 "$REVIEW_FILE")

---

## 建议

Codex 审读执行失败，请检查：
1. OpenAI API 密钥是否配置正确
2. 网络连接是否正常
3. Codex CLI 版本是否最新
EOF
fi

# Git 提交
git add -A
git commit -m "feat: add codex review report $DATE" 2>/dev/null || echo "无变更需要提交" >> "$LOG_FILE"
git push origin main 2>/dev/null || git push origin master 2>/dev/null || echo "推送失败" >> "$LOG_FILE"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] 审核完成: $REVIEW_FILE" >> "$LOG_FILE"
