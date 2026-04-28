---
name: i-system
description: Extract and maintain a reusable design system from an existing interface. Use when the user has a page or component they like and wants later pages to keep the same colors, typography, spacing, components, states, interaction feel, and product voice.
version: 1.0.0
argument-hint: "[source page or project]"
---

Extract the design decisions from a good interface and turn them into a reusable project design system.

## When To Use

Use this when the user says a page "feels right", wants the next page to match it, or asks to create/update a `DESIGN.md`, design tokens, style guide, UI rules, or project visual language.

Do not redesign the page. Your job is to observe, name, and codify the rules that already make it work.

## Workflow

1. **Find the source of truth**
   - Identify the page, component, screenshot, Figma node, or running app state the user considers the reference.
   - If the source is a local app or web page, inspect the actual files and visual result when feasible.
   - Note which parts are intentionally good and which parts are accidental or should not be copied.

2. **Extract foundation rules**
   - Color: background, surface, border, primary action, secondary action, text, muted text, success/error/warning, overlays.
   - Typography: font family, display/title/body/caption sizes, weights, line heights, letter spacing, Chinese text rhythm.
   - Spacing: page margins, section gaps, component padding, row gaps, list density, mobile safe areas.
   - Shape and depth: radius scale, border weight, shadow/elevation, blur/translucency rules.
   - Layout: grid/flex patterns, max widths, card proportions, sidebar/header/content relationships.

3. **Extract component rules**
   - Buttons: size, padding, radius, states, primary/secondary/destructive hierarchy.
   - Cards: padding, icon treatment, title/body/meta hierarchy, hover/pressed/selected states.
   - Inputs/search: height, placeholder tone, focus style, error style.
   - Navigation: active state, hover state, density, icon/text relationship.
   - Modals/toasts/loading/empty states: placement, motion, tone, and copy conventions.

4. **Extract product voice**
   - Describe the emotional direction in plain words, not abstract adjectives only.
   - Capture UX copy rules: how button text, empty states, errors, confirmations, and helper text should sound.
   - Include "do not" rules that prevent drift.

5. **Write or update the system artifact**
   - Prefer `DESIGN.md` at the project root unless the repo already has another design-system file.
   - If a design-system file exists, update it instead of creating a competing source of truth.
   - Keep the artifact specific enough to guide later implementation, but not so brittle that every pixel becomes a rule.

6. **Add a reuse checklist**
   - Include a short checklist for future pages: typography, color, spacing, components, states, responsive, copy tone.
   - Make the checklist easy for `$i-consistency` to use later.

## Output Format

When planning only:

- Reference source
- Extracted system summary
- Design rules to keep
- Rules to avoid
- Proposed `DESIGN.md` structure

When editing:

- Create/update the design-system artifact.
- Summarize the specific rules captured.
- Mention how future pages should invoke `$i-consistency` against it.

## Quality Bar

A good `i-system` result lets another page feel related without copying layout blindly. It should preserve the product's visual DNA: typography hierarchy, spacing rhythm, component behavior, and tone.

Never create vague rules like "make it modern" or "use nice spacing". Name the actual values, relationships, and behaviors that make the current design work.
