# Socratic Debate

Conduct a structured multi-perspective debate on a topic using 4 specialized subagents.

## Usage

```
/socratic-debate <topic or question>
```

## Arguments

- `$ARGUMENTS` - The topic, question, or context to debate (can reference current conversation context)

## Instructions

You will orchestrate a Socratic debate by spawning 4 subagents. First read the skill at `skills/socratic-debate/SKILL.md` to understand the debate framework and guidelines.

### Subagent Roles

1. **Advocate FOR** - Makes the strongest possible case in favor of the position/proposal
2. **Advocate AGAINST** - Devil's advocate making the strongest counterargument
3. **Neutral Analyst** - Weighs both sides objectively, identifies tradeoffs
4. **Scribe/Moderator** - Synthesizes all perspectives into a structured summary with verdict

### Execution

**Phase 1: Spawn Debaters (parallel)**

Launch 3 Task subagents simultaneously with `subagent_type=general-purpose`:

1. **FOR Agent** prompt:
   ```
   You are debating: $ARGUMENTS

   **Your role: Advocate FOR / in favor of this position**

   Make the strongest possible case FOR this position. Consider:
   - Technical merits and benefits
   - Risk mitigation / safety improvements
   - Precedent and best practices
   - Long-term implications of accepting

   Be persuasive but intellectually honest. Acknowledge weaknesses only if they strengthen your overall argument.

   Provide a concise argument (250-400 words) with a memorable closing line.
   ```

2. **AGAINST Agent** prompt:
   ```
   You are debating: $ARGUMENTS

   **Your role: Devil's Advocate AGAINST this position**

   Make the strongest possible case AGAINST this position (or for deprioritizing it). Consider:
   - Costs, overhead, or complexity introduced
   - Whether the problem is overstated
   - Alternative approaches or tradeoffs
   - Opportunity cost of addressing this

   Be persuasive but intellectually honest. Your goal is to stress-test the idea, not dismiss it unfairly.

   Provide a concise argument (250-400 words) with a memorable closing line.
   ```

3. **NEUTRAL Agent** prompt:
   ```
   You are debating: $ARGUMENTS

   **Your role: Neutral Analyst**

   Objectively analyze both sides of this debate:
   - What are the strongest points on each side?
   - What are the key tradeoffs?
   - What context or constraints affect the decision?
   - Are there hybrid approaches or middle grounds?

   Provide:
   1. Balanced analysis (200 words)
   2. Key tradeoffs table (if applicable)
   3. Your preliminary verdict with confidence level (low/medium/high)

   Remain impartial but willing to take a position based on evidence.
   ```

**Phase 2: Synthesize (after Phase 1 completes)**

Launch the Scribe/Moderator agent with the outputs from all 3 debaters:

4. **Scribe/Moderator Agent** prompt:
   ```
   You are the Scribe and Moderator for a Socratic debate.

   **Original topic:** $ARGUMENTS

   **FOR argument:**
   [Insert FOR agent output]

   **AGAINST argument:**
   [Insert AGAINST agent output]

   **NEUTRAL analysis:**
   [Insert NEUTRAL agent output]

   Your task:
   1. Synthesize all three perspectives into a well-formatted debate summary
   2. Extract the most compelling points from each side
   3. Identify any points of agreement across perspectives
   4. Provide a final **Moderator's Verdict** with:
      - Clear recommendation (accept/reject/modify/defer)
      - Confidence level (low/medium/high)
      - Key factor(s) that drove the decision
   5. If applicable, suggest next actions

   Format the output as a polished markdown document suitable for posting as a PR comment, Slack message, or documentation.
   Use emoji headers for each perspective (e.g., green for FOR, red for AGAINST, balance scale for NEUTRAL).
   ```

### Output

Display the Scribe/Moderator's synthesized debate summary to the user.

If the user's original request mentioned posting somewhere (PR comment, Slack, etc.), offer to post the formatted output there.

## Examples

```
/socratic-debate Should we fix Copilot's suggested description change before merging?
/socratic-debate Is it worth refactoring this module to use dependency injection?
/socratic-debate Should we adopt Rust for this performance-critical service?
/socratic-debate PR #1893 - evaluate the tradeoffs of the proposed Vault policy changes
```
