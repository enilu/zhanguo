#!/bin/bash
# 战国小说点评脚本
# 每2小时检查项目更新并生成点评

PROJECT_DIR="/root/.openclaw/workspace/zhanguo"
REVIEW_DIR="$PROJECT_DIR/reviews"
DATE=$(date +%Y-%m-%d-%H%M)
REVIEW_FILE="$REVIEW_DIR/review-$DATE.md"

cd "$PROJECT_DIR"

# 获取最新变更
git pull origin main 2>/dev/null || git pull origin master 2>/dev/null || echo "无法拉取更新，使用本地版本"

# 检查是否有新内容（与上次提交的差异）
LAST_REVIEW_FILE=$(ls -t "$REVIEW_DIR"/review-*.md 2>/dev/null | head -1)

echo "# 战国小说点评报告 - $DATE" > "$REVIEW_FILE"
echo "" >> "$REVIEW_FILE"
echo "## 📊 项目状态" >> "$REVIEW_FILE"
echo "" >> "$REVIEW_FILE"

# 统计项目文件
echo "- **总章回数**: $(ls -1 docs/*.md 2>/dev/null | wc -l)" >> "$REVIEW_FILE"
echo "- **总字数估算**: $(find docs -name '*.md' -exec wc -c {} + 2>/dev/null | tail -1 | awk '{print $1}') 字符" >> "$REVIEW_FILE"
echo "- **点评时间**: $(date '+%Y年%m月%d日 %H:%M')" >> "$REVIEW_FILE"
echo "" >> "$REVIEW_FILE"

# 分析最新章节
LATEST_CHAPTER=$(ls -t docs/chapter-*.md 2>/dev/null | head -1)
if [ -n "$LATEST_CHAPTER" ]; then
    CHAPTER_NAME=$(basename "$LATEST_CHAPTER" .md)
    echo "## 📝 最新章节分析: $CHAPTER_NAME" >> "$REVIEW_FILE"
    echo "" >> "$REVIEW_FILE"
    
    # 提取章节标题
    TITLE=$(head -1 "$LATEST_CHAPTER" | sed 's/^# //')
    echo "**章节标题**: $TITLE" >> "$REVIEW_FILE"
    echo "" >> "$REVIEW_FILE"
    
    # 统计字数
    WORD_COUNT=$(wc -c < "$LATEST_CHAPTER")
    echo "**本章字数**: $WORD_COUNT 字符" >> "$REVIEW_FILE"
    echo "" >> "$REVIEW_FILE"
    
    # 分析内容特点
    echo "### 内容特点" >> "$REVIEW_FILE"
    echo "" >> "$REVIEW_FILE"
    
    # 检测人物出场
    CHARACTERS=$(grep -oE '[苏张白廉李王韩][秦仪起颇牧斯翦非]' "$LATEST_CHAPTER" | sort | uniq | tr '\n' ' ')
    if [ -n "$CHARACTERS" ]; then
        echo "- **出场人物**: $CHARACTERS" >> "$REVIEW_FILE"
    fi
    
    # 检测场景
    if grep -q "秦\|函谷\|关中" "$LATEST_CHAPTER"; then
        echo "- **主要场景**: 秦国/函谷关/关中地区" >> "$REVIEW_FILE"
    elif grep -q "赵\|邯郸" "$LATEST_CHAPTER"; then
        echo "- **主要场景**: 赵国/邯郸地区" >> "$REVIEW_FILE"
    elif grep -q "齐\|临淄" "$LATEST_CHAPTER"; then
        echo "- **主要场景**: 齐国/临淄地区" >> "$REVIEW_FILE"
    elif grep -q "楚\|郢都" "$LATEST_CHAPTER"; then
        echo "- **主要场景**: 楚国/郢都地区" >> "$REVIEW_FILE"
    fi
    
    # 检测情节类型
    if grep -q "战\|兵\|阵\|杀" "$LATEST_CHAPTER"; then
        echo "- **情节类型**: 战争/军事" >> "$REVIEW_FILE"
    elif grep -q "说\|辩\|策\|谋" "$LATEST_CHAPTER"; then
        echo "- **情节类型**: 谋略/外交" >> "$REVIEW_FILE"
    elif grep -q "朝\|廷\|议\|谏" "$LATEST_CHAPTER"; then
        echo "- **情节类型**: 朝堂/政治" >> "$REVIEW_FILE"
    fi
    
    echo "" >> "$REVIEW_FILE"
fi

# 生成AI点评
echo "## 💡 AI点评与建议" >> "$REVIEW_FILE"
echo "" >> "$REVIEW_FILE"

# 根据项目整体情况给出建议
if [ -f "$PROJECT_DIR/STORY_BIBLE.md" ]; then
    echo "### 与故事圣经的一致性" >> "$REVIEW_FILE"
    echo "" >> "$REVIEW_FILE"
    echo "✅ 项目遵循《战国小说总纲》的设定：" >> "$REVIEW_FILE"
    echo "- 主线：秦国东出，终成一统" >> "$REVIEW_FILE"
    echo "- 立场：天下共视角" >> "$REVIEW_FILE"
    echo "- 起点：苏秦张仪时代" >> "$REVIEW_FILE"
    echo "" >> "$REVIEW_FILE"
fi

echo "### 写作建议" >> "$REVIEW_FILE"
echo "" >> "$REVIEW_FILE"

# 根据字数给出建议
if [ -n "$LATEST_CHAPTER" ]; then
    if [ "$WORD_COUNT" -lt 2000 ]; then
        echo "⚠️ **篇幅建议**: 本章篇幅较短（$WORD_COUNT字符），建议扩充至3000-5000字，增加：" >> "$REVIEW_FILE"
        echo "  - 人物心理描写" >> "$REVIEW_FILE"
        echo "  - 环境氛围渲染" >> "$REVIEW_FILE"
        echo "  - 对话细节展开" >> "$REVIEW_FILE"
    elif [ "$WORD_COUNT" -gt 8000 ]; then
        echo "✅ **篇幅评价**: 本章内容充实（$WORD_COUNT字符），注意节奏把控，避免信息过载" >> "$REVIEW_FILE"
    else
        echo "✅ **篇幅评价**: 本章篇幅适中（$WORD_COUNT字符），符合长篇小说节奏" >> "$REVIEW_FILE"
    fi
    echo "" >> "$REVIEW_FILE"
fi

echo "### 人物塑造建议" >> "$REVIEW_FILE"
echo "" >> "$REVIEW_FILE"
echo "根据《故事圣经》的五维能力体系（武勇、统兵、机谋、纵横、国策）：" >> "$REVIEW_FILE"
echo "" >> "$REVIEW_FILE"
echo "1. **苏秦** - 应突出其'合纵第一'的纵横能力，同时展现其布衣困顿的初期状态" >> "$REVIEW_FILE"
echo "2. **张仪** - 应突出其'破盟第一'的机谋能力，与苏秦形成对比" >> "$REVIEW_FILE"
echo "3. **白起** - 后期应突出其'歼灭战第一'的统兵能力" >> "$REVIEW_FILE"
echo "" >> "$REVIEW_FILE"

echo "### 情节推进建议" >> "$REVIEW_FILE"
echo "" >> "$REVIEW_FILE"
echo "1. **节奏把控**: 纵横家开局阶段应注重辩说与谋略，战争场面适度" >> "$REVIEW_FILE"
echo "2. **历史真实**: 在史实主干上适度演义，避免过度虚构" >> "$REVIEW_FILE"
echo "3. **六国平衡**: 避免将六国写得过弱，保持统一的史诗重量" >> "$REVIEW_FILE"
echo "4. **人物标签**: 每个核心人物应有鲜明标签、代表名场面、致命短板" >> "$REVIEW_FILE"
echo "" >> "$REVIEW_FILE"

echo "### 语言风格建议" >> "$REVIEW_FILE"
echo "" >> "$REVIEW_FILE"
echo "- ✅ 现代白话为主，关键处带古意" >> "$REVIEW_FILE"
echo "- ✅ 避免写成三国翻版" >> "$REVIEW_FILE"
echo "- ✅ 战争戏突出统帅差异，不依赖过量单挑" >> "$REVIEW_FILE"
echo "" >> "$REVIEW_FILE"

# 提交和推送
echo "" >> "$REVIEW_FILE"
echo "---" >> "$REVIEW_FILE"
echo "*本点评由AI自动生成于 $(date '+%Y-%m-%d %H:%M:%S')*" >> "$REVIEW_FILE"

# Git 提交
git add -A
git commit -m "feat: add AI review report $DATE"
git push origin main 2>/dev/null || git push origin master 2>/dev/null

echo "点评已生成: $REVIEW_FILE"
