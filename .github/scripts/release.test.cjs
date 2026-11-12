const { test } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const release = require('./release.cjs');
const version = fs.readFileSync('pubspec.yaml', 'utf8').match(/^version: (.+)$/m)[1];
const tag = `v${version}`;

function fixture({ sha, refStatus = 404, pubStatus = 404, dispatchError } = {}) {
  const calls = [];
  const repo = { owner: 'TQC-Solution', repo: 'flutter_admob_native_ads' };
  const args = {
    context: { repo, sha: 'tested-commit' },
    core: { notice() {} },
    fetchImpl: async (url) => {
      calls.push(['check', url]);
      return { ok: pubStatus === 200, status: pubStatus };
    },
    github: { rest: {
      git: {
        getRef: async () => {
          if (sha) return { data: { object: { sha } } };
          throw Object.assign(new Error('getRef failed'), { status: refStatus });
        },
        createRef: async (input) => { calls.push(['tag', input]); },
      },
      actions: {
        createWorkflowDispatch: async (input) => {
          calls.push(['dispatch', input]);
          if (dispatchError) throw new Error('dispatch failed');
        },
      },
    } },
  };
  return { args, calls, repo };
}

test('new version tags the tested SHA and explicitly dispatches on that tag', async () => {
  const { args, calls, repo } = fixture();
  await release(args);
  assert.deepEqual(calls, [
    ['check', `https://pub.dev/api/packages/flutter_admob_native_ads/versions/${version}`],
    ['tag', { ...repo, ref: `refs/tags/${tag}`, sha: 'tested-commit' }],
    ['dispatch', { ...repo, workflow_id: 'publish.yml', ref: tag }],
  ]);
});

test('retry dispatches the existing tag at the same SHA without recreating it', async () => {
  const { args, calls } = fixture({ sha: 'tested-commit' });
  await release(args);
  assert.deepEqual(calls.map(([name]) => name), ['check', 'dispatch']);
});

test('existing tag at a different SHA is never moved or published', async () => {
  const { args, calls } = fixture({ sha: 'older-commit' });
  await release(args);
  assert.deepEqual(calls, []);
});

test('published version skips tag creation and dispatch', async () => {
  const { args, calls } = fixture({ pubStatus: 200 });
  await release(args);
  assert.deepEqual(calls.map(([name]) => name), ['check']);
});

test('GitHub permission failure cannot be mistaken for a missing tag', async () => {
  const { args, calls } = fixture({ refStatus: 403 });
  await assert.rejects(release(args), /getRef failed/);
  assert.deepEqual(calls, []);
});

test('pub.dev outage does not create a tag or dispatch a release', async () => {
  const { args, calls } = fixture({ pubStatus: 503 });
  await assert.rejects(release(args), /HTTP 503/);
  assert.deepEqual(calls.map(([name]) => name), ['check']);
});

test('dispatch failure is reported so the same tag can be retried', async () => {
  const { args } = fixture({ dispatchError: true });
  await assert.rejects(release(args), /dispatch failed/);
});

test('invalid version fails before any GitHub or pub.dev mutation', async (t) => {
  const { args, calls } = fixture();
  t.mock.method(fs, 'readFileSync', () => 'version: 1.2.3-rc.1\n');
  await assert.rejects(release(args), /stable major.minor.patch/);
  assert.deepEqual(calls, []);
});

test('podspec version mismatch fails before release', async (t) => {
  const { args, calls } = fixture();
  const read = fs.readFileSync;
  t.mock.method(fs, 'readFileSync', (path, encoding) =>
    path.endsWith('.podspec') ? "s.version = '0.0.0'" : read(path, encoding));
  await assert.rejects(release(args), /podspec version must match/);
  assert.deepEqual(calls, []);
});

test('missing release notes fail before release', async (t) => {
  const { args, calls } = fixture();
  const read = fs.readFileSync;
  t.mock.method(fs, 'readFileSync', (path, encoding) =>
    path === 'CHANGELOG.md' ? '# Changelog\n' : read(path, encoding));
  await assert.rejects(release(args), /dated release section/);
  assert.deepEqual(calls, []);
});
