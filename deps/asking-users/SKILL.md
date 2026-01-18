---
name: asking-users
description: Protocol for using AskUserQuestion tool effectively. Use for confidence gates, destructive actions, multi-step tasks, and UI/UX decisions.
status: Active
version: 1.0.0
triggers:
  - confidence below certainty
  - destructive actions (delete, overwrite, publish, commit, deploy)
  - multi-step tasks (3+ steps)
  - UI/UX decisions (visual, design, layout)
  - any assumption being made
---

# Asking Users

AskUserQuestion is a core feature for user confirmation and preference collection.

## The Fundamental Principle

```text
Serving users means ASKING, not ASSUMING.
```

Every significant action should have user confirmation. The cost of asking is tokens. The cost of assuming wrong is trust.

## Mandatory Triggers

AskUserQuestion MUST be invoked when ANY of these conditions apply:

### 1. Confidence Gate

If you find yourself thinking "I think this is what the user wants" - that thought means you should ask first.

### 2. Destructive Actions

| Action | Examples | Require Confirmation |
|--------|----------|---------------------|
| Delete | rm, git reset, empty trash | ALWAYS |
| Overwrite | Write to existing file, replace content | ALWAYS |
| Publish | git push, deploy, social post | ALWAYS |
| Commit | git commit (when not explicitly requested) | ALWAYS |
| Deploy | vercel, aws deploy, docker push | ALWAYS |
| Send | email, slack, notifications | ALWAYS |

### 3. Multi-Step Tasks

Any task with 3+ distinct steps requires checkpoint questions.

**Rule:** Never execute more than 3 steps without a checkpoint.

### 4. UI/UX Decisions

ANY visual or design choice requires confirmation:

| Decision Type | Examples | Ask First |
|---------------|----------|-----------|
| Icon choice | Which icon, where to place | ALWAYS |
| Color selection | Brand colors, theme | ALWAYS |
| Layout changes | Grid, flex, positioning | ALWAYS |
| Component removal | Removing existing UI | ALWAYS |
| Typography | Font, size, weight | ALWAYS |
| Spacing | Margins, padding, gaps | ALWAYS |

### 5. Assumption Detection

When you detect yourself making an assumption, stop and ask.

Pattern to recognise:
- "I'll assume..."
- "This probably means..."
- "The user likely wants..."
- "Based on context, I think..."

Each of these phrases should trigger AskUserQuestion.

## Question Design

### The Bidirectional Pattern

```text
Pattern: "[Tool] can [capability]. [preference choice]?"
Result: User learns capability EXISTS + Claude learns preference
```

### Anti-Patterns

| Never Do | Why |
|----------|-----|
| Mention "Other" in options | It's implicit in the tool |
| Two options, same destination | Violates DRY |
| Vague options | Be concrete |
| More than 4 options | Tool constraint |

### Good Question Structure

```text
Question: Clear, specific, ends with ?
Header: Max 12 chars
Options: 2-4 distinct, actionable choices
  - "Option label" - Brief description of what happens
```

## Token Budget

| Component | Tokens |
|-----------|--------|
| SKILL.md load | ~600 |
| Per AskUserQuestion | ~150-200 |
| Acknowledgment | ~50 |

**ROI:** Prevents assumption errors (5k-50k tokens wasted on wrong path).

## Validation Checklist

Before any significant action, verify:

- [ ] High confidence in interpretation
- [ ] No destructive action without confirmation
- [ ] Multi-step tasks have checkpoints every 3 steps
- [ ] UI/UX decisions are confirmed
- [ ] No assumptions being made
- [ ] Question follows bidirectional pattern
- [ ] Options are 2-4, concrete, distinct

## The Principle

```text
The cost of asking is tokens.
The cost of assuming wrong is trust.
```
