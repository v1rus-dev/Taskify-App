---
name: markdown-reader
description: Read and interpret Markdown files (.md) accurately with structure awareness, including frontmatter, headings, lists, links, tables, code fences, and blockquotes. Use when a task asks to review, summarize, extract, validate, or transform Markdown content without losing meaning or formatting intent.
---

# Markdown Reader

Follow this workflow when handling Markdown files.

## Parse in Order

1. Detect file encoding and preserve raw text boundaries.
2. Identify optional YAML frontmatter at the top delimited by `---`.
3. Parse body structure in document order:
- headings and hierarchy
- paragraphs and line breaks
- ordered and unordered lists
- task lists
- blockquotes
- code fences with language tags
- tables
- links and images
4. Treat fenced code blocks as literal content. Do not reinterpret Markdown syntax inside them.

## Preserve Meaning

- Keep heading hierarchy and section boundaries intact in summaries.
- Keep list nesting and checkbox states exact.
- Keep inline code, links, and emphasis semantics.
- Distinguish prose from examples, commands, and code snippets.
- Flag malformed Markdown instead of guessing silently.

## Output Contract

When asked to summarize or extract, return:
1. Frontmatter fields (if present)
2. Section-by-section summary following heading order
3. Explicit list of unresolved parsing ambiguities or malformed parts

When asked to transform Markdown:
1. Preserve original meaning and structure
2. Preserve code fences and inline code verbatim unless explicitly requested
3. Keep links valid and avoid dropping reference definitions
