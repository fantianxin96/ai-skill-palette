---
name: i-web-interact
description: Audit Web product interaction feedback and state completeness across mouse, keyboard, trackpad, browser, responsive layout, and common web UI patterns. Use when the user wants to check whether a web page or web app feels interactive, coherent, and usable before adding motion polish.
version: 1.0.0
argument-hint: "[web page or web app]"
---

Audit Web interaction quality before polishing motion.

## When To Use

Use this for desktop web, responsive web, landing pages, web apps, admin tools, dashboards, and browser-based products.

Do not treat this as a mobile app audit. Web has hover, focus, cursor, keyboard, browser constraints, and responsive states that native mobile apps do not share.

## Workflow

1. **Identify the Web context**
   - Is this desktop-first, responsive, data-dense, marketing, tool, dashboard, or small interactive page?
   - What are the primary inputs: mouse, keyboard, trackpad, or mixed touch?

2. **Check interaction states**
   - Hover: cards, buttons, nav, list rows, tool items, table rows.
   - Active/pressed: click-down feedback, button press, selected item.
   - Focus: visible focus rings, keyboard tab order, focus trap in modals.
   - Disabled: unavailable actions communicate why or when they become available.
   - Selected/current: nav, tabs, filters, segmented controls.
   - Expanded/collapsed: menus, accordions, dropdowns, popovers.

3. **Check feedback loops**
   - Loading, success, error, retry, empty, offline/failed request.
   - Copy/save/share/upload actions confirm what happened.
   - Long-running actions set expectations and prevent duplicate actions.

4. **Check Web-specific patterns**
   - Cursor affordance matches clickability.
   - Tooltip/popover/dropdown behavior is discoverable and dismissible.
   - Modal/drawer open/close is clear and keyboard-safe.
   - Scroll states, sticky elements, and overflow do not hide important controls.
   - Responsive breakpoints preserve interaction hierarchy.

5. **Prioritize**
   - P0: interaction blocks task completion.
   - P1: missing feedback creates uncertainty or repeated clicks.
   - P2: interaction feels flat or inconsistent.
   - P3: polish improvements.

## Output Format

- Web interaction score: `?/10`
- Context and input assumptions
- Missing or weak interaction states
- Feedback-loop issues
- Web-specific risks
- Priority fixes
- Suggested implementation notes

## Quality Bar

A good Web interaction audit makes the page feel obviously usable before it becomes animated. It should catch missing hover/focus/pressed/selected/loading/error states and prevent flat, uncertain, or inaccessible Web experiences.

Never recommend mobile-only gestures as the primary interaction for Web unless the product is explicitly touch-first.
