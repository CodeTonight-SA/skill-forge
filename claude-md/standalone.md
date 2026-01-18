# Skill Forge

Prevents skill atrophy by periodically halting for user code writing and review.

## Core Philosophy

The sharpest sword is forged through use, not observation.

## Activation

```
/output-style forging-skills
```

## How It Works

Three gates interrupt your flow at strategic moments:

1. **Code Review** (every 15-25 operations)
   - "What does this code do? Any issues?"

2. **User Write** (every 25-40 operations)
   - "Time to write code. I'll describe WHAT, you write HOW."

3. **Architect** (before multi-file changes)
   - "How would YOU structure this?"

## AskUserQuestion Protocol

All forge interactions use structured questions:
- Header: Max 12 characters
- Options: 2-4 concrete choices
- Skip: Always available (no forced participation)

## Configuration

Edit `~/.claude/skill-forge/config.json` to customize:
- Gate frequencies
- Default complexity level
- Skip tracking preferences

## Documentation

Full guide: `~/.claude/skill-forge/docs/USAGE.md`
