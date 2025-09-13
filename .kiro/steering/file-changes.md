---
inclusion: always
---

# File Change Confirmation Rules

## Before Making Any File Changes

You MUST follow this process before modifying or creating any files:

1. **Show Current State**: Read and display the current file content (if it exists)

2. **Present Diff Preview**: Show exactly what will change using diff format:
   ```diff
   - old content
   + new content
   ```

3. **List New Files**: Clearly state any new files that will be created with their full content

4. **Request Confirmation**: Ask "Should I proceed with these changes?" and wait for user approval

5. **Only Then Execute**: Make the actual file changes after receiving confirmation

## Example Format

```
Current file content:
[show current content]

Proposed changes:
[show diff]

New files to create:
- filename.ext: [show content]

Should I proceed with these changes?
```

## Exceptions

- Only skip confirmation for simple read operations or when explicitly told to "just do it"
- Always show diffs for any file modifications, no matter how small

This ensures transparency and prevents unwanted file modifications.