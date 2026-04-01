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

# 飞书通知配置
FEISHU_WEBHOOK="https://open.feishu.cn/open-apis/bot/v2/hook/placeholder"  # 如有需要可配置
NOTIFY_USER="张涛"

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
    
    # 发送通知
    echo "❌ 战国小说审核任务取消" 
    echo "原因: Codex 未安装"
    echo "时间: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "建议: 请检查 Codex CLI 安装状态"
    
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
    # 超时 - 取消任务并通知
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Codex 审读超时，取消任务并通知" >> "$LOG_FILE"
    
    # 删除空文件
    rm -f "$REVIEW_FILE"
    
    # 输出通知信息（会被飞书机器人捕获）
    echo ""
    echo "⚠️ @张涛 战国小说审核任务取消通知"
    echo "═══════════════════════════════════"
    echo "📋 任务: 战国小说 Codex 审读"
    echo "⏰ 时间: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "❌ 状态: 已取消"
    echo ""
    echo "📌 取消原因:"
    echo "   Codex 连接超时（5分钟未响应）"
    echo "   可能是网络问题或 OpenAI API 连接失败"
    echo ""
    echo "💡 建议操作:"
    echo "   1. 检查服务器网络连接"
    echo "   2. 检查 OpenAI API 状态"
    echo "   3. 稍后手动执行: codex review"
    echo ""
    echo "📁 项目路径: $PROJECT_DIR"
    echo "═══════════════════════════════════"
    
    exit 1

elif [ $CODEX_EXIT_CODE -ne 0 ]; then
    # 执行失败 - 取消任务并通知
    ERROR_MSG=$(tail -20 "$REVIEW_FILE" 2>/dev/null || echo "未知错误")
    
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Codex 审读失败，退出码: $CODEX_EXIT_CODE，取消任务并通知" >> "$LOG_FILE"
    
    # 删除失败报告
    rm -f "$REVIEW_FILE"
    
    # 输出通知信息
    echo ""
    echo "⚠️ @张涛 战国小说审核任务取消通知"
    echo "═══════════════════════════════════"
    echo "📋 任务: 战国小说 Codex 审读"
    echo "⏰ 时间: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "❌ 状态: 已取消"
    echo ""
    echo "📌 取消原因:"
    echo "   Codex 执行失败（退出码: $CODEX_EXIT_CODE）"
    echo ""
    echo "🔍 错误信息:"
    echo "$ERROR_MSG" | sed 's/^/   /'
    echo ""
    echo "💡 建议操作:"
    echo "   1. 检查 OpenAI API 密钥配置"
    echo "   2. 检查网络连接状态"
    echo "   3. 运行: codex --version 检查安装"
    echo "   4. 手动执行测试: codex review 'test'"
    echo ""
    echo "📁 项目路径: $PROJECT_DIR"
    echo "═══════════════════════════════════"
    
    exit 1
fi

# 审读成功
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Codex 审读成功" >> "$LOG_FILE"

# 在报告头部添加元信息
REPORT_HEADER="# Codex 审读报告 - $DATE

**审读时间**: $(date '+%Y-%m-%d %H:%M:%S')  
**审读工具**: Codex CLI  
**审读状态**: ✅ 成功  
**执行时长**: 正常

---

"

# 将元信息添加到报告开头
echo "$REPORT_HEADER" | cat - "$REVIEW_FILE" > "$REVIEW_FILE.tmp" && mv "$REVIEW_FILE.tmp" "$REVIEW_FILE"

# Git 提交
git add -A
git commit -m "feat: add codex review report $DATE" 2>/dev/null || echo "无变更需要提交" >> "$LOG_FILE"
git push origin main 2>/dev/null || git push origin master 2>/dev/null || echo "推送失败" >> "$LOG_FILE"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] 审核完成: $REVIEW_FILE" >> "$LOG_FILE"

# 输出成功通知
echo ""
echo "✅ @张涛 战国小说审核任务完成"
echo "═══════════════════════════════════"
echo "📋 任务: 战国小说 Codex 审读"
echo "⏰ 时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo "✅ 状态: 成功"
echo ""
echo "📁 报告位置: reviews/records/codex-review-$DATE.md"
echo "📝 报告已推送至 GitHub"
echo "═══════════════════════════════════"
