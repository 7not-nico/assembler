# API scale

The ZScript API dwarfs the language spec. The epub carries 126 chapters; the API reference occupies ch016–ch126 (~110 chapters), while the language core takes ch004–ch015.

## Scale evidence

```text
Chapters         251 h1 sections
API chapters     ~110 of 126
Class families   Actor, Thinker, PlayerPawn, EventHandler, LevelLocals,
                 CVar, Screen, Wads, Sound, Font, String, Vector2/3
Term frequency   static in 27 chapters
```

## API shape

- Class-methods — static factory and lookup APIs
- Instance-methods — per-object behavior
- Instance-members — per-object state
- Constants, properties, flags, defaults on each class
- Event handlers (Console, Input, Player, Render, Replace, Static, UI, World) — engine hooks as script classes

## Platform implication

The language exists to script the engine's object graph, not to stand alone. Authors subclass native classes, override virtuals, and attach action scopes. The semantic center of gravity sits in the API — the grammar is a thin substrate under a large class hierarchy.
