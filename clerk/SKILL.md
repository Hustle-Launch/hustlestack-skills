---
name: clerk
description: Clerk authentication for Next.js. Use when setting up Clerk auth, protecting routes, or configuring sign-in. Includes proxy.ts migration (middleware.ts is DEPRECATED in Next.js 16+).
---

# Clerk + Next.js

---

## ⚠️ IMPORTANT: READ THIS FIRST ⚠️

**DO NOT DO ANYTHING WITH CLERK UNLESS YOU HAVE READ AND UNDERSTAND EXACTLY HOW CLERK WORKS BY FOLLOWING ALL THE RULES IN THIS DOCUMENT TO A TEE AND HAVE VERIFIED THAT THE WORK YOU HAVE DONE FOLLOWS THESE RULES AS IF GOD HIMSELF ETCHED THEM ONTO STONE BLOCKS AND WOULD VAPORIZE YOU ONE BIT AT A TIME IN A SLOW AND PAINFUL PROCESS OVER EONS IF EVEN THE SLIGHTEST DEVIATION IS MADE IN THE CODE PRODUCED!!!**

---

# _***The Twelve Clerk/Next.js Commandments***_

### I. Thou Shalt Use Route Groups
Protected routes go in `app/(private)/`. Public routes stay in `app/` or `app/(public)/`. This is the ONLY correct pattern.

### II. Thou Shalt Keep proxy.ts Simple
`proxy.ts` protects ONLY the `/(private)` route group. It shall NOT enumerate every public route like a caveman.

### III. Thou Shalt NEVER Call `auth()` on Public Routes
The homepage, marketing pages, pricing, about, blog — these are PUBLIC. No `auth()`, no `await auth()`, no server-side auth checks. EVER.

### IV. Thou Shalt Use Client Components for Conditional Auth Content
Need signed-in content on a public page? Use `<SignedIn>` and `<SignedOut>` from `@clerk/nextjs`. NOT server-side auth checks.

### V. Thou Shalt Always Wrap Clerk Components with `<ClerkLoaded>`
Every Clerk component (`<SignedIn>`, `<SignedOut>`, `<UserButton>`, etc.) MUST be wrapped in `<ClerkLoaded>`.

### VI. Thou Shalt Always Pair `<ClerkLoaded>` with `<ClerkLoading>`
Show a loading state while Clerk initializes. No flash of unauthenticated content.

### VII. Thou Shalt Configure Redirects in ClerkProvider
`afterSignInUrl`, `afterSignUpUrl`, `signInUrl`, `signUpUrl` — set these in `<ClerkProvider>`, NOT with `auth()` redirects.

### VIII. Thou Shalt Not Cause Handshake Redirects on Public Pages
If you see `?__clerk_handshake=` in URLs on public pages, YOU HAVE SINNED. Fix the auth check.

### IX. Thou Shalt Keep Marketing Pages Lightning Fast
Public pages should be STATIC. No server-side auth, no dynamic rendering for auth state. Static. Fast. SEO-friendly.

### X. Thou Shalt Verify Environment Variables Match Exactly
Copy-paste from Clerk dashboard. One wrong character (`x` vs `X`) breaks everything with cryptic 500 errors.

### XI. Thou Shalt Use `proxy.ts` NOT `middleware.ts`
Next.js 16+ deprecated `middleware.ts`. Rename it or face the warning.

### XII. Thou Shalt Test as an Anonymous User
Before deploying, open incognito and verify ALL public pages load without auth prompts or errors.

---

## Correct Project Structure

```
app/
├── (private)/           # ← Protected routes (requires auth)
│   ├── dashboard/
│   │   └── page.tsx
│   ├── settings/
│   │   └── page.tsx
│   └── layout.tsx       # Can have auth checks here
├── (public)/            # ← Optional group for marketing
│   ├── about/
│   │   └── page.tsx
│   └── pricing/
│       └── page.tsx
├── page.tsx             # Homepage - PUBLIC, no auth
├── layout.tsx           # Root layout with ClerkProvider
├── sign-in/
│   └── [[...sign-in]]/
│       └── page.tsx
└── sign-up/
    └── [[...sign-up]]/
        └── page.tsx
```

---

## The ONLY Correct proxy.ts

```typescript
// proxy.ts
import { clerkMiddleware, createRouteMatcher } from "@clerk/nextjs/server";

// ONLY protect the (private) route group
const isPrivateRoute = createRouteMatcher(["/(private)(.*)"]);

export default clerkMiddleware(async (auth, request) => {
  if (isPrivateRoute(request)) {
    await auth.protect();
  }
});

export const config = {
  matcher: [
    "/((?!_next|[^?]*\\.(?:html?|css|js(?!on)|jpe?g|webp|png|gif|svg|ttf|woff2?|ico|csv|docx?|xlsx?|zip|webmanifest)).*)",
    "/(api|trpc)(.*)",
  ],
};
```

**That's it.** No listing every public route. No inverted logic. Simple.

---

## Public Page with Conditional Auth Content

```tsx
// app/page.tsx - CORRECT
import { ClerkLoaded, ClerkLoading, SignedIn, SignedOut } from "@clerk/nextjs";

export default function HomePage() {
  return (
    <main>
      <h1>Welcome to Our App</h1>
      
      <ClerkLoading>
        <div>Loading...</div>
      </ClerkLoading>
      
      <ClerkLoaded>
        <SignedOut>
          <p>Sign in to access your dashboard</p>
          <a href="/sign-in">Sign In</a>
        </SignedOut>
        
        <SignedIn>
          <p>Welcome back!</p>
          <a href="/dashboard">Go to Dashboard</a>
        </SignedIn>
      </ClerkLoaded>
    </main>
  );
}
```

**WRONG:**
```tsx
// ❌ NEVER DO THIS on a public page
import { auth } from "@clerk/nextjs/server";

export default async function HomePage() {
  const { userId } = await auth();  // ← WRONG WRONG WRONG
  if (userId) redirect("/dashboard");
  return <LandingPage />;
}
```

---

## Root Layout

```tsx
// app/layout.tsx
import { ClerkProvider } from "@clerk/nextjs";

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <ClerkProvider
      signInUrl="/sign-in"
      signUpUrl="/sign-up"
      afterSignInUrl="/dashboard"
      afterSignUpUrl="/dashboard"
    >
      <html lang="en">
        <body>{children}</body>
      </html>
    </ClerkProvider>
  );
}
```

---

## Private Layout (inside route group)

```tsx
// app/(private)/layout.tsx
import { auth } from "@clerk/nextjs/server";
import { redirect } from "next/navigation";

export default async function PrivateLayout({ 
  children 
}: { 
  children: React.ReactNode 
}) {
  const { userId } = await auth();
  
  if (!userId) {
    redirect("/sign-in");
  }
  
  return <>{children}</>;
}
```

This is the ONLY place `auth()` should be called for route protection.

---

## UserButton / Header Component

```tsx
// components/header.tsx
"use client";

import { ClerkLoaded, ClerkLoading, SignedIn, SignedOut, UserButton } from "@clerk/nextjs";

export function Header() {
  return (
    <header>
      <nav>
        <a href="/">Home</a>
        
        <ClerkLoading>
          <div className="w-8 h-8 rounded-full bg-gray-200 animate-pulse" />
        </ClerkLoading>
        
        <ClerkLoaded>
          <SignedOut>
            <a href="/sign-in">Sign In</a>
          </SignedOut>
          
          <SignedIn>
            <UserButton afterSignOutUrl="/" />
          </SignedIn>
        </ClerkLoaded>
      </nav>
    </header>
  );
}
```

---

## Environment Variables

```bash
# .env.local
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_test_...  # Copy EXACTLY from dashboard
CLERK_SECRET_KEY=sk_test_...                    # Copy EXACTLY from dashboard

# Redirects (optional - can also set in ClerkProvider)
NEXT_PUBLIC_CLERK_SIGN_IN_URL=/sign-in
NEXT_PUBLIC_CLERK_SIGN_UP_URL=/sign-up
NEXT_PUBLIC_CLERK_AFTER_SIGN_IN_URL=/dashboard
NEXT_PUBLIC_CLERK_AFTER_SIGN_UP_URL=/dashboard
```

---

## Convex Integration

```tsx
// app/layout.tsx with Convex
"use client";

import { ClerkProvider, useAuth } from "@clerk/nextjs";
import { ConvexProviderWithClerk } from "convex/react-clerk";
import { ConvexReactClient } from "convex/react";

const convex = new ConvexReactClient(process.env.NEXT_PUBLIC_CONVEX_URL!);

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <ClerkProvider>
      <ConvexProviderWithClerk client={convex} useAuth={useAuth}>
        <html lang="en">
          <body>{children}</body>
        </html>
      </ConvexProviderWithClerk>
    </ClerkProvider>
  );
}
```

---

## Debugging

If you see 500 errors or infinite redirects:

1. **Check env vars** — Copy fresh from Clerk dashboard, character by character
2. **Check for `auth()` on public pages** — Remove it
3. **Check proxy.ts** — Should only protect `/(private)`
4. **Open incognito** — Test as anonymous user
5. **Check Clerk dashboard logs** — Shows auth failures

```typescript
// Enable debug mode in proxy.ts
export default clerkMiddleware(
  async (auth, request) => { /* ... */ },
  { debug: true }
);
```

---

## Migration from middleware.ts

```bash
# Rename the file
mv middleware.ts proxy.ts

# OR use codemod
npx @next/codemod@latest middleware-to-proxy
```

---

## Common Sins (DO NOT COMMIT THESE)

| Sin | Punishment | Repentance |
|-----|------------|------------|
| `await auth()` on homepage | 500 errors, slow pages | Use `<SignedIn>`/`<SignedOut>` |
| Listing every public route in proxy.ts | Maintenance hell | Use `/(private)` route group |
| Missing `<ClerkLoaded>` wrapper | Flash of wrong content | Always wrap Clerk components |
| Wrong env var character | Cryptic 500 errors | Copy-paste from dashboard |
| `middleware.ts` in Next.js 16+ | Deprecation warnings | Rename to `proxy.ts` |
