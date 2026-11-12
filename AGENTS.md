# Repository instructions

## Release preparation

- Before creating a new PR, increase the package version in `pubspec.yaml` from
  the current upstream `main` version: patch for compatible fixes, minor for
  compatible features, and major for breaking changes.
- Use a stable `major.minor.patch` version. Keep the version in
  `ios/flutter_admob_native_ads.podspec` identical and add a dated release section
  to `CHANGELOG.md`.
- Keep the same version when updating an existing PR, unless upstream `main`
  has already used that version. Check upstream before pushing the final update.
- Run the relevant checks and `flutter pub publish --dry-run` from a clean
  checkout. Do not include unrelated local changes.
- Merge to upstream `main` starts CI. After CI passes, the release job creates
  `v<version>` and dispatches publishing on that tag using `GITHUB_TOKEN`.
  Do not add a personal release token. See `.github/RELEASING.md`.
