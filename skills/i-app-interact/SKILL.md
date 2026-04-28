---
name: i-app-interact
description: Audit mobile app interaction feedback and state completeness across tap, pressed states, gestures, bottom sheets, navigation transitions, safe areas, keyboard behavior, haptics, and native app expectations. Use when the user wants to check whether a mobile app flow feels tactile, coherent, and usable.
version: 1.0.0
argument-hint: "[mobile app screen or flow]"
---

Audit mobile app interaction quality before polishing motion.

## When To Use

Use this for iOS/Android app screens, native-like mobile app flows, app prototypes, and mobile product interactions.

Do not treat this as a Web audit. Mobile apps do not rely on hover and must prioritize touch, gestures, reachability, system conventions, and native feedback.

## Workflow

1. **Identify the mobile app context**
   - Platform: iOS, Android, cross-platform, or prototype.
   - Primary flow: browsing, creation, editing, checkout, onboarding, settings, content consumption, or utility.
   - Interaction surface: one-handed, bottom-heavy, gesture-heavy, form-heavy, or media-heavy.

2. **Check touch states**
   - Tap/pressed feedback on buttons, list rows, cards, tabs, and tool icons.
   - Disabled/unavailable actions explain themselves when needed.
   - Selected/current states for tab bars, filters, lists, and steps.
   - Success/error/retry/empty/loading states are visible without blocking the flow unnecessarily.

3. **Check gestures and native patterns**
   - Swipe, drag, pull to refresh, long press, reorder, dismiss, and back gestures.
   - Bottom sheets, action sheets, full-screen modals, toast/snackbar, permission prompts.
   - Navigation transitions and result reveals feel expected for the platform.
   - Haptic feedback is considered for important confirmations where appropriate.

4. **Check mobile constraints**
   - Safe areas, home indicator, status bar, navigation bar, tab bar.
   - Keyboard push-up, form focus, input accessory actions.
   - Touch targets are comfortable.
   - Important actions are reachable and not hidden behind gestures only.
   - Gesture conflicts do not fight scroll or system back.

5. **Prioritize**
   - P0: interaction blocks task completion or conflicts with system gestures.
   - P1: missing feedback makes users unsure whether the app responded.
   - P2: interaction feels non-native, stiff, or inconsistent.
   - P3: tactile polish improvements.

## Output Format

- Mobile app interaction score: `?/10`
- Platform/input assumptions
- Missing or weak touch states
- Gesture and native-pattern issues
- Mobile constraint risks
- Priority fixes
- Suggested implementation notes

## Quality Bar

A good mobile app interaction audit makes the flow feel tactile, responsive, and platform-aware. It should catch missing pressed states, gesture conflicts, unsafe layouts, keyboard issues, and non-native transitions.

Never recommend hover-based interactions for mobile apps.
