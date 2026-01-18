# Code Evaluation Criteria

Rubrics for evaluating user-submitted code in forge mode.

## Evaluation Philosophy

**Goal**: Reinforce learning and maintain skills, not grade performance.

| Principle | Application |
|-----------|-------------|
| Specific | "The null check on line 3 prevents..." not "Good job" |
| Constructive | Point to solution, not just problem |
| Respectful | Senior engineers know what they're doing |
| Practical | Focus on production-ready patterns |

## Evaluation Weights

| Criterion | Weight | Description |
|-----------|--------|-------------|
| Correctness | 40% | Does it work for the happy path? |
| Edge Cases | 25% | Handles nulls, empties, boundaries? |
| Style | 15% | Idiomatic for the language? |
| Efficiency | 10% | Reasonable performance? |
| Readability | 10% | Clear naming, structure? |

## Correctness (40%)

### Pass Criteria

- Produces correct output for documented examples
- Handles the primary use case
- Returns expected types

### Common Issues

| Issue | Feedback Template |
|-------|-------------------|
| Wrong algorithm | "This approach works for X but not Y because..." |
| Off-by-one | "The loop boundary misses the last element..." |
| Type mismatch | "The return type should be X, but this returns Y..." |
| Logic inversion | "The condition is inverted - this returns true when it should return false..." |

## Edge Cases (25%)

### Pass Criteria

- Handles null/undefined inputs
- Handles empty collections
- Handles boundary values (0, -1, MAX_INT)
- Handles unexpected types (if dynamically typed)

### Common Issues

| Issue | Feedback Template |
|-------|-------------------|
| No null check | "Consider what happens when input is null..." |
| Empty array crash | "Empty array causes X - add a guard..." |
| Boundary overflow | "At MAX_INT, this overflows because..." |

### Hint Progression

1. First hint: "What happens with empty input?"
2. Second hint: "Add a guard for the empty case"
3. Solution: "Here's one way: `if (!arr?.length) return defaultValue`"

## Style (15%)

### Pass Criteria

- Follows language conventions
- Consistent naming
- Appropriate use of language features

### Language-Specific Guidance

**TypeScript/JavaScript**
```
- Use const/let appropriately
- Arrow functions for callbacks
- Destructuring where clear
- Optional chaining for null safety
```

**Python**
```
- Snake_case for functions/variables
- List comprehensions where readable
- Type hints for parameters
- Docstrings for public functions
```

**Go**
```
- Short variable names in small scope
- Error handling immediately after call
- Exported names PascalCase
- unexported names camelCase
```

### Feedback Templates

| Issue | Feedback |
|-------|----------|
| Naming | "Consider renaming `x` to `userCount` for clarity" |
| Idiom | "In [language], the idiomatic way is..." |
| Modern syntax | "You could simplify with [feature]..." |

## Efficiency (10%)

### Pass Criteria

- No obvious O(n^2) when O(n) is trivial
- No unnecessary iterations
- Reasonable space usage

### Feedback Templates

| Issue | Feedback |
|-------|----------|
| Unnecessary loop | "This nested loop makes it O(n^2). Consider using a Set for O(n)..." |
| Multiple iterations | "You iterate twice - could combine into one pass..." |
| Memory waste | "This creates intermediate arrays. Consider in-place..." |

**Note**: Don't over-optimize for forge exercises. Correctness > micro-optimizations.

## Readability (10%)

### Pass Criteria

- Self-documenting code
- Logical structure
- Appropriate comments (not excessive)

### Feedback Templates

| Issue | Feedback |
|-------|----------|
| Magic numbers | "What does 86400 mean? Consider `SECONDS_PER_DAY`..." |
| Long function | "This does three things. Consider extracting..." |
| Unclear flow | "The early return pattern would clarify this..." |

## Response Templates

### Correct Implementation

```
Your implementation is correct.

Strengths:
- [Specific thing done well with why it matters]
- [Another specific strength]

Integrating your code now.
```

### Close But Issues

```
Almost there. [Specific issue]:

[Code snippet showing the problem]

This causes [consequence] when [condition].

Options:
1. Try fixing it (hint: [subtle hint])
2. See the solution

What would you prefer?
```

### Fundamentally Wrong

```
This approach won't work because [clear explanation].

The issue: [specific technical reason]

Here's a hint to get started:
[Pseudocode or conceptual hint]

Would you like to try again or see a working solution?
```

### Skipped (No Judgment)

```
Skipping this one. Continuing with implementation.
```

## Adaptive Difficulty

### Accuracy Tracking

```
accuracy = writes_correct / writes_attempted
```

### Adjustment Rules

| Accuracy | Action |
|----------|--------|
| > 80% for 3+ attempts | Increase complexity by 1 level |
| < 50% for 3+ attempts | Decrease complexity by 1 level |
| 50-80% | Maintain current level |

### Complexity Bounds

- Minimum: Level 1
- Maximum: Level 5
- Default start: Level 2

## Anti-Patterns in Evaluation

| Don't | Do |
|-------|-----|
| "Great job!" | "Your null handling prevents crashes in production" |
| "This is wrong" | "This returns X when it should return Y" |
| "You should know this" | "Here's how this pattern works..." |
| Grade (A/B/C) | Specific, actionable feedback |
| Compare to "right" answer | Evaluate against requirements |
