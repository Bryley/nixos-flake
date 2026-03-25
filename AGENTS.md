# AGENTS.md

Guidance for coding agents working in `/Users/bryley/nixos-flake`.

## 1) Repository at a glance

- Primary stack: **NixOS flake** with modular NixOS configuration.
- Main entry points:
  - `flake.nix` (inputs + `nixosConfigurations` output)
  - `lib.nix` (`buildSystem` helper for host definitions)
  - `modules/*.nix` (shared module logic)
  - `hosts/<name>/*.nix` (host-specific overrides)
  - `Justfile` (day-to-day operational commands)
- Metadata:
  - `meta.toml` drives hosts/users/public keys.

## 2) Important directories

- `hosts/`
  - Host-level configuration (`desktop`, `laptop`, etc.)
  - Keep host files focused on overrides only.
- `modules/`
  - Shared feature modules (`essential`, `software`, `users`, `nvidia`, `disko`).
  - Preferred place for reusable logic and options.
- `configs/`
  - Dotfiles and app configs (Neovim, Nushell, etc.).
  - These folders are the source of truth and are symlinked into `~/.config/`.
  - When asked to edit a user config, edit files under `configs/<app>/`, not under `~/.config/`.
  - Contains a nested agent setup at `configs/opencode/AGENTS.md`.

## 3) Build, lint, and test commands

Use these commands from repo root.

### Core operational commands (from `Justfile`)

- List available tasks:
  - `just --list --unsorted`
- Safe switch (requires clean git tree):
  - `just switch`
- Fast switch (no clean-tree guard):
  - `just quick-switch`
- Garbage collect old generations:
  - `just gc`
- Dotfile symlink setup:
  - `just setup-dotfiles`
- Provisioning flows:
  - `just add [ip]`
  - `just install <name> [ip|local]`

### Build / validation commands

- Evaluate all flake outputs:
  - `nix flake show`
- General flake validation:
  - `nix flake check`
- Build a single host system closure (most useful targeted check):
  - `nix build .#nixosConfigurations.<host>.config.system.build.toplevel`
  - Example: `nix build .#nixosConfigurations.laptop.config.system.build.toplevel`
- Evaluate only one host derivation path (quick sanity check):
  - `nix eval .#nixosConfigurations.<host>.config.system.build.toplevel.drvPath`

### Lint / format commands

This repo does not define a single enforced lint script at root.
Use tool-specific checks when editing relevant files:

- Nix formatting:
  - `nix shell nixpkgs#nixfmt-rfc-style -c nixfmt **/*.nix`
- Nix static checks:
  - `nix shell nixpkgs#statix -c statix check .`
- Optional dead code scan for Nix:
  - `nix shell nixpkgs#deadnix -c deadnix .`

If these tools are unavailable in your environment, use the nearest equivalent
from `nixpkgs` and keep behavior consistent with existing formatting.

### Running a single test (important)

There is no dedicated unit-test suite in this repository root.
Use **single-host build** as the test-equivalent unit:

- `nix build .#nixosConfigurations.<host>.config.system.build.toplevel`

Treat that as the “single test” for one machine profile.

## 4) Code style guidelines

### 4.1 Nix imports and module structure

- Prefer module files shaped like:
  - function args attrset
  - optional `let` bindings
  - final attrset with `imports`, `options`, `config`
- Keep `imports = [ ... ];` explicit and one item per line.
- In shared modules, define options under `options.modules.<name>`.
- Use `cfg = config.modules.<name>;` when options drive behavior.
- Prefer `lib.mkIf` for conditional config blocks.
- Prefer `lib.mkMerge [ ... ]` when combining large config fragments.
- Use `lib.mkDefault` for defaults that hosts can override.

### 4.2 Formatting conventions

- Indentation: 2 spaces (no tabs in Nix files).
- Use trailing semicolons in attrsets.
- Keep lists vertically aligned when non-trivial.
- Favor multiline attribute sets over dense one-liners.
- Keep comments concise and directly above related code.

### 4.3 Types and option design

- For module options, use typed options (`lib.mkOption`, `lib.types.*`).
- Use `lib.mkEnableOption` for feature flags.
- Provide sensible defaults and short descriptions.
- Add `example` values for user-supplied string options when useful.

### 4.4 Naming conventions

- File names: lowercase, descriptive (`essential.nix`, `users.nix`).
- Module namespace: `modules.<feature>.*`.
- Boolean flags: `enable`, `headless`, `...enable`.
- Keep host names stable and directory-aligned (`hosts/<host>`).
- Prefer descriptive local names: `cfg`, `paths`, `dotfiles`, `runtimeInputs`.

### 4.5 Error handling and safety

- Use Nix `assertions` for invalid option combinations.
  - Example pattern exists in `modules/nvidia.nix`.
- Guard optional filesystem references with `builtins.pathExists`.
  - Example pattern exists in `lib.nix`.
- In operational scripts, fail early on unsafe state.
  - `just switch` currently blocks when git tree is dirty.
- When adding shell/Nushell logic, keep confirmations for destructive actions.

### 4.6 Packages and dependencies

- Add shared packages in `modules/software.nix`.
- Keep host-specific package decisions in host files only when necessary.
- Group package lists by purpose (CLI, GUI, VM, etc.) with comment headers.
- Prefer existing patterns (`with pkgs; [ ... ]`) used in this codebase.

## 5) Agent workflow expectations

- Make minimal, targeted changes.
- Preserve existing style and comment voice.
- Do not introduce broad refactors unless requested.
- Validate with the smallest meaningful command first:
  1. `nix eval ...drvPath` for quick checks
  2. `nix build ...toplevel` for changed host/module scope
  3. `nix flake check` for wider validation

## 6) Nested agent instructions

- A separate agent instruction set exists at:
  - `configs/opencode/AGENTS.md`
- When working specifically inside `configs/opencode/`, read and follow that
  nested file in addition to this root guidance.
