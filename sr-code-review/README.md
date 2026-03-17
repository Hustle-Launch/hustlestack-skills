# HustleStack Skills

Battle-tested AI coding skills for shipping production web apps fast.

Born from building dozens of Next.js + Convex apps with Claude Code. These aren't theoretical best practices — they're lessons learned from 50K lines of broken code, 29-agent disasters, and the rewrites that followed.

## The Stack (Opinionated)

| Layer | Tech |
|-------|------|
| Framework | Next.js 16+ (App Router, Turbopack, PPR) |
| React | React 19+ with react-compiler |
| Styling | Tailwind CSS v4 |
| Components | shadcn/ui + Radix UI |
| Icons | Phosphor (react-icons/pi, light weight only) |
| Database | Convex |
| Auth | Clerk |
| Payments | Stripe |
| Email | Resend |
| Analytics | PostHog |
| Errors | Sentry |
| Hosting | Vercel |

No config. No alternatives. This stack ships.

## Skills

### [sr-engineering-director](./sr-engineering-director/SKILL.md)
Multi-agent orchestration for complex projects. Phased builds, functional verification, the full playbook for delegating to sub-agents without producing 50K lines of broken code.

Includes supporting docs:
- [TECH-REQ.md](./sr-engineering-director/TECH-REQ.md) — full technical specification for the stack
- [CODING-STANDARDS.md](./sr-engineering-director/CODING-STANDARDS.md) — TypeScript, React, Convex, and git conventions
- [CONTRACTS-TEMPLATE.md](./sr-engineering-director/CONTRACTS-TEMPLATE.md) — API contract definitions between frontend and backend

### [sr-production-engineer](./sr-production-engineer/SKILL.md)
12-step production workflow with TODO tracking, Graphite PRs, GitHub issues, and Vercel deploy checks. Use for any development task that needs tracked progress and code review.

### [sr-react-design-expert](./sr-react-design-expert/SKILL.md)
Create distinctive, production-grade interfaces that avoid generic AI aesthetics. Bold choices, memorable design, zero AI slop.

### [sr-software-architect](./sr-software-architect/SKILL.md)
Architecture-first workflow for delegating individual tasks. Read the architecture, understand the system, then write code that fits.

## Templates

Reusable project tracking files in [`templates/`](./templates/):

| Template | Purpose |
|----------|---------|
| [TODO.md](./templates/TODO.md) | Task tracking that survives context compaction |
| [PLAN.md](./templates/PLAN.md) | Architecture decisions and phased roadmap |
| [CHANGELOG.md](./templates/CHANGELOG.md) | Version history (Keep a Changelog format) |

Copy these into your project root when starting a new build:

```bash
cp skills/templates/TODO.md ./TODO.md
cp skills/templates/PLAN.md ./PLAN.md
cp skills/templates/CHANGELOG.md ./CHANGELOG.md
```

## Installation

### Claude Code (Recommended)

1. Clone into your home directory:

```bash
git clone https://github.com/hustlestack/hustlestack-skills ~/.claude/skills/hustlestack
```

2. Reference a skill in your project's `CLAUDE.md`:

```markdown
## Skills
Import and follow the skill at ~/.claude/skills/hustlestack/sr-production-engineer/SKILL.md
```

Or reference skills directly in prompts:

```
Use the skill at ~/.claude/skills/hustlestack/sr-react-design-expert/SKILL.md to build the landing page
```

### Per-project (vendored)

If you prefer skills checked into your repo:

```bash
# Add as a subtree or just copy the directory
cp -r ~/.claude/skills/hustlestack ./skills

# Reference from your project CLAUDE.md
# Import and follow the skill at ./skills/sr-production-engineer/SKILL.md
```

### Manual

Grab individual skills — each is self-contained in its own directory:

```bash
# Just the architect skill
curl -sL https://github.com/hustlestack/hustlestack-skills/archive/main.tar.gz \
  | tar xz --strip-components=1 hustlestack-skills-main/sr-software-architect
```

## Project Structure

```
skills/
├── sr-engineering-director/     # Multi-agent orchestration
│   ├── SKILL.md                 # Core workflow & agent policy
│   ├── TECH-REQ.md              # Full stack specification
│   ├── CODING-STANDARDS.md      # Code conventions & patterns
│   └── CONTRACTS-TEMPLATE.md    # API contract template
├── sr-production-engineer/      # 12-step dev workflow
│   └── SKILL.md
├── sr-react-design-expert/      # Frontend design system
│   └── SKILL.md
├── sr-software-architect/       # Architecture-first delegation
│   └── SKILL.md
├── templates/                   # Reusable project files
│   ├── TODO.md
│   ├── PLAN.md
│   └── CHANGELOG.md
└── docs/
    └── index.html               # Landing page
```

## Philosophy

1. **Single agent + full context > many agents + partial context**
2. **"Compiles" ≠ "works"** — verify functionality, not just builds
3. **Architecture first** — understand the system before writing code
4. **Opinionated stack** — decision fatigue kills velocity
5. **Ship daily** — momentum compounds

## Origin Story

These skills emerged from:
- 29 parallel agents writing 50K lines that didn't compile
- A "working" app with zero actual functionality (BreazyApp autopsy)
- Rewriting entire backends in 11 minutes with single-agent + full context
- Shipping 15+ production apps in early 2026

The hard lessons are baked in.

## License

MIT

---

Created by [Michael C. Hurley](https://michaelchurley.com)
