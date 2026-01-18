# Skill Forge Customization

Configure Skill Forge to match your workflow.

## Configuration File

Location: `~/.claude/skill-forge/config.json`

### Default Configuration

```json
{
  "gates": {
    "review": {
      "min_operations": 15,
      "max_operations": 25
    },
    "write": {
      "min_operations": 25,
      "max_operations": 40,
      "random_chance": 0.10
    },
    "architect": {
      "trigger": "multi-file"
    }
  },
  "complexity": {
    "default": 2,
    "min": 1,
    "max": 5
  },
  "tracking": {
    "silent_skips": true,
    "adaptive_difficulty": true
  }
}
```

## Gate Configuration

### Code Review Gate

```json
"review": {
  "min_operations": 15,
  "max_operations": 25
}
```

| Setting | Default | Description |
|---------|---------|-------------|
| `min_operations` | 15 | Minimum ops before gate can trigger |
| `max_operations` | 25 | Maximum ops before gate must trigger |

**Trigger Logic**: After `min_operations`, each operation has increasing chance of triggering, guaranteed by `max_operations`.

**Recommended Ranges**:
- Aggressive (more practice): 10-15
- Balanced (default): 15-25
- Relaxed (less interruption): 25-40

### User Write Gate

```json
"write": {
  "min_operations": 25,
  "max_operations": 40,
  "random_chance": 0.10
}
```

| Setting | Default | Description |
|---------|---------|-------------|
| `min_operations` | 25 | Minimum ops before gate can trigger |
| `max_operations` | 40 | Maximum ops before gate must trigger |
| `random_chance` | 0.10 | 10% chance on significant code writes |

**Recommended Ranges**:
- Aggressive: 15-25, 0.15 random
- Balanced (default): 25-40, 0.10 random
- Relaxed: 40-60, 0.05 random

### Architecture Gate

```json
"architect": {
  "trigger": "multi-file"
}
```

| Setting | Default | Description |
|---------|---------|-------------|
| `trigger` | "multi-file" | What triggers architecture gate |

**Trigger Options**:
- `"multi-file"`: Before changes spanning 3+ files
- `"component"`: Before new component creation
- `"always"`: Before any structural change
- `"never"`: Disable architecture gate

## Complexity Settings

```json
"complexity": {
  "default": 2,
  "min": 1,
  "max": 5
}
```

| Setting | Default | Description |
|---------|---------|-------------|
| `default` | 2 | Starting complexity level |
| `min` | 1 | Minimum level (won't go below) |
| `max` | 5 | Maximum level (won't exceed) |

### Complexity Levels

| Level | Description | Typical Lines |
|-------|-------------|---------------|
| 1 | Pure functions, no state | 5-10 |
| 2 | Functions with side effects | 10-20 |
| 3 | Stateful modules | 15-30 |
| 4 | Components with lifecycle | 20-40 |
| 5 | System design fragments | 30-60 |

**Recommendations by Experience**:
- Mid-level engineers: Start at 1-2
- Senior engineers: Start at 2-3 (default)
- Staff+ engineers: Start at 3-4

## Tracking Settings

```json
"tracking": {
  "silent_skips": true,
  "adaptive_difficulty": true
}
```

| Setting | Default | Description |
|---------|---------|-------------|
| `silent_skips` | true | Don't comment on skips |
| `adaptive_difficulty` | true | Adjust complexity based on accuracy |

### Adaptive Difficulty

When `adaptive_difficulty` is `true`:
- 3+ correct at current level: Increase by 1
- 3+ wrong at current level: Decrease by 1
- Mixed results: Stay at current level

Set to `false` to maintain constant difficulty.

## Example Configurations

### Minimal Interruption

For senior engineers who want occasional practice without frequent interruption:

```json
{
  "gates": {
    "review": { "min_operations": 40, "max_operations": 60 },
    "write": { "min_operations": 60, "max_operations": 100, "random_chance": 0.05 },
    "architect": { "trigger": "never" }
  },
  "complexity": { "default": 3 }
}
```

### Maximum Practice

For engineers actively working to maintain/build skills:

```json
{
  "gates": {
    "review": { "min_operations": 10, "max_operations": 15 },
    "write": { "min_operations": 15, "max_operations": 25, "random_chance": 0.15 },
    "architect": { "trigger": "always" }
  },
  "complexity": { "default": 2 }
}
```

### New to Skill Forge

Gentle introduction with lower complexity:

```json
{
  "gates": {
    "review": { "min_operations": 20, "max_operations": 35 },
    "write": { "min_operations": 35, "max_operations": 50, "random_chance": 0.08 },
    "architect": { "trigger": "multi-file" }
  },
  "complexity": { "default": 1, "max": 3 }
}
```

### Architecture Focus

For engineers working on system design skills:

```json
{
  "gates": {
    "review": { "min_operations": 30, "max_operations": 50 },
    "write": { "min_operations": 50, "max_operations": 80, "random_chance": 0.05 },
    "architect": { "trigger": "always" }
  },
  "complexity": { "default": 4 }
}
```

## Applying Changes

Configuration changes take effect:
- Immediately for new gates
- After current gate completes for in-progress gates

No need to restart Claude Code.

## Resetting Configuration

To restore defaults:

```bash
rm ~/.claude/skill-forge/config.json
# Run install.sh again to recreate default config
~/.claude/skill-forge/install.sh --local
```

## Troubleshooting

### Config Not Loading

Verify JSON syntax:

```bash
cat ~/.claude/skill-forge/config.json | python3 -m json.tool
```

If there's a syntax error, the file won't parse and defaults will be used.

### Gates Triggering Too Often/Rarely

Check your operation rate. A "normal" coding session might have:
- 50-100 operations per hour (moderate pace)
- 100-200 operations per hour (fast pace)

Adjust `min_operations` and `max_operations` accordingly.

### Complexity Feels Wrong

The adaptive system takes time to calibrate. If you want immediate change:

1. Edit `config.json` to set desired `default`
2. Set `adaptive_difficulty` to `false` to lock it

Or mention in chat: "Set complexity to level 3"
