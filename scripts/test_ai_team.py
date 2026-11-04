import importlib.util
import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest
from unittest.mock import patch

SCRIPT = Path(__file__).with_name('ai_team.py')
spec = importlib.util.spec_from_file_location('ai_team', SCRIPT)
team = importlib.util.module_from_spec(spec)
spec.loader.exec_module(team)


class IntegrationTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.root = Path(self.temp.name)
        subprocess.run(['git', 'init', '-q', str(self.root)], check=True)
        (self.root / '.gitignore').write_text('/.context/\n')
        (self.root / 'code.txt').write_text('original\n')
        subprocess.run(['git', '-C', str(self.root), 'add', '.'], check=True)
        subprocess.run(['git', '-C', str(self.root), '-c', 'user.name=Fixture', '-c', 'user.email=fixture@example.invalid', 'commit', '-qm', 'initial'], check=True)

    def tearDown(self):
        self.temp.cleanup()

    def call(self, *args):
        return subprocess.run(['python3', str(SCRIPT), *args], cwd=self.root, capture_output=True, text=True)

    def test_init_preserves_original_base_and_existing_brief(self):
        self.assertEqual(self.call('init').returncode, 0)
        state = (self.root / '.context/ai-team/task.json').read_text()
        brief = self.root / '.context/ai-team/brief.md'
        brief.write_text('user requirements')
        (self.root / 'code.txt').write_text('changed')
        self.assertEqual(self.call('init').returncode, 0)
        self.assertEqual(state, (self.root / '.context/ai-team/task.json').read_text())
        self.assertEqual(brief.read_text(), 'user requirements')

    def test_review_requires_known_scope_and_brief(self):
        self.assertNotEqual(self.call('review').returncode, 0)
        self.call('init')
        self.assertNotEqual(self.call('review').returncode, 0)

    def test_fingerprint_detects_untracked_and_tracked_changes(self):
        before = team.fingerprint(self.root)
        (self.root / 'new.txt').write_text('new')
        untracked = team.fingerprint(self.root)
        self.assertNotEqual(before, untracked)
        (self.root / 'code.txt').write_text('changed')
        self.assertNotEqual(untracked, team.fingerprint(self.root))

    def test_reports_do_not_invalidate_review(self):
        before = team.fingerprint(self.root)
        self.call('init')
        (self.root / '.context/ai-team/report.md').write_text('report')
        self.assertEqual(before, team.fingerprint(self.root))

    def test_bootstrap_preserves_existing_files(self):
        (self.root / 'AGENTS.md').write_text('local instructions')
        (self.root / 'docs').mkdir()
        (self.root / 'docs/development.md').write_text('local setup instructions')
        self.assertEqual(self.call('bootstrap').returncode, 0)
        self.assertEqual((self.root / 'AGENTS.md').read_text(), 'local instructions')
        alias = self.root / '.claude/skills'
        self.assertTrue(alias.is_symlink())
        self.assertEqual(alias.readlink(), Path('../.agents/skills'))
        for name in ('team-design', 'team-build', 'team-review', 'update-master', 'cleanup-old-images'):
            self.assertTrue((alias / name / 'SKILL.md').samefile(self.root / '.agents/skills' / name / 'SKILL.md'))
        self.assertFalse((self.root / '.claude/commands').exists())
        self.assertEqual((self.root / 'CLAUDE.md').read_text(), '@AGENTS.md\n')
        for name in ('architecture.md', 'app-architecture.md', 'development.md', 'conductor.md'):
            self.assertTrue((self.root / 'docs' / name).is_file())
        self.assertEqual((self.root / 'docs/development.md').read_text(), 'local setup instructions')
        (alias / 'team-build/SKILL.md').write_text('local implementation instructions')
        once = (self.root / '.gitignore').read_text()
        self.assertEqual(self.call('bootstrap').returncode, 0)
        self.assertEqual(once, (self.root / '.gitignore').read_text())
        self.assertEqual((self.root / '.agents/skills/team-build/SKILL.md').read_text(), 'local implementation instructions')

    def test_bootstrap_migrates_existing_skills_with_supporting_files(self):
        skill = self.root / '.claude/skills/team-build'
        (skill / 'references').mkdir(parents=True)
        (skill / 'SKILL.md').write_text('custom skill')
        (skill / 'references/example.md').write_text('custom reference')
        result = self.call('bootstrap')
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertTrue((self.root / '.claude/skills').is_symlink())
        canonical = self.root / '.agents/skills/team-build'
        self.assertEqual((canonical / 'SKILL.md').read_text(), 'custom skill')
        self.assertEqual((canonical / 'references/example.md').read_text(), 'custom reference')
        self.assertTrue((skill / 'SKILL.md').samefile(canonical / 'SKILL.md'))

    def test_bootstrap_preserves_both_versions_on_skill_conflict(self):
        for location, contents in (('.agents', 'canonical skill'), ('.claude', 'legacy skill')):
            skill = self.root / location / 'skills/team-build'
            skill.mkdir(parents=True)
            (skill / 'SKILL.md').write_text(contents)
        unique = self.root / '.claude/skills/custom'
        unique.mkdir()
        (unique / 'SKILL.md').write_text('unrelated skill')
        self.assertNotEqual(self.call('bootstrap').returncode, 0)
        self.assertFalse((self.root / '.claude/skills').is_symlink())
        self.assertEqual((self.root / '.agents/skills/team-build/SKILL.md').read_text(), 'canonical skill')
        self.assertEqual((self.root / '.claude/skills/team-build/SKILL.md').read_text(), 'legacy skill')
        self.assertEqual((unique / 'SKILL.md').read_text(), 'unrelated skill')

    def test_bootstrap_preserves_unexpected_skill_link(self):
        external = self.root / 'external-skills'
        external.mkdir()
        (external / 'notes.md').write_text('untouched')
        alias = self.root / '.claude/skills'
        alias.parent.mkdir()
        alias.symlink_to('../external-skills', target_is_directory=True)
        self.assertNotEqual(self.call('bootstrap').returncode, 0)
        self.assertEqual(alias.readlink(), Path('../external-skills'))
        self.assertEqual(list(external.iterdir()), [external / 'notes.md'])
        self.assertEqual((external / 'notes.md').read_text(), 'untouched')

    def test_api_auth_is_rejected(self):
        result = subprocess.CompletedProcess([], 0, 'Logged in using an API key', '')
        with patch.object(team.subprocess, 'run', return_value=result):
            with self.assertRaises(RuntimeError):
                team.check_auth('codex', 'codex', {})
        result = subprocess.CompletedProcess([], 0, json.dumps({'loggedIn': True, 'authMethod': 'api_key'}), '')
        with patch.object(team.subprocess, 'run', return_value=result):
            with self.assertRaises(RuntimeError):
                team.check_auth('claude', 'claude', {})

    def test_provider_overrides_are_removed_from_child_only(self):
        with patch.dict(os.environ, {'ANTHROPIC_API_KEY': 'test-value', 'OPENAI_API_KEY': 'test-value'}):
            env = team.environment()
            self.assertNotIn('ANTHROPIC_API_KEY', env)
            self.assertNotIn('OPENAI_API_KEY', env)
            self.assertIn('ANTHROPIC_API_KEY', os.environ)


if __name__ == '__main__':
    unittest.main()
