# Repository Guidelines

## Project Structure & Module Organization
- This is a Homebrew tap containing Ruby formulae.
- Root-level `.rb` files define packages (e.g., `pulseview.rb`, `libsigrok.rb`).
- Each formula follows the `ClassName < Formula` pattern and may include a `test do` block.

## Build, Test, and Development Commands
- Install from this tap: `brew tap olegtarasov/sigrok` then `brew install --build-from-source olegtarasov/sigrok/pulseview`.
- Run formula tests: `brew test olegtarasov/sigrok/pulseview` (executes the formula’s `test do`).
- Lint/style: `brew style olegtarasov/sigrok` (Rubocop rules for Homebrew).
- Audit checks: `brew audit --strict --online olegtarasov/sigrok/pulseview` (verify URLs, deps, caveats).
- Local iteration example:
  - `brew uninstall pulseview` and `brew install --build-from-source ./pulseview.rb` while editing.

## Coding Style & Naming Conventions
- Ruby, 2-space indentation; keep lines concise and readable.
- File is `name.rb`; class is `ClassName` (CamelCase matching formula name).
- Prefer stable `url` + `sha256`; add `head` for Git builds if useful.
- Use `depends_on`, `uses_from_macos`, and `on_macos/on_linux` for portability.
- Keep `def install` minimal, use standard helpers (`system`, `inreplace`, `std_cmake_args`).

## Testing Guidelines
- Provide a meaningful `test do` that validates a core binary (`--version`, `--help`, or a small operation).
- Keep tests network-free and fast; avoid external services.
- Run `brew test` for the target formula and ensure it passes on clean environments.

## Commit & Pull Request Guidelines
- Commits: imperative mood, focused scope (e.g., "Update sigrok-cli deps").
- Reference issues/PRs when relevant (e.g., "fixes #123").
- PRs should include: summary of change, rationale, build/test results, and `brew audit`/`brew style` outputs.
- Touch only relevant formulae; avoid unrelated churn.

## Agent-Specific Instructions
- Respect Homebrew best practices; prefer upstream patches over large inline changes.
- Do not add new tooling without maintainer approval.
- If modifying multiple formulae, separate changes into individual PRs when possible.
