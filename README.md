# Opinionated Agentic SDLC

Minimal, deterministic feature workflow. Every feature is a self-contained unit under `.agents/<feature>/`.
Agents resolve repo locations/descriptions **only** from `.agents/config.json`.

> [!CAUTION]
> Experimental. Agents can consume large number of tokens (50k–100k tokens per agent).

## Install

Copy **once** into any workspace (skips if targets already exist; never overwrites). From your workspace, clone the repository and run:

**macOS / Linux**

```bash
./agents/install.sh
```

**Windows / WSL (PowerShell)**

```powershell
pwsh -File .\agents\install.ps1
```

What it does:

* Copies this repo’s **`.agents/` → `<workspace>/.agents/`**
* Copies this repo’s **`agents/` → `<workspace>/.claude/agents/`**

**Manual install (alternative)**
Copy `.agents/` to your workspace root, and `agents/` to `<workspace>/.claude/agents/`.

## Configure repos (`.agents/config.json`)

Agents read repo roots/descriptions here; each `repos[].key` **must match** the change folders under `.agents/<feature>/changes/<key>/`.

```json
{
  "repos": [
    {
      "key": "backend",
      "path": "../backend",
      "type": "backend",
      "description": "Firebase Functions, Firestore Rules, indexes, emulators."
    },
    {
      "key": "frontend",
      "path": "../frontend",
      "type": "app",
      "description": "Flutter app: screens, routing (GoRouter), blocs, repos, tests."
    }
  ]
}
```

> [!TIP]
> Bootstrap a feature with **`start: <feature> [links]`** (handled by the **starter** agent).

## Feature layout

```
.agents/<feature>/
  brief.md
  plan.md                # created/maintained by starter
  status.json            # machine-readable stage status by starter
  ui/                    # Figma links/exports (optional)
  research/              # principal-researcher
  arch/                  # principal-architect
  design/                # principal-design-reviewer (approved spec)
  apis/                  # principal-api-designer (OpenAPI/SDL/JSON Schemas/fixtures)
  backend/               # lead-backend-engineer plan/runbook
  flutter/               # lead-flutter-engineer plan/runbook
  qa/
    backend/             # lead-backend-qa plans/reports
    flutter/             # lead-flutter-qa plans/reports/goldens
  reviews/               # backend-review.md, flutter-review.md, required-deltas.md
  changes/
    backend/             # staged impl/tests targeting repo key "backend"
    frontend/            # staged impl/tests targeting repo key "frontend"
  closer/                # closer logs (plan.json, apply-*.log, summary.md)
```

## Flow (parallel implementation, per-track review & QA)

```
Starter → Research → Architect → Design Review → API Design
                                                    ├─ Backend Impl → Backend Review → Backend QA
                                                    └─ Flutter Impl → Flutter Review → Flutter QA
                                                    ↓
                                                    Closer (manual apply to repos)
```

* **Inputs**: previous stage folder(s) under `.agents/<feature>/…`
* **Outputs**: current stage folder
* **Changes**: staged files under `.agents/<feature>/changes/<repo-key>/` (not patches)

## Agents (current set)

* `starter` → creates/updates feature (`plan.md`, `status.json`, folders)
* `principal-researcher` → `research/`
* `principal-architect` → `arch/`
* `principal-design-reviewer` → `design/`
* `principal-api-designer` → `apis/`
* `lead-backend-engineer` → `backend/` (stages code/files under `changes/backend/`)
* `backend-code-reviewer` → `reviews/` (may apply **mechanical** fixes inside `changes/backend/`)
* `lead-flutter-engineer` → `flutter/` (stages code/files under `changes/frontend/`)
* `flutter-code-reviewer` → `reviews/` (may apply **mechanical** fixes inside `changes/frontend/`)
* `lead-backend-qa` → `qa/backend/` (may add **tests/fixtures/seeds** in `changes/backend/`)
* `lead-flutter-qa` → `qa/flutter/` (may add **tests/goldens/fixtures** in `changes/frontend/`)
* `closer` — manual finalizer that applies `.agents/<feature>/changes/<repo-key>/` into repos from `.agents/config.json`

### Closer (how it works)

When you invoke **closer** for a feature, it:

* Reads `.agents/config.json` to map `<repo-key> → path`.
* Verifies **approved** reviews and **PASS** QA (or requires a `closer/FORCE` file).
* For each `<repo-key>` with staged changes:
  * Creates branch `feature/<feature>-YYYYMMDD` in the target repo.
  * Copies the change tree into the repo (only those paths), optional `precheck.sh|ps1` and `VERIFY.md` honored.
  * Makes a single commit and writes logs under `.agents/<feature>/closer/` (`plan.json`, `apply-*.log`, `summary.md`).
* Never touches other features or unrelated repo paths.

## Rules

* Agents **must only** read repo roots from `.agents/config.json`; no hardcoded paths.
* Install scripts **do not overwrite** existing folders; they skip if the destination exists.
* Keep `changes/<key>/` folder names aligned with `repos[].key`.
* Engineering/QA agents stage files exactly as they should appear in the real repos; only **closer** applies them.
