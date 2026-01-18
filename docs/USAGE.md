# Skill Forge Usage Guide

Complete guide to using Skill Forge effectively.

## Getting Started

### Activation

After installation, start Claude Code and activate forge mode:

```
/output-style forging-skills
```

The output style remains active for your session. You can deactivate by:
- Starting a new session
- Running `/output-style default`

### Verification

Forge mode is active when you see gates appearing during your coding session. There's no status indicator - just continue working and the gates will trigger at configured intervals.

## The Three Gates

### Gate 1: Code Review

**When**: Every 15-25 operations (randomised)

**Purpose**: Ensure you understand code Claude wrote for you.

**Interaction**:

```
[FORGE: CODE REVIEW]

I just wrote some code. Let's make sure you understand it.

Question: "Review this code. What does it do? Identify any issues."
Header: "Review"
Options:
- "Show me the code" -> Display code for review
- "I reviewed it" -> Trust your claim
- "Skip this one" -> Continue without review
```

**If you select "Show me the code"**:
1. Claude displays the most recent significant code change
2. You explain what it does and identify any issues
3. Claude acknowledges your understanding (not grades it)

**Tips**:
- Actually engage with the code - this is your mental model
- Look for edge cases Claude might have missed
- Suggest improvements if you see them

### Gate 2: User Write

**When**: Every 25-40 operations, or 10% random chance after significant writes

**Purpose**: Write real code that gets integrated into your project.

**Interaction**:

```
[FORGE: YOUR TURN]

Time to write some code. I'll describe WHAT, you write HOW.

Question: "Ready to implement a function?"
Header: "Your Turn"
Options:
- "Ready" -> Show task, you implement
- "Too busy now" -> Skip gracefully
- "Hint first" -> Get pseudocode hint before starting
```

**If you select "Ready"**:
1. Claude presents a task extracted from the current work
2. You write your implementation and send it
3. Claude evaluates with specific feedback:
   - **Correct**: Integrates your code
   - **Close**: Offers hint, lets you retry
   - **Wrong**: Explains issue, offers solution or retry

**Task Format**:

```
[FORGE: YOUR TURN - Level 2]

Implement this function:

**Signature**: `groupBy<T, K>(items: T[], keyFn: (item: T) => K): Record<K, T[]>`

**Description**: Groups array items by the result of keyFn.

**Examples**:
- `groupBy([{type: 'a'}, {type: 'b'}], x => x.type)` -> `{a: [...], b: [...]}`

Write your implementation and send it when ready.
```

**Tips**:
- Take your time - this is practice, not a test
- Request hints if stuck - that's what they're for
- The code you write gets used - it's real work

### Gate 3: Architecture Decision

**When**: Before any multi-file refactor or new component creation

**Purpose**: Think through structure before Claude implements.

**Interaction**:

```
[FORGE: ARCHITECT]

I'm about to make changes across multiple files.

Files affected:
- src/auth/provider.tsx
- src/auth/hooks.ts
- src/api/client.ts

Question: "Before I implement: How would YOU structure this?"
Header: "Architect"
Options:
- "Let me think" -> Describe your approach
- "Show me options" -> See 2-3 approaches first
- "Just do it" -> Skip architecture discussion
```

**If you select "Let me think"**:
1. Describe how you'd structure the change
2. Claude compares to planned approach
3. Best of both approaches proceeds

**Tips**:
- Consider: Where should state live? How do components communicate?
- Your architecture might be better than Claude's default
- Even if Claude's is better, you've engaged your design skills

## Complexity Levels

Tasks range from Level 1 (simple) to Level 5 (complex):

| Level | Type | Example |
|-------|------|---------|
| 1 | Pure function | `isPrime(n): boolean` |
| 2 | Side effects | `saveToCache(key, value)` |
| 3 | Stateful module | `createRateLimiter(limit, window)` |
| 4 | Lifecycle | React hook with cleanup |
| 5 | System design | Event bus with subscriptions |

**Adaptive difficulty**: Start at L2-3. If you nail several in a row, complexity increases. If you struggle, it decreases. No judgment - just calibration.

## Skipping Gates

You can always skip. Reasons to skip:
- Genuine time pressure
- Already reviewed that code yourself
- Just not in the mood

Skill Forge tracks skips silently. High skip rates don't trigger warnings or guilt trips. This is practice, not obligation.

**Anti-pattern**: Skipping every gate defeats the purpose. If you find yourself always skipping, consider whether forge mode is right for your current work.

## Best Practices

### Engage Authentically

The gates are opportunities, not obstacles. Rushing through them to "check a box" wastes your time without building skill.

### Code Reviews: Look for Issues

Don't just skim. Look for:
- Edge cases (null, empty, boundary values)
- Security issues (injection, XSS, etc.)
- Performance concerns
- Readability improvements

### User Writes: Write First, Then Verify

Don't look up the answer first. Write your implementation, submit it, then learn from the feedback.

### Architecture: Draw It Out

Before describing your approach, sketch the components and their relationships. Even mentally. This engages different thinking than just typing.

## Troubleshooting

### Gates Not Appearing

- Confirm output style is active: `/output-style forging-skills`
- Gates trigger after operations (tool calls), not messages
- 15-25 operations for first review gate

### Task Too Hard/Easy

Complexity adapts over time. If it feels consistently wrong:
- Edit `config.json` to change default complexity
- Mention in chat: "Level 2 tasks please"

### Want Different Frequency

Edit `~/.claude/skill-forge/config.json`:

```json
{
  "gates": {
    "review": { "min_operations": 20, "max_operations": 30 },
    "write": { "min_operations": 30, "max_operations": 50 }
  }
}
```

## Session Flow Example

```
Operation 1-14:  Normal coding work
Operation 15:    [FORGE: CODE REVIEW] triggered
Operation 16-35: Normal coding work
Operation 36:    [FORGE: YOUR TURN] triggered
Operation 37-50: Normal coding work
Before refactor: [FORGE: ARCHITECT] triggered
```

Actual triggers are randomised within ranges to prevent predictability.

## Advanced Usage

### Forcing Gates

For testing or practice, you can mention:
- "Trigger a code review now"
- "I want a write task"
- "Let's do an architecture discussion"

Claude will accommodate outside normal trigger conditions.

### Deactivating Temporarily

If you need uninterrupted flow:
- `/output-style default` to deactivate
- `/output-style forging-skills` to reactivate

### Combining with Other Output Styles

Skill Forge is designed to be the primary output style. Combining with others may cause conflicts.
