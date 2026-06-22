---
name: launch-nextjs-blacksmith
description: Configure or audit a Bun-managed Next.js project that deploys through Blacksmith GitHub Actions and Vercel prebuilt output. Use when syncing local preflight gates, production-only installs, Bun and Next cache restores, Vercel build/deploy workflows, prune removal, or AGENTS.md rules for repos with bun.lock and .next at the root.
---

# Launch Next.js on Blacksmith

Use this for Next.js projects with Bun, Blacksmith runners, and Vercel prebuilt deploys. The standard is the combined uncap.us + barbquewagon.com pattern: strict local gates, production-only CI installs, restored Bun/Next caches, archived `.vercel/output`, and no package-manager pruning.

## Applicability

Apply this law when the project root contains both:

- `bun.lock`
- `.next/`

If `.next/` is absent because the repo has never run locally, inspect `package.json`, `next.config.*`, and `.github/workflows/*` before applying.

## Local Preflight

Use `bun lint` as the local preflight command. It should be the single script humans and hooks run before `~/bin/freview`.

It should:

1. Run `biome format --write .`.
2. Run `oxlint --fix .`.
3. Run `tsgo --noEmit` through `bun tsc`.

Before push, also run `~/bin/freview` and resolve its findings.

Keep these gates local. Production deployment CI should build and deploy; it should not spend Blacksmith/Vercel time running lint, typecheck, or freview.

Protected branch pre-push hooks should run the local lint stack first, then freview. Keep freview outside `scripts/lint.mts` so it remains a local QA gate, not a lint step:

```bash
#!/usr/bin/env bash
set -euo pipefail
protected_ref='refs/heads/(main|master)$'
while read -r local_ref _local_sha remote_ref _remote_sha; do
  if [[ "$local_ref" =~ $protected_ref || "$remote_ref" =~ $protected_ref ]]; then
    bun lint
    exec "$HOME/bin/freview"
  fi
done
```

Required dev dependencies:

- `@biomejs/biome`
- `oxlint`
- `@typescript/native-preview`
- `typescript`
- `jsonc-parser` when the repo uses the HustleStack JSON comment cleanup gate

Preferred `scripts/lint.mts` behavior:

- Strip comments from tracked `*.json` files with `jsonc-parser`, unless `--no-clean-json` is passed.
- Parse cleaned JSON before writing so invalid JSON fails loudly.
- Then run Biome format, Oxlint fix, and `bun tsc`.

## Production CI

Blacksmith/Vercel production deploy jobs should:

1. Run on a Blacksmith runner, usually `blacksmith-4vcpu-ubuntu-2404`.
2. Restore Bun cache:
   - `~/.bun/install/cache`
   - key: `${{ runner.os }}-bun-${{ hashFiles('**/bun.lock') }}`
3. Restore Next cache:
   - `${{ github.workspace }}/.next/cache`
   - key includes `bun.lock` plus source file hashes.
4. Install with:

```bash
bun install --production --frozen-lockfile
```

Do not add a separate prune step after this install. `bun install --production --frozen-lockfile` is the prune boundary for Vercel prebuilt CI.

5. Pull Vercel env. Run the Vercel CLI under Node, not Bun:

```bash
bunx vercel pull --yes --environment=production --token="$VERCEL_TOKEN"
```

6. Build prebuilt output:

```bash
export GZ_OPT="-9"
bunx vercel build --prod --token="$VERCEL_TOKEN"
```

7. Archive only `.vercel/output`:

```bash
export GZ_OPT="-9"
tar -czf vercel-output.tgz .vercel/output
```

8. Deploy the archived prebuilt output. Keep Vercel under Node for pull/build/deploy/inspect; `bunx --bun vercel ...` has shown flaky CLI behavior on Blacksmith.

```bash
bunx vercel deploy --prebuilt --prod --archive=tgz --yes --token="$VERCEL_TOKEN"
```

## Dependency Rule

Because CI installs production dependencies before `vercel build`, any package required by the build must be in `dependencies`, not `devDependencies`.

Common build-time dependencies that may need to be production deps:

- `@tailwindcss/postcss`
- `tailwindcss`
- Sentry packages used by `next.config.*`
- MDX/content plugins imported by config or server code

Keep pure local tools in `devDependencies`, including Biome, Oxlint, TypeScript, Playwright, and testing libraries.

## Do Not Prune

Do not use:

```bash
npm prune --production
bun prune --production
```

For Vercel prebuilt deploys, pruning is unnecessary because the deployed artifact is `.vercel/output`, not the checkout `node_modules`. Running `npm prune` in a Bun-managed repo also mixes package managers, and `bun prune --production` is not a reliable current CI primitive.

If the deploy target is Docker or self-hosted `next start`, use a separate runtime-stage strategy instead of this Vercel prebuilt workflow.

## AGENTS.md Rule

Add or update this section in applicable repos:

```md
## Next.js Bun Blacksmith Law

When a Next.js project has both `bun.lock` and `.next/` at the project root:

- Local preflight is `bun lint`, then `~/bin/freview`; `bun lint` is the canonical local gate and must run Biome format, Oxlint fix, and `tsgo --noEmit`.
- Production CI must not run lint, typecheck, or freview; those are local pre-push gates.
- Production Blacksmith/Vercel prebuilt CI installs with `bun install --production --frozen-lockfile`.
- Any package needed by `vercel build --prod` must be in `dependencies`, not `devDependencies`.
- Restore `~/.bun/install/cache` and `.next/cache` in CI before install/build.
- Run the Vercel CLI with `bunx vercel`, not `bunx --bun vercel`, for pull/build/deploy/inspect steps.
- Deploy only archived `.vercel/output` with `vercel deploy --prebuilt --archive=tgz`; do not prune `node_modules` after build.
- Do not use `npm prune --production` or `bun prune --production` in Bun-managed Vercel prebuilt projects.
- Protected branch pre-push hooks must run `bun lint` first, then `~/bin/freview`; freview remains outside the lint script.
```

## Migration Checklist

When applying this skill to an existing project:

1. Confirm `package.json` has `lint`, `lint:fix`, `check`, `tsc`, and `typecheck` scripts wired to the local gate.
2. Confirm `scripts/lint.mts` runs Biome format, Oxlint fix, and `bun tsc`.
3. Confirm protected branch pre-push hooks run `bun lint`, then `~/bin/freview`.
4. Remove CI steps that run lint, typecheck, freview, `npm prune --production`, or `bun prune --production`.
5. Add or preserve Bun cache restore before install.
6. Add or preserve `.next/cache` restore before build.
7. Install in CI with `bun install --production --frozen-lockfile`.
8. Build with `bunx vercel build --prod`.
9. Archive `.vercel/output` and deploy with `bunx vercel deploy --prebuilt --prod --archive=tgz`.
10. Add the AGENTS.md law when the root has both `bun.lock` and `.next/`.

## Workflow Template

Use this shape for production deployments:

```yaml
jobs:
  ship:
    runs-on: blacksmith-4vcpu-ubuntu-2404
    steps:
      - uses: actions/checkout@v5
      - uses: oven-sh/setup-bun@v2
        with:
          bun-version: latest
      - uses: actions/cache@v4
        with:
          path: ~/.bun/install/cache
          key: ${{ runner.os }}-bun-${{ hashFiles('**/bun.lock') }}
          restore-keys: ${{ runner.os }}-bun-
      - uses: actions/cache@v4
        with:
          path: ${{ github.workspace }}/.next/cache
          key: ${{ runner.os }}-nextjs-${{ hashFiles('**/bun.lock') }}-${{ hashFiles('**.[jt]s', '**.[jt]sx', '**/*.ts', '**/*.tsx') }}
          restore-keys: ${{ runner.os }}-nextjs-${{ hashFiles('**/bun.lock') }}-
      - run: bun install --production --frozen-lockfile
      - run: bunx vercel pull --yes --environment=production --token="$VERCEL_TOKEN"
      - run: bunx vercel build --prod --token="$VERCEL_TOKEN"
      - run: tar -czf vercel-output.tgz .vercel/output
      - run: bunx vercel deploy --prebuilt --prod --archive=tgz --yes --token="$VERCEL_TOKEN"
```

## Verification

Run:

```bash
bun lint
bun install --production --frozen-lockfile
~/bin/freview
```

For workflow-only changes, inspect the YAML and, when appropriate, trigger the workflow with the repo’s `bun ship` wrapper.
