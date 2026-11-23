# .github working agreements

The public organization profile for `simpsonm09-projects`, and the normative repository
standard for the organization.

## Ground rules

- `standards/core.md` is byte-identical in the five owner `.github` repositories. Change
  it only in one pull request per owner with the same content, and check the result with
  `just core-drift`. Never edit this copy alone.
- `standards/owner.md` is the standard for this owner. Policy lives there; the reusable
  workflows, checkers and apply scripts live in `repo-standard`, and the roster lives in
  `repo-catalog`.
- `profile/README.md` is the public organization profile. Do not edit it in a standards
  change.
- No secret, credential, or machine path is committed.

## Commands

- `just`, `just fmt`, `just fmt-check`, `just check`, `just core-drift`.

## Repo facts

- No application code. One Bun TypeScript script, `scripts/core-drift.ts`; tools are
  pinned in `mise.toml`.
- `standards/` holds the standard. `CONTRIBUTING.md`, `SUPPORT.md` and the templates are
  the account-level community defaults, not the standard.
- `.github` has no workflows by owner decision. It records that gap in
  `standards/owner.md` rather than adding CI.

## Skills

No repo-local skills. General best practices and integration come from the plugins.
