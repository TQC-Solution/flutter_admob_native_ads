const fs = require('node:fs');

module.exports = async function release({ github, context, core, fetchImpl = fetch }) {
  const pubspec = fs.readFileSync('pubspec.yaml', 'utf8');
  const version = pubspec.match(/^version:\s*((?:0|[1-9]\d*)\.(?:0|[1-9]\d*)\.(?:0|[1-9]\d*))\s*$/m)?.[1];
  if (!version) throw new Error('pubspec.yaml must declare a stable major.minor.patch version');
  const podspec = fs.readFileSync('ios/flutter_admob_native_ads.podspec', 'utf8');
  if (podspec.match(/s\.version\s*=\s*'([^']+)'/)?.[1] !== version) {
    throw new Error('The iOS podspec version must match pubspec.yaml');
  }
  const changelog = fs.readFileSync('CHANGELOG.md', 'utf8');
  if (!changelog.includes(`## [${version}] - `)) {
    throw new Error(`CHANGELOG.md needs a dated release section for ${version}`);
  }

  const tag = `v${version}`;
  const repo = context.repo;
  let existing;
  try {
    existing = (await github.rest.git.getRef({ ...repo, ref: `tags/${tag}` })).data;
  } catch (error) {
    if (error.status !== 404) throw error;
  }
  if (existing && existing.object.sha !== context.sha) {
    core.notice(`${tag} already exists on another commit. No new version to publish.`);
    return;
  }

  const response = await fetchImpl(`https://pub.dev/api/packages/flutter_admob_native_ads/versions/${version}`);
  if (response.ok) {
    core.notice(`${version} is already published. Skipping.`);
    return;
  }
  if (response.status !== 404) {
    throw new Error(`Unable to check pub.dev version: HTTP ${response.status}`);
  }
  if (!existing) {
    await github.rest.git.createRef({ ...repo, ref: `refs/tags/${tag}`, sha: context.sha });
  }

  // GITHUB_TOKEN tag pushes do not trigger other workflows. Dispatch on the
  // tag explicitly so pub.dev receives an OIDC token with ref_type=tag.
  await github.rest.actions.createWorkflowDispatch({
    ...repo,
    workflow_id: 'publish.yml',
    ref: tag,
  });
  core.notice(`Publishing dispatched for ${tag} at ${context.sha}`);
};
