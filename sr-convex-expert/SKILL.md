---
name: sr-convex-expert
description: Senior-level Convex expertise across all platforms. Use when designing schemas, implementing queries/mutations/actions, deploying to production, integrating with Next.js/React Native/Swift, or debugging Convex issues. Covers real-time subscriptions, auth patterns, file storage, migrations, and the critical deployment workflow.
env:
  required:
    - CONVEX_DEPLOYMENT
    - NEXT_PUBLIC_CONVEX_URL
  optional:
    - CONVEX_DEPLOY_KEY
    - CLERK_JWT_ISSUER_DOMAIN
---

> **Global Standards:** See [../STANDARDS.md](../STANDARDS.md) for icon library and other cross-platform standards.

# Senior Convex Expert

You are a senior engineer building production applications with Convex. This skill covers schema design, function patterns, deployment workflows, and platform-specific integrations.

---

## ⚠️ CRITICAL: DEPLOYMENT COMMANDMENTS

These rules prevent production disasters. Violations cause broken builds and data loss.

| # | Commandment | Violation Consequence |
|---|-------------|----------------------|
| I | Use `--cmd` wrapper for Next.js deploys | Types not generated, build fails |
| II | Never change field types without migration | Runtime errors, data corruption |
| III | Index every query filter field | Slow queries, timeouts |
| IV | Use `v.optional()` for new fields | Existing documents break |
| V | Run `convex dev --once` before local dev | Stale types, TypeScript errors |
| VI | Use internal functions for sensitive logic | Security bypass |
| VII | Store secrets in Convex dashboard, not code | Credential leaks |
| VIII | Test migrations in preview deployment first | Production data loss |
| IX | Use `_id` not `id` for document references | Type errors, query failures |
| X | Use `_creationTime` not `createdAt` | Redundant field, wasted storage |

---

## ⚠️ BUILT-IN FIELDS — NEVER DEFINE THESE

Convex automatically provides on EVERY document:
- `_id` — Document ID (type: `Id<"tableName">`)
- `_creationTime` — Unix timestamp when created (milliseconds)

**❌ WRONG:**
```typescript
users: defineTable({
  id: v.string(),           // WRONG - Convex provides _id
  createdAt: v.number(),    // WRONG - Convex provides _creationTime
})
```

**✅ CORRECT:**
```typescript
users: defineTable({
  clerkId: v.string(),
  email: v.string(),
  // _id and _creationTime are automatic - don't define them!
})

// Access them like any other field:
const user = await ctx.db.get(args.userId);  // userId is Id<"users">
console.log(user._id, user._creationTime);
```

**If you need `updatedAt`**, define it explicitly (Convex doesn't auto-track updates):
```typescript
users: defineTable({
  email: v.string(),
  updatedAt: v.optional(v.number()),
})

// Update it manually in mutations:
await ctx.db.patch(userId, {
  email: newEmail,
  updatedAt: Date.now(),
});
```

---

## Quick Reference

### Project Structure
```
your-app/
├── convex/
│   ├── _generated/         # Auto-generated (don't edit)
│   │   ├── api.d.ts        # Type-safe function references
│   │   ├── dataModel.d.ts  # Schema types
│   │   └── server.d.ts     # Server utilities
│   ├── schema.ts           # Database schema
│   ├── auth.config.ts      # Auth provider config
│   ├── crons.ts            # Scheduled jobs
│   ├── http.ts             # HTTP routes (optional)
│   ├── [feature].ts        # Feature modules
│   └── tsconfig.json       # Convex TypeScript config
├── app/                    # Next.js app
│   └── providers.tsx       # ConvexProvider setup
└── package.json
```

### The ONLY Correct Deploy Command (Next.js)
```json
{
  "scripts": {
    "dev": "npx convex dev --once && next dev --turbopack",
    "build": "npx convex deploy --yes --cmd 'bun run build:next'",
    "build:next": "next build"
  }
}
```

**Why `--cmd` wrapper?**
1. `convex deploy` pushes functions to Convex cloud
2. `--cmd 'bun run build:next'` runs AFTER types are generated
3. Next.js build sees correct `_generated/` types
4. Without this: build uses stale/missing types → runtime errors

### Environment Variables

| Variable | Where | Purpose |
|----------|-------|---------|
| `CONVEX_DEPLOYMENT` | CI/CD only | Deployment target (e.g., `your-project-abc123`) |
| `NEXT_PUBLIC_CONVEX_URL` | Client + Server | Convex endpoint URL |
| `CONVEX_DEPLOY_KEY` | CI/CD only | Auth for `convex deploy` |
| `CLERK_JWT_ISSUER_DOMAIN` | Server only | Clerk auth validation |

**Local Development:**
```bash
# .env.local (auto-created by `npx convex dev`)
CONVEX_DEPLOYMENT=dev:your-team:your-project
NEXT_PUBLIC_CONVEX_URL=https://your-project.convex.cloud
```

**Production (Vercel):**
```bash
# Set via dashboard or CLI
vercel env add CONVEX_DEPLOYMENT production
vercel env add CONVEX_DEPLOY_KEY production
```

---

## Function Types

### Query (Read Data)
```typescript
import { v } from "convex/values";
import { query } from "./_generated/server";

// Public query - exposed to clients
export const getProfile = query({
  args: { userId: v.string() },
  handler: async (ctx, args) => {
    return await ctx.db
      .query("profiles")
      .withIndex("by_clerk", (q) => q.eq("clerkId", args.userId))
      .first();
  },
});

// Authenticated query
export const getMyProfile = query({
  args: {},
  handler: async (ctx) => {
    const identity = await ctx.auth.getUserIdentity();
    if (!identity) return null;

    return await ctx.db
      .query("profiles")
      .withIndex("by_clerk", (q) => q.eq("clerkId", identity.subject))
      .first();
  },
});
```

### Mutation (Write Data)
```typescript
import { v } from "convex/values";
import { mutation } from "./_generated/server";

export const createProfile = mutation({
  args: {
    name: v.string(),
    email: v.optional(v.string()),
  },
  handler: async (ctx, args) => {
    const identity = await ctx.auth.getUserIdentity();
    if (!identity) throw new Error("Unauthorized");

    // _creationTime is automatic - don't define createdAt
    return await ctx.db.insert("profiles", {
      clerkId: identity.subject,
      name: args.name,
      email: args.email,
      // Only define updatedAt if you need to track modifications
      updatedAt: Date.now(),
    });
  },
});
```

### Action (External APIs, Side Effects)
```typescript
import { v } from "convex/values";
import { action } from "./_generated/server";
import { api } from "./_generated/api";

export const sendEmail = action({
  args: {
    to: v.string(),
    subject: v.string(),
    body: v.string(),
  },
  handler: async (ctx, args) => {
    // Actions can call external APIs
    const response = await fetch("https://api.resend.com/emails", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${process.env.RESEND_API_KEY}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        from: "noreply@example.com",
        to: args.to,
        subject: args.subject,
        html: args.body,
      }),
    });

    // Actions can call mutations/queries
    await ctx.runMutation(api.notifications.markSent, {
      email: args.to,
    });

    return response.ok;
  },
});
```

### Internal Functions (Server-Only)
```typescript
import { internalMutation, internalQuery, internalAction } from "./_generated/server";
import { internal } from "./_generated/api";

// Not exposed to clients - only callable from other functions
export const processWebhook = internalMutation({
  args: { payload: v.any() },
  handler: async (ctx, args) => {
    // Process sensitive data
  },
});

// Call internal function from action
export const handleStripeWebhook = action({
  args: { payload: v.string() },
  handler: async (ctx, args) => {
    // Verify webhook signature...
    await ctx.runMutation(internal.billing.processWebhook, {
      payload: JSON.parse(args.payload),
    });
  },
});
```

### HTTP Actions (Webhooks, Custom Endpoints)
```typescript
// convex/http.ts
import { httpRouter } from "convex/server";
import { httpAction } from "./_generated/server";
import { internal } from "./_generated/api";

const http = httpRouter();

http.route({
  path: "/webhooks/stripe",
  method: "POST",
  handler: httpAction(async (ctx, request) => {
    const signature = request.headers.get("stripe-signature");
    const body = await request.text();

    // Verify signature
    // ...

    await ctx.runMutation(internal.billing.processWebhook, {
      payload: JSON.parse(body),
    });

    return new Response("OK", { status: 200 });
  }),
});

export default http;
```

### Scheduled Functions (Cron Jobs)
```typescript
// convex/crons.ts
import { cronJobs } from "convex/server";
import { internal } from "./_generated/api";

const crons = cronJobs();

// Every hour
crons.interval(
  "process-queue",
  { minutes: 60 },
  internal.workers.processQueue
);

// Cron syntax: minute hour day month weekday
crons.cron(
  "daily-cleanup",
  "0 3 * * *",  // 3 AM daily
  internal.maintenance.cleanup
);

crons.cron(
  "weekly-digest",
  "0 9 * * 1",  // Monday 9 AM
  internal.email.sendWeeklyDigest
);

export default crons;
```

---

## Auth Integration (Clerk)

### Config File
```typescript
// convex/auth.config.ts
export default {
  providers: [
    {
      domain: process.env.CLERK_JWT_ISSUER_DOMAIN,
      applicationID: "convex",
    },
  ],
};
```

### Auth Pattern in Functions
```typescript
export const getMyData = query({
  args: {},
  handler: async (ctx) => {
    const identity = await ctx.auth.getUserIdentity();
    if (!identity) return null;

    // identity.subject = Clerk user ID
    // identity.email = User's email
    // identity.name = User's name
    
    const profile = await ctx.db
      .query("profiles")
      .withIndex("by_clerk", (q) => q.eq("clerkId", identity.subject))
      .first();

    return profile;
  },
});

export const requireAuth = mutation({
  args: {},
  handler: async (ctx) => {
    const identity = await ctx.auth.getUserIdentity();
    if (!identity) {
      throw new Error("Unauthorized");
    }
    // Continue with authenticated logic
  },
});
```

---

## File Storage

### Upload Flow
```typescript
// 1. Generate upload URL (mutation)
export const generateUploadUrl = mutation({
  args: {},
  handler: async (ctx) => {
    return await ctx.storage.generateUploadUrl();
  },
});

// 2. Store file reference (mutation)
export const saveFile = mutation({
  args: {
    storageId: v.id("_storage"),
    filename: v.string(),
  },
  handler: async (ctx, args) => {
    const identity = await ctx.auth.getUserIdentity();
    if (!identity) throw new Error("Unauthorized");

    return await ctx.db.insert("files", {
      storageId: args.storageId,
      filename: args.filename,
      uploadedBy: identity.subject,
      uploadedAt: Date.now(),
    });
  },
});

// 3. Get file URL (query)
export const getFileUrl = query({
  args: { storageId: v.id("_storage") },
  handler: async (ctx, args) => {
    return await ctx.storage.getUrl(args.storageId);
  },
});
```

### Client Upload (React)
```tsx
const generateUploadUrl = useMutation(api.files.generateUploadUrl);
const saveFile = useMutation(api.files.saveFile);

async function uploadFile(file: File) {
  // Get signed URL
  const uploadUrl = await generateUploadUrl();
  
  // Upload to Convex storage
  const result = await fetch(uploadUrl, {
    method: "POST",
    headers: { "Content-Type": file.type },
    body: file,
  });
  
  const { storageId } = await result.json();
  
  // Save reference in database
  await saveFile({ storageId, filename: file.name });
}
```

---

## Pagination

### Cursor-Based Pagination
```typescript
export const listItems = query({
  args: {
    cursor: v.optional(v.string()),
    limit: v.optional(v.number()),
  },
  handler: async (ctx, args) => {
    const limit = args.limit ?? 20;

    const results = await ctx.db
      .query("items")
      .order("desc")
      .paginate({ numItems: limit, cursor: args.cursor ?? null });

    return {
      items: results.page,
      nextCursor: results.continueCursor,
      hasMore: !results.isDone,
    };
  },
});
```

### Client Usage
```tsx
function ItemList() {
  const [cursor, setCursor] = useState<string | undefined>();
  const result = useQuery(api.items.listItems, { cursor, limit: 20 });

  return (
    <>
      {result?.items.map(item => <Item key={item._id} {...item} />)}
      {result?.hasMore && (
        <button onClick={() => setCursor(result.nextCursor)}>
          Load More
        </button>
      )}
    </>
  );
}
```

---

## Platform Integrations

See detailed guides:
- [NEXT.md](./NEXT.md) — Next.js App Router patterns
- [REACT-NATIVE.md](./REACT-NATIVE.md) — Mobile considerations
- [SWIFT.md](./SWIFT.md) — Native iOS/macOS via HTTP

---

## Migrations

### Safe Schema Changes

**✅ Safe (additive):**
```typescript
// Add new optional field
profiles: defineTable({
  existingField: v.string(),
  newField: v.optional(v.string()),  // Safe!
})

// Add new index
.index("new_index", ["field"])  // Safe!

// Add new table
newTable: defineTable({ ... })  // Safe!
```

**⚠️ Unsafe (breaking):**
```typescript
// Change field type (BREAKS existing docs)
// oldField: v.string(),
newField: v.number(),  // DANGER!

// Remove required field (BREAKS existing docs)
// requiredField: v.string(),  // REMOVED = DANGER!

// Rename field (old data has wrong name)
// oldName: v.string(),
newName: v.string(),  // DANGER! Old docs still have oldName
```

### Migration Pattern
```typescript
// 1. Add new field as optional
profiles: defineTable({
  oldField: v.string(),
  newField: v.optional(v.string()),  // Step 1
})

// 2. Run migration to backfill
export const migrateProfiles = internalMutation({
  args: {},
  handler: async (ctx) => {
    const profiles = await ctx.db.query("profiles").collect();
    for (const profile of profiles) {
      if (profile.newField === undefined) {
        await ctx.db.patch(profile._id, {
          newField: computeNewValue(profile.oldField),
        });
      }
    }
  },
});

// 3. After migration completes, make field required
profiles: defineTable({
  oldField: v.string(),
  newField: v.string(),  // Now required (step 3)
})

// 4. Eventually remove old field (optional)
```

---

## Common Errors & Fixes

| Error | Cause | Fix |
|-------|-------|-----|
| `Document does not match schema` | Missing required field | Add field with `v.optional()` first |
| `Index not found` | Query on unindexed field | Add index to schema |
| `Cannot find module '_generated'` | Types not generated | Run `npx convex dev --once` |
| `Unauthorized` | Missing/invalid JWT | Check Clerk config, token expiry |
| `Function not found` | Function not exported | Ensure `export const` |
| `Action timeout` | Long-running action | Use scheduled functions instead |
| `Query returned too many documents` | No pagination | Add `.take(n)` or `.paginate()` |

---

## Verification Checklist

Before deploying:

- [ ] Schema has indexes for all filtered/sorted fields
- [ ] New fields are `v.optional()` or have migrations
- [ ] Auth checks in all mutations that modify user data
- [ ] Internal functions for sensitive operations
- [ ] `--cmd` wrapper in build script
- [ ] Environment variables set in production
- [ ] Test in preview deployment first

---

## Related Skills

- See [SCHEMA-PATTERNS.md](./SCHEMA-PATTERNS.md) for schema design
- See [FUNCTION-PATTERNS.md](./FUNCTION-PATTERNS.md) for function implementations
- Use `/sr-next-clerk-expert` for Clerk-specific patterns
- Use `/sr-production-engineer` for deployment workflow
