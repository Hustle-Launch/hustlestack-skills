---
name: hustlelaunch-sales
description: HustleLaunch Pro Sales Acquisition Agent - automated lead management, outreach, and CRM updates via Notion API.
env:
  required:
    - NOTION_API_KEY
  optional:
    - RESEND_API_KEY
---

# HustleLaunch Sales Acquisition Agent

Automated sales prospecting and lead management for HustleLaunch.com

## CLI Tools

```bash
# Full assessment suite (all 4 assessments)
hl-assess <url>                    # Returns JSON with scores + issues

# Growth plan generator
hl-growth-plan --company "Name" --industry "type" --location "City, ST" \
  --url "https://..." --dm "Decision Maker" --phone "555-1234" \
  [--assessment data.json] [-o output.html]

# Industries: wildlife, home-services, appliance, laboratory, medical, legal, restaurant, real-estate

# Pipeline automation
hl-pipeline assess <notion-lead-id>   # Assess single lead, update CRM
hl-pipeline batch-assess              # Assess all leads missing scores (max 10)
hl-pipeline generate <notion-lead-id> # Generate growth plan for lead
hl-pipeline report                    # Daily pipeline report
```

## Overview

This skill powers an AI sales agent that:
1. **Assesses leads automatically** — runs 4-point assessment on every website
2. **Generates growth plans** — branded PDFs with Day 1/Week 1/Month 1/Q1/Year 1 roadmaps
3. Monitors email for lead replies
4. Updates lead status in Notion CRM
5. Discovers missing contact info
6. Performs first-touch outreach with assessment insights
7. Follows up on stale leads
8. Tracks payments and closes
9. Generates daily call sheets with prioritized hot leads

## CRM Database Fields

The Notion CRM must have these fields:
- **Company Name** (title)
- **Status** (select): Lead, Contacted, Meeting Scheduled, Proposal Sent, Negotiating, Closed Won, Closed Lost
- **Temperature** (select): Cold, Warm, Hot
- **Decision Maker Name** (text)
- **Decision Maker Email** (email)
- **Decision Maker Phone** (phone)
- **Company Website** (url)
- **Company Phone** (phone)
- **Company Address** (text)
- **First Touch Date** (date)
- **Last Touch Date** (date)
- **Close Probability %** (number)
- **Cycle Progress** (select): Discovery, Qualification, Proposal, Negotiation, Closing
- **Technical SEO Score** (number 0-100)
- **Local SEO Score** (number 0-100)
- **Marketing Health Score** (number 0-100)
- **Web Design Score** (number 0-100)
- **Growth Plan Link** (url)
- **Communication Notes** (rich text)

## 10-Minute Cycle Tasks

### 1. Check Email for Replies
```bash
# Check inbox, spam, archive for replies from leads
gog gmail search 'newer_than:1d (in:inbox OR in:spam OR in:all)' --account support@hustlelaunch.com
```

Match sender email against CRM leads. If match found:
- Update Status to appropriate value
- Update Temperature (replied = Warm/Hot)
- Update Last Touch Date
- Add reply summary to Communication Notes

### 2. Enrich Missing Contact Info
For leads missing decision maker info:
- Search company website for contact page
- Check LinkedIn (via search)
- Look for email patterns
- Update CRM with found info

### 3. Run Assessments
For leads missing scores, run:
```bash
technical-seo-assessor <website>
local-seo-assessor <website>
marketing-health-assessor <website>
webdesign-assessor <website>
```
Update CRM with scores.

### 4. First Touch Outreach
For leads with Status = "Lead" and no First Touch Date:

**Email Template (MUST BE SHORT):**
```
Subject: Quick thought on [Company Name]'s [specific issue from assessment]

Hi [First Name],

Noticed [one sharp detail from assessment they'd care about].

Worth a 15-min call to see if we can help?

— Michael
HustleLaunch.com
```

After sending:
- Update Status → "Contacted"
- Set First Touch Date
- Set Last Touch Date
- Add to Communication Notes

### 5. Second Touch (7-day follow-up)
For leads where:
- Status = "Contacted"
- Last Touch Date > 7 days ago
- No reply received

**Follow-up Template:**
```
Subject: Re: Quick thought on [Company Name]'s [original issue]

Hi [First Name],

Following up on my note last week about [issue].

Happy to share what I found — just reply "yes" if interested.

— Michael
```

Update Last Touch Date after sending.

### 6. Discover New Leads
Search for businesses similar to current leads:
- Same industry
- Same location
- Similar size

Add to CRM with Status = "Lead", Temperature = "Cold"

### 7. Process Payment Emails
Check for Stripe/payment notifications:
```bash
gog gmail search 'newer_than:1d (from:stripe subject:payment OR subject:invoice)'
```

If payment matches a lead:
- Update Status → "Closed Won"
- Create client record in Notion > Hustle Launch > Clients

### 8. Generate Daily Call Sheet
At end of cycle, if not sent today:

Email to michael@hurleyus.com:
```
Subject: HustleLaunch Call Sheet - [Date]

HOT LEADS (reply today):
1. [Company] - [Decision Maker] - [Phone] - [Key detail]

WARM LEADS (follow up this week):
1. [Company] - [Decision Maker] - [Phone] - [Key detail]

NEW LEADS (first touch needed):
1. [Company] - [Website] - [Scores summary]

ASSESSMENT LINKS:
- [Company] Growth Plan: [link]
```

## Guardrails

1. **Max 5 first touches per cycle** - Don't spam
2. **Max 3 follow-ups per lead** - Know when to stop
3. **Never email on weekends** - Respect boundaries
4. **Always personalize** - Use assessment data
5. **Log everything** - Communication Notes must track all touches
6. **Human escalation** - Flag hot leads for Michael's attention

## API Reference

### Notion CRM Query
```bash
NOTION_KEY=$(cat ~/.config/notion/api_key)
curl -X POST "https://api.notion.com/v1/data_sources/{CRM_ID}/query" \
  -H "Authorization: Bearer $NOTION_KEY" \
  -H "Notion-Version: 2025-09-03" \
  -H "Content-Type: application/json" \
  -d '{
    "filter": {"property": "Status", "select": {"equals": "Lead"}}
  }'
```

### Update Lead
```bash
curl -X PATCH "https://api.notion.com/v1/pages/{page_id}" \
  -H "Authorization: Bearer $NOTION_KEY" \
  -H "Notion-Version: 2025-09-03" \
  -H "Content-Type: application/json" \
  -d '{
    "properties": {
      "Status": {"select": {"name": "Contacted"}},
      "First Touch Date": {"date": {"start": "2026-02-17"}},
      "Last Touch Date": {"date": {"start": "2026-02-17"}}
    }
  }'
```

### Send Email
```bash
gog gmail send \
  --to "lead@company.com" \
  --subject "Quick thought on Company's SEO" \
  --body "Email content here" \
  --account support@hustlelaunch.com
```

## Environment Variables

- `NOTION_API_KEY` - Notion integration key
- `RESEND_API_KEY` - For backup email sending
- `CRM_DATABASE_ID` - `30ac8208-d2ce-8166-a0e2-dd0d450e840a`
- `CLIENTS_DATABASE_ID` - Notion Clients database ID (TBD)
