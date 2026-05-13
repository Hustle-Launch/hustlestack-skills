---
name: blacksmith-vercel-prebuilt
description: Set up GitHub Actions on Blacksmith runners to run checks, build with `vercel build`, and deploy prebuilt output to Vercel with `vercel deploy --prebuilt`. Use when reducing Vercel build minutes, replacing GitHub-hosted Actions runners, or creating CI/CD workflows for Next.js/Vercel projects.
---

# Blacksmith + Vercel Prebuilt Deploys

Use this when a project should stop spending Vercel build minutes and run CI/builds on Blacksmith GitHub Actions runners instead.

## Hard Blockers

Before editing workflows, verify:

```bash
gh repo view --json nameWithOwner,isInOrganization,owner
command -v blacksmith || true
```

Blacksmith runners require the Blacksmith GitHub App to be installed from `https://app.blacksmith.sh`. Blacksmith currently supports GitHub organizations, not personal repositories. If `isInOrganization` is `false`, tell the user the repo must move to an org or Blacksmith cannot run jobs for it.

Do not add `runs-on: blacksmith-*` to a repo until the Blacksmith app has access; jobs may queue indefinitely.

If a project is still under a personal account, use `references/github-org-migration.md` and `assets/transfer-github-org-repos.sh` to prepare a dry-run transfer plan. GitHub.com organization creation must happen in the browser; `gh org` cannot create orgs.

## Required Secrets

GitHub repository or org secrets:

- `VERCEL_TOKEN`
- `VERCEL_ORG_ID`
- `VERCEL_PROJECT_ID`

Get Vercel IDs from `.vercel/project.json` when present:

```bash
cat .vercel/project.json
```

Create `VERCEL_TOKEN` in Vercel account settings. Do not commit it.

## Vercel Build Pattern

Use Vercel’s Build Output API path:

```bash
bunx --bun vercel pull --yes --environment=production --token="$VERCEL_TOKEN"
bunx --bun vercel build --prod --token="$VERCEL_TOKEN"
bunx --bun vercel deploy --prebuilt --prod --archive=tgz --token="$VERCEL_TOKEN"
```

Do not use plain `next build` for Vercel prebuilt deploys. `vercel build` creates `.vercel/output`, which `vercel deploy --prebuilt` uploads.

## Workflow Choice

Use `assets/vercel-prebuilt-blacksmith.yml` for production deploys from `main`.

Use `assets/vercel-preview-blacksmith.yml` when preview deployments are wanted for PRs. If the user is trying to reduce cost aggressively, prefer production-only first and disable Vercel Git auto-deploys/preview deploys in Vercel project settings.

## Setup Steps

1. Confirm repo is in a GitHub organization.
2. Ask user to install Blacksmith from `https://app.blacksmith.sh` if not already installed.
3. Add required GitHub secrets.
4. Copy the relevant workflow asset to `.github/workflows/`.
5. Disable or ignore Vercel Git auto-deploys, otherwise Git pushes will still trigger Vercel builds and waste build minutes.
6. Push a branch and verify the Blacksmith job starts.
7. Confirm Vercel deployment was created by `vercel deploy --prebuilt`, not the Git integration.

## Validation

After setup:

```bash
gh run list --limit 5
gh run view --log
```

Check Vercel deployment metadata. A successful prebuilt workflow should show the GitHub Actions job deploying, while Vercel’s Git integration should not run a separate build for the same commit.

## Cost Notes

Blacksmith provides free x64 2vCPU minutes per organization and lower per-minute rates than GitHub-hosted runners. It reduces Vercel build-machine usage only if Vercel Git auto-builds are disabled or ignored.

Runtime costs on Vercel remain: functions, bandwidth, image optimization, logs, storage, and other platform usage are unaffected by prebuilt deploys.
