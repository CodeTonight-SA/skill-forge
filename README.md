# Skill Forge

**Anti-skill-atrophy system for software engineers using Claude Code.**

The sharpest sword is forged through use, not blind acceptance. At the very least, it requires keen observation and accountability. Better yet, with practise and participation. 

## The Problem

Agentic AI is a double-edged sword. The better Claude gets at writing code, the less you write yourself. Over time, software engineers who rely heavily on AI assistance risk losing the very skills required to build these systems in the first place. Fully accepting all LLM output inevitably leads to skill atrophy, **and**, critically, skill formation itself. For more information, see the recent [paper](https://arxiv.org/abs/2601.20245) about this on Arxiv.org.

**Vibe coding can be a deadly trap.**

Skill Forge addresses this by periodically interrupting your workflow to keep you hands-on with code. Suitable for all levels of experience. The AI will gently assist you in the task(s) proposed during so-called "vibe coding" (a pejorative term, and one that has polarised software engineers and leaders around the world. One should heed caution and always remember that LIFE is a VIBE, not code.

## Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/CodeTonight-SA/skill-forge/main/install.sh | bash
```

## Activate

After installation, start Claude Code and run:

```
/output-style forging-skills
```

## How It Works

Skill Forge implements three "gates" that interrupt your flow at strategic moments:

### Gate 1: Code Review (every 15-25 operations)

```
[FORGE: CODE REVIEW]

Question: "Review this code. What does it do? Identify any issues."
Options:
- "Show me the code"
- "I reviewed it"
- "Skip this one"
```

Forces you to engage with code Claude just wrote, ensuring you understand the changes being made to your codebase.

### Gate 2: User Write (every 25-40 operations)

```
[FORGE: YOUR TURN]

Question: "Time to write code. I'll describe WHAT, you write HOW."
Options:
- "Ready"
- "Too busy now"
- "Hint first"
```

Extracts a discrete, testable piece from the current work and asks YOU to implement it. This is the primary skill forge - you write real code that gets integrated into the project.

### Gate 3: Architecture Decision (before multi-file changes)

```
[FORGE: ARCHITECT]

Question: "Before I implement: How would YOU structure this?"
Options:
- "Let me think"
- "Show me options"
- "Just do it"
```

Before Claude makes significant structural changes, you're asked to think through the architecture yourself.

## Key Features

- **Non-intrusive**: Skip any gate without judgment. Skips are data, not failure.
- **Adaptive complexity**: Tasks adjust to your demonstrated skill level (L1-L5).
- **Specific feedback**: No generic "Great job!" - you get actionable, technical feedback.
- **Real work**: Tasks are extracted from your actual project, not contrived exercises.
- **No tracking**: Privacy-first. State is session-local only.

## Complexity Levels

| Level | Task Type | Example |
|-------|-----------|---------|
| 1 | Single function, pure logic | `isPrime(n: number): boolean` |
| 2 | Function with side effects | `saveToCache(key, value): Promise<void>` |
| 3 | Multi-function with state | `createRateLimiter(limit, window)` |
| 4 | Component with lifecycle | React hook with cleanup |
| 5 | System design fragment | Event bus with subscriptions |

Default: Level 2-3 for senior engineers.

## Configuration

Edit `~/.claude/skill-forge/config.json`:

```json
{
  "gates": {
    "review": { "min_operations": 15, "max_operations": 25 },
    "write": { "min_operations": 25, "max_operations": 40 },
    "architect": { "trigger": "multi-file" }
  },
  "complexity": { "default": 2, "min": 1, "max": 5 }
}
```

See [docs/CUSTOMIZATION.md](docs/CUSTOMIZATION.md) for all options.

## Uninstall

```bash
~/.claude/skill-forge/uninstall.sh
```

Clean removal that preserves your other Claude Code configuration.

## Philosophy

Read [PHILOSOPHY.md](PHILOSOPHY.md) for the full manifesto on why skill maintenance matters in the age of agentic AI.

## Requirements

- Claude Code CLI (`npm install -g @anthropic-ai/claude-code`)
- git (for installation)
- macOS, Linux, or Windows (Git Bash)

## License

MIT - See [LICENSE](LICENSE)

## Contributing

Issues and PRs welcome at [github.com/CodeTonight-SA/skill-forge](https://github.com/CodeTonight-SA/skill-forge)

---

**The sharpest sword is forged through use, not observation.**
