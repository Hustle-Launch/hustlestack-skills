# SHIP.md

A terse team punchlist for shipping HurleyUS JS/native projects without clown shoes.

## 0. Before touching code

- [ ] `git status --short --branch`
- [ ] Confirm target branch and repo.
- [ ] Read `README.md`, `AGENTS.md`, `TODO.md` if present.
- [ ] Create/update task notes if this is non-trivial.

## 1. Local standards

- [ ] `package.json` has standard scripts:
  - [ ] `dev`
  - [ ] `dev:raw`
  - [ ] `dev:info`
  - [ ] `build`
  - [ ] `start`
  - [ ] `tsc`
  - [ ] `typecheck`
  - [ ] `lint`
  - [ ] `lint:fix`
  - [ ] `check`
  - [ ] `test`
  - [ ] `format`
  - [ ] `ship` when deployable
- [ ] TypeScript gate uses `tsgo --noEmit` where compatible.
- [ ] `tsconfig.json` includes Bun/Node types and `.mts` scripts.
- [ ] Biome config exists and ignores generated/runtime artifacts.
- [ ] `bun lint --fix` works through the Biome wrapper.
- [ ] Local dev uses deterministic `*.localhost` + Caddy where applicable.

## 2. Hooks/review

- [ ] `~/bin/freview` installed.
- [ ] `scripts/hooks/pre-push` exists.
- [ ] `.git/hooks/pre-push` installed locally.
- [ ] Protected branch pushes run `freview`.
- [ ] `REVIEW.md` regenerated or reviewed when relevant.

## 3. Code gate

Run the smallest complete gate:

```bash
bun tsc
bun lint --fix
bun test
```

If tests do not exist:

- [ ] Run `bun build` or project-specific smoke check.
- [ ] Document missing test coverage as a follow-up.

## 4. CI/CD gate

For production Vercel repos:

- [ ] Repo lives in a GitHub org if using Blacksmith.
- [ ] Blacksmith GitHub App has access.
- [ ] GitHub secrets exist:
  - [ ] `VERCEL_TOKEN`
  - [ ] `VERCEL_ORG_ID`
  - [ ] `VERCEL_PROJECT_ID`
- [ ] Workflow uses Blacksmith runner.
- [ ] Workflow runs install, typecheck, lint, Vercel build, prebuilt deploy.
- [ ] Vercel Git auto-builds are disabled/ignored when Blacksmith owns deploys.
- [ ] `bun ship --no-watch` dispatches correctly.

## 5. Commit

- [ ] `git diff` reviewed.
- [ ] No secrets in diff.
- [ ] No generated junk unless intentional.
- [ ] Commit author is Michael C. Hurley.
- [ ] Commit message says what shipped, not vibes.

## 6. Push/PR

- [ ] Push branch.
- [ ] Open PR or Graphite stack if needed.
- [ ] Link issue/task.
- [ ] Paste verification commands and results.
- [ ] Address review quickly.

## 7. Deploy

- [ ] Merge only after checks pass.
- [ ] Run `bun ship` or verify deploy trigger.
- [ ] Watch GitHub Actions logs.
- [ ] Verify Vercel deployment ready.
- [ ] Smoke production URL.
- [ ] Check health endpoint if present.

## 8. After ship

- [ ] Update `CHANGELOG.md`/release notes if user-facing.
- [ ] Close issue/task.
- [ ] Post concise status:
  - repo
  - commit/PR
  - checks run
  - deploy URL/status
  - blockers/follow-ups

## Stop-the-line blockers

Do not ship if:

- [ ] Secrets appear in diff.
- [ ] Typecheck fails.
- [ ] Lint fails for new code.
- [ ] Build fails.
- [ ] Production deploy target is unclear.
- [ ] Blacksmith app/secrets are missing but workflow depends on them.
- [ ] You are about to delete branches/work without merge/recovery path.
