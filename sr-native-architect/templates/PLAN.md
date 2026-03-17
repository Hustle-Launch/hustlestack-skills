# Project Plan

Architecture decisions and implementation roadmap.

---

## Overview

**Project:** [Name]
**Goal:** [One-sentence description]
**Stack:** Next.js 16 + React 19 + Convex + Clerk + Stripe + Tailwind v4

---

## Architecture

### Route Structure
```
app/
├── (auth)/           # Sign-in, sign-up
├── (marketing)/      # Public pages
├── (app)/            # Protected app routes
│   ├── dashboard/
│   └── settings/
└── (admin)/          # Admin routes
```

### Data Model
```
users ──┬── profiles
        └── subscriptions ── plans
```

### Key Decisions
1. **[Decision]:** [Rationale]
2. **[Decision]:** [Rationale]

---

## Phases

### Phase 1: Foundation
- [ ] Project setup
- [ ] Convex schema
- [ ] Auth integration
- [ ] Base components

### Phase 2: Core Features
- [ ] Feature A
- [ ] Feature B
- [ ] Feature C

### Phase 3: Polish
- [ ] Error handling
- [ ] Loading states
- [ ] Mobile responsive
- [ ] SEO

### Phase 4: Launch
- [ ] Production deploy
- [ ] Monitoring setup
- [ ] Documentation

---

## Open Questions
- [ ] Question 1?
- [ ] Question 2?

---

## References
- [Design doc]
- [Figma]
- [Competitor research]
