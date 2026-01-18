# Sample Forge Interactions

Real examples of forge gates in action.

## Example 1: Code Review Gate

### Context

Claude just wrote a debounce utility function.

### Interaction

```
[FORGE: CODE REVIEW]

I just wrote some code. Let's make sure you understand it.

Question: "Review this code. What does it do? Identify any issues."
Header: "Review"
Options:
- "Show me the code"
- "I reviewed it"
- "Skip this one"
```

**User selects**: "Show me the code"

```
Here's the code I just wrote:

```typescript
function debounce<T extends (...args: any[]) => any>(
  fn: T,
  delay: number
): (...args: Parameters<T>) => void {
  let timeoutId: ReturnType<typeof setTimeout> | null = null;

  return (...args: Parameters<T>) => {
    if (timeoutId) clearTimeout(timeoutId);
    timeoutId = setTimeout(() => fn(...args), delay);
  };
}
```

What does this code do? Any bugs or improvements you'd suggest?
```

**User responds**: "It's a debounce function that delays execution until calls stop for `delay` ms. One issue: the return type loses the original function's return type - it should preserve it or explicitly return void."

```
Correct understanding.

Your observation about the return type is valid - this implementation intentionally returns void because debounced functions don't return values synchronously. The original return type is lost by design.

If you needed the return value, you'd want a different pattern (Promise-based debounce).

Continuing with implementation.
```

---

## Example 2: User Write Gate - Correct Implementation

### Context

Working on a data processing feature. Claude extracts a discrete task.

### Interaction

```
[FORGE: YOUR TURN]

Time to write some code. I'll describe WHAT, you write HOW.

Question: "Ready to implement a function?"
Header: "Your Turn"
Options:
- "Ready"
- "Too busy now"
- "Hint first"
```

**User selects**: "Ready"

```
[FORGE: YOUR TURN - Level 2]

Implement this function:

**Signature**: `groupBy<T, K extends string | number>(items: T[], keyFn: (item: T) => K): Record<K, T[]>`

**Description**: Groups array items by the result of keyFn.

**Examples**:
- `groupBy([{type: 'a'}, {type: 'b'}, {type: 'a'}], x => x.type)` -> `{a: [{type:'a'}, {type:'a'}], b: [{type:'b'}]}`

Write your implementation and send it when ready.
```

**User submits**:

```typescript
function groupBy<T, K extends string | number>(
  items: T[],
  keyFn: (item: T) => K
): Record<K, T[]> {
  return items.reduce((acc, item) => {
    const key = keyFn(item);
    if (!acc[key]) acc[key] = [];
    acc[key].push(item);
    return acc;
  }, {} as Record<K, T[]>);
}
```

```
Your implementation is correct.

Strengths:
- Clean reduce pattern with proper accumulator typing
- Handles the empty array case implicitly (returns {})
- Mutates accumulator efficiently instead of spreading

Integrating your code now.
```

---

## Example 3: User Write Gate - Close But Issues

### Context

Same scenario, different user response.

**User submits**:

```typescript
function groupBy<T, K extends string | number>(
  items: T[],
  keyFn: (item: T) => K
): Record<K, T[]> {
  const result: Record<K, T[]> = {};
  for (const item of items) {
    const key = keyFn(item);
    result[key].push(item);
  }
  return result;
}
```

```
Almost there. There's an issue on line 6:

`result[key].push(item)` - When `key` doesn't exist in `result` yet, `result[key]` is undefined, and calling `.push()` on undefined throws.

This causes a runtime error on the first item of each group.

Options:
1. Try fixing it (hint: initialize the array if it doesn't exist)
2. See the solution

What would you prefer?
```

**User selects**: Option 1 and resubmits:

```typescript
function groupBy<T, K extends string | number>(
  items: T[],
  keyFn: (item: T) => K
): Record<K, T[]> {
  const result: Record<K, T[]> = {};
  for (const item of items) {
    const key = keyFn(item);
    if (!result[key]) result[key] = [];
    result[key].push(item);
  }
  return result;
}
```

```
Your implementation is correct.

Strengths:
- Clear imperative style that's easy to debug
- Explicit initialization guard
- Handles empty input correctly

Integrating your code now.
```

---

## Example 4: Architecture Gate

### Context

About to refactor authentication across 4 files.

### Interaction

```
[FORGE: ARCHITECT]

I'm about to make changes across multiple files for the auth refactor.

Files affected:
- src/auth/provider.tsx
- src/auth/hooks.ts
- src/api/client.ts
- src/components/ProtectedRoute.tsx

Question: "Before I implement: How would YOU structure this?"
Header: "Architect"
Options:
- "Let me think"
- "Show me options"
- "Just do it"
```

**User selects**: "Let me think"

```
Take your time. Describe how you'd structure the authentication refactor across these files.

Consider:
- Where should auth state live?
- How should components access auth?
- How should API client get tokens?
```

**User responds**: "Auth state in a context provider. Custom hook useAuth() for components. API client should have an interceptor that reads from the auth context or a token store. ProtectedRoute wraps children and redirects if not authed."

```
Solid architecture. Your approach aligns with the plan:

Your Design:
- Context provider for state
- useAuth() hook
- API interceptor with token access
- ProtectedRoute as wrapper

My planned addition:
- Token refresh logic in the interceptor (handles expiry)

Proceeding with your structure plus the refresh handling.
```

---

## Example 5: User Write Gate - Hint Requested

### Context

User wants a hint before attempting.

### Interaction

```
[FORGE: YOUR TURN]

Question: "Ready to implement a function?"
Header: "Your Turn"
Options:
- "Ready"
- "Too busy now"
- "Hint first"
```

**User selects**: "Hint first"

```
[FORGE: YOUR TURN - Level 3]

Implement a rate limiter:

**Interface**:
```typescript
interface RateLimiter {
  tryAcquire(): boolean;
  reset(): void;
}

function createRateLimiter(maxTokens: number, refillMs: number): RateLimiter
```

**Hint (pseudocode)**:
```
- Track: tokens remaining, last refill time
- On tryAcquire:
  - Calculate tokens to add based on time elapsed
  - If tokens > 0: decrement and return true
  - Else: return false
- On reset: set tokens to max
```

Ready when you are.
```

---

## Example 6: Skip (No Judgment)

### Context

User is in a time crunch.

### Interaction

```
[FORGE: YOUR TURN]

Question: "Ready to implement a function?"
Header: "Your Turn"
Options:
- "Ready"
- "Too busy now"
- "Hint first"
```

**User selects**: "Too busy now"

```
No problem. Continuing with implementation.
```

*[Forge silently tracks skip, no further comment]*

---

## Example 7: Code Review - User Already Reviewed

### Interaction

```
[FORGE: CODE REVIEW]

Question: "Review this code. What does it do? Identify any issues."
Header: "Review"
Options:
- "Show me the code"
- "I reviewed it"
- "Skip this one"
```

**User selects**: "I reviewed it"

```
Good. Continuing.
```

*[Trust the user's self-report, no verification needed]*

---

## Frequency Examples

### Typical Session Flow

```
Operation 1-14: Normal work (no gates)
Operation 15-25: [FORGE: CODE REVIEW] triggered
Operation 26-39: Normal work
Operation 40: [FORGE: YOUR TURN] triggered (randomised in 25-40 range)
Operation 41-55: Normal work
Before multi-file change: [FORGE: ARCHITECT] triggered
```

### High-Frequency Mode (User Very Engaged)

If user completes writes with high accuracy, gates might:
- Increase complexity
- Slightly reduce frequency (reward)

### Low-Frequency Mode (User Busy)

Multiple skips tracked silently. No frequency increase, no judgment.
