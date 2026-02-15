from __future__ import annotations

import subprocess
import unittest
from pathlib import Path


class TestHomebrewTapBumpNilsCliSkill(unittest.TestCase):
    def setUp(self) -> None:
        self.skill_root = Path(__file__).resolve().parents[1]

    def test_contract_section_exists(self) -> None:
        text = (self.skill_root / "SKILL.md").read_text("utf-8", errors="replace")
        self.assertIn("## Contract", text)
        for heading in [
            "Prereqs:",
            "Inputs:",
            "Outputs:",
            "Exit codes:",
            "Failure modes:",
        ]:
            self.assertIn(heading, text)
        self.assertIn("--wait-release-timeout <seconds>", text)
        self.assertIn("--assume-no-release-ci", text)

    def test_entrypoint_help(self) -> None:
        script = self.skill_root / "scripts" / "homebrew-tap-bump-nils-cli.sh"
        self.assertTrue(script.is_file())
        out = subprocess.check_output(["bash", str(script), "--help"], text=True)
        self.assertIn("Usage:", out)
        self.assertIn("--wait-release-timeout <seconds>", out)
        self.assertIn("--wait-release-interval <seconds>", out)
        self.assertIn("--release-workflow <name>", out)
        self.assertIn("--assume-no-release-ci", out)
