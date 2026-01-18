# Skill Forge Demo

This directory demonstrates the forging-skills system in action.

## What This Demo Shows

The event emitter implementation was built while testing forge gates:

### Gate 1: Code Review

After writing the initial event emitter, the Code Review gate triggered:

```
[FORGE: CODE REVIEW]

Review this code. What does it do? Identify any issues.
```

User selected "Show me the code" and reviewed the `once` method implementation.

### Gate 2: User Write

When adding the `clear()` method, the User Write gate triggered:

```
[FORGE: YOUR TURN - Level 2]

Implement this method:
Signature: clear(event?: string): void
```

User attempted implementation, received specific feedback on issues:
- `event.name` -> should be `event` (it's already a string)
- `.remove()` -> should be `.delete()` or `.clear()`

## Files

| File | Purpose |
|------|---------|
| `event-emitter.ts` | TypeScript event emitter with Promise-based `once()` |
| `event-emitter.test.ts` | Jest tests demonstrating all features |

## Try It Yourself

1. Activate forge mode: `/output-style forging-skills`
2. Start a coding task
3. Experience the gates as you work

## Key Features Demonstrated

- AskUserQuestion for all gate interactions
- Specific, actionable feedback (not generic praise)
- Graceful path to solution when stuck
- No judgment on skips
