# JS/Native Project Standards Rollout Plan

## Goal

Every HurleyUS web/native JS repo gets the same boring gates:

```bash
bun tsc && bun lint --fix && bun test
```

Production Vercel repos also get:

```bash
bun ship
```

## Project buckets

### Bucket A — reference templates first

- `uncap.us`
- `bestwnc.com`
- `test-create-next-app`
- `michaelhurley`

Purpose: finish the golden patterns before copying them everywhere.

### Bucket B — active revenue web apps

Prioritize repos with live domains, customers, or demos:

- `appestatesales.com`
- `merchwinner.com`
- `getat.me`
- `reaferral`
- `hustle*.com`
- `bestjeepdecals.com`
- local service sites under active outreach

### Bucket C — native/mobile JS

- Expo/React Native apps
- shared packages consumed by native apps

Native keeps its own dev command, but still gets `tsc`, `lint`, `check`, tests, hooks, and CI where relevant.

### Bucket D — archives / low-traffic experiments

Only migrate if touched. No archaeology cosplay.

## Phase 0 — freview everywhere

1. Install `~/bin/freview` from `HurleyUS/freview`.
2. Add `scripts/hooks/pre-push` to every active repo.
3. Install local `.git/hooks/pre-push` for protected branches.
4. Confirm `freview --help` works.

Exit criteria: protected branch pushes run review before leaving the machine.

## Phase 1 — finish the four reference repos

### `uncap.us`

- Replace `tsc --noEmit` with `tsgo --noEmit`.
- Add `types: ["bun", "node"]` and `**/*.mts` to `tsconfig.json`.
- Replace `scripts/lint.mts` with `scripts/biome-lint.mjs` adapter or change current wrapper to honor `--fix`.
- Add explicit `bun tsc` and `bun lint` to `.github/workflows/ship.yml` before Vercel build.

### `bestwnc.com`

- Add Bun/Node types and `.mts` include to `tsconfig.json`.
- Normalize dev host unless `bestwnc.localhost` is intentional.
- Add `scripts/hooks/pre-push`.
- Add `scripts/ship.mts` and Blacksmith workflow.

### `test-create-next-app`

- Add `lint:fix` and `check` scripts.
- Add `scripts/hooks/pre-push`.
- Decide whether it is only a template/test repo or should have Blacksmith deploys.

### `michaelhurley`

- Add `ship` script.
- Add `scripts/hooks/pre-push`.
- Add Blacksmith workflow if production deploys should be action-driven.

Exit criteria: all four run `bun tsc`, `bun lint --fix`, and test/build gate without script drift.

## Phase 2 — make a reusable patch kit

Create a portable standards bundle:

- `scripts/biome-lint.mjs`
- `scripts/hooks/pre-push`
- `scripts/dev-localhost.mjs`
- `scripts/dev-localhost-info.mjs`
- `scripts/ship.mts`
- `.github/workflows/ship.yml`
- baseline `biome.jsonc`
- baseline `tsconfig` patch

Store the canonical copy in `hustlestack-skills`.

Exit criteria: one documented checklist can migrate a repo in under 20 minutes.

## Phase 3 — active revenue repos

For each repo:

1. Create `chore/js-standards` branch.
2. Apply patch kit.
3. Run `bun install`.
4. Run `bun tsc`.
5. Run `bun lint --fix`.
6. Run tests or smoke build.
7. Add Blacksmith ship only if repo is in `HurleyUS`/org and Vercel secrets exist.
8. Commit and push.

Batch size: 3 repos at a time. More than that is how migrations turn into soup.

## Phase 4 — native repos

Adapt the same gates:

- `tsc`: `tsgo --noEmit` if compatible; otherwise keep `tsc --noEmit` until Expo/tooling catches up.
- `lint`: Biome wrapper.
- `test`: `bun test` or project-native test runner.
- `ship`: native release script, not Vercel.
- pre-push hook: `freview` if Fallow/Scribe understand the repo; otherwise `bun check` until supported.

## Phase 5 — CI enforcement

- Add Blacksmith/Vercel prebuilt for production web repos.
- Add PR check workflow for repos that should not deploy from every branch.
- Turn off Vercel Git auto-builds where Blacksmith prebuilt deploy owns production.
- Verify `gh run view --log` and Vercel deployment source.

## Tracking

Create one GitHub issue per repo with this checklist:

```md
- [ ] tsgo deps/scripts
- [ ] tsconfig Bun/Node/.mts
- [ ] Biome config + wrapper
- [ ] dev/dev:raw/dev:info scripts
- [ ] pre-push freview hook
- [ ] tests/check script
- [ ] ship.mts
- [ ] Blacksmith workflow/secrets/app access
- [ ] build/test/lint verified
```

## Definition of done

A repo is migrated only when:

- `git status` is clean after commit.
- `bun tsc` passes.
- `bun lint` passes.
- `bun lint --fix` works.
- `bun test` or documented alternate gate passes.
- `freview --root . --summary` writes `REVIEW.md`.
- Production repos can ship through `bun ship` or have a documented blocker.
