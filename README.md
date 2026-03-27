# Claude Code Playbook

A collection of Claude Code hooks, commands, agents, and rules from our engineering team. Everything here is copy-paste ready and stack-agnostic - adapt it to your project in minutes, not hours.

## What's inside

| Directory | What it contains |
|---|---|
| [hooks/scripts/](hooks/scripts/) | Shell scripts that fire automatically on Claude Code lifecycle events |
| [commands/](commands/) | Reusable slash commands for common workflows (start ticket, gate check, raise PR) |
| [agents/](agents/) | Specialised subagents for planning, architecture, build errors, and database review |
| [rules/](rules/) | Ambient context files Claude loads as standing instructions |
| [docs/](docs/) | Guides for hooks, commands, agents, rules, context management, adoption, and settings |
| [hooks/settings-template.json](hooks/settings-template.json) | Ready-to-use `settings.json` with all hooks wired up |

## Quick start

- Copy `hooks/scripts/dev-server-block.sh`, `prettier-format.sh`, and `auto-approve-safe-commands.sh` into `.claude/hooks/scripts/` in your project
- Copy `settings-template.json` to `.claude/settings.json` and update the paths
- Open Claude Code - hooks fire automatically from this point on

For a fuller setup including commands, agents, and rules, see [docs/adoption.md](docs/adoption.md).

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## Licence

MIT
