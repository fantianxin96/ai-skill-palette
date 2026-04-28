---
name: i-handoff
description: Prepare a design or feature for implementation, QA, or AI-assisted development by creating a clear handoff brief with scope, page structure, component list, states, responsive rules, acceptance criteria, and non-negotiable design intent.
version: 1.0.0
argument-hint: "[feature or page]"
---

Turn a design direction into a clean implementation handoff.

## When To Use

Use this when a design is ready to be built, handed to another developer/AI agent, QAed, or shipped. It is also useful before asking an AI to implement a second pass so the design intent does not get lost.

## Workflow

1. **Define scope**
   - Name the feature/page.
   - State the user goal and business/product goal.
   - Separate in-scope, out-of-scope, and later ideas.

2. **Describe the experience**
   - User path and primary task.
   - Key screens/sections.
   - Important interaction states.
   - Empty, loading, error, success, long text, and edge cases.

3. **List implementation pieces**
   - Components and reusable patterns.
   - Required content and data.
   - Responsive and mobile constraints.
   - Accessibility requirements.
   - Performance or animation constraints.

4. **Protect design intent**
   - Identify what must not drift: typography, spacing, color, component rules, product voice, motion feel.
   - Reference `DESIGN.md` or the approved page when available.

5. **Write acceptance criteria**
   - Provide testable checks.
   - Include visual, interaction, responsive, accessibility, and content acceptance criteria.

## Output Format

- Handoff summary
- Scope
- User path
- Screens/sections
- Component and state inventory
- Responsive/accessibility/performance notes
- Design intent guardrails
- Acceptance criteria
- Suggested build order

## Quality Bar

A good handoff should let a developer or AI implement without guessing the important design decisions. It should be specific, testable, and protective of the user's intended experience.

Never write vague acceptance criteria like "looks good" or "works well". Make it observable.
