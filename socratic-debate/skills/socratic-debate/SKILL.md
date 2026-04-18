---
name: socratic-debate
description: This skill should be used when conducting structured multi-perspective debates to stress-test ideas, evaluate tradeoffs, or reach well-reasoned decisions. Supports binary decisions (yes/no, accept/reject, A vs B) AND multi-option comparisons (3–5 named choices). Provides the Socratic debate framework with parallel subagent roles — use whenever a decision has real tradeoffs and "it depends" is the honest first answer.
---

# Socratic Debate Framework

A structured approach to deliberation using multiple AI perspectives to stress-test ideas and reach well-reasoned conclusions.

## When to Use

- Evaluating whether to accept or reject a proposal (PR feedback, RFC, design decision)
- Choosing between multiple architectural or technology options
- Deciding whether something is worth the effort/complexity
- Any situation where "it depends" is the initial answer

## Step 0: Parse the Topic and Choose a Mode

Before spawning any agents, read the topic and count how many distinct options are being debated.

- **1 option** — Reject. Tell the user this isn't a debate and ask them to clarify what they're deciding between.
- **2 options** — Use **Binary Mode** below (FOR / AGAINST / NEUTRAL).
- **3–5 options** — Use **Multi-Option Mode** below (one Advocate per option).
- **6+ options** — Reject. Tell the user the skill supports a maximum of 5 options and ask them to consolidate or group options before proceeding.

For multi-option topics, name each option from the user's natural language (e.g. "CodeMirror 6", "Monaco", "Ace"). If options are unnamed approaches, invent short descriptive labels.

---

## Binary Mode (2 options)

Use when the topic is a yes/no, accept/reject, or A-vs-B decision.

## The Four Perspectives

### 1. Advocate FOR (Proponent)

**Role:** Make the strongest possible case in favor of the position.

**Mindset:**
- Assume the proposal has merit and find the best reasons why
- Consider benefits that may not be immediately obvious
- Think about precedent, standards, and long-term implications
- Acknowledge weaknesses only if doing so strengthens credibility

**Output format:** 250-400 word persuasive argument with a memorable closing line.

### 2. Advocate AGAINST (Devil's Advocate)

**Role:** Stress-test the idea by making the strongest counterargument.

**Mindset:**
- Look for hidden costs, complexity, or unintended consequences
- Question whether the problem being solved is overstated
- Identify alternative approaches that might be simpler
- Consider opportunity cost and what else could be done instead

**Output format:** 250-400 word counterargument with a memorable closing line.

**Important:** The goal is constructive challenge, not dismissal. A good devil's advocate helps strengthen ideas.

### 3. Neutral Analyst

**Role:** Objectively weigh both sides and identify the key tradeoffs.

**Mindset:**
- Remain impartial while still being willing to draw conclusions
- Identify where the debaters agree (often more than expected)
- Surface context or constraints that affect the decision
- Consider hybrid approaches or middle grounds

**Output format:**
1. Balanced analysis (200 words)
2. Tradeoffs table (if applicable)
3. Preliminary verdict with confidence level (low/medium/high)

### 4. Scribe/Moderator

**Role:** Synthesize all perspectives into a coherent summary and final verdict.

**Responsibilities:**
- Extract the most compelling points from each perspective
- Identify areas of agreement across all three debaters
- Resolve conflicts by weighing evidence quality
- Deliver a clear, actionable recommendation

**Output format:**
```markdown
## Socratic Debate Summary

### Topic
[Original question/topic]

### FOR (Proponent)
[Key points summarized]

### AGAINST (Devil's Advocate)
[Key points summarized]

### NEUTRAL (Analyst)
[Key tradeoffs identified]

### Points of Agreement
[What all perspectives agreed on]

### Moderator's Verdict
**Recommendation:** [accept/reject/modify/defer]
**Confidence:** [low/medium/high]
**Key Factor:** [The decisive consideration]

### Suggested Next Steps
[If applicable]
```

---

## Multi-Option Mode (3–5 options)

Use when the topic presents three or more named choices. The goal is a ranked recommendation, not a binary accept/reject.

### Phase 1: Spawn one Advocate per option (all in parallel)

For each option, spawn a subagent with this prompt:

```
You are debating: <topic>

Your role: Advocate for <Option Name>.

Make the strongest possible case for choosing <Option Name> over the alternatives:
- What makes this option distinctly better for this use case
- Its key strengths relative to the other options
- Honest acknowledgment of its weaknesses (a credible advocate admits tradeoffs)

Provide a concise argument (200–350 words) with a memorable closing line.
```

### Phase 2: Neutral Analyst (after all advocates complete)

Spawn a single Neutral Analyst with all advocate outputs:

```
You are the Neutral Analyst for a multi-option decision.

Topic: <topic>
Options being compared: <list all option names>

Advocate arguments:
<Option Name>: <advocate output>
... (one entry per option)

Your task:
1. Evaluate each option objectively against the others
2. Produce a comparison table — key decision dimensions as rows, options as columns
3. Note any options that are clearly dominated (worse on every dimension) and can be eliminated
4. Give a preliminary ranked verdict (1st, 2nd, 3rd...) with confidence level (low/medium/high)
```

### Phase 3: Scribe/Moderator (after Neutral completes)

```
You are the Scribe and Moderator for a multi-option Socratic debate.

Topic: <topic>
Options compared: <list all option names>

Advocate arguments: <all advocate outputs>
Neutral analysis: <neutral output>

Your task:
1. Synthesize all perspectives into a structured debate summary
2. For each option, summarize its strongest argument in 1–2 sentences
3. Present the comparison table from the Neutral Analyst (improve it if needed)
4. Deliver a final Moderator's Verdict:
   - Ranked recommendation (1st choice, 2nd choice, etc.)
   - Confidence: low / medium / high
   - Key Factor: the single consideration that most determined the ranking
   - Any options eliminated from contention and why
5. Suggest next steps if applicable

Assign a distinct emoji to each option and use it consistently throughout the summary. Format as polished markdown.
```

**Output format example:**

```markdown
## Socratic Debate Summary — Multi-Option

### Topic
[Original question/topic]

### Options
🔵 Option A | 🟢 Option B | 🟠 Option C

### Advocate Summaries
🔵 **Option A** — [1–2 sentence strongest case]
🟢 **Option B** — [1–2 sentence strongest case]
🟠 **Option C** — [1–2 sentence strongest case]

### Comparison

| Dimension       | 🔵 Option A | 🟢 Option B | 🟠 Option C |
|-----------------|-------------|-------------|-------------|
| [dimension]     | ...         | ...         | ...         |

### Moderator's Verdict
**Ranking:** 🟢 Option B › 🔵 Option A › 🟠 Option C
**Confidence:** [low/medium/high]
**Key Factor:** [The decisive consideration]
**Eliminated:** [Any option ruled out and why]

### Suggested Next Steps
[If applicable]
```

---

## Debate Principles

### Intellectual Honesty
- Debaters should make their best arguments, not strawmen
- Acknowledge strong points from other perspectives
- Distinguish between facts, interpretations, and opinions

### Steelmanning
- Each perspective should address the strongest version of opposing arguments
- Avoid attacking weak or irrelevant points
- Give credit where due

### Actionable Outcomes
- The goal is a decision, not endless deliberation
- Every debate should end with a clear recommendation
- Include confidence levels to indicate certainty

### Appropriate Scope
- Focus on the specific question at hand
- Avoid scope creep into tangential issues
- Time-box arguments to maintain focus

## Example Debate Topics

| Mode | Category | Example Topic |
|------|----------|---------------|
| Binary | Code Review | "Should we require this change before merging?" |
| Binary | Architecture | "Should we adopt microservices for this system?" |
| Binary | Process | "Is the added ceremony of RFCs worth it for this team?" |
| Binary | Prioritization | "Is this bug fix more urgent than feature work?" |
| Multi-Option | Technology | "Should we use CodeMirror 6, Monaco, or Ace as our editor?" |
| Multi-Option | Architecture | "Compare REST vs GraphQL vs tRPC for our API layer" |
| Multi-Option | Infrastructure | "Evaluate Redis vs Memcached vs DynamoDB for our cache" |

## Anti-Patterns to Avoid

1. **False Balance** - Not all positions deserve equal weight; evidence matters
2. **Analysis Paralysis** - The goal is a decision, not perpetual debate
3. **Bikeshedding** - Don't let low-stakes issues consume debate resources
4. **Motivated Reasoning** - Debaters should follow evidence, not justify predetermined conclusions
5. **Ignoring Context** - Recommendations should account for real-world constraints

## Output Behavior

### Default: Local reasoning, silent action

By default, the debate reasoning is shown **locally** to the user (full FOR/AGAINST/ANALYST/MODERATOR output in the conversation), but consensus fixes are applied **silently** — no debate summary is posted to PRs, issues, or external systems. The agent goes straight to implementing the consensus recommendation.

This means:
- The user sees the full deliberation process in their terminal
- External artifacts (PRs, commits, comments) reflect only the outcome, not the process
- Commit messages and PR descriptions should describe *what* changed, not *why the debate concluded X*

### Override: Post reasoning externally

If the user explicitly asks to share the debate reasoning (e.g., "post the debate to the PR", "include the reasoning in the ADR"), then include the Moderator's Summary in the external artifact.

## Integration with Workflows

The Socratic debate format works well for:

- **Code/skill review** - Debate quality, then apply consensus fixes directly
- **PR Reviews** - Debate review feedback, then post only actionable comments (not the debate itself)
- **ADRs** - Include debate summary in "Considered Alternatives" only if explicitly requested
- **RFCs** - Use as structured feedback before approval
- **Retrospectives** - Debate proposed process changes
- **Incident Reviews** - Evaluate proposed preventive measures
