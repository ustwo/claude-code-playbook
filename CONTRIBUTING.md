# Contributing

## One rule

Nothing in this repo can reference a specific project, client, framework, database, ORM, cloud provider, or internal tooling. Every hook, command, agent, and rule must work - or be trivially adaptable - for any team using Claude Code, regardless of their stack.

If your contribution is currently project-specific, generalise it before submitting. Replace hardcoded tool names with placeholders, remove platform-specific commands, and document what the adopter needs to customise.

## How to add a new hook

1. Create the script in `hooks/scripts/<your-hook-name>.sh`. Make it executable (`chmod +x`).
2. Add a wiring example to `settings-template.json` under the appropriate event key, commented out by default so it's opt-in.
3. Document the hook in [docs/hooks.md](docs/hooks.md) - add a row to the table in section 4 with the script path and a one-line description.

Keep hook scripts focused: one script, one concern. If your hook does two things, split it into two scripts.

## How to add a new command

1. Create a `.md` file in `commands/<your-command-name>.md`.
2. Include YAML frontmatter with at least a `description` field.
3. Write the instruction body as clear, numbered steps.
4. Document the command in [docs/commands.md](docs/commands.md) - add a row to the table in section 4.

## How to add a new agent

1. Create a `.md` file in `agents/<your-agent-name>.md`.
2. Open with a one-sentence description of the agent's purpose.
3. Specify the tools the agent should have access to and what it should return.
4. Document the agent in [docs/agents.md](docs/agents.md) - add a row to the table in section 5.

## How to add a new rule

1. Create a `.md` file in `rules/<your-rule-name>.md`. One topic per file.
2. Write rules as direct instructions ("Always...", "Never...", "Prefer..."), not suggestions.
3. If the rule applies only to certain file types, add a `glob` frontmatter field.
4. Document the rule in [docs/rules.md](docs/rules.md) - add a row to the table in section 4.
