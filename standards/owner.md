# simpsonm09-projects repository standard

`simpsonm09-projects` holds the owner's professional coding projects: developer tooling,
shared CI, AI workflows, API testing and utilities. This document is the normative
standard for the organization. [`core.md`](core.md) applies in full, and this owner
adjusts only the rules marked **(profile)**. The implementation moved: `repo-standard`
holds the reusable workflows, checkers and apply scripts, and `repo-catalog` holds the
roster and the tiers. Neither repository states policy of its own.

The `simpsonm09` user account is out of scope, except for the repositories that moved
there (see [Repositories that left this owner](#repositories-that-left-this-owner)).

## Scope

All 19 repositories are public on the GitHub Free plan. There are no private
repositories and no forks in the organization.

| Repository                                            | Visibility | Kind            | Notes                                                                 |
| ----------------------------------------------------- | ---------- | --------------- | --------------------------------------------------------------------- |
| `repo-standard`                                       | public     | standard        | Reusable workflows, checkers and apply scripts. Implementation only.  |
| `repo-catalog`                                        | public     | catalog         | Roster, tiers and the tier policy.                                    |
| `repo-template`                                       | public     | template        | GitHub template; Kotlin and Spring Boot reference service.            |
| `.github`                                             | public     | profile         | This repository. Normative standard at `standards/`; no workflows.    |
| `org-ai-plugin`                                       | public     | plugin          | Organization plugin layer: shared skills and integrations.            |
| `personal-ai-plugin`                                  | public     | plugin          | Personal plugin layer.                                                |
| `maxstack`                                            | public     | tooling         | Workspace AI installer; Linux-only, the Windows installer is dropped. |
| `dev-setup`                                           | public     | tooling         | Retired Windows workstation setup; archived 2026-11-23 (C9.1, C5.6).  |
| `postman-test-utils`                                  | public     | tooling         | Offline Postman and newman suite.                                     |
| `playwright-api-wrapper`                              | public     | feature         | HTTP API that runs one Playwright scenario per request.               |
| `browser-calculator`                                  | public     | feature         | Fastify calculator with a safe arithmetic evaluator.                  |
| `pokeapi-wrapper`                                     | public     | feature         | FastAPI wrapper; reference for the generated-OpenAPI rule.            |
| `fixture-nest`                                        | public     | fixture         | Conformance fixture.                                                  |
| `fixture-go`                                          | public     | fixture         | Conformance fixture.                                                  |
| `fixture-rust`                                        | public     | fixture         | Conformance fixture.                                                  |
| `fixture-dotnet`                                      | public     | fixture         | Conformance fixture.                                                  |
| `pdf-field-automation-acrobat`                        | public     | archived legacy | Retired. Read-only.                                                   |
| `pstack-opencode-plugin`                              | public     | archived legacy | Retired. Read-only.                                                   |
| `the-gaming-index-video-game-database-final-capstone` | public     | archived legacy | Retired course project. Read-only.                                    |

Archived repositories are read-only and outside the active rules. Their only obligation
is the archive note from C9.1: the description starts `Retired (archived):`, the README
opens with a `> **Retired.**` note that says what replaced it, and no scheduled workflow
runs. Do not unarchive one without a new scope decision.

## Plan and protection

The organization is on GitHub Free, so every repository is public. Public repositories
on Free support repository rulesets, required status checks, native auto-merge, secret
scanning, push protection and CodeQL default setup. This owner keeps every repository
public, which is what makes C2.1 enforceable without a paid plan.

### Public repositories: C2.1 enforcement

One ruleset, `protect-main`, targets `refs/heads/main` and is active. It has no bypass
actors. Its rules are:

- Block deletions, force pushes and branch creation. `main` is created once and never
  again.
- Require a pull request before merging, with `required_approving_review_count: 0`.
  Passing checks are the gate (C2.2).
- Allow squash merges only: `allowed_merge_methods: ["squash"]` (C2.3). Merge commits
  and rebase merges are also disabled in repository settings, because the ruleset only
  constrains merges that go through a pull request.
- Dismiss stale approvals on push and require review-thread resolution. Both stay on
  even at zero required approvals, so a resolved conversation is still a condition.
- Do not require a code-owner review, a last-push approval, or an extra approval for
  unattributed changes. A solo maintainer cannot supply them.
- Require signed commits (C2.7).
- Require the status checks in [Required checks](#required-checks), and require the
  branch to be up to date before merging.

There is no `approval-main` ruleset. With zero required approvals and no bypass actors,
a second review ruleset would exist only to carry a bypass. The apply scripts retire it
in the repository-standard follow-up.

A second ruleset, `protect-tags`, targets `refs/tags/v*` and blocks update, deletion and
force push.

Repository settings outside the rulesets:

| Setting                                     | Value                       |
| ------------------------------------------- | --------------------------- |
| Default branch                              | `main`                      |
| Merge commit, rebase merge                  | off                         |
| Squash merge                                | on                          |
| Delete branch on merge                      | on                          |
| Auto-merge                                  | on                          |
| Issues                                      | on                          |
| Wiki, Projects, Discussions                 | off                         |
| Default `GITHUB_TOKEN`                      | read-only                   |
| Require actions pinned to a full-length SHA | on                          |
| Secret scanning and push protection         | on                          |
| Dependabot alerts and security updates      | on                          |
| Description and owner topic                 | set (`simpsonm09-projects`) |

The owner is subject to the same rules. There is no administrator bypass and no
`gh pr merge --admin`. A broken required check is fixed, or removed from the required
set with a recorded exception; it is not bypassed.

### Private repositories on Free: the fallback

No private repository exists today. If one becomes unavoidable, it cannot carry
rulesets on Free, so C2.1 is enforced locally and visibly:

- A `lefthook.yml` loading `hooks/core.yml` and `hooks/owner.yml` through `remotes` at the
  `hooks-v3` tag and installed by `just hooks`; its `core-policy` job refuses every push whose
  destination is `refs/heads/main`. The hook is the primary guard.
- A `guard-main` workflow triggers on `push` to `main`, fails, and opens an issue that
  names the pusher and the commit. It cannot revert the push; its purpose is to make
  the violation impossible to miss.
- An `automerge` workflow supplies C3.3. A pull request labeled `automerge` waits for
  every check on its exact head, then runs `gh pr merge --squash --auto`. The workflow
  never labels `major-update` PRs and removes the label when checks fail.
- Required checks are advisory on the pull request because branch protection is not
  available. The merge step in the workflow is the gate, and it refuses a red head.

The exception row `C2.1` in `docs/exceptions.md` records the plan limitation and a
revisit date. The repository returns to the ruleset path when it becomes public.

## Profile choices

| Rule | Choice                                                                                                                                           |
| ---- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| C1.5 | Issues are on. Wiki, Projects and Discussions are off in every repository. None is used.                                                         |
| C2.7 | Commits are signed with SSH signing and `protect-main` requires signatures. The existing setup stays. GitHub signs the squash commit it creates. |

## Required checks

Each check is a job in the repository's own `.github/workflows/ci.yml`. Its context is
the job name. Never add a required context that no job reports, because the pull
request would wait forever.

| Context     | Recipe                                             | Required when                    |
| ----------- | -------------------------------------------------- | -------------------------------- |
| `fmt`       | `just fmt-check`                                   | every repository                 |
| `lint`      | `just lint`                                        | every repository                 |
| `typecheck` | `just typecheck`                                   | every repository with TypeScript |
| `test`      | `just test-changed` on a PR, `just test` on `main` | every repository                 |
| `coverage`  | `just coverage`                                    | every covered repository         |
| `standard`  | `just standard`                                    | every repository                 |
| `aislop`    | `just aislop`                                      | every repository                 |
| `security`  | `just security`                                    | every repository                 |
| `secrets`   | `just secrets`                                     | every repository                 |

Non-required jobs, which run on `main`, on a schedule, or on the pull request without
blocking it:

| Job             | Runs              | Why                                                                |
| --------------- | ----------------- | ------------------------------------------------------------------ |
| `secrets-full`  | `main` and weekly | Full-history gitleaks scan.                                        |
| `security-full` | `main` and weekly | Trivy misconfiguration and licence scans.                          |
| `test-<suffix>` | when declared     | A stable second suite, required only after it is green for a week. |
| CodeQL          | default setup     | Never required.                                                    |

Rules behind the set:

- `just check` runs `fmt-check`, `lint` and `typecheck`, the parts a local run can share.
  CI runs each in its own parallel job so one failure does not hide another.
- Coverage gates changed lines only: 80 percent of changed lines and 70 percent of
  changed branches, measured against the merge base. A documentation-only change has no
  measured units and passes. A repository without a measurable suite records
  `ci/coverage` in `docs/exceptions.md` with a **Records** or **Not measurable** reason
  and a revisit date.
- The old contexts map as follows: `lint / flint` → `fmt` plus `lint`; `aislop / aislop`
  → `aislop`; `security / trivy` → `security`; `security / secrets` → `secrets`;
  `standard / standard` → `standard`; `coverage / coverage` → `coverage`; `test` stays
  `test`. During migration both sets may exist; the old set is removed in the same pull
  request that adds the new jobs.

### CI speed (C5)

The target is a required-check wall time under 60 seconds, measured from the first job
starting to the last required check finishing, as the median of the last 20 pull request
runs. The plan is concrete:

1. Cache the mise tool set with `jdx/mise-action` caching on, and cache Bun's install
   cache. A job that needs no dependencies installs none.
2. Run the required jobs in parallel, with `concurrency` and
   `cancel-in-progress: true` per pull request. Only `coverage` waits for `test`, and
   only because it consumes the report.
3. On a pull request, scan the diff only: gitleaks over `base..head` and Trivy over
   changed paths with `--scanners vuln --diff`. Full-history gitleaks, Trivy
   misconfiguration and Trivy licence scans move to `main` and the weekly schedule as
   non-required jobs.
4. Gate coverage on changed lines and branches only. There is no whole-repository floor.
5. Select tests from the diff with `just test-changed`. The full suite runs on every
   push to `main` and weekly, so selection never hides a failure for long. When the
   selector cannot map a change to a package, it runs the full suite.
6. Keep CodeQL default setup and scheduled audits out of the required path.
7. Measure before and after. `just ci-median` prints the median from the last 20 pull
   request runs; a repository that cannot reach 60 seconds records `C5.5` with the
   measured median and what dominates it.

`just fleet-audit` re-derives this conformance list read-only, and `just fleet-audit --timing`
adds the C5.1 median; `scripts/fleet-audit.ts` is the shared copy of the tool.

## CI-only required checks

C5.7 requires the pull-request checks to be the hook recipes. The `protect-main`
rulesets still require the old `workflow / job` contexts during the migration in
[Required checks](#required-checks); each one below is decided, not left open.
`just fleet-audit` accepts a context only while it is named in this section.

Four checks cannot run inside the hook budgets (pre-commit under 3 s, pre-push under
30 s), so they stay required and this table is the owner-standard rule that names
them (C5.7). Every other check is folded into `pre-push-check` and CI confirms it.

| Context    | Old context during migration | Why it is CI-only                                                                                        | Measured locally       |
| ---------- | ---------------------------- | -------------------------------------------------------------------------------------------------------- | ---------------------- |
| `standard` | `standard / standard`        | `check-repo` reads the repository's GitHub settings and ruleset through the API; a hook cannot see them. | 2.2 s tree-local       |
| `security` | `security / trivy`           | Trivy downloads the vulnerability database; the action caches it per day.                                | ~10 s warm, >60 s cold |
| `aislop`   | `aislop / aislop`            | Fetches the npm package tree, so a hook would block a push when the registry is unreachable.             | 2.1 s warm, 9.2 s cold |
| `coverage` | `coverage / coverage`        | The changed-line gate needs the pull request's base commit and the pinned `patch-coverage` checker.      | 0.3–4 s for the recipe |

The folded checks, measured per repository on a warm cache: `fmt` (`just fmt-check`, 0.03–0.1 s),
`lint` (`just lint`, 0.1–0.4 s), `typecheck` (0.07–1 s), `test` (0.3–10 s) and `secrets`
(`just hook-pre-push` scans the exact pushed range). `just pre-push-check` measured 0.9–9 s.

The `hooks` job keeps its name and runs `lefthook install`, the merged-config assertion and
`lefthook validate` (C7.9), plus the four recipes that only a hook ran before — `agent-files`,
`forbidden-files`, `workflows`, `shellcheck` — so every hook check has a CI confirmation. The
decision table also lives in `repo-standard/docs/validation.md`.

`maxstack` also requires `test-node`. That job runs `just lint` and the three Node test files;
`pre-push-check` runs both through `just lint` and `just test`, so the hook covers it without
running the suite twice. Its `pre-push-check` measures 4.6 s and its `hooks` job confirms the four
hook-only recipes like every other repository.

## Git hooks

Hooks run through Lefthook, pinned in `mise.toml` as `"aqua:evilmartians/lefthook"` (C7.8). Each
repository's `lefthook.yml` loads `hooks/core.yml` and `hooks/owner.yml` from this repository
through `remotes` at the annotated tag `hooks-v3`, and adds its own jobs under names that never
start with `core-` or `owner-`. Repositories migrate from the old `.githooks` launchers to Lefthook
per core C7.8.

This owner's `hooks/owner.yml` job runs before every commit:

| Job             | Recipe               | Behaviour                                                                                                                                       |
| --------------- | -------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| `owner-signing` | `just signing-check` | Fails when `commit.gpgsign` is not true or `user.signingkey` is unset for this checkout, because `protect-main` requires signed commits (C2.7). |

`just hooks` removes a local `core.hooksPath` only when it equals `.githooks`, refuses any other
value or a global one, runs `lefthook install`, and then asserts that `lefthook dump` contains the
`core-*` and `owner-*` jobs, because a failed remote fetch only warns. `lefthook-local.yml` is
git-ignored, and agents never skip hooks: no `LEFTHOOK=0`, no `--no-verify` (C7.11).

## Owner rules

### Governance split

This file is the standard. `repo-standard` holds the reusable workflows, checkers,
apply scripts and implementation guides, and its docs link here instead of restating
policy. `repo-catalog` holds `repos.json` and `ignore.json`. Every live organization
repository is either in `repos.json` or in `ignore.json` with a reason; catalog
validation fails when the roster and the organization disagree.

### Merging

Squash merge only. Merge commits and rebase merges are disabled in both the ruleset and
the repository settings. The squash commit uses the pull request title and body, so the
title is the Conventional Commit and the body explains the change.

### Dependency automation

Dependabot minor and patch updates group per ecosystem and enable native auto-merge when
the pull request opens. GitHub merges only after every required check on the exact head
commit passes. Major updates carry `major-update`, never enable auto-merge, and wait for
the owner. A pull request that changes a workflow, a ruleset or a security setting does
not auto-merge, even when Dependabot opened it.

### Scripts

Repository scripts are TypeScript executed by Bun and called through `just`. The old
rule that every operational script ships as a bash and a PowerShell twin is dropped.
Bash remains only as a thin launcher for a git hook or a one-line wrapper. PowerShell is
allowed only for code that runs on a Windows target (C5.6). No repository here has one
after this change: `maxstack` is Linux-only and `dev-setup` is archived. Python
stays only where TypeScript cannot do the job, recorded in `docs/exceptions.md`.

Existing `.mjs` checkers in `repo-standard` migrate to Bun TypeScript one script at a
time. New scripts are `.ts` from the start. `tsconfig.json` enables `strict`, `bun check`
is the type check, and `bun test` is the test runner. No `ts-node`, `tsx`, `jest` or
`vitest` in new code.

### JavaScript and TypeScript toolchain

Bun is the whole toolchain. Biome, `tsc` as a standalone step, Vitest and flint's
JavaScript checks are retired.

| Job     | Command                                                    | Recipe              |
| ------- | ---------------------------------------------------------- | ------------------- |
| install | `bun install --frozen-lockfile`                            | `install`           |
| format  | `bun fmt` / `bun fmt --check`                              | `fmt` / `fmt-check` |
| lint    | `bun lint --no-script` (oxlint until `bun lint` is stable) | `lint`              |
| types   | `bun check`                                                | `typecheck`         |
| test    | `bun test`                                                 | `test`              |
| build   | `bun build`                                                | `build`             |

`package.json` has no `fmt` or `lint` script, and `--no-script` makes that explicit.
When Bun ships a stable native linter, the recipe stays the same and only the Bun pin
moves.

Flint stays, but only as the aggregator for non-JavaScript languages. Python, Go, Rust,
Kotlin, C#, shell, Markdown, YAML and workflow files still need per-language tools and
one activation point; flint already provides that from `mise.toml` and
`.github/config/flint.toml`. Removing it would replace one pinned aggregator with six
hand-wired recipes. Flint no longer activates `biome` or `biome-format`, `biome` leaves
`mise.toml`, and `biome.jsonc` is deleted where it served only JavaScript.

### Skills

`.agents/skills/<name>/SKILL.md` is canonical. Each skill also has the relative symlink
`.claude/skills/<name>` → `../../.agents/skills/<name>`, because Claude Code reads only
the second path (C8.2, C8.3). `.claude/skills/` holds no real directory. `just
agent-files` fails when the two sets differ, a link is broken, or a skill names a recipe
that does not exist. A clone where links became text files fails the same recipe.

The three consumer repositories that still carry `.claude/skills/verify/` move it to
`.agents/skills/verify/` plus a symlink in one pull request. Do not keep two copies.

### CodeQL

CodeQL default setup is on for every public repository with a supported language. Per
repository `codeql.yml` is deleted. A repository whose language matrix default setup
cannot express records `C6.1` in `docs/exceptions.md` and keeps a workflow. CodeQL is
never a required context.

### Bypass actors

`protect-main` has no bypass actors, so no agent and no administrator can push to `main`
or merge a red pull request. The live `OrganizationAdmin` entry (15 repositories) and the
fleet App `Integration` entry (6 repositories) are removed, and the App itself is retired.

Agents use the owner's own accounts: there is no organization App, installation token or
per-repository access level, and the rulesets, required checks and hooks are the boundary.

### Owner guards

Every repository-local workflow tests `github.repository_owner == 'simpsonm09-projects'`.
The pre-rename spelling `simpsonm09-org` is dead and is removed wherever it appears. A
workflow that runs only inside this owner's repositories needs no owner guard at all;
delete the guard rather than update it when it serves no second purpose.

### Repositories that left this owner

These moves happened in November 2026. They are not part of this standard and must not
be added back to the roster:

| Repository                     | Destination                   | State         |
| ------------------------------ | ----------------------------- | ------------- |
| `openclaw-homelab`             | `sakuragaoka-homelab`         | Active there. |
| `machine-inventory`            | `sakuragaoka-homelab`         | Active there. |
| `steam-wishlist-cleanup`       | `simpsonm09` user account     | Active there. |
| `pdf-field-automation-acrobat` | archived in this organization | Read-only.    |

`pstack-opencode-plugin` and `the-gaming-index-video-game-database-final-capstone` are
also archived in this organization.

### Exceptions

A rule this standard cannot meet is recorded in the repository's own
`docs/exceptions.md`: one row per rule with the rule id, the reason and a revisit date.
An exception without a reason or a date is drift. The central
`repo-standard/docs/exceptions.json` is superseded; a new opt-out no longer needs a
change to `repo-standard`. The `standard` job reads the repository-local file.

Coverage exceptions use the two core reason types. **Records** means the repository has
no executable code under test. **Not measurable** names the part the shared workflow
cannot measure.

### Community files, documentation and definition of done

Each active repository carries the community file set: `README.md`,
`CODE_OF_CONDUCT.md`, `CONTRIBUTING.md`, `SECURITY.md`, `LICENSE`, `SUPPORT.md` and
`favicon.svg`. `LICENSE`, `SECURITY.md`, `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`,
`SUPPORT.md`, `.editorconfig`, `.aislop/config.yml`, the pull request template and the
three issue templates are byte-identical across the fleet. `CODEOWNERS` and
`.gitattributes` are per repository. `CODEOWNERS` maps `*` to exactly `@simpsonm09`.
Public code is MIT licensed with the 2026 copyright line.

The docs layout is `docs/README.md` as index, `docs/manifest.json` with
`readme`/`features`/`diagrams`/`api`, one feature document per user-facing feature, and a
mermaid diagram where a flow exists. A generated OpenAPI or AsyncAPI document is marked
`linguist-generated` and regenerated by `just spec`, which CI diffs. Optional additions
are `docs/decisions.tsv`, `docs/runbooks/` and `docs/machines/`.

The root README stays under about 120 lines and keeps the fixed order: `# <name>`,
purpose, source-of-truth block, optional `## Status`, `## What it does`,
`## Quick start`, `## Commands`, `## Documentation`, optional `## Layout`,
`## License`, optional `## Related repositories`. Commands go through `just`. The
source-of-truth block names `simpsonm09-projects/<repo>`, the branch-and-PR rule, and
links `repo-standard` for the implementation.

A change is done when all nine hold: `standard` green; `test` and changed-line coverage
green; the behavior verified on the real artifact and stated in the pull request; signed
commits; no secret, credential or machine path committed; docs match the change;
generated files marked; a release note when the repository publishes; and a decision
trail when a human will review the work after stepping away. A compile or a green lint
is not proof of behavior.

### Pinning and tool versions

Every `uses:` is a full 40-character commit SHA with a trailing `# vX.Y.Z` comment.
Reusable-workflow callers pin a reviewed commit of `repo-standard`, never `@main`.
Tools pin in `mise.toml`; images pin a version tag or digest. Dependabot updates the SHA
and the comment together. All repositories pin the same versions:

| Tool         | Version                               |
| ------------ | ------------------------------------- |
| `just`       | 1.59.0                                |
| `bun`        | 1.4.5                                 |
| `actionlint` | 1.7.12                                |
| `zizmor`     | 1.30.1                                |
| `flint`      | 0.22.14 (non-JavaScript checks only)  |
| `gitleaks`   | 8.30.1                                |
| `aislop`     | 0.16.1                                |
| Python       | 3.12                                  |
| Node         | legacy only; new code does not use it |

Language toolchains (`go`, `rust`, `dotnet`, JDK/Gradle) pin in `mise.toml` per
repository at versions the repository's own build supports. `maxstack` moves from Node
22 and Python 3.13 to Bun and Python 3.12 as its installer migrates.

### Testing

Each repository adds a `test` job that runs its own suite through `just test`. A second
suite is `test-<suffix>` and stays non-required until it has been green for a week. Every
job runs on `ubuntu-*` runners (C5.6). Windows-target code that a repository keeps is
linted and parsed on Linux, never built or tested on a Windows runner. Pull requests run
`just test-changed`; `main` and the weekly schedule run the full suite.

## Superseded

This file replaces the policy text in the older standard repositories. Those
repositories are not edited here; each change is a follow-up pull request.

| Older document                             | What moved to this file                                           | What remains in place                          |
| ------------------------------------------ | ----------------------------------------------------------------- | ---------------------------------------------- |
| `repo-standard/docs/adoption.md`           | The gate, community set, docs layout and agent-file rules.        | The step list becomes an implementation guide. |
| `repo-standard/docs/governance.md`         | Branch model, required checks, coverage states and bypass policy. | Ruleset payloads and checkers.                 |
| `repo-standard/docs/github-settings.md`    | Settings, topics, secret scanning and auto-merge.                 | `apply-settings` script.                       |
| `repo-standard/docs/definition-of-done.md` | The nine items.                                                   | Pull request template link.                    |
| `repo-standard/docs/pinning.md`            | Pinning rules.                                                    | Dependabot and pin-update workflow.            |
| `repo-standard/docs/documentation.md`      | Docs layout.                                                      | Checker.                                       |
| `repo-standard/docs/root-readme.md`        | README shape.                                                     | README template.                               |
| `repo-standard/docs/community.md`          | Community file set.                                               | Checker.                                       |
| `repo-standard/docs/testing.md`            | Test jobs.                                                        | Checker.                                       |
| `repo-standard/docs/coverage.md`           | Changed-line gate and coverage states.                            | Coverage workflow and patch-coverage checker.  |
| `repo-standard/docs/linting.md`            | JavaScript/TypeScript toolchain and flint scope.                  | Flint configuration for non-JavaScript tools.  |
| `repo-standard/docs/task-runner.md`        | Recipe set.                                                       | Justfile template.                             |
| `repo-standard/docs/scripting.md`          | TypeScript-on-Bun scripts.                                        | Hooks and checkers.                            |
| `repo-standard/docs/local-runs.md`         | The local/CI parity rule.                                         | Implementation detail.                         |
| `repo-standard/docs/validation.md`         | `docs/exceptions.md` mechanism.                                   | Checkers.                                      |
| `repo-standard/docs/automation.md`         | Dependabot, auto-merge and CodeQL policy.                         | Workflows.                                     |
| `repo-standard/docs/agents-and-skills.md`  | Skill paths.                                                      | Templates.                                     |
| `repo-catalog/policy.md`                   | Tiers and the membership rule.                                    | Roster JSON and validator.                     |

What changed from the old standard:

| Area                 | Old                                                     | Now                                                                   |
| -------------------- | ------------------------------------------------------- | --------------------------------------------------------------------- |
| Merge methods        | Merge, squash and rebase                                | Squash only                                                           |
| Auto-merge           | Explicitly off everywhere                               | Dependabot minor/patch auto-merge after required checks; majors held  |
| Scripts              | Bash and PowerShell twin for every operational script   | TypeScript on Bun through `just`; PowerShell only for Windows targets |
| JavaScript toolchain | Biome, `tsc`, Vitest, flint JS checks                   | `bun fmt`, `bun lint`, `bun check`, `bun test`                        |
| Lint aggregation     | Flint for every language                                | Flint for non-JavaScript languages only                               |
| Skills               | `.claude/skills/`                                       | `.agents/skills/` plus `.claude/skills/<name>` symlinks               |
| CodeQL               | Per-repository advanced `codeql.yml`                    | Default setup; no `codeql.yml`                                        |
| CI speed             | No target                                               | Required checks under 60 seconds (C5)                                 |
| Exceptions           | Central `repo-standard/docs/exceptions.json`            | Per-repository `docs/exceptions.md`                                   |
| Review ruleset       | `approval-main` plus `protect-main`                     | One `protect-main`, zero approvals, no bypass                         |
| Bypass actors        | Organization admin and fleet App on live `protect-main` | None                                                                  |
| Agent `full`         | Push to `main` or change settings                       | Not granted to agents; read as `merge`                                |
| Owner guards         | `simpsonm09-org` and `simpsonm09-projects` tests        | `simpsonm09-projects` only, or deleted                                |
| Moved repositories   | Part of the roster                                      | Moved out or archived, listed above                                   |

Follow-up pull requests, in order. None is part of this change:

1. `repo-standard` docs: point every guide at `.github/standards/owner.md`, delete
   duplicated policy text, keep implementation steps.
2. `repo-standard` rulesets: `allowed_merge_methods: ["squash"]`, no bypass actors, drop
   `approval-main`, update required contexts, regenerate `ops.generated.just`.
3. `repo-standard` CI: reusable workflows for `fmt`, `lint`, `typecheck`, `test`,
   `coverage`, `standard`, `aislop`, `security` and `secrets`; diff scans on pull
   requests; mise caching; parallel jobs; diff-selected tests; 60-second budget.
4. `repo-standard` toolchain: migrate `.mjs` checkers to Bun TypeScript, remove
   PowerShell twins except Windows-target code, drop `biome`, pin `aislop` in
   `mise.toml`.
5. `repo-standard` CodeQL: delete the `codeql.yml` template and document default setup.
6. `repo-catalog`: link `policy.md` to this file, retire agent `full`, update the tier
   defaults and the ignored archived repositories.
7. Consumers: delete `codeql.yml`, remove `simpsonm09-org` guards, set squash-only and
   auto-merge, turn wiki and projects off, turn delete-branch on, remove the live
   `protect-main` bypass actors, adopt the new check contexts, and add
   `docs/exceptions.md` where a gap is recorded.
8. `browser-calculator`, `postman-test-utils` and `playwright-api-wrapper`: move
   `.claude/skills/verify/` to `.agents/skills/verify/` plus a symlink. Delete
   `browser-calculator/templates/agents/`, which nothing reads.

## Conformance backlog

The CI median is the median wall time of the `ci` workflow on pull requests, from the
audit snapshot's last ten runs. The sample is small (two to eight runs per repository),
so the number shows scale rather than a precise baseline.

Every active repository also shares these gaps, which the table does not repeat:
merge commit and rebase are enabled, auto-merge is off, wiki and Projects are on,
CodeQL runs from an advanced `codeql.yml`, the JavaScript path uses Biome or Vitest,
scripts are `.mjs`, the required contexts are the old names, `approval-main` still
exists, and `simpsonm09-org` guards remain.

| Repository                                            | Specific gaps                                                                                                                                                                    | Proposed fix                                                                                                                                                 | CI median              |
| ----------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---------------------- |
| `repo-standard`                                       | Two main rulesets; docs duplicate policy; 48 `.mjs` scripts and a PowerShell twin; stale caller-template pin; `simpsonm09-org` guards.                                           | Follow-ups 1–5.                                                                                                                                              | 66 s                   |
| `repo-catalog`                                        | `protect-main` has `OrganizationAdmin` bypass; `policy.md` claims 1 approval and a bypass the payload does not have.                                                             | Remove the actor; replace the prose with a link.                                                                                                             | 77 s                   |
| `repo-template`                                       | `protect-main` has `OrganizationAdmin`; default setup not enabled; `dependabot-summary.yml` names the pre-rename repository.                                                     | Remove the actor; enable default setup; fix the identity.                                                                                                    | 149 s                  |
| `maxstack`                                            | `OrganizationAdmin` bypass; no coverage, recorded centrally only; Node 22 and Python 3.13; 14 `.ps1` (dropped as it becomes Linux-only) and 53 `.mjs`; 12-line `AGENTS.md`.      | Remove the actor; add repo-local coverage exception; converge pins; migrate scripts; make it Linux-only; expand `AGENTS.md`.                                 | 848 s (one 1682 s run) |
| `org-ai-plugin`                                       | `OrganizationAdmin` bypass; aislop audit off under a central exception.                                                                                                          | Remove the actor; record the exception locally.                                                                                                              | 161 s                  |
| `personal-ai-plugin`                                  | `OrganizationAdmin` bypass; aislop audit off; `docs/` has no `README.md`.                                                                                                        | Remove the actor; local exception; add the docs index.                                                                                                       | 349 s                  |
| `dev-setup`                                           | `OrganizationAdmin` bypass; coverage excepted centrally; 14 `.ps1` and 4 `.sh`; a `windows-2022` workflow (C5.6); no `.env.example`.                                             | Archive it (C9.1): it is the Windows workstation setup and this owner is Linux-only.                                                                         | 271 s                  |
| `browser-calculator`                                  | `OrganizationAdmin` and `Integration` bypass; Vitest and Biome; inert `templates/agents/`; `AGENTS.md` claims to be the reference implementation.                                | Remove both actors; migrate toolchain; delete the inert copy; name `repo-template` as the reference.                                                         | 185 s                  |
| `postman-test-utils`                                  | `OrganizationAdmin` and `Integration` bypass; aislop audit off; Vitest and Biome.                                                                                                | Remove both actors; local exception; migrate toolchain.                                                                                                      | 116 s                  |
| `playwright-api-wrapper`                              | `OrganizationAdmin` and `Integration` bypass; Vitest and Biome.                                                                                                                  | Remove both actors; migrate toolchain.                                                                                                                       | 252 s                  |
| `pokeapi-wrapper`                                     | `OrganizationAdmin` and `Integration` bypass.                                                                                                                                    | Remove both actors.                                                                                                                                          | 176 s                  |
| `fixture-nest`                                        | `OrganizationAdmin` bypass; Vitest and Biome.                                                                                                                                    | Remove the actor; migrate toolchain.                                                                                                                         | 41 s                   |
| `fixture-go`                                          | No bypass. `all-checks` exists but `ALL_CHECKS_REQUIRED` is false.                                                                                                               | Add the aggregate to the required set, or delete the flag and job.                                                                                           | 225 s                  |
| `fixture-rust`                                        | `OrganizationAdmin` and `Integration` bypass.                                                                                                                                    | Remove both actors.                                                                                                                                          | 206 s                  |
| `fixture-dotnet`                                      | `OrganizationAdmin` bypass; no `.env.example` and no `.worktreeinclude`.                                                                                                         | Remove the actor; add both files.                                                                                                                            | 128 s                  |
| `.github`                                             | No ruleset, no workflows and no required checks by owner decision; secret scanning off; no LICENSE or CODE_OF_CONDUCT; merge/rebase on; delete-branch off; wiki and Projects on. | Apply `protect-main` after this merge; turn secret scanning on; add LICENSE and CODE_OF_CONDUCT; converge settings. Record the no-workflow choice as `C5.1`. | n/a                    |
| `pdf-field-automation-acrobat`                        | Archived; description and README lack the C9.1 retirement note.                                                                                                                  | Edit the archived repository once to add the note.                                                                                                           | n/a                    |
| `pstack-opencode-plugin`                              | Archived; retirement note not confirmed.                                                                                                                                         | Confirm or add the C9.1 note.                                                                                                                                | n/a                    |
| `the-gaming-index-video-game-database-final-capstone` | Archived; retirement note not confirmed.                                                                                                                                         | Confirm or add the C9.1 note.                                                                                                                                | n/a                    |

The two largest required-check medians are `maxstack` and `personal-ai-plugin`. Both are
dominated by the same causes: unsharded tests and full-history scanning. The C5 plan
addresses both.
