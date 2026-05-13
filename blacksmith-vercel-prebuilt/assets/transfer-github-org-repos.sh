#!/usr/bin/env bash
set -euo pipefail

# Dry-run by default. Pass --execute to call the GitHub transfer API.
mode="${1:---dry-run}"
if [[ "$mode" != "--dry-run" && "$mode" != "--execute" ]]; then
  echo "usage: $0 [--dry-run|--execute]" >&2
  exit 2
fi

source_owner="${SOURCE_OWNER:-michaelmonetized}"

require_org() {
  local org="$1"
  if ! gh api "orgs/${org}" >/dev/null 2>&1; then
    echo "missing or inaccessible org: ${org}" >&2
    echo "create it in GitHub first, then run: gh auth refresh -h github.com -s admin:org" >&2
    exit 1
  fi
}

transfer_repo() {
  local repo="$1"
  local owner="$2"

  if ! gh repo view "${source_owner}/${repo}" >/dev/null 2>&1; then
    echo "skip missing source repo: ${source_owner}/${repo}" >&2
    return 0
  fi

  echo "${source_owner}/${repo} -> ${owner}/${repo}"
  if [[ "$mode" == "--execute" ]]; then
    gh api --method POST "repos/${source_owner}/${repo}/transfer" -f "new_owner=${owner}" >/dev/null
  fi
}

hurleyus_repos=(
  "uncap.us"
  "reaferral"
  "canaveral"
  "svganimator"
  "bestwnc.com"
  "test-create-next-app"
  "michaelhurley"
  "prosthetics-ecommerce-pilot"
  "hurleyus.com"
  "getat.me"
  "citation-manager"
  "hurleyus-sop"
  "yacnat8"
  "yacnat7"
  "yacnat6"
  "nextjs-clean-start"
  "mockup-gallery"
  "ileague.golf"
  "itour.golf"
  "merchwinner.com"
  "hurley-mission-control"
  "codemail"
  "cravees.com"
  "wnchistorytours.com"
  "bestjeepdecals.com"
  "santabox.org"
  "s12.in"
  "waynesville.yourzaxbys.com"
  "coordinatorapp.com"
  "www.yourzaxbys.com"
  "delaterrestore"
  "djsidethree.com"
  "thenationalnc.com"
  "barbquewagon.com"
  "michaelchurley.com"
  "www.mybathroomconversion.com"
  "getfarmin.com"
  "breazyapp.com"
  "everythingmonetized.com"
  "iPro-main-web"
  "ileague-app"
  "SalesPromis"
  "getatme.com"
  "convex-nextfaster"
  "HurleyUS"
)

hustlelaunch_repos=(
  "www.hustlelaunch.com"
  "migrate--www.hustlelaunch.com"
  "my.hustlelaunch.com"
  "my-hustle-launch"
  "my-hustle-launch-native"
  "mobile.hustlelaunch.com"
  "hustlestack"
  "hustlestack-skills"
  "hustlestack-starter"
  "hustlestack-template"
  "hustlemail"
  "hustle-prospect"
  "hustlepay.com"
  "hustlepay"
  "hustlelaunch-assessors"
  "hustle"
  "hustle-launch-socials"
  "hl-webhooks"
  "hl-social-cli"
  "hustle-launch-dark-plus"
  "cursor-tutor-hl"
  "account.hustlelaunch.com"
  "hustle-launch-booking"
  "app.hustlelaunch.com"
  "hustle-launch-pro-slate"
  "hustlecrm.com"
  "hustleforms.com"
  "hustlechat.com"
  "hustleconvert.com"
  "hustledesk.com"
  "kingsroofingnc.com"
  "jenningscustomhomes"
  "appestatesales-com"
  "monarchmountainfoundations.com"
)

review_before_transfer=(
  "Jennings Custom Homes has a local path, but the GitHub repo appears to be jenningscustomhomes."
  "appestatesales local path was not found; GitHub repo appears to be appestatesales-com."
  "delaterrestore local path maps to GitHub repo delaterrestore, while local path is delaterrestore.com."
  "djsideThree.com local path maps to GitHub repo djsidethree.com."
  "Zaxbys and bathroom conversion repos are included under hurleyus because only kings/jennings/monarch/appestatesales were excluded."
)

echo "mode: ${mode}"
echo "source owner: ${source_owner}"
printf 'review: %s\n' "${review_before_transfer[@]}"

require_org "HurleyUS"
require_org "Hustle-Launch"

echo
echo "HurleyUS transfers:"
for repo in "${hurleyus_repos[@]}"; do
  transfer_repo "$repo" "HurleyUS"
done

echo
echo "Hustle Launch transfers:"
for repo in "${hustlelaunch_repos[@]}"; do
  transfer_repo "$repo" "Hustle-Launch"
done
