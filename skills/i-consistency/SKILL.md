---
name: i-consistency
description: Check and align multiple pages, views, or components against an existing design system or approved reference page. Use when later pages drift from the first page in typography, spacing, colors, components, states, motion, or copy tone.
version: 1.0.0
argument-hint: "[target page or project]"
---

Keep new pages and components aligned with the approved visual and interaction system.

## When To Use

Use this when the user says a second page does not match the first, pages feel like different products, spacing or colors drift, or a project needs multi-page consistency.

Your job is not to invent a new direction. Your job is to pull the current target back toward the reference system.

## Workflow

1. **Locate the reference**
   - First look for `DESIGN.md`, design tokens, component docs, or existing style rules.
   - If no system artifact exists, identify the approved reference page/component and extract a quick working baseline.
   - If the user has not named a reference, ask for the page they like or infer from the most polished existing page.

2. **Compare target against reference**
   Check for drift in:
   - Typography: font family, sizes, weights, line heights, title/body/meta hierarchy, Chinese type rhythm.
   - Color: background, surfaces, borders, text contrast, accent usage, selected/hover/copied states.
   - Spacing: page margins, section gaps, card padding, list density, grid rhythm, mobile one-screen pressure.
   - Components: buttons, cards, inputs, nav, modals, toasts, empty/loading/error states.
   - Interaction: hover, pressed, selected, loading, result reveal, modal open/close, focus states.
   - Copy tone: labels, helper text, empty states, errors, CTA verbs, product voice.
   - Responsive behavior: breakpoints, touch targets, safe areas, text wrapping, overflow.

3. **Prioritize issues**
   - P0: breaks core task or makes page unusable.
   - P1: obvious visual drift from the reference system.
   - P2: minor inconsistency that users may feel but can still use.
   - P3: polish detail.

4. **Fix by aligning, not redesigning**
   - Reuse existing tokens/classes/components when possible.
   - Prefer small targeted edits over broad restyling.
   - Preserve the target page's unique content and layout purpose.
   - Do not introduce a new palette, new font system, new radius system, or unrelated component style.

5. **Verify**
   - Compare before/after visually when possible.
   - Check desktop and mobile if the interface is responsive.
   - Confirm repeated components now share the same rules.
   - If a design-system artifact was missing or incomplete, recommend running `$i-system`.

## Output Format

When reviewing only:

- Consistency score: `?/10`
- Reference used
- Top drift issues by priority
- What should stay unique on this page
- Recommended fixes
- Whether `$i-system` is needed first

When editing:

- State the reference system used.
- List the aligned areas.
- Mention any intentional differences preserved.
- Verify the target now follows the same visual language.

## Quality Bar

A good `i-consistency` pass makes pages feel like one product without flattening every page into the same layout. Preserve purpose; align language, components, spacing, states, and tone.

Never solve consistency by making everything generic. The goal is coherence, not sameness.
