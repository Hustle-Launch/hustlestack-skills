# JS/Native Project Standards Implementation Guide

Terse version: make every web/native JS repo boring to develop, review, and ship.

## Baseline package scripts

Use these names everywhere so muscle memory works across repos:

```json
{
  "scripts": {
    "dev": "bun scripts/dev-localhost.mjs",
    "dev:raw": "next dev",
    "dev:info": "bun scripts/dev-localhost-info.mjs",
    "build": "next build",
    "start": "next start",
    "tsc": "tsgo --noEmit",
    "typecheck": "tsgo --noEmit",
    "lint": "bun scripts/biome-lint.mjs",
    "lint:fix": "bun scripts/biome-lint.mjs --fix",
    "check": "bun tsc && bun lint",
    "test": "bun test",
    "test:coverage": "bun test --coverage --coverage-reporter=lcov --coverage-dir=coverage",
    "format": "biome format --write .",
    "ship": "bun scripts/ship.mts"
  }
}
```

Repo-specific exceptions:

- Vitest repos may keep `test: vitest`.
- Convex repos can keep generated folders excluded from Biome.
- Native/Expo repos should keep `dev` mapped to their normal native startup, but still expose `tsc`, `lint`, `check`, and `ship`.

## tsgo migration

Install:

```bash
bun add -d @typescript/native-preview typescript @types/bun @types/node @biomejs/biome
```

Remove ESLint after Biome is passing:

```bash
bun remove eslint eslint-config-next @eslint/eslintrc @eslint/js eslint-plugin-react eslint-plugin-react-hooks eslint-plugin-jsx-a11y eslint-plugin-import
```

`tsconfig.json` must include Bun + Node types and `.mts` scripts:

```json
{
  "compilerOptions": {
    "strict": true,
    "noEmit": true,
    "moduleResolution": "bundler",
    "jsx": "react-jsx",
    "types": ["bun", "node"],
    "plugins": [{ "name": "next" }]
  },
  "include": [
    "next-env.d.ts",
    "**/*.ts",
    "**/*.tsx",
    ".next/types/**/*.ts",
    ".next/dev/types/**/*.ts",
    "**/*.mts"
  ],
  "exclude": ["node_modules"]
}
```

Best current examples:

- `test-create-next-app`: cleanest tsgo/Bun type setup.
- `michaelhurley`: stricter TypeScript options layered on top.
- `bestwnc.com`: good tsgo scripts but missing `types: ["bun", "node"]` and `**/*.mts` include.
- `uncap.us`: still uses `tsc --noEmit`; migrate to `tsgo --noEmit`.

## Biome setup

Use a wrapper, not raw `biome check .`, so `bun lint --fix` maps to Biome `--write`.

`scripts/biome-lint.mjs`:

```js
#!/usr/bin/env bun

export function buildBiomeArgs(args) {
  const biomeArgs = ["check", "."];

  for (const arg of args) {
    if (arg === "--fix") {
      biomeArgs.push("--write");
      continue;
    }

    biomeArgs.push(arg);
  }

  return biomeArgs;
}

export async function runBiomeLint(args, spawnCommand = Bun.spawn) {
  const proc = spawnCommand(["biome", ...buildBiomeArgs(args)], {
    stderr: "inherit",
    stdout: "inherit",
  });

  return proc.exited;
}

if (import.meta.url === `file://${process.argv[1]}`) {
  process.exit(await runBiomeLint(process.argv.slice(2)));
}
```

Biome config baseline:

- Enable VCS/use `.gitignore`.
- Exclude generated/runtime artifacts: `node_modules`, `.next`, `.vercel`, `out`, `build`, `coverage`, `bun.lock`, `tsconfig.tsbuildinfo`, `next-env.d.ts`, `convex/_generated`.
- Keep Tailwind CSS parser directives enabled.
- Start with recommended rules, then explicitly document any a11y/security/correctness relaxations.

Best current examples:

- `michaelhurley`: best wrapper + strict formatter.
- `test-create-next-app`: best migration template with `ignoreUnknown`.
- `bestwnc.com`: useful custom lint wrapper for team-specific design rules.
- `uncap.us`: currently duplicates typecheck inside lint; split `tsc` and `lint` so `lint --fix` works predictably.

## Local dev scripts

Standard pattern:

- `dev`: create deterministic `*.localhost` host + port, write Caddy snippet, reload Caddy, run Next.
- `dev:raw`: unwrapped framework dev server.
- `dev:info`: print `{ slug, host, port, url }` JSON.

Best current example: `michaelhurley` because Caddy logic is split into testable modules.

Hard requirements:

- Host is `${repo-slug}.localhost` unless a custom domain is intentional.
- Port is deterministic from slug.
- Dev script exports `DEV_HOST`, `DEV_URL`, and `PORT`.
- Prefer Bun shebangs when the script uses Bun APIs.

## Pre-push hook

Protected branch pushes should run `freview`:

```bash
#!/usr/bin/env bash
set -euo pipefail

protected_ref='refs/heads/(main|master)$'

while read -r local_ref _local_sha remote_ref _remote_sha; do
  if [[ "$local_ref" =~ $protected_ref || "$remote_ref" =~ $protected_ref ]]; then
    exec "$HOME/bin/freview"
  fi
done
```

Store this at `scripts/hooks/pre-push`, then install into `.git/hooks/pre-push`.

Current best example: `uncap.us`.

## Blacksmith + Vercel CI/CD

Use Blacksmith only when the repo is in an org and the Blacksmith GitHub app is installed.

Required secrets:

- `VERCEL_TOKEN`
- `VERCEL_ORG_ID`
- `VERCEL_PROJECT_ID`

Workflow shape:

1. `runs-on: blacksmith-4vcpu-ubuntu-2404` for production ships.
2. `bun install --frozen-lockfile`.
3. `bun tsc`.
4. `bun lint`.
5. `bunx --bun vercel pull --yes --environment=production --token="$VERCEL_TOKEN"`.
6. `bunx --bun vercel build --prod --token="$VERCEL_TOKEN"`.
7. `bunx --bun vercel deploy --prebuilt --prod --archive=tgz --yes --token="$VERCEL_TOKEN"`.
8. `vercel inspect --wait` + at least one production smoke URL.

Best current example: `uncap.us/.github/workflows/ship.yml`, with one fix: add explicit `bun tsc` and `bun lint` before Vercel build unless intentionally skipped for emergency deploys.

## `ship.mts` script

Every Vercel repo should expose `bun ship` for humans.

Required behavior:

- `--setup`: populate `VERCEL_ORG_ID` and `VERCEL_PROJECT_ID` from `.vercel/project.json`; set/verify `VERCEL_TOKEN`.
- `--branch`: choose ref for workflow dispatch.
- `--no-watch`: dispatch and exit.
- Default: push current branch, dispatch workflow, watch latest run.
- Fail loudly if `gh`, `.vercel/project.json`, or required secrets are missing.

Best current example: `uncap.us/scripts/ship.mts`.

## Current repo comparison

| Repo | Strongest pattern | Gaps to fix |
| --- | --- | --- |
| `uncap.us` | Blacksmith ship workflow, `ship.mts`, pre-push hook, strict Biome | Move `tsc` to `tsgo`, split lint/typecheck, add `types` + `.mts` includes |
| `bestwnc.com` | tsgo scripts, custom design lint, Vitest | Add Bun/Node types, `.mts` include, standard dev host, pre-push hook, Blacksmith ship |
| `test-create-next-app` | Clean tsgo + Biome migration template | Add `check`, `lint:fix`, pre-push hook, Blacksmith ship if production repo |
| `michaelhurley` | Strict TS, best testable dev script, clean Biome wrapper | Add `ship`, pre-push hook, Blacksmith ship |

## Default rollout order per repo

1. Snapshot current status: `git status --short --branch`, scripts, workflows.
2. Add/update `tsgo` + Biome deps.
3. Update `tsconfig.json`.
4. Add `scripts/biome-lint.mjs`.
5. Normalize package scripts.
6. Run `bun install`.
7. Run `bun tsc`, `bun lint --fix`, `bun test`.
8. Add `scripts/hooks/pre-push` and install local hook.
9. Add `scripts/ship.mts` + Blacksmith workflow for org/Vercel repos.
10. Run `bun ship --no-watch` only after secrets and Blacksmith app are confirmed.
