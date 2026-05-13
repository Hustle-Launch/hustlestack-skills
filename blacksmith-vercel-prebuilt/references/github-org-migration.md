# GitHub Org Migration for Blacksmith

Blacksmith requires repositories to live under a GitHub organization. GitHub.com organization creation is not exposed by `gh org`; `gh org` only supports listing orgs. Create the orgs in the browser first:

- `HurleyUS`
- `Hustle-Launch`, display name `Hustle Launch`

Then refresh the GitHub CLI token for org administration:

```bash
gh auth refresh -h github.com -s admin:org
```

Review the transfer plan:

```bash
/Users/michael/Projects/hustlestack-skills/blacksmith-vercel-prebuilt/assets/transfer-github-org-repos.sh --dry-run
```

Execute only after reviewing the dry run:

```bash
/Users/michael/Projects/hustlestack-skills/blacksmith-vercel-prebuilt/assets/transfer-github-org-repos.sh --execute
```

The script sends web repositories to `HurleyUS` and sends client/Hustle Launch repositories to `Hustle-Launch`. Client exceptions currently routed to `Hustle-Launch` are Kings Roofing, Jennings Custom Homes, Monarch Mountain Foundations, and App Estate Sales.

After transfers, install the Blacksmith GitHub App from `https://app.blacksmith.sh` for the target organization and grant access to the transferred repositories.
