# Task Prompts by Complexity Level

Templates for extracting user write tasks from current work.

## Level 1: Single Function, Pure Logic

### Template

```
[FORGE: YOUR TURN - Level 1]

Implement this function:

**Signature**: `{functionName}({params}): {returnType}`

**Description**: {what it does}

**Examples**:
- `{functionName}({input1})` -> `{output1}`
- `{functionName}({input2})` -> `{output2}`

Write your implementation and send it when ready.
```

### Sample Tasks

**isPrime**
```
Implement this function:

**Signature**: `isPrime(n: number): boolean`

**Description**: Returns true if n is a prime number, false otherwise.

**Examples**:
- `isPrime(7)` -> `true`
- `isPrime(4)` -> `false`
- `isPrime(1)` -> `false`
```

**capitalizeWords**
```
Implement this function:

**Signature**: `capitalizeWords(str: string): string`

**Description**: Capitalizes the first letter of each word.

**Examples**:
- `capitalizeWords("hello world")` -> `"Hello World"`
- `capitalizeWords("jAVA script")` -> `"Java Script"`
```

---

## Level 2: Function with Side Effects

### Template

```
[FORGE: YOUR TURN - Level 2]

Implement this function:

**Signature**: `{functionName}({params}): {returnType}`

**Description**: {what it does}

**Side Effects**: {what external state changes}

**Error Handling**: {expected error behaviour}

Write your implementation and send it when ready.
```

### Sample Tasks

**saveToLocalStorage**
```
Implement this function:

**Signature**: `saveToLocalStorage<T>(key: string, value: T): boolean`

**Description**: Serializes value to JSON and saves to localStorage.

**Side Effects**: Writes to browser localStorage.

**Error Handling**: Returns false if serialization fails or storage is full.
```

**fetchWithRetry**
```
Implement this function:

**Signature**: `fetchWithRetry(url: string, retries: number): Promise<Response>`

**Description**: Fetches URL, retrying on failure up to specified count.

**Side Effects**: Network requests.

**Error Handling**: Throws after all retries exhausted.
```

---

## Level 3: Multi-Function with State

### Template

```
[FORGE: YOUR TURN - Level 3]

Implement this module:

**Interface**:
```typescript
{interface definition}
```

**Description**: {what it does}

**State**: {what state it maintains}

**Behaviour**:
- {behaviour 1}
- {behaviour 2}

Write your implementation and send it when ready.
```

### Sample Tasks

**createCounter**
```
Implement this module:

**Interface**:
```typescript
interface Counter {
  increment(): number;
  decrement(): number;
  reset(): void;
  value(): number;
}
```

**Description**: Creates a counter with increment, decrement, reset operations.

**State**: Current count value.

**Behaviour**:
- `increment()` adds 1 and returns new value
- `decrement()` subtracts 1 and returns new value
- `reset()` sets count to 0
- `value()` returns current count without changing it
```

**createRateLimiter**
```
Implement this module:

**Interface**:
```typescript
interface RateLimiter {
  tryAcquire(): boolean;
  reset(): void;
}
```

**Description**: Token bucket rate limiter.

**State**: Tokens remaining, last refill timestamp.

**Behaviour**:
- `tryAcquire()` returns true if token available, false otherwise
- Tokens refill at configured rate
- `reset()` refills all tokens immediately
```

---

## Level 4: Component with Lifecycle

### Template

```
[FORGE: YOUR TURN - Level 4]

Implement this React hook:

**Signature**: `{hookName}({params}): {returnType}`

**Description**: {what it does}

**Lifecycle**:
- Mount: {what happens}
- Update: {what happens}
- Unmount: {what happens}

**Return Value**: {what it returns}

Write your implementation and send it when ready.
```

### Sample Tasks

**useDebounce**
```
Implement this React hook:

**Signature**: `useDebounce<T>(value: T, delay: number): T`

**Description**: Returns debounced version of value.

**Lifecycle**:
- Mount: Set up timeout
- Update: Reset timeout when value changes
- Unmount: Clear timeout

**Return Value**: Debounced value (updates after delay ms of no changes)
```

**useLocalStorage**
```
Implement this React hook:

**Signature**: `useLocalStorage<T>(key: string, initialValue: T): [T, (value: T) => void]`

**Description**: useState that persists to localStorage.

**Lifecycle**:
- Mount: Read from localStorage or use initialValue
- Update: Write to localStorage on state change
- Unmount: No cleanup needed

**Return Value**: [currentValue, setValue] tuple
```

---

## Level 5: System Design Fragment

### Template

```
[FORGE: YOUR TURN - Level 5]

Design and implement:

**System**: {what system}

**Interface**:
```typescript
{interface definition}
```

**Requirements**:
- {requirement 1}
- {requirement 2}
- {requirement 3}

**Constraints**:
- {constraint 1}
- {constraint 2}

Write your implementation and send it when ready.
```

### Sample Tasks

**EventBus**
```
Design and implement:

**System**: Pub/Sub Event Bus

**Interface**:
```typescript
interface EventBus {
  subscribe(event: string, callback: (data: any) => void): () => void;
  publish(event: string, data: any): void;
  once(event: string, callback: (data: any) => void): () => void;
}
```

**Requirements**:
- Multiple subscribers per event
- Unsubscribe returns cleanup function
- `once` auto-unsubscribes after first call

**Constraints**:
- No external dependencies
- Type-safe callback invocation
```

**SimpleCache**
```
Design and implement:

**System**: LRU Cache with TTL

**Interface**:
```typescript
interface Cache<T> {
  get(key: string): T | undefined;
  set(key: string, value: T, ttlMs?: number): void;
  delete(key: string): boolean;
  clear(): void;
}
```

**Requirements**:
- Max capacity with LRU eviction
- Optional per-key TTL
- Expired items removed on access

**Constraints**:
- O(1) get/set operations
- No external dependencies
```

---

## Extraction Guidelines

When extracting from current work:

| Do | Don't |
|----|-------|
| Pick a self-contained piece | Extract tightly coupled code |
| Match complexity to user level | Always pick easiest option |
| Use actual types from project | Invent unrelated types |
| Keep scope 10-30 lines | Request 100+ line implementations |
