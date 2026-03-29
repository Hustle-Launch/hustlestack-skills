---
name: sr-native-engineer
description: Build production-grade React Native apps with Expo, NativeWind, and react-strict-dom. Use when creating mobile/tablet apps, cross-platform experiences, or adapting web designs for native. Handles iOS, Android, and macOS targets with proper platform-specific code.
---

> **Global Standards:** See [../STANDARDS.md](../STANDARDS.md) for icon library and other cross-platform standards.

# Native Engineer

Build distinctive, production-grade React Native apps with Expo. This skill combines the production workflow rigor of `sr-production-engineer` with the design quality standards of `sr-react-design-expert`, adapted for native mobile/tablet development.

## Stack Context

| Layer | Tech | Notes |
|-------|------|-------|
| Framework | Expo SDK 53+ | Managed workflow, `expo-dev-client` for native modules |
| Router | Expo Router v4+ | File-based routing, parallel routes, typed routes |
| Styling | NativeWind v4+ | Tailwind for RN, CSS-first approach |
| Cross-Platform | react-strict-dom | Web + Native from single codebase |
| Components | Custom + Community | No direct shadcn (use inspiration, build native) |
| Icons | Phosphor (`phosphor-react-native`) | Match web projects, consistent iconography |
| Animation | Reanimated 3 + Moti | 60fps native animations |
| State | Zustand / Jotai | Lightweight, works with RN architecture |
| Storage | expo-secure-store, MMKV | Secure credentials, fast KV storage |

## Project Structure

```
app/
├── (tabs)/                    # Tab navigator group
│   ├── _layout.tsx           # Tab configuration
│   ├── index.tsx             # Home tab
│   └── settings.tsx          # Settings tab
├── (auth)/                    # Auth flow group
│   ├── _layout.tsx
│   ├── login.tsx
│   └── register.tsx
├── [id]/                      # Dynamic routes
├── _layout.tsx                # Root layout (providers, fonts)
├── +not-found.tsx             # 404 handler
└── +html.tsx                  # Web HTML template (if targeting web)

components/
├── ui/                        # Base components (Button, Input, Card)
├── forms/                     # Form-specific components
└── [feature]/                 # Feature-specific components

lib/
├── api/                       # API clients, queries
├── hooks/                     # Custom hooks
├── utils/                     # Utilities
└── stores/                    # State stores

constants/
├── Colors.ts                  # Theme colors
├── Spacing.ts                 # Spacing scale
└── Typography.ts              # Font definitions
```

## NativeWind Setup

### Configuration (nativewind.config.ts)

```typescript
import type { Config } from 'nativewind';

export default {
  content: [
    './app/**/*.{js,jsx,ts,tsx}',
    './components/**/*.{js,jsx,ts,tsx}',
  ],
  theme: {
    extend: {
      colors: {
        // Use semantic names
        background: 'var(--background)',
        foreground: 'var(--foreground)',
        primary: 'var(--primary)',
        'primary-foreground': 'var(--primary-foreground)',
        muted: 'var(--muted)',
        'muted-foreground': 'var(--muted-foreground)',
        accent: 'var(--accent)',
        destructive: 'var(--destructive)',
        border: 'var(--border)',
        ring: 'var(--ring)',
      },
      fontFamily: {
        sans: ['Inter'],
        mono: ['JetBrainsMono'],
      },
    },
  },
  plugins: [],
} satisfies Config;
```

### Global CSS (global.css)

```css
@tailwind base;
@tailwind components;
@tailwind utilities;

:root {
  --background: 250 250 250;
  --foreground: 10 10 10;
  --primary: 59 130 246;
  --primary-foreground: 255 255 255;
  --muted: 245 245 245;
  --muted-foreground: 115 115 115;
  --accent: 245 245 245;
  --destructive: 239 68 68;
  --border: 229 229 229;
  --ring: 59 130 246;
}

.dark {
  --background: 10 10 10;
  --foreground: 250 250 250;
  --primary: 96 165 250;
  --primary-foreground: 10 10 10;
  --muted: 38 38 38;
  --muted-foreground: 163 163 163;
  --accent: 38 38 38;
  --destructive: 248 113 113;
  --border: 38 38 38;
  --ring: 96 165 250;
}
```

### Usage Patterns

```tsx
import { View, Text, Pressable } from 'react-native';

// ✅ Correct - className works with NativeWind
export function Card({ children }: { children: React.ReactNode }) {
  return (
    <View className="bg-background rounded-2xl p-4 border border-border">
      {children}
    </View>
  );
}

// ✅ Platform-specific styles with NativeWind
export function Header() {
  return (
    <View className="ios:pt-14 android:pt-8 px-4">
      <Text className="text-2xl font-bold text-foreground">Title</Text>
    </View>
  );
}

// ✅ Responsive with breakpoints (works on tablets)
export function ResponsiveGrid() {
  return (
    <View className="flex-row flex-wrap gap-4 px-4">
      <View className="w-full md:w-1/2 lg:w-1/3">
        {/* Card content */}
      </View>
    </View>
  );
}
```

## Component Patterns

### Base Button Component

```tsx
import { Pressable, Text, ActivityIndicator } from 'react-native';
import { cva, type VariantProps } from 'class-variance-authority';
import { cn } from '@/lib/utils';

const buttonVariants = cva(
  'flex-row items-center justify-center rounded-xl active:opacity-80',
  {
    variants: {
      variant: {
        default: 'bg-primary',
        secondary: 'bg-muted',
        destructive: 'bg-destructive',
        outline: 'border border-border bg-transparent',
        ghost: 'bg-transparent',
      },
      size: {
        sm: 'h-9 px-3',
        md: 'h-11 px-4',
        lg: 'h-14 px-6',
        icon: 'h-11 w-11',
      },
    },
    defaultVariants: {
      variant: 'default',
      size: 'md',
    },
  }
);

const textVariants = cva('font-semibold', {
  variants: {
    variant: {
      default: 'text-primary-foreground',
      secondary: 'text-foreground',
      destructive: 'text-white',
      outline: 'text-foreground',
      ghost: 'text-foreground',
    },
    size: {
      sm: 'text-sm',
      md: 'text-base',
      lg: 'text-lg',
      icon: 'text-base',
    },
  },
  defaultVariants: {
    variant: 'default',
    size: 'md',
  },
});

interface ButtonProps extends VariantProps<typeof buttonVariants> {
  children: React.ReactNode;
  onPress?: () => void;
  disabled?: boolean;
  loading?: boolean;
  className?: string;
}

export function Button({
  children,
  variant,
  size,
  onPress,
  disabled,
  loading,
  className,
}: ButtonProps) {
  return (
    <Pressable
      onPress={onPress}
      disabled={disabled || loading}
      className={cn(
        buttonVariants({ variant, size }),
        disabled && 'opacity-50',
        className
      )}
    >
      {loading ? (
        <ActivityIndicator
          color={variant === 'default' ? '#fff' : '#000'}
          size="small"
        />
      ) : typeof children === 'string' ? (
        <Text className={textVariants({ variant, size })}>{children}</Text>
      ) : (
        children
      )}
    </Pressable>
  );
}
```

### Card Component

```tsx
import { View, Text } from 'react-native';
import { cn } from '@/lib/utils';

interface CardProps {
  children: React.ReactNode;
  className?: string;
}

export function Card({ children, className }: CardProps) {
  return (
    <View
      className={cn(
        'bg-background rounded-2xl border border-border overflow-hidden',
        className
      )}
    >
      {children}
    </View>
  );
}

export function CardHeader({ children, className }: CardProps) {
  return (
    <View className={cn('p-4 pb-2', className)}>
      {children}
    </View>
  );
}

export function CardTitle({ children, className }: { children: string; className?: string }) {
  return (
    <Text className={cn('text-lg font-semibold text-foreground', className)}>
      {children}
    </Text>
  );
}

export function CardContent({ children, className }: CardProps) {
  return (
    <View className={cn('p-4 pt-0', className)}>
      {children}
    </View>
  );
}
```

### Input Component

```tsx
import { TextInput, View, Text } from 'react-native';
import { forwardRef } from 'react';
import { cn } from '@/lib/utils';

interface InputProps extends React.ComponentProps<typeof TextInput> {
  label?: string;
  error?: string;
  containerClassName?: string;
}

export const Input = forwardRef<TextInput, InputProps>(
  ({ label, error, className, containerClassName, ...props }, ref) => {
    return (
      <View className={cn('gap-1.5', containerClassName)}>
        {label && (
          <Text className="text-sm font-medium text-foreground">{label}</Text>
        )}
        <TextInput
          ref={ref}
          className={cn(
            'h-12 px-4 rounded-xl bg-muted text-foreground',
            'border border-transparent',
            'focus:border-ring',
            error && 'border-destructive',
            className
          )}
          placeholderTextColor="rgb(var(--muted-foreground))"
          {...props}
        />
        {error && (
          <Text className="text-sm text-destructive">{error}</Text>
        )}
      </View>
    );
  }
);
```

## react-strict-dom Integration

For true cross-platform (Web + iOS + Android + macOS):

```tsx
import { css, html } from 'react-strict-dom';

const styles = css.create({
  container: {
    flex: 1,
    padding: 16,
    backgroundColor: 'var(--background)',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    color: 'var(--foreground)',
  },
});

export function CrossPlatformComponent() {
  return (
    <html.div style={styles.container}>
      <html.h1 style={styles.title}>Works Everywhere</html.h1>
    </html.div>
  );
}
```

### When to Use react-strict-dom vs NativeWind

| Use Case | Recommendation |
|----------|----------------|
| Native-first app with web export | NativeWind |
| Web-first app with native | react-strict-dom |
| Shared component library | react-strict-dom |
| Complex native animations | NativeWind + Reanimated |
| Design system tokens | Both work, prefer CSS vars |

## Platform-Specific Code

### Conditional Rendering

```tsx
import { Platform } from 'react-native';

// ✅ Platform-specific components
export function Header() {
  return (
    <View className="px-4">
      {Platform.OS === 'ios' && <StatusBar style="dark" />}
      <Text className="text-2xl font-bold">
        {Platform.select({
          ios: 'iPhone App',
          android: 'Android App',
          macos: 'macOS App',
          default: 'App',
        })}
      </Text>
    </View>
  );
}
```

### Platform-Specific Files

```
components/
├── Button.tsx           # Default implementation
├── Button.ios.tsx       # iOS-specific (auto-selected)
├── Button.android.tsx   # Android-specific (auto-selected)
└── Button.macos.tsx     # macOS-specific
```

### Safe Area Handling

```tsx
import { SafeAreaView } from 'react-native-safe-area-context';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

// ✅ Using SafeAreaView wrapper
export function Screen({ children }: { children: React.ReactNode }) {
  return (
    <SafeAreaView className="flex-1 bg-background">
      {children}
    </SafeAreaView>
  );
}

// ✅ Using insets for custom layouts
export function CustomHeader() {
  const insets = useSafeAreaInsets();
  
  return (
    <View style={{ paddingTop: insets.top }} className="px-4 pb-4 bg-background">
      <Text className="text-xl font-bold">Header</Text>
    </View>
  );
}
```

## iOS-Specific Configuration

### Info.plist Permissions (app.json)

```json
{
  "expo": {
    "ios": {
      "infoPlist": {
        "NSCameraUsageDescription": "We need camera access to take photos",
        "NSPhotoLibraryUsageDescription": "We need photo library access to save images",
        "NSLocationWhenInUseUsageDescription": "We need location to show nearby places",
        "NSFaceIDUsageDescription": "Use Face ID to unlock the app",
        "UIBackgroundModes": ["fetch", "remote-notification"]
      },
      "entitlements": {
        "aps-environment": "production"
      }
    }
  }
}
```

### iOS Design Patterns

```tsx
// ✅ Native-feeling iOS interactions
import * as Haptics from 'expo-haptics';

export function ListItem({ onPress, title }: { onPress: () => void; title: string }) {
  const handlePress = () => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
    onPress();
  };
  
  return (
    <Pressable
      onPress={handlePress}
      className="flex-row items-center justify-between p-4 bg-background active:bg-muted"
    >
      <Text className="text-foreground">{title}</Text>
      <ChevronRight className="text-muted-foreground" />
    </Pressable>
  );
}
```

## Android-Specific Configuration

### AndroidManifest Permissions (app.json)

```json
{
  "expo": {
    "android": {
      "permissions": [
        "CAMERA",
        "READ_EXTERNAL_STORAGE",
        "WRITE_EXTERNAL_STORAGE",
        "ACCESS_FINE_LOCATION",
        "ACCESS_COARSE_LOCATION",
        "RECEIVE_BOOT_COMPLETED",
        "VIBRATE"
      ],
      "blockedPermissions": [
        "READ_PHONE_STATE"
      ]
    }
  }
}
```

### Android Design Patterns

```tsx
// ✅ Material ripple effect (native on Android)
import { Platform, Pressable } from 'react-native';

export function AndroidButton({ onPress, children }) {
  return (
    <Pressable
      onPress={onPress}
      android_ripple={{ color: 'rgba(0, 0, 0, 0.1)', borderless: false }}
      className="px-4 py-3 bg-primary rounded-lg"
    >
      {children}
    </Pressable>
  );
}

// ✅ Back handler
import { BackHandler } from 'react-native';
import { useFocusEffect } from 'expo-router';

export function useAndroidBackHandler(handler: () => boolean) {
  useFocusEffect(() => {
    const subscription = BackHandler.addEventListener('hardwareBackPress', handler);
    return () => subscription.remove();
  });
}
```

## Expo Router Patterns

### Root Layout

```tsx
// app/_layout.tsx
import { Stack } from 'expo-router';
import { ThemeProvider, DarkTheme, DefaultTheme } from '@react-navigation/native';
import { useColorScheme } from 'react-native';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import { useFonts } from 'expo-font';
import * as SplashScreen from 'expo-splash-screen';
import '../global.css';

SplashScreen.preventAutoHideAsync();

export default function RootLayout() {
  const colorScheme = useColorScheme();
  
  const [fontsLoaded] = useFonts({
    Inter: require('@/assets/fonts/Inter.ttf'),
    'Inter-Bold': require('@/assets/fonts/Inter-Bold.ttf'),
  });

  useEffect(() => {
    if (fontsLoaded) {
      SplashScreen.hideAsync();
    }
  }, [fontsLoaded]);

  if (!fontsLoaded) return null;

  return (
    <SafeAreaProvider>
      <ThemeProvider value={colorScheme === 'dark' ? DarkTheme : DefaultTheme}>
        <Stack screenOptions={{ headerShown: false }}>
          <Stack.Screen name="(tabs)" />
          <Stack.Screen name="(auth)" />
          <Stack.Screen name="+not-found" />
        </Stack>
      </ThemeProvider>
    </SafeAreaProvider>
  );
}
```

### Tab Navigator

```tsx
// app/(tabs)/_layout.tsx
import { Tabs } from 'expo-router';
import { House, Gear, User } from 'phosphor-react-native';
import { useColorScheme } from 'react-native';

export default function TabLayout() {
  const colorScheme = useColorScheme();
  const iconColor = colorScheme === 'dark' ? '#fff' : '#000';
  
  return (
    <Tabs
      screenOptions={{
        headerShown: false,
        tabBarStyle: {
          backgroundColor: colorScheme === 'dark' ? '#0a0a0a' : '#fafafa',
          borderTopColor: colorScheme === 'dark' ? '#262626' : '#e5e5e5',
        },
        tabBarActiveTintColor: colorScheme === 'dark' ? '#60a5fa' : '#3b82f6',
      }}
    >
      <Tabs.Screen
        name="index"
        options={{
          title: 'Home',
          tabBarIcon: ({ color, size }) => <House size={size} color={color} />,
        }}
      />
      <Tabs.Screen
        name="profile"
        options={{
          title: 'Profile',
          tabBarIcon: ({ color, size }) => <User size={size} color={color} />,
        }}
      />
      <Tabs.Screen
        name="settings"
        options={{
          title: 'Settings',
          tabBarIcon: ({ color, size }) => <Gear size={size} color={color} />,
        }}
      />
    </Tabs>
  );
}
```

### Navigation Patterns

```tsx
import { router, useLocalSearchParams, Link } from 'expo-router';

// ✅ Programmatic navigation
function handleSubmit() {
  router.push('/profile/123');
  router.replace('/home');  // No back
  router.back();
}

// ✅ Link component
<Link href="/settings" className="text-primary">
  Settings
</Link>

// ✅ Dynamic params
const { id } = useLocalSearchParams<{ id: string }>();
```

## Animation Patterns

### Reanimated 3 Basics

```tsx
import Animated, {
  useAnimatedStyle,
  useSharedValue,
  withSpring,
  withTiming,
  FadeIn,
  FadeOut,
  SlideInRight,
} from 'react-native-reanimated';

// ✅ Entering/Exiting animations
export function AnimatedCard({ children }) {
  return (
    <Animated.View
      entering={FadeIn.duration(300)}
      exiting={FadeOut.duration(200)}
      className="bg-background rounded-2xl p-4"
    >
      {children}
    </Animated.View>
  );
}

// ✅ Interactive animations
export function ScaleButton({ onPress, children }) {
  const scale = useSharedValue(1);
  
  const animatedStyle = useAnimatedStyle(() => ({
    transform: [{ scale: scale.value }],
  }));
  
  const handlePressIn = () => {
    scale.value = withSpring(0.95);
  };
  
  const handlePressOut = () => {
    scale.value = withSpring(1);
  };
  
  return (
    <Pressable onPressIn={handlePressIn} onPressOut={handlePressOut} onPress={onPress}>
      <Animated.View style={animatedStyle} className="bg-primary px-4 py-3 rounded-xl">
        {children}
      </Animated.View>
    </Pressable>
  );
}
```

### Moti for Declarative Animations

```tsx
import { MotiView, AnimatePresence } from 'moti';

export function FadeInView({ children, visible }) {
  return (
    <AnimatePresence>
      {visible && (
        <MotiView
          from={{ opacity: 0, translateY: 20 }}
          animate={{ opacity: 1, translateY: 0 }}
          exit={{ opacity: 0, translateY: -20 }}
          transition={{ type: 'timing', duration: 300 }}
        >
          {children}
        </MotiView>
      )}
    </AnimatePresence>
  );
}
```

## Expo EAS Build & Submit

### eas.json Configuration

```json
{
  "cli": {
    "version": ">= 5.0.0"
  },
  "build": {
    "development": {
      "developmentClient": true,
      "distribution": "internal",
      "ios": {
        "simulator": true
      }
    },
    "preview": {
      "distribution": "internal",
      "ios": {
        "simulator": false
      }
    },
    "production": {
      "autoIncrement": true
    }
  },
  "submit": {
    "production": {
      "ios": {
        "appleId": "your@email.com",
        "ascAppId": "123456789"
      },
      "android": {
        "serviceAccountKeyPath": "./google-services.json",
        "track": "internal"
      }
    }
  }
}
```

### Build Commands

```bash
# Development build (with dev client)
eas build --profile development --platform ios
eas build --profile development --platform android

# Preview build (internal testing)
eas build --profile preview --platform all

# Production build
eas build --profile production --platform all

# Submit to stores
eas submit --platform ios
eas submit --platform android
```

## Testing Strategy

### Expo Go vs Dev Builds

| Feature | Expo Go | Dev Build |
|---------|---------|-----------|
| Quick iteration | ✅ Instant | ⚠️ Requires rebuild |
| Native modules | ❌ Limited | ✅ Full support |
| Push notifications | ❌ | ✅ |
| In-app purchases | ❌ | ✅ |
| Custom native code | ❌ | ✅ |
| Production parity | ⚠️ Differences | ✅ Identical |

**Rule:** Use Expo Go for rapid UI iteration, switch to dev builds for feature testing and before release.

### Test on Real Devices

```bash
# Install dev build on physical device
eas build --profile development --platform ios
# Scan QR from terminal or EAS dashboard

# Run with dev client
npx expo start --dev-client
```

### Component Testing

```tsx
// __tests__/Button.test.tsx
import { render, fireEvent } from '@testing-library/react-native';
import { Button } from '@/components/ui/Button';

describe('Button', () => {
  it('renders correctly', () => {
    const { getByText } = render(<Button>Press me</Button>);
    expect(getByText('Press me')).toBeTruthy();
  });

  it('handles press events', () => {
    const onPress = jest.fn();
    const { getByText } = render(<Button onPress={onPress}>Press me</Button>);
    fireEvent.press(getByText('Press me'));
    expect(onPress).toHaveBeenCalled();
  });

  it('shows loading state', () => {
    const { getByTestId } = render(<Button loading>Press me</Button>);
    expect(getByTestId('activity-indicator')).toBeTruthy();
  });
});
```

## Design Rules (Native-Adapted)

These rules override aesthetic preferences. They are non-negotiable.

### Buttons
- **Content-width only** — never `flex-1` or `w-full` on buttons (exception: bottom sheet CTAs)
- **Solid backgrounds** — no gradients on buttons
- **Consistent hit targets** — minimum 44x44pt touch area (accessibility requirement)
- **Active states** — always show `active:opacity-80` or scale animation

### Cards
- Use `overflow-hidden` on card container, not child images
- Border radius: `rounded-2xl` (16pt) is the native standard
- Shadow: `shadow-sm` on iOS, elevation on Android (handled by RN)

### Forms
- Single column on phones, 2-column on tablets (`md:` breakpoint)
- Submit button: full-width at bottom of form on mobile
- Input height: minimum 48pt for comfortable touch

### Navigation
- Tab bars: max 5 items
- Bottom sheet > modal for actions on mobile
- Swipe gestures should feel native (use react-native-gesture-handler)

### Platform Conventions

| Pattern | iOS | Android |
|---------|-----|---------|
| Back navigation | Swipe from edge | Hardware back + app bar |
| Action sheets | iOS action sheet | Bottom sheet |
| Alerts | Native alert | Material dialog |
| Pull to refresh | Bouncy | Material indicator |
| Haptics | Essential | Subtle/optional |

## Performance Checklist

- [ ] Images use `expo-image` with proper sizing and caching
- [ ] Lists use `FlashList` (not `FlatList`) for 60fps scrolling
- [ ] Heavy computations wrapped in `useMemo` / `useCallback`
- [ ] No inline styles in render (use StyleSheet or NativeWind)
- [ ] Animations run on UI thread (Reanimated `worklet` functions)
- [ ] Bundle size checked with `npx expo-doctor`
- [ ] Memory leaks checked (subscriptions cleaned up)
- [ ] Splash screen properly managed (no white flash)

## Pre-Flight Checklist

Before marking implementation complete:

- [ ] Renders without yellow box warnings or red errors
- [ ] Works on iOS simulator AND Android emulator
- [ ] Tested on physical device (at least one platform)
- [ ] Safe areas handled correctly (notch, home indicator)
- [ ] Keyboard avoidance works on all forms
- [ ] Dark/light mode switches correctly
- [ ] Touch targets are minimum 44x44pt
- [ ] Loading states for all async operations
- [ ] Error states for failed operations
- [ ] Empty states for lists/content
- [ ] Pull-to-refresh where appropriate
- [ ] Back navigation works correctly
- [ ] Deep links work (if applicable)
- [ ] Offline behavior is graceful

## Production Workflow

Follow `sr-production-engineer` for PR workflow after implementation:

1. Update `TODO.md` with task tracking
2. Update `CHANGELOG.md` with changes
3. Create branch with Graphite: `gt create "feature/add-profile-screen" -m "Add profile screen"`
4. Submit PR: `gt submit`
5. After merge, build and test:
   ```bash
   eas build --profile preview --platform all
   ```
6. For production release:
   ```bash
   eas build --profile production --platform all
   eas submit --platform all
   ```

## Related Skills

- Use `/sr-production-engineer` for PR workflow after implementation
- Use `/sr-react-design-expert` for design system reference (adapt patterns for native)
- Use `/sr-software-architect` when building complex native features
