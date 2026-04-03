---
description: Generate tests for a file, function, or recent changes
argument-hint: "[file-or-function]"
allowed-tools: Bash, Read, Write, Edit, Grep, Glob
---

# Generate Tests

Create tests with happy path, edge case, and error case coverage.

## Input

Target: $ARGUMENTS

## Steps

1. Determine what to test:
   - If `$ARGUMENTS` is a file path: generate tests for that file
   - If `$ARGUMENTS` is a function name: search for it with `Grep`, generate tests for that function
   - If `$ARGUMENTS` is empty: run `git diff --name-only` to find changed files, generate tests for those
2. Detect the test framework by checking project config files:
   - `package.json` for jest, vitest, mocha
   - `pyproject.toml` or `setup.cfg` for pytest
   - `go.mod` for go test
   - `Cargo.toml` for cargo test
   - If none found, ask the user which framework to use
3. Detect the project test convention:
   - Search for existing test files with `Glob` (`**/*.test.*`, `**/*.spec.*`, `**/test_*`, `**/*_test.*`)
   - Match the naming pattern and directory structure of existing tests
4. Read the target source code. Identify:
   - Public functions and their signatures
   - Input types and return types
   - Error conditions and edge cases
   - Dependencies that need mocking
5. Generate tests covering:
   - **Happy path**: normal inputs produce expected outputs
   - **Edge cases**: empty inputs, boundary values, null/undefined, large inputs
   - **Error cases**: invalid inputs, missing dependencies, thrown exceptions
6. Write the test file to the correct location following project convention.
7. Run the tests to verify they pass. If any fail, fix them until all pass.
8. Report: `Generated X tests in [file]. All passing.`
