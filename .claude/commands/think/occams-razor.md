---
description: Apply the simplicity principle — the simplest viable explanation or approach wins
argument-hint: "[problem with multiple possible explanations or approaches]"
allowed-tools: Read, Grep
---

# Occam's Razor

Apply the simplicity principle to: **$ARGUMENTS**

The explanation or approach that requires the fewest assumptions is most likely correct.

## Process

1. **List all possible explanations or approaches**: Enumerate every viable option.

2. **Count assumptions for each**:

| # | Approach/Explanation | Assumptions Required | Count |
|---|---------------------|---------------------|-------|
| 1 | ... | a, b, c | 3 |
| 2 | ... | a, b | 2 |
| 3 | ... | a | 1 |

3. **Rank by simplicity**: Fewest assumptions first.

4. **Viability check**: For the simplest option, does it actually explain the full situation? If not, move to the next simplest that does.

5. **Complexity justification**: If a more complex approach is chosen over a simpler one, there MUST be a concrete reason. "It might be needed someday" is not a valid reason.

## Output

- Ranked list of approaches from simplest to most complex
- The recommended approach: the simplest one that fully addresses the problem
- If the simplest is NOT recommended, explicit justification for the added complexity
- Concrete next step to implement the chosen approach
