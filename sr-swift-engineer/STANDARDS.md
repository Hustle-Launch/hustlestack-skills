# STANDARDS.md - Global Standards for All sr-* Skills

These standards apply to ALL sr-* skills unless explicitly overridden by project requirements or spec-docs.

---

## Icons: Phosphor Icons

**Default icon library for ALL platforms.**

| Platform | Package | Install |
|----------|---------|---------|
| Next.js / React | `@phosphor-icons/react` | `bun add @phosphor-icons/react` |
| React Native | `phosphor-react-native` | `bun add phosphor-react-native` |
| Swift | `phosphor-swift` | SPM: `github.com/nicklockwood/phosphor-swift` |

### Usage

```tsx
// Web (React/Next.js)
import { House, Gear, User, CaretRight } from "@phosphor-icons/react";

<House size={24} weight="regular" />
<Gear size={24} weight="fill" />
<User size={24} weight="duotone" />
```

```tsx
// React Native
import { House, Gear, User } from "phosphor-react-native";

<House size={24} color="#000" weight="regular" />
```

```swift
// Swift
import PhosphorSwift

Image(phosphor: .house)
Image(phosphor: .gear, weight: .fill)
```

### Weights
- `thin` — 1px stroke
- `light` — 1.5px stroke  
- `regular` — 2px stroke (default)
- `bold` — 3px stroke
- `fill` — Solid fill
- `duotone` — Two-tone with opacity

### Override Conditions
Only use a different icon library when:
1. Project requirements explicitly specify another library
2. Client brand guidelines require specific icons
3. Platform requires native icons (e.g., SF Symbols for iOS App Store)
4. Spec-docs document the exception

**When overriding:** Document the reason in the project's STANDARDS.md or README.md.

---

## More Standards

Additional global standards will be added here as they're established.

---

*Last updated: 2026-02-14*
