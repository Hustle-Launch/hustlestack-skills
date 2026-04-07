---
name: sr-react-design-expert
description: Create distinctive, production-grade frontend interfaces with high design quality. Use this skill when the user asks to build web components, pages, or applications. Generates creative, polished code that avoids generic AI aesthetics.
---

# Frontend Design

Create distinctive, production-grade frontend interfaces that avoid generic "AI slop" aesthetics. Implement real working code with exceptional attention to aesthetic details and creative choices.

## Stack Context

This skill targets the HustleStack:

| Layer | Tech | Notes |
|-------|------|-------|
| Framework | Next.js 16+ (App Router) | Use `Image`, `Link`, metadata API |
| Styling | Tailwind CSS v4 | `@theme` block, no `tailwind.config` |
| Components | shadcn/ui + Radix UI | New York variant, extend don't replace |
| Icons | Phosphor (`@phosphor-icons/react`) | Light weight only |
| Animation | CSS-first, Embla Carousel | No Framer Motion unless already installed |

When working in an existing project, read the layout, globals.css, and component library before designing. Match the established patterns.

## Design Thinking

Before coding, answer these questions:

1. **What is this?** — Marketing page, dashboard, form, settings panel, landing page?
2. **Who sees it?** — First-time visitor, returning user, admin?
3. **What should they feel?** — Trust, excitement, urgency, calm, delight?
4. **What's the one action?** — Every page has a primary action. Design toward it.

Then commit to a clear aesthetic direction and execute with precision. Bold maximalism and refined minimalism both work — the key is intentionality, not intensity.

## Aesthetic Selection (MANDATORY)

**When asked for multiple design variants:**

1. Read `references/aesthetics-library.md` first
2. SELECT FROM DIFFERENT CATEGORIES — never pick 5 from the same section
3. Match aesthetics to the project's industry, audience, and brand
4. BANNED DEFAULT SET: "Minimal Editorial, Bold & Playful, Mountain Modern, Warm Community, Tech Forward" — never use these 5 together again

**100 aesthetics are documented.** Use them. Pick unexpected combinations. Consider:
- The client's competitors (differentiate)
- The project's content (photography-heavy? data-dense? text-focused?)
- The audience's expectations (subvert or meet them intentionally)

**Example rotation for a local business directory:**
1. Kinfolk Lifestyle (#2) — quiet elegance
2. Bloomberg Terminal (#3) — data-forward dark mode
3. Art Deco Gatsby (#75) — vintage local charm
4. Mid-Century Modern (#79) — retro warmth
5. Neon Noir (#83) — dramatic nightlife energy

Not: the same 5 generics every time.

### Direction by Context

| Context | Direction | Why |
|---------|-----------|-----|
| Landing/Marketing | Bold, atmospheric, high-contrast | First impression, brand recall |
| Dashboard/App | Clean, structured, information-dense | Daily-use clarity |
| Forms | Focused, minimal, guided | Reduce friction |
| Content/Blog | Editorial, typographic, readable | Content is the design |
| Error/Empty states | Warm, helpful, on-brand | Don't break immersion |

## Design Rules

These rules override aesthetic preferences. They are non-negotiable.

### Buttons
- **Content-width only** — never `w-full` on buttons
- **Solid backgrounds** — no gradients on buttons
- **Right-align submit buttons** — bottom-right of forms and panels

### Cards
- Title in `<CardHeader>`
- Image + description in `<CardContent>`
- No `rounded-*` on images inside cards — the card handles border radius
- Use `overflow-hidden` on containers, not `rounded-*` on images

### Forms
- **2-column layout** — description/pitch on the left, fields on the right
- Submit button: bottom-right aligned

### Layout
- Follow established UX conventions over trendy styling
- When in doubt, conventional beats clever

## Aesthetics Guidelines

### Typography

Choose fonts that serve the design. For standalone projects, pair a distinctive display font with a clean body font. When working in an existing project, use the project's established fonts.

**Good font choices** (vary between projects):
- Display: Playfair Display, Clash Display, Cabinet Grotesk, Instrument Serif, Syne, General Sans, Satoshi
- Body: DM Sans, Plus Jakarta Sans, Source Serif 4, Outfit, Manrope

**Avoid converging** on the same font across projects. If you used Syne last time, pick something different.

### Color & Theme

Commit to a cohesive palette. Use CSS variables for consistency.

- Dominant color with sharp accents outperforms evenly-distributed palettes
- Dark themes: avoid pure black (#000) — use rich dark tones (e.g., Catppuccin base/surface colors)
- Light themes: avoid pure white (#fff) backgrounds for large surfaces — use warm/cool tints
- Accent colors should appear in 2-3 places max, not everywhere

### Motion

Prioritize CSS-only animations. Reserve JS animation libraries for complex orchestration.

**High-impact moments:**
- Page load: staggered reveals with `@keyframes` and `animation-delay`
- Scroll: IntersectionObserver-based reveals (the project uses a `useScrollReveal` hook)
- Hover: subtle transforms and color shifts
- Transitions: `transition-*` utilities for state changes

**Low-value motion to skip:**
- Parallax on every section
- Bouncing elements that distract from content
- Loading spinners where skeleton screens would work better

### Spatial Composition

Break out of the grid when it serves the design — asymmetry, overlap, diagonal flow, generous negative space. But grid-breaking should be intentional. A marketing hero section can be wild; a data table should not.

### Backgrounds & Depth

Create atmosphere through layering:
- Gradient meshes, noise textures, geometric patterns
- `backdrop-blur` for glassmorphic surfaces
- Layered transparencies and dramatic shadows
- Grain overlays and decorative borders

These work on hero sections and feature showcases. Don't apply them to every surface.

## Working with shadcn/ui

shadcn/ui components are a starting point, not a ceiling.

**Extend, don't fight:**
- Use `cn()` to merge custom classes with defaults
- Override via Tailwind — don't fork component files for cosmetic changes
- Use CVA variants when a component needs multiple visual modes
- Add wrapper components for project-specific patterns (e.g., a `FeatureCard` that composes `Card` + `CardHeader` + `CardContent`)

**Don't:**
- Recreate components that shadcn already provides
- Add inline styles when Tailwind classes exist
- Override Radix accessibility primitives (focus rings, keyboard nav, ARIA)

## Accessibility

Accessibility is not optional. Every interface must:

- Use semantic HTML (`nav`, `main`, `section`, `article`, `aside`, `header`, `footer`)
- Include proper heading hierarchy (one `h1` per page, sequential `h2`→`h3`→`h4`)
- Provide alt text on all images (descriptive for content images, empty `alt=""` for decorative)
- Support keyboard navigation — all interactive elements focusable, visible focus rings
- Maintain WCAG AA color contrast (4.5:1 for body text, 3:1 for large text)
- Use ARIA labels on icon-only buttons and non-obvious interactive elements
- Include skip links for keyboard users

Don't sacrifice accessibility for aesthetics. They're not in conflict — good design is accessible design.

## Anti-Patterns

**Generic AI output:**
- Cookie-cutter hero → heading → 3-card grid → CTA → footer
- Purple-to-blue gradients on white backgrounds
- Evenly-spaced sections with identical padding
- Stock placeholder text that wasn't replaced

**Implementation mistakes:**
- `w-full` buttons (use content-width)
- Gradient backgrounds on buttons (use solid colors)
- `rounded-*` on images inside cards (let the card handle it)
- Centered submit buttons (right-align them)
- Single-column forms where 2-column works better
- `px` values instead of Tailwind spacing scale
- Hardcoded colors instead of CSS variables or theme tokens

**Overengineering:**
- Animation on every element (pick 2-3 high-impact moments)
- Custom scroll hijacking
- Canvas backgrounds that tank performance on mobile
- Parallax that causes layout thrashing

## Pre-Flight Checklist

Before marking a design implementation complete:

- [ ] Renders without console errors
- [ ] All interactive elements work (buttons, links, forms)
- [ ] Responsive at 375px, 768px, 1024px, 1440px
- [ ] Keyboard navigable — tab through the entire page
- [ ] Color contrast passes WCAG AA
- [ ] Images have appropriate alt text
- [ ] No `w-full` buttons, no gradient buttons, submit buttons right-aligned
- [ ] Card structure follows convention (title in header, content in content)
- [ ] Forms use 2-column layout where applicable
- [ ] Animations are CSS-first and don't cause layout shift
- [ ] Dark/light theme works if the project supports theming
- [ ] No hardcoded colors — uses theme tokens or CSS variables

## Related Skills

- Use `/sr-production-engineer` for PR workflow after implementation
- Use `/sr-software-architect` when the UI is part of a larger architectural change
