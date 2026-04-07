# url-to-md Skill

Convert web pages to clean markdown with advanced table support and media preservation. Perfect for AI agents ingesting web content without HTML/div soup token overhead.

## When to Use This Skill

Use `mdurl` when you need to:
- Convert web pages to markdown for analysis or migration
- Ingest documentation from websites that don't offer markdown/LLMs.md
- Extract content from HTML-heavy pages while preserving structure
- Migrate WordPress or legacy sites to modern frameworks (Next.js, Astro, etc.)
- Save tokens by converting HTML to clean markdown before processing
- Scrape content with specific CSS selectors

**Examples of when to invoke:**
- User asks to "convert this URL to markdown"
- User asks to "migrate website content" or "scrape this page"
- User wants to "extract the main content from a URL"
- User needs to "get documentation from a website"
- Working with large content pages (10k+ words) that would be expensive in HTML

## Installation

If not already installed:

```bash
cd /path/to/url-to-md
bun install
bun run build
```

This installs the `mdurl` executable to `~/.local/bin/mdurl`.

Ensure `~/.local/bin` is in PATH:
```bash
export PATH="$HOME/.local/bin:$PATH"
```

## Usage

### Basic Syntax

```bash
mdurl <url> [selector] [output]
```

Or with flags:

```bash
mdurl -u <url> -s <selector> -o <output>
```

### Parameters

- `url` (required): The URL to convert
- `selector` (optional): CSS selector for content extraction (default: `[role='main']`)
- `output` (optional): Output file path (default: `README.md`)

### Examples

**Convert entire page:**
```bash
mdurl https://example.com
```

**Extract specific content with CSS selector:**
```bash
mdurl https://docs.example.com "article.documentation" docs.md
```

**Using flags:**
```bash
mdurl -u "https://blog.example.com/post" -s ".post-content" -o "./content/post.md"
```

**Nested directory output (auto-creates directories):**
```bash
mdurl -u "https://example.com" -s "main" -o "./output/nested/path/file.md"
```

## Features

### Automatic Directory Creation
If output path contains directories, they're created automatically:
```bash
mdurl -u "https://example.com" -o "./deeply/nested/path/output.md"
# Creates: ./deeply/nested/path/ if it doesn't exist
```

### Advanced Table Support
HTML tables are converted to proper markdown tables with headers and alignment preserved.

### Media Preservation
- **Images**: Converted with alt text, src, and optional titles
- **Videos**: Converted with links and thumbnails
- **SVGs**: Preserved in code blocks
- **iFrames**: Converted to embedded content links

### CSS Selector Support
Extract specific page sections using any valid CSS selector:
- `[role='main']` - ARIA main content
- `.article-content` - Class selector
- `#main-content` - ID selector
- `article.post` - Element + class
- `div.container > section` - Complex selectors

## Common Use Cases

### Website Migration
```bash
# Migrate a WordPress post
mdurl -u "https://oldsite.com/blog/post" -s ".post-content" -o "./content/posts/post.md"
```

### Documentation Ingestion
```bash
# Extract documentation
mdurl -u "https://docs.example.com/api" -s "article" -o "./docs/api.md"
```

### Content Scraping
```bash
# Scrape multiple pages
mdurl -u "https://site.com/page1" -s ".content" -o "./pages/page1.md"
mdurl -u "https://site.com/page2" -s ".content" -o "./pages/page2.md"
```

### Token Optimization
```bash
# Before analyzing large HTML pages, convert to markdown first
mdurl -u "https://example.com/massive-page" -s "main" -o "temp.md"
# Then read temp.md instead of fetching HTML (saves ~40-60% tokens)
```

## Integration Patterns

### For AI Agents

When a user asks to analyze web content:

1. **Use mdurl first** to convert to markdown
2. **Then read** the markdown file
3. **Process** with much lower token cost

```bash
# Instead of WebFetch (HTML with all markup):
mdurl -u "https://example.com" -s "article" -o "temp.md"
# Then use Read tool on temp.md
```

### Batch Processing

```bash
# Process multiple URLs
for url in "${urls[@]}"; do
  filename=$(echo "$url" | sed 's/[^a-zA-Z0-9]/-/g')
  mdurl -u "$url" -s ".content" -o "./output/${filename}.md"
done
```

### With Other Tools

```bash
# Convert, then process with other CLI tools
mdurl -u "https://example.com" -o "temp.md"
cat temp.md | wc -w  # Count words
grep "keyword" temp.md  # Search content
```

## Troubleshooting

### Selector Returns Nothing
If the CSS selector matches no elements, mdurl falls back to entire `<body>` content with a warning.

### Large Files
For very large pages (100k+ words), the output file may be large. Consider:
- Using more specific CSS selectors
- Processing in chunks
- Splitting by sections

### Permission Issues
If "permission denied" when running `mdurl`:
```bash
chmod +x ~/.local/bin/mdurl
```

## Token Savings

Converting HTML to markdown before ingestion saves significant tokens:

- **HTML with markup**: ~200 tokens per 100 words
- **Markdown**: ~120 tokens per 100 words
- **Savings**: ~40% token reduction

For a 10,000 word article:
- HTML: ~20,000 tokens
- Markdown: ~12,000 tokens
- **Saved**: ~8,000 tokens per page

## Best Practices

1. **Always use specific selectors** when possible to reduce noise
2. **Test selectors first** with browser DevTools before running
3. **Create output directories** with meaningful paths for organization
4. **Use for token optimization** when working with large web content
5. **Fallback gracefully** - if selector fails, entire body is used

## Advanced Examples

### Migrate entire blog
```bash
#!/bin/bash
urls=(
  "https://blog.com/post-1"
  "https://blog.com/post-2"
  "https://blog.com/post-3"
)

for url in "${urls[@]}"; do
  slug=$(basename "$url")
  mdurl -u "$url" -s "article.post" -o "./content/blog/${slug}.md"
  echo "✓ Migrated: $slug"
done
```

### Extract with fallback selectors
```bash
# Try specific selector, fallback to broader ones
mdurl -u "$url" -s "article.content" -o "output.md" || \
mdurl -u "$url" -s ".main-content" -o "output.md" || \
mdurl -u "$url" -s "main" -o "output.md"
```

## Output Format

The tool produces clean markdown with:
- Proper heading hierarchy (h1-h6)
- Formatted lists (ordered and unordered)
- Tables with headers and separators
- Images with alt text
- Links preserved
- Code blocks (for SVGs)
- Minimal noise from HTML structure

## Performance

- **Speed**: ~1-3 seconds per page (network dependent)
- **Size**: ~73KB markdown for 10k word article
- **Executable**: 59MB standalone binary (includes Bun runtime)

## See Also

- GitHub: https://github.com/michaelmonetized/url-to-md
- Issues: https://github.com/michaelmonetized/url-to-md/issues
