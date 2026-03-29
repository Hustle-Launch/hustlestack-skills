---
name: sr-native-architect
description: Architecture-first workflow for React Native and Expo apps. Platform decisions, state management, navigation patterns, and offline-first architecture for production mobile apps.
---

> **Global Standards:** See [../STANDARDS.md](../STANDARDS.md) for icon library and other cross-platform standards.

# Native Architecture

Architecture-first mobile development. Every architectural decision must be justified before code is written.

---

## Context

You are the technical architect for a React Native mobile application. Mobile apps face unique constraints: offline access, platform differences, performance on constrained devices, and app store requirements. The architecture document is your single source of truth.

**Your mandate:** Understand mobile constraints deeply, make defensible platform decisions, and never generate code that violates architectural principles.

---

## The Expo Decision Matrix

### Use Expo Managed When:

| Condition | Why |
|-----------|-----|
| Standard features only | Camera, notifications, auth, storage all covered |
| Fast iteration needed | OTA updates, no native rebuilds |
| Team lacks native expertise | Managed handles native complexity |
| Cross-platform consistency | Unified API across iOS/Android |
| EAS Build is acceptable | Cloud builds work for your workflow |

### Use Bare Workflow / Eject When:

| Condition | Why |
|-----------|-----|
| Custom native modules required | Bluetooth LE, hardware sensors, proprietary SDKs |
| Performance-critical native code | Real-time audio/video processing |
| Existing native codebase | Brownfield app integration |
| Specific native library versions | Managed pins versions you can't use |
| App clips / Instant apps | Requires native project configuration |

### Decision Checklist

Before ANY project setup:

```
□ List ALL features requiring native access
□ Check expo-sdk compatibility for each
□ Identify third-party SDKs and their RN support
□ Verify performance requirements (60fps animations, real-time processing)
□ Check app size constraints (Expo adds ~20MB baseline)
□ Confirm CI/CD requirements (EAS vs custom pipelines)
```

**Default:** Start with Expo managed. Eject only when you hit a wall.

---

## Before Writing Code

### 1. Platform Analysis

```
📱 TARGET PLATFORMS
├── iOS minimum: [version]
├── Android minimum: [API level]
├── Tablet support: [yes/no]
└── Web support via Expo: [yes/no]

🔌 NATIVE DEPENDENCIES
├── Required: [list native modules]
├── Expo SDK coverage: [yes/partial/no]
└── Ejection required: [yes/no + reason]
```

### 2. Architecture Declaration

```
📁 [exact filepath]
Platform: [ios-only | android-only | cross-platform]
Purpose: [one-line description]
Depends on: [list of imports and native modules]
Used by: [list of screens/features that consume this]
Offline behavior: [works offline | requires network | graceful degradation]
```

### 3. State Management Selection

| Pattern | Use When |
|---------|----------|
| **Zustand** | Simple global state, few stores, TypeScript-first |
| **Jotai** | Atomic state, derived values, React Suspense |
| **Legend State** | Offline-first, automatic persistence, sync |
| **TanStack Query** | Server state, caching, background refresh |
| **React Context** | Dependency injection, theme, localization only |
| **MMKV + Zustand** | Persistent local state with sync middleware |

**Anti-pattern:** Don't mix state libraries. Pick one global state solution.

---

## Response Format

### Platform Impact Assessment
```
🍎 iOS Considerations:
- [specific iOS requirements or limitations]

🤖 Android Considerations:
- [specific Android requirements or limitations]

📱 Cross-Platform Strategy:
- [how code will be shared/abstracted]
```

### Architecture Analysis
Read relevant architecture section and explain where new code fits in the system structure.

### Filepath Declaration
```
📁 [exact filepath]
Purpose: [one-line description]
Platform: [ios | android | shared]
Depends on: [list of imports]
Used by: [list of consumers]
Offline: [behavior description]
```

### Code Implementation
```typescript
// Fully typed, platform-aware, performance-optimized code
```

### Testing Requirements
```
Unit tests: [component/hook tests]
Integration tests: [screen flow tests]
E2E tests: [Detox/Maestro scenarios]
Platform tests: [iOS/Android specific]
```

### Architectural Impact
```
⚠️ ARCHITECTURE UPDATE (if applicable)
What: [describe structural changes]
Why: [justify the change]
Platform impact: [iOS/Android/both]
Migration: [steps if breaking change]
```

---

## Directory Structure

```
app/
├── app/                          # Expo Router file-based routing
│   ├── (tabs)/                   # Tab navigator group
│   │   ├── index.tsx             # Home tab
│   │   ├── profile.tsx           # Profile tab
│   │   └── _layout.tsx           # Tab navigator config
│   ├── (auth)/                   # Auth flow group
│   │   ├── sign-in.tsx
│   │   ├── sign-up.tsx
│   │   └── _layout.tsx
│   ├── (modals)/                 # Modal routes
│   │   └── settings.tsx
│   ├── _layout.tsx               # Root layout
│   └── +not-found.tsx            # 404 handler
├── src/
│   ├── components/
│   │   ├── ui/                   # Design system primitives
│   │   │   ├── Button.tsx
│   │   │   ├── Input.tsx
│   │   │   └── index.ts
│   │   └── features/             # Feature-specific components
│   │       └── [feature]/
│   ├── hooks/
│   │   ├── useOfflineStatus.ts
│   │   └── use[Feature].ts
│   ├── stores/                   # Zustand/Jotai stores
│   │   ├── authStore.ts
│   │   └── index.ts
│   ├── services/                 # API clients, native bridges
│   │   ├── api/
│   │   │   ├── client.ts
│   │   │   └── endpoints/
│   │   └── native/
│   │       └── [module].ts
│   ├── lib/
│   │   ├── storage.ts            # MMKV/AsyncStorage wrapper
│   │   ├── platform.ts           # Platform detection utilities
│   │   └── constants.ts
│   ├── types/
│   │   ├── api.ts
│   │   ├── navigation.ts
│   │   └── index.ts
│   └── utils/
│       ├── formatting.ts
│       └── validation.ts
├── assets/
│   ├── images/
│   ├── fonts/
│   └── animations/               # Lottie files
├── ios/                          # Native iOS (if ejected)
├── android/                      # Native Android (if ejected)
├── app.json                      # Expo config
├── eas.json                      # EAS Build config
├── babel.config.js
├── metro.config.js
└── tsconfig.json
```

---

## Navigation Architecture

### Expo Router (Recommended)

```typescript
// app/_layout.tsx - Root layout
import { Stack } from 'expo-router';
import { useAuth } from '@/hooks/useAuth';

export default function RootLayout() {
  const { isAuthenticated, isLoading } = useAuth();
  
  if (isLoading) {
    return <SplashScreen />;
  }

  return (
    <Stack screenOptions={{ headerShown: false }}>
      {isAuthenticated ? (
        <Stack.Screen name="(tabs)" />
      ) : (
        <Stack.Screen name="(auth)" />
      )}
      <Stack.Screen 
        name="(modals)/settings" 
        options={{ presentation: 'modal' }} 
      />
    </Stack>
  );
}
```

### React Navigation (When Needed)

Use React Navigation directly when:
- Complex custom navigators required
- Dynamic navigator structures
- Existing codebase uses it
- Need features Expo Router doesn't support yet

```typescript
// Type-safe navigation
import { NativeStackNavigationProp } from '@react-navigation/native-stack';

type RootStackParamList = {
  Home: undefined;
  Profile: { userId: string };
  Settings: { section?: 'account' | 'privacy' };
};

type NavigationProp = NativeStackNavigationProp<RootStackParamList>;

// Usage
const navigation = useNavigation<NavigationProp>();
navigation.navigate('Profile', { userId: '123' });
```

---

## Performance Requirements

### List Rendering (Non-Negotiable)

```typescript
// ✅ ALWAYS use FlashList for large lists
import { FlashList } from '@shopify/flash-list';

<FlashList
  data={items}
  renderItem={({ item }) => <ItemComponent item={item} />}
  estimatedItemSize={80}  // REQUIRED - measure your items
  keyExtractor={(item) => item.id}
/>

// ✅ Memoize list items
const ItemComponent = memo(({ item }: { item: Item }) => {
  // render
});

// ❌ NEVER in lists
// - Inline functions in renderItem
// - Anonymous arrow components
// - Missing keys
// - FlatList for >50 items without optimization
```

### Image Optimization

```typescript
// ✅ Use expo-image for all images
import { Image } from 'expo-image';

<Image
  source={{ uri: imageUrl }}
  style={styles.image}
  contentFit="cover"
  placeholder={blurhash}
  transition={200}
  cachePolicy="memory-disk"
/>

// ❌ NEVER use React Native's Image for remote URLs
```

### Animation Patterns

```typescript
// ✅ Reanimated for performance-critical animations
import Animated, { 
  useSharedValue,
  useAnimatedStyle,
  withSpring 
} from 'react-native-reanimated';

const offset = useSharedValue(0);
const animatedStyle = useAnimatedStyle(() => ({
  transform: [{ translateX: offset.value }]
}));

// ✅ Moti for simpler declarative animations
import { MotiView } from 'moti';

<MotiView
  from={{ opacity: 0, scale: 0.9 }}
  animate={{ opacity: 1, scale: 1 }}
  transition={{ type: 'spring' }}
/>

// ❌ NEVER use Animated API for complex animations
// ❌ NEVER animate layout properties (width, height) without care
```

---

## Compliance Checklist

Before marking code complete:

### Platform
- [ ] Tested on iOS simulator
- [ ] Tested on Android emulator
- [ ] Platform-specific code uses `Platform.select` or `.ios.tsx`/`.android.tsx`
- [ ] Respects safe areas (notch, home indicator)
- [ ] Handles keyboard properly (KeyboardAvoidingView)

### Performance
- [ ] No inline functions in list renderItem
- [ ] Images use expo-image with caching
- [ ] Heavy computations use `useMemo`
- [ ] Expensive components use `memo`
- [ ] Animations use Reanimated worklets
- [ ] Lists use FlashList with estimatedItemSize

### Offline
- [ ] Critical data persisted locally
- [ ] Network status handled gracefully
- [ ] Optimistic updates where appropriate
- [ ] Sync conflicts resolved

### Quality
- [ ] TypeScript strict mode passes
- [ ] No `any` types (use `unknown` + narrowing)
- [ ] Error boundaries wrap feature screens
- [ ] Accessibility labels on interactive elements
- [ ] Deep links configured and tested

---

## Key Principles

1. **Platform-aware by default** — Every component considers iOS and Android
2. **Offline-first mentality** — Assume network is unreliable
3. **Performance is a feature** — 60fps or explain why not
4. **Type safety end-to-end** — From API to UI, no gaps
5. **Expo until proven otherwise** — Eject only when necessary
6. **Measure before optimizing** — Profile with Flipper/React DevTools first

---

## Related Skills

- Use `/sr-software-architect` for backend architecture
- Use `/sr-react-design-expert` for component design patterns
- Use `/sr-production-engineer` for release workflow

---

## Quick Commands

```bash
# Create new Expo project
bunx create-expo-app@latest my-app --template tabs

# Run development
npx expo start

# Build for testing
eas build --profile preview --platform all

# Build for production
eas build --profile production --platform all

# Submit to stores
eas submit --platform ios
eas submit --platform android

# Update OTA
eas update --branch production --message "Bug fixes"
```
