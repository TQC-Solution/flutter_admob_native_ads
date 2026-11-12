# Releasing to pub.dev

Each release starts in a pull request. Before opening a new PR, increase the
version in `pubspec.yaml`, set the same version in the iOS podspec, and add a
dated section to `CHANGELOG.md`. Use a patch version for fixes, minor for
compatible features, and major for breaking changes. Updates to the same PR
keep its version unless upstream has already used that version.

After merge to upstream `main`, CI runs formatting, release automation tests,
Flutter analysis, Flutter tests, and a publish dry-run. Only after those checks
pass does its release job create `v<version>` at the tested commit and dispatch
`publish.yml` on that tag. Publishing repeats analysis, tests, and the dry-run
before uploading with pub.dev OIDC.

This uses the built-in `GITHUB_TOKEN` with Contents and Actions write permissions
in the release job. No personal access token or `RELEASE_PLEASE_TOKEN` is needed.
Fork CI and pull request builds cannot start the release job.

## One-time pub.dev setup

On the package's **Admin > Automated publishing** page, configure:

- GitHub repository: `TQC-Solution/flutter_admob_native_ads`
- Tag pattern: `v{{version}}`
- **Enable publishing from `workflow_dispatch` events**: enabled
- Keep tag push publishing enabled if manual tag pushes should still work.

The dispatch option is necessary because tags created with `GITHUB_TOKEN` do
not trigger another workflow through a push event. CI explicitly dispatches the
publish workflow using the tag as its ref. Dispatching on a branch does not
publish. This option is supported by pub.dev's
[automated publishing configuration](https://github.com/dart-lang/pub-dev/blob/master/app/test/package/automated_publishing_test.dart)
and [maintainer explanation](https://github.com/dart-lang/pub-dev/issues/8507).

If repository or organization policies restrict Contents/Actions write access
or tag creation, an administrator must allow the release job to create version
tags and dispatch the publish workflow.

## Reruns and failed publishing

CI skips a version already published on pub.dev or tagged at another commit.
It never moves an existing tag. A rerun for the same tested commit can dispatch
an existing tag again if that version has not yet reached pub.dev, for example
if the first dispatch failed. Concurrent publishes for a tag are serialized.

For a failed upload, re-run the failed publish workflow or dispatch it on the
existing tag:

```sh
gh workflow run publish.yml --repo TQC-Solution/flutter_admob_native_ads --ref v1.1.1
```

If source changes are needed, use a new version in another PR. Published
versions cannot be overwritten. CI does not increase versions itself: the
reviewed PR contains the version that will be released.

Both CI and publishing use Flutter `3.47.2`. Update both pins together when
upgrading the SDK and validating dependency or API migrations.
