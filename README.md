# Agentic SDLC for Claude Code

![glootie](./resources/glootie.png)

**Streamlined, efficient feature workflow** with dual-mode operation. Every feature is a self-contained unit under `.agents/<feature>/`.
Agents resolve repo locations/descriptions **only** from `.agents/config.json`.

> [!NOTE]
> **Optimized**: Reduced from 12 to 6 agents. Token consumption reduced 60-70%. Feature completion time: 15+ hours → <5 hours.

```mermaid
graph TD
  %% Streamlined Agentic SDLC — dual-mode flow

  A[Plan Agent] --> B{Mode}
  B -->|Manual| C[Manual Execution]
  B -->|Auto| D[Automated Pipeline]

  D --> E[Research]
  E --> F[Architect]
  F --> G{Feature Complexity}
  G -->|Complex| H[API Designer]
  G -->|Simple CRUD| I1
  H --> I1

  subgraph Parallel Implementation
    I1[Backend Engineer]
    I2[Flutter Engineer]
  end

  I1 --> J1[Backend Tester]
  I2 --> J2[Flutter Tester]

  J1 --> K[Direct Repo Application]
  J2 --> K

  C --> E
```

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

Agents read repo roots/descriptions here for direct application of changes.

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

## Starting Features

> [!TIP]
> **Manual Mode**: `start: <feature> [links]` - Creates structure for manual agent execution
>
> **Automated Mode**: `start: <feature> --auto [links]` - Runs complete pipeline automatically

## Feature layout

```
.agents/<feature>/
  brief.md
  plan.md                # created/maintained by plan agent
  status.json            # real-time stage status
  workflow.md            # automated pipeline decisions (auto mode)
  ui/                    # Figma links/exports (optional)
  research/              # streamlined: current-state, options, recommendation
  arch/                  # combined architecture and design specifications
  apis/                  # conditional: complex features only
  backend/               # backend implementation notes
  flutter/               # flutter implementation notes
  qa/
    backend/             # backend tester reports
    flutter/             # flutter tester reports/goldens
  changes/
    backend/             # direct application to backend repo
    frontend/            # direct application to flutter repo
```

## Agents (streamlined set)

* `plan` → dual-mode orchestrator: manual planning or automated pipeline execution
* `research` → focused discovery and analysis (`research/current-state.md`, `options.md`, `recommendation.md`)
* `architect` → combined architecture and design specifications (`arch/`, `design/` if UI present)
* `api-designer` → **conditional** API specifications for complex features only (`apis/`)
* `backend-engineer` → backend implementation with direct repo application
* `backend-tester` → backend testing & QA with fresh testing perspective
* `flutter-engineer` → flutter implementation with direct repo application
* `flutter-tester` → flutter testing & QA with fresh testing perspective

### Key Improvements

* **Direct Application**: Engineers apply changes directly to repos (no staging/closer complexity)
* **Conditional API Designer**: Skipped for simple CRUD, invoked for complex business logic
* **Separate Perspectives**: Implementation vs testing agents provide different viewpoints
* **Real-time Status**: All agents update `plan.md` and `status.json` with progress
* **Intelligent Selection**: Plan agent selects appropriate agents based on feature complexity

## Rules

* Agents **must only** read repo roots from `.agents/config.json`; no hardcoded paths.
* Install scripts **do not overwrite** existing folders; they skip if the destination exists.
* Keep `changes/<key>/` folder names aligned with `repos[].key`.
* Engineer agents apply changes directly to repos on feature branches.
* All agents update `plan.md` and `status.json` with real-time progress.
* API designer is conditionally invoked based on feature complexity assessment.
