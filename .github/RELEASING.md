# Releasing to pub.dev

Release Please prepares a release PR after releasable commits reach `main`.
It updates `pubspec.yaml`, the iOS podspec, `CHANGELOG.md`, and the release
manifest. Review the PR and merge it after CI passes. The next Release Please
run creates a GitHub release and a tag such as `v1.1.1`. That tag starts
`publish.yml`, which checks the version, runs analysis, tests, and a publish
dry-run, then publishes to pub.dev using OIDC.

Release PRs are merged manually. Ordinary pushes, PR builds, and workflow
reruns do not independently increment the package version.

## One-time setup

1. Create a fine-grained GitHub personal access token with access to
   `TQC-Solution/flutter_admob_native_ads` and read/write repository permissions
   for **Contents**, **Pull requests**, and **Issues** (release labels).
   The token owner must have permission to write to this repository. Complete
   organization approval or SSO authorization if your organization requires it.
2. In the repository's **Settings > Secrets and variables > Actions**, add a
   repository secret named `RELEASE_PLEASE_TOKEN` containing that token. Renew
   the secret when the token expires. Do not use the built-in `GITHUB_TOKEN`:
   its PRs and tags do not start the downstream CI and publish workflows.
3. On pub.dev, open the package's **Admin > Automated publishing** settings and
   enable GitHub Actions publishing for:
   - Repository: `TQC-Solution/flutter_admob_native_ads`
   - Tag pattern: `v{{version}}`
4. Merge these workflow/configuration files into `main`. If needed, run
   **Actions > Release Please > Run workflow** on `main` to prepare the PR.

Publishing requires a tag push for pub.dev OIDC authentication; running the
Release Please workflow manually only prepares a PR or tags an already merged
release PR. It does not publish directly from a branch.

## Commit messages and version increments

Use Conventional Commits in the commits that land on `main`. When squash
merging, use a Conventional Commit message for the resulting squash commit.

| Commit | Version change from 1.1.0 |
| --- | --- |
| `fix: correct native ad colors` | 1.1.1 |
| `feat: add another ad layout` | 1.2.0 |
| `feat!: change the public ad API` | 2.0.0 |
| `docs: update usage examples` or `ci: update workflows` | No release by itself |

Release Please chooses the largest required increment across the pending
commits. A `BREAKING CHANGE:` footer also requests a major release.

The initial manifest starts at `1.1.0`. The bootstrap SHA is the existing
`v1.1.0` commit, so the first release includes changes after that release.
Existing manually written `[Unreleased]` notes should be reconciled with the
generated release notes when reviewing the first release PR.

## Failed publishing

If publishing fails before upload, fix the cause and re-run the failed tag
workflow when the tagged source is still valid. If code must change, release
a new version through another release PR. A version already published to
pub.dev cannot be overwritten; do not move an existing release tag.

Both CI and publishing use Flutter `3.47.2`. Update both pins together when
upgrading the supported SDK and validating dependency or API migrations.

References: [Release Please Action](https://github.com/googleapis/release-please-action)
and [pub.dev automated publishing](https://dart.dev/tools/pub/automated-publishing).
