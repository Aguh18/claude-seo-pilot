#!/usr/bin/env python3
"""Render freelance pipeline status from a state file."""

import json
import sys

ICONS = {"done": "✅", "running": "🔄", "pending": "⬜", "failed": "❌"}


def bar(pct):
    return "█" * (pct // 10) + "░" * (10 - pct // 10)


def render_phases(data):
    total = 0
    completed = 0

    for phase, steps in data["steps"].items():
        phase_done = sum(1 for s in steps.values() if s == "done")
        phase_total = len(steps)
        total += phase_total
        completed += phase_done

        pct = int((phase_done / phase_total) * 100) if phase_total else 0
        print(f"  {phase.upper()}")
        print(f"    [{bar(pct)}] {pct}% ({phase_done}/{phase_total})")
        for step, status in steps.items():
            print(f"    {ICONS.get(status, '?')} {step}")
        print()

    overall = int((completed / total) * 100) if total else 0
    print(f"  Overall: {completed}/{total} steps ({overall}%)")
    print(f"  Last updated: {data.get('last_updated', 'never')}")


def render_flat(data):
    """Pre-rename projects track flat step arrays rather than nested phases."""
    done = data.get("completed_steps", [])
    pending = data.get("pending_steps", [])
    total = len(done) + len(pending)
    pct = int((len(done) / total) * 100) if total else 0

    print(f"  {data.get('project', 'unnamed')}  (legacy flat state)")
    print(f"    [{bar(pct)}] {pct}% ({len(done)}/{total})")
    print()
    for step in done:
        print(f"    ✅ {step}")
    for step in pending:
        print(f"    ⬜ {step}")
    print()

    audit = data.get("last_audit", {})
    if audit:
        print(f"  Last audit: {audit.get('date', 'never')} — health {audit.get('health_score', '?')}/100")
    for action in data.get("next_actions", []):
        print(f"  → {action[:100]}")


def main():
    try:
        with open(sys.argv[1]) as f:
            data = json.load(f)
    except (OSError, json.JSONDecodeError) as exc:
        print(f"  ⚠️  Could not read state file: {exc}")
        return 1

    if "steps" in data:
        render_phases(data)
    else:
        render_flat(data)
    return 0


if __name__ == "__main__":
    sys.exit(main())
