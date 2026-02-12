---
name: promptify
description: "Transform user requests into detailed, precise prompts for AI models. Use when users say 'promptify', 'promptify this', or explicitly request prompt engineering or improvement of their request for better AI responses."
category: agent
tags: [agent, prompt-engineering, clarity, specification]
status: ready
---

# Promptify

Transform user requests into detailed, precise prompts optimised for AI model consumption.

## Core Task

Rewrite the user's request as a clear, specific, and complete prompt that guides an AI model to produce the desired output without ambiguity. Treat the output as specification language, not casual natural language.

## Process

### 1. Analyze

Read the user's request carefully. Identify:

- The core intent and desired outcome
- Missing context (audience, domain, environment)
- Unstated constraints (length, tone, format)
- Expected output format

### 2. Structure

Apply the four-block pattern to organise the prompt. See `rules/structure-four-block-pattern.md`.

- **Context** - Background, audience, domain
- **Task** - What the AI must do
- **Constraints** - Boundaries, rules, limitations
- **Output Format** - Exact structure of the response

Not every prompt needs all four blocks. Use only what adds clarity.

### 3. Refine

Apply the rules in `rules/` to sharpen the prompt:

- Replace vague terms with measurable requirements
- Add examples where the desired output is ambiguous
- Specify exact format (headings, bullet style, length)
- Break complex tasks into numbered sequential steps

### 4. Output

Present the final prompt to the user as a markdown block, clearly labeled. Do not add commentary beyond the prompt itself.

### 5. Execute

After presenting the prompt, treat it as your new instruction and proceed based on the current conversation context. Use your normal judgement to decide the best next action — plan complex tasks, implement simple ones directly, or ask clarifying questions if needed.

## Writing Guidelines

### Structure

- Begin with a single short paragraph summarising the overall task
- Use headings (##, ###, ####) for sections only where appropriate (no first-level title)
- Use **bold**, _italics_, bullet points (`-`), and numbered lists (1., 2.) liberally for organisation
- Never use emojis
- Never use `*` for bullet points, always use `-`

### Language

- Use plain, straightforward, precise language
- Avoid embellishments, niceties, or creative flourishes
- Think of language as specification/code, not natural language
- Be clear and specific in all instructions

### Content

- Keep the prompt concise: 0.75X to 1.5X the length of the original request
- Do not add or invent information not present in the input
- Do not include unnecessary complexity or verbosity
