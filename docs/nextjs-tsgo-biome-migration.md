# Next.js tsgo + Biome Migration Guide

This guide migrates a Bun-only Next.js 16+ project from ESLint/`tsc` habits to `tsgo` for TypeScript checks and Biome for linting.

The goal is a boring, repeatable gate:

```bash
bun tsc && bun lint --fix && bun test
```

For projects using docstring coverage:

```bash
bun tsc && bun lint --fix && bun lint:docs && bun test
```

## What Good Looks Like

- `bun tsc` runs `tsgo`.
- `bun lint` still works after the migration.
- `bun lint --fix` works even though Biome uses `--write`, not ESLint's `--fix`.
- `tsgo` understands Bun test files through `"types": ["bun", "node"]`.
- Old ESLint packages and config files are removed.
- Docs no longer mention `--max-warnings`.
- Verification passes without using `bun run build`.

## Install

Add Biome, Bun types, and tsgo:

```bash
bun add -d @biomejs/biome @types/bun @typescript/native-preview typescript
```

Remove ESLint packages after the replacement is working:

```bash
bun remove eslint eslint-config-next
```

Also remove project-specific ESLint plugins/configs if present:

```bash
bun remove @eslint/eslintrc @eslint/js eslint-plugin-react eslint-plugin-react-hooks eslint-plugin-jsx-a11y eslint-plugin-import
```

## Package Scripts

Use a wrapper for `bun lint` so old command muscle memory still works.

```json
{
  "scripts": {
    "tsc": "tsgo",
    "typecheck": "tsgo --noEmit",
    "lint": "bun scripts/biome-lint.mjs",
    "lint:docs": "scribe",
    "test": "bun test",
    "test:coverage": "bun test --coverage --coverage-reporter=lcov --coverage-dir=coverage",
    "format": "biome format --write ."
  }
}
```

If the project does not use `scribe`, omit `lint:docs`.

Avoid:

```json
"lint": "biome check ."
```

That works for `bun lint`, but `bun lint --fix` becomes awkward because Biome wants `--write`.

## Lint Wrapper

Create `scripts/biome-lint.mjs`:

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

Do not add compatibility handling for `--max-warnings`. That was an ESLint escape hatch, and Biome should fail loudly if old docs, aliases, or scripts still pass it.

## tsconfig

Make sure Bun and Node types are both present. This is the most common missed step; without it, `tsgo` fails on test files importing `bun:test`.

```json
{
  "compilerOptions": {
    "target": "ES2017",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "react-jsx",
    "incremental": true,
    "types": ["bun", "node"],
    "plugins": [
      {
        "name": "next"
      }
    ],
    "paths": {
      "@/*": ["./*"]
    }
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

## Biome Config

Start with a strict but practical `biome.jsonc`:

```jsonc
{
  "$schema": "https://biomejs.dev/schemas/2.4.13/schema.json",
  "vcs": {
    "enabled": true,
    "clientKind": "git",
    "useIgnoreFile": true
  },
  "files": {
    "ignoreUnknown": true,
    "includes": [
      "**",
      "!node_modules",
      "!.next",
      "!out",
      "!build",
      "!coverage",
      "!bun.lock",
      "!tsconfig.tsbuildinfo",
      "!next-env.d.ts",
      "!AUDIT.md",
      "!DEAD_CODE.md",
      "!DUPLICATION.md",
      "!HEALTH.md",
      "!REVIEW.md"
    ]
  },
  "formatter": {
    "enabled": false,
    "indentStyle": "space"
  },
  "css": {
    "parser": {
      "tailwindDirectives": true
    }
  },
  "linter": {
    "enabled": true,
    "rules": {
      "recommended": true,
      "a11y": {
        "noRedundantRoles": "off",
        "noInteractiveElementToNoninteractiveRole": "off",
        "noSvgWithoutTitle": "off",
        "useAnchorContent": "off",
        "useAriaPropsForRole": "off",
        "useAriaPropsSupportedByRole": "off",
        "useFocusableInteractive": "off",
        "useGenericFontNames": "off",
        "useKeyWithClickEvents": "off",
        "useSemanticElements": "off"
      },
      "correctness": {
        "noInvalidPositionAtImportRule": "off",
        "useHookAtTopLevel": "off",
        "useExhaustiveDependencies": "off"
      },
      "complexity": {
        "noImportantStyles": "off"
      },
      "performance": {
        "noImgElement": "off"
      },
      "security": {
        "noDangerouslySetInnerHtml": "off"
      },
      "style": {
        "noDescendingSpecificity": "off",
        "useTemplate": "off"
      },
      "suspicious": {
        "noArrayIndexKey": "off",
        "noDocumentCookie": "off",
        "noDuplicateCustomProperties": "off",
        "noDoubleEquals": "off",
        "noShadowRestrictedNames": "off"
      }
    }
  },
  "javascript": {
    "formatter": {
      "quoteStyle": "double"
    }
  },
  "assist": {
    "enabled": true,
    "actions": {
      "source": {
        "organizeImports": "off"
      }
    }
  }
}
```

Why `organizeImports` is off by default: import churn during a migration makes diffs harder to review. Turn it on later if the team wants Biome to own import ordering.

Why `formatter.enabled` is false by default: migrating lint and formatting at the same time creates noisy diffs. Turn formatting on in a separate PR.

## Delete Old ESLint Surface

Remove these if present:

```bash
rm -f eslint.config.mjs .eslintrc .eslintrc.json .eslintignore
```

Then search for old assumptions:

```bash
rg "eslint|--max-warnings|next lint|lint --fix" .
```

Update docs and agent instructions. Do not leave `--max-warnings 9999` in the recommended gate; Biome does not use it.

## Coverage Config

Bun coverage reports only files loaded by tests. If CLI wrapper scripts create noisy uncovered entrypoint lines, use file-level coverage ignores in `bunfig.toml`:

```toml
[test]
coveragePathIgnorePatterns = [
  "scripts/*.mjs",
]
```

Do not confuse this with full-project coverage. For full source-surface checks, add a separate audit like `scribe`.

## Verification

Run the migration in small, concrete passes:

```bash
bun install
bun tsc
bun lint
bun lint --fix
bun test
```

If using doc coverage:

```bash
scribe --fix
bun lint:docs
```

Final gate:

```bash
bun tsc && bun lint --fix && bun lint:docs && bun test
```

If the project does not use doc coverage:

```bash
bun tsc && bun lint --fix && bun test
```

## Common Failures

### `Cannot find module 'bun:test'`

Add Bun types to `tsconfig.json`:

```json
"types": ["bun", "node"]
```

### `bun lint --fix` does nothing useful

Use the wrapper. Biome's write flag is `--write`, not `--fix`.

### Biome scans generated files

Add generated outputs to `files.includes` exclusions:

```jsonc
"!coverage",
"!.next",
"!build",
"!out",
"!tsconfig.tsbuildinfo"
```

### Huge formatting diff

Disable Biome formatting during the migration:

```jsonc
"formatter": {
  "enabled": false
}
```

Run formatting as a separate commit or PR.

### Agent docs still say `bun run build`

For this stack, do not use `bun run build` as the migration verification signal. Use:

```bash
bun tsc && bun lint --fix && bun test
```

## Migration Checklist

- [ ] Install `@biomejs/biome`, `@types/bun`, `@typescript/native-preview`.
- [ ] Add `tsc`, `typecheck`, `lint`, `test`, and `format` scripts.
- [ ] Add `scripts/biome-lint.mjs`.
- [ ] Add `biome.jsonc`.
- [ ] Add `"types": ["bun", "node"]` to `tsconfig.json`.
- [ ] Remove ESLint packages.
- [ ] Delete ESLint config files.
- [ ] Remove `--max-warnings` from docs and scripts.
- [ ] Run `bun tsc`.
- [ ] Run `bun lint --fix`.
- [ ] Run `bun test`.
- [ ] Run Fallow or the repo's review tool if configured.
