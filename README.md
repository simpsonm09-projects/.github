# simpsonm09-projects GitHub defaults

Public community defaults for repositories owned by [simpsonm09-projects](https://github.com/simpsonm09-projects).

The organization overview is maintained in `profile/README.md`.

## Standards

- [standards/owner.md](standards/owner.md): the normative standard for this organization.
- [standards/core.md](standards/core.md): the shared core, byte-identical in all five owner `.github` repositories.
- `repo-standard` implements the standard: reusable workflows, checkers and apply scripts. `repo-catalog` lists the repositories it covers.

## Shared defaults

- CONTRIBUTING.md: basic contribution guidance.
- SUPPORT.md: how to ask for help.
- .github/pull_request_template.md: a concise change and verification template.
- .github/ISSUE_TEMPLATE/: bug reports and feature requests.

GitHub uses supported defaults when a repository owned by this account has no local equivalent. Local files take precedence. Defaults are not copied into clones, and defaults from an upstream organization do not automatically extend to forks owned by another account.

Fleet CI, checks, and templates are implemented in [repo-standard](https://github.com/simpsonm09-projects/repo-standard), with membership tracked in [repo-catalog](https://github.com/simpsonm09-projects/repo-catalog) and the standard in [`standards/owner.md`](standards/owner.md). These defaults do not replace the explicit files required by that standard.

Workflows, branch protection, repository settings, and agent instructions require explicit configuration. Merely placing them here does not apply them across the account.

See [GitHub's default community health file documentation](https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions/creating-a-default-community-health-file).
