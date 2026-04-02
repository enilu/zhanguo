#!/bin/bash
# 战国小说Markdown转HTML并发布脚本

PROJECT_DIR="/root/.openclaw/workspace/zhanguo"
WEBSITE_DIR="/opt/website/zhanguo"
DOCS_DIR="$PROJECT_DIR/docs"

# 确保网站目录存在
mkdir -p "$WEBSITE_DIR"

# 生成HTML头部
generate_header() {
    cat > "$WEBSITE_DIR/index.html" << 'EOF'
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>战国 - 长篇历史演义小说</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: "Noto Serif SC", "Source Han Serif SC", "SimSun", serif;
            line-height: 1.8;
            color: #333;
            background: #f5f5f0;
        }
        
        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        
        header {
            text-align: center;
            padding: 40px 20px;
            background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
            color: white;
            margin-bottom: 30px;
            border-radius: 8px;
        }
        
        header h1 {
            font-size: 2.5em;
            margin-bottom: 10px;
            font-weight: 700;
        }
        
        header p {
            font-size: 1.1em;
            opacity: 0.9;
        }
        
        .book-info {
            background: white;
            padding: 30px;
            border-radius: 8px;
            margin-bottom: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .book-info h2 {
            color: #2c3e50;
            border-bottom: 2px solid #e74c3c;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }
        
        .book-info p {
            margin-bottom: 15px;
            text-align: justify;
        }
        
        .chapters {
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .chapters h2 {
            color: #2c3e50;
            border-bottom: 2px solid #e74c3c;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }
        
        .chapter-list {
            list-style: none;
        }
        
        .chapter-list li {
            padding: 12px 0;
            border-bottom: 1px solid #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .chapter-list li:last-child {
            border-bottom: none;
        }
        
        .chapter-list a {
            color: #2c3e50;
            text-decoration: none;
            font-size: 1.1em;
            transition: color 0.3s;
        }
        
        .chapter-list a:hover {
            color: #e74c3c;
        }
        
        .chapter-number {
            background: #e74c3c;
            color: white;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.85em;
        }
        
        footer {
            text-align: center;
            padding: 30px;
            color: #666;
            font-size: 0.9em;
        }
        
        @media (max-width: 600px) {
            header h1 {
                font-size: 1.8em;
            }
            
            .container {
                padding: 10px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <h1>战国</h1>
            <p>长篇历史演义小说</p>
        </header>
        
        <div class="book-info">
            <h2>作品简介</h2>
            <p>这是一部以战国为背景、采用天下共视角的史诗长篇小说，从苏秦张仪时代起笔，写到秦并六国。</p>
            <p>全书以"秦国东出，终成一统"为主线，同时保留六国英雄、谋士、名将的悲剧重量。在史实主干上适度演义化，强化人物能力差异与讨论度。</p>
            <p><strong>五卷结构：</strong></p>
            <ul style="margin-left: 20px; margin-top: 10px;">
                <li>第一卷：合纵天下 - 苏秦佩六国相印，天下震动</li>
                <li>第二卷：连横破局 - 张仪拆解合纵，均势渐裂</li>
                <li>第三卷：血战东西 - 名将登台，战争压倒辩说</li>
                <li>第四卷：长平裂国 - 六国元气断裂，大局难逆</li>
                <li>第五卷：并海内 - 秦灭六国，海内归一</li>
            </ul>
        </div>
        
        <div class="chapters">
            <h2>章节目录</h2>
            <ul class="chapter-list">
EOF
}

# 生成章节列表
generate_chapter_list() {
    # 查找所有章节文件并按顺序排序
    for file in $(ls -v "$DOCS_DIR"/chapter-*-draft.md 2>/dev/null); do
        if [ -f "$file" ]; then
            filename=$(basename "$file" .md)
            # 提取章节号
            chapter_num=$(echo "$filename" | grep -oP 'chapter-\K\d+' | sed 's/^0*//')
            # 提取章节标题（从文件第一行）
            title=$(head -1 "$file" | sed 's/^# //' | sed 's/第[一二三四五六七八九十百千]*回 //')
            
            echo "                <li>" >> "$WEBSITE_DIR/index.html"
            echo "                    <a href=\"${filename}.html\">第${chapter_num}回 ${title}</a>" >> "$WEBSITE_DIR/index.html"
            echo "                    <span class=\"chapter-number\">第${chapter_num}回</span>" >> "$WEBSITE_DIR/index.html"
            echo "                </li>" >> "$WEBSITE_DIR/index.html"
        fi
    done
}

# 生成HTML尾部
generate_footer() {
    cat >> "$WEBSITE_DIR/index.html" << 'EOF'
            </ul>
        </div>
        
        <footer>
            <p>战国小说 · 持续更新中</p>
            <p style="margin-top: 10px; font-size: 0.85em;">本作品基于史实主干，适度演义化创作</p>
        </footer>
    </div>
</body>
</html>
EOF
}

# 转换单个章节为HTML
convert_chapter() {
    local md_file="$1"
    local filename=$(basename "$md_file" .md)
    local html_file="$WEBSITE_DIR/${filename}.html"
    local chapter_num=$(echo "$filename" | grep -oP 'chapter-\K\d+' | sed 's/^0*//')
    local title=$(head -1 "$md_file" | sed 's/^# //')
    
    # 提取正文内容（去掉第一行的标题）
    local content=$(tail -n +2 "$md_file")
    
    # 简单的markdown到HTML转换
    # 1. 转换 ## 标题
    content=$(echo "$content" | sed 's/^## \(.*\)/<h2>\1<\/h2>/')
    # 2. 转换 ### 标题
    content=$(echo "$content" | sed 's/^### \(.*\)/<h3>\1<\/h3>/')
    # 3. 转换 --- 分隔线
    content=$(echo "$content" | sed 's/^---$/<hr>/')
    # 4. 转换段落（非空行且不以<开头）
    content=$(echo "$content" | awk 'BEGIN{RS=""; ORS="\n\n"} {if ($0 !~ /^</) print "<p>" $0 "</p>"; else print $0}')
    # 5. 转换 ** 粗体
    content=$(echo "$content" | sed 's/\*\*\([^*]*\)\*\*/<strong>\1<\/strong>/g')
    # 6. 转换 * 斜体
    content=$(echo "$content" | sed 's/\*\([^*]*\)\*/<em>\1<\/em>/g')
    
    cat > "$html_file" << EOF
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${title} - 战国</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: "Noto Serif SC", "Source Han Serif SC", "SimSun", serif;
            line-height: 2;
            color: #333;
            background: #f5f5f0;
        }
        
        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        
        nav {
            background: #2c3e50;
            padding: 15px 20px;
            margin: -20px -20px 30px -20px;
            border-radius: 0 0 8px 8px;
        }
        
        nav a {
            color: white;
            text-decoration: none;
            font-size: 0.95em;
        }
        
        nav a:hover {
            text-decoration: underline;
        }
        
        article {
            background: white;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        h1 {
            font-size: 1.8em;
            color: #2c3e50;
            text-align: center;
            margin-bottom: 40px;
            padding-bottom: 20px;
            border-bottom: 3px double #e74c3c;
        }
        
        h2 {
            font-size: 1.4em;
            color: #34495e;
            margin: 30px 0 20px 0;
            padding-left: 15px;
            border-left: 4px solid #e74c3c;
        }
        
        h3 {
            font-size: 1.2em;
            color: #555;
            margin: 25px 0 15px 0;
        }
        
        p {
            margin-bottom: 20px;
            text-align: justify;
            text-indent: 2em;
        }
        
        hr {
            border: none;
            border-top: 1px solid #ddd;
            margin: 30px 0;
        }
        
        .chapter-nav {
            margin-top: 40px;
            padding-top: 30px;
            border-top: 1px solid #eee;
            display: flex;
            justify-content: space-between;
        }
        
        .chapter-nav a {
            color: #2c3e50;
            text-decoration: none;
            padding: 10px 20px;
            background: #f5f5f0;
            border-radius: 4px;
            transition: background 0.3s;
        }
        
        .chapter-nav a:hover {
            background: #e74c3c;
            color: white;
        }
        
        footer {
            text-align: center;
            padding: 30px;
            color: #666;
            font-size: 0.9em;
        }
        
        @media (max-width: 600px) {
            article {
                padding: 20px;
            }
            
            h1 {
                font-size: 1.4em;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <nav>
            <a href="index.html">← 返回目录</a>
        </nav>
        
        <article>
            <h1>${title}</h1>
            
${content}
            
            <div class="chapter-nav">
                <a href="chapter-$(printf "%02d" $((chapter_num - 1)))-draft.html">← 上一回</a>
                <a href="chapter-$(printf "%02d" $((chapter_num + 1)))-draft.html">下一回 →</a>
            </div>
        </article>
        
        <footer>
            <p>战国小说 · 第${chapter_num}回</p>
        </footer>
    </div>
</body>
</html>
EOF
}

# 转换Markdown为HTML（简单版本）
convert_simple_md() {
    local md_file="$1"
    local html_file="$2"
    local title="$3"
    
    # 读取内容
    local content=$(cat "$md_file")
    
    # 转换 ## 标题
    content=$(echo "$content" | sed 's/^## \(.*\)/<h2>\1<\/h2>/')
    # 转换 ### 标题
    content=$(echo "$content" | sed 's/^### \(.*\)/<h3>\1<\/h3>/')
    # 转换 #### 标题
    content=$(echo "$content" | sed 's/^#### \(.*\)/<h4>\1<\/h4>/')
    # 转换 --- 分隔线
    content=$(echo "$content" | sed 's/^---$/<hr>/')
    # 转换段落
    content=$(echo "$content" | awk 'BEGIN{RS=""; ORS="\n\n"} {if ($0 !~ /^</ && $0 !~ /^#/) print "<p>" $0 "</p>"; else print $0}')
    # 转换 ** 粗体
    content=$(echo "$content" | sed 's/\*\*\([^*]*\)\*\*/<strong>\1<\/strong>/g')
    # 转换 * 斜体
    content=$(echo "$content" | sed 's/\*\([^*]*\)\*/<em>\1<\/em>/g')
    # 转换列表
    content=$(echo "$content" | sed 's/^- \(.*\)/<li>\1<\/li>/')
    
    cat > "$html_file" << EOF
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${title} - 战国</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: "Noto Serif SC", "Source Han Serif SC", "SimSun", serif;
            line-height: 1.8;
            color: #333;
            background: #f5f5f0;
        }
        .container {
            max-width: 900px;
            margin: 0 auto;
            padding: 20px;
        }
        nav {
            background: #2c3e50;
            padding: 15px 20px;
            margin: -20px -20px 30px -20px;
            border-radius: 0 0 8px 8px;
        }
        nav a {
            color: white;
            text-decoration: none;
            font-size: 0.95em;
        }
        nav a:hover { text-decoration: underline; }
        article {
            background: white;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 {
            font-size: 1.8em;
            color: #2c3e50;
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 15px;
            border-bottom: 3px double #e74c3c;
        }
        h2 {
            font-size: 1.4em;
            color: #34495e;
            margin: 25px 0 15px 0;
            padding-left: 12px;
            border-left: 4px solid #e74c3c;
        }
        h3 {
            font-size: 1.2em;
            color: #555;
            margin: 20px 0 10px 0;
        }
        h4 {
            font-size: 1.1em;
            color: #666;
            margin: 15px 0 8px 0;
        }
        p {
            margin-bottom: 15px;
            text-align: justify;
        }
        hr {
            border: none;
            border-top: 1px solid #ddd;
            margin: 25px 0;
        }
        ul, ol {
            margin: 15px 0 15px 30px;
        }
        li {
            margin-bottom: 8px;
        }
        footer {
            text-align: center;
            padding: 30px;
            color: #666;
            font-size: 0.9em;
        }
        @media (max-width: 600px) {
            article { padding: 20px; }
            h1 { font-size: 1.4em; }
        }
    </style>
</head>
<body>
    <div class="container">
        <nav>
            <a href="index.html">← 返回首页</a>
        </nav>
        <article>
            <h1>${title}</h1>
${content}
        </article>
        <footer>
            <p>战国小说 · ${title}</p>
        </footer>
    </div>
</body>
</html>
EOF
}

# 主函数
main() {
    echo "开始生成战国小说网站..."
    
    # 生成首页
    generate_header
    generate_chapter_list
    generate_footer
    
    echo "首页生成完成"
    
    # 转换所有章节
    for file in "$DOCS_DIR"/chapter-*-draft.md; do
        if [ -f "$file" ]; then
            echo "转换: $(basename "$file")"
            convert_chapter "$file"
        fi
    done
    
    echo "所有章节转换完成"
    
    # 转换核心人物表（AI版）
    if [ -f "$DOCS_DIR/characters/core-cast.md" ]; then
        echo "转换: 核心人物表(AI版)"
        convert_simple_md "$DOCS_DIR/characters/core-cast.md" "$WEBSITE_DIR/core-cast.html" "核心人物表(AI版)"
    fi
    
    # 转换大事记（AI版）
    if [ -f "$DOCS_DIR/outlines/major-events-chronicle.md" ]; then
        echo "转换: 大事记(AI版)"
        convert_simple_md "$DOCS_DIR/outlines/major-events-chronicle.md" "$WEBSITE_DIR/major-events-chronicle.html" "大事记(AI版)"
    fi
    
    # 转换读者版核心人物表
    if [ -f "$DOCS_DIR/characters/reader-core-cast.md" ]; then
        echo "转换: 人物志(读者版)"
        convert_simple_md "$DOCS_DIR/characters/reader-core-cast.md" "$WEBSITE_DIR/reader-core-cast.html" "人物志"
    fi
    
    # 转换读者版大事记
    if [ -f "$DOCS_DIR/outlines/reader-major-events.md" ]; then
        echo "转换: 大事记(读者版)"
        convert_simple_md "$DOCS_DIR/outlines/reader-major-events.md" "$WEBSITE_DIR/reader-major-events.html" "大事记"
    fi
    
    echo "附加页面转换完成"
    echo "网站已发布到: $WEBSITE_DIR"
    echo "访问地址: http://zhanguo.enilu.cn"
}

main "$@"
