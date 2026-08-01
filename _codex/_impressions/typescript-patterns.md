# TypeScript Patterns Worth Knowing

## Branded types
```ts
type UserId = string & { __brand: "UserId" }
type PostId = string & { __brand: "PostId" }
```

## Discriminated unions
```ts
type Result<T, E> =
  | { ok: true; value: T }
  | { ok: false; error: E }
```

## Template literal types
```ts
type EventName = `on${Capitalize<string>}`
```

## Satisfies operator
```ts
const palette = {
  red: [255, 0, 0],
  green: [0, 255, 0],
} satisfies Record<string, [number, number, number]>
```

## Utility types
- `Omit<T, K>` — remove keys
- `Pick<T, K>` — subset
- `Partial<T>` — all optional
- `Readonly<T>` — all frozen
- `Extract<T, U>` — filter union
- `Exclude<T, U>` — subtract union
