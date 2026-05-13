# Operational Notes

## Disable Duplicate Vercel Builds

Prebuilt deploys only save Vercel build minutes when Vercel does not also run its Git integration build for the same push.

Options:

- Disable automatic deployments in Vercel project Git settings.
- Configure an ignored build step in Vercel that ignores Git-triggered builds.
- Keep Git integration for production only and use Blacksmith for preview deploys, if that is the intended tradeoff.

## GitHub Actions Billing

Blacksmith replaces the runner for GitHub Actions jobs, but GitHub Actions still orchestrates workflows. Use `runs-on: blacksmith-*`; do not use `ubuntu-latest` if the goal is avoiding GitHub-hosted runner minutes.

## Vercel System Env Caveat

`vercel deploy --prebuilt` deploys output from an earlier `vercel build`. Vercel system environment variables are not automatically present at build time in the same way as Git-based Vercel builds. If the app needs values like commit SHA, branch, deployment URL, or Vercel system vars during build, provide equivalents through GitHub Actions env or avoid prebuilt for that project.

## Recommended Default

For Next.js/Vercel apps:

1. Use `blacksmith-2vcpu-ubuntu-2404` first.
2. Run `bun install --frozen-lockfile`, `bun tsc`, `bun lint`.
3. Run `vercel pull`, `vercel build`, `vercel deploy --prebuilt --archive=tgz`.
4. Add higher-vCPU runners only after measuring build time.
