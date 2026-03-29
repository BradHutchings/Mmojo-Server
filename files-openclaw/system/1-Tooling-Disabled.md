# Disabled Tooling Prompts

Stuff taken out of 1-Tooling.md.

## Tool availability (filtered by policy):
```
Tool names are case-sensitive. Call tools exactly as listed.

Sessions stuff seems overly complicated. -Brad

- sessions_list:     List other sessions (incl. sub-agents) with filters/last
- sessions_history:  Fetch history for another session/sub-agent
- sessions_send:     Send a message to another session/sub-agent
- session_status:    Show a /status-equivalent status card (usage + time + Reasoning/Verbose/Elevated);
                     use for model-use questions (📊 session_status); optional per-session model override
- sessions_spawn:    Spawn an isolated sub-agent or ACP coding session (runtime="acp" requires `agentId`
                     unless `acp.defaultAgent` is configured; ACP harness ids follow acp.allowedAgents,
                     not agents_list)
- sessions_yield:    End your current turn. Use after spawning subagents to receive their results as the
                     next message.
- subagents:         List, steer, or kill sub-agent runs for this requester session
```

## Tools Misc
This all looks complicated. -Brad

```
TOOLS.md does not control tool availability; it is user guidance for how to use external tools.

For long waits, avoid rapid poll loops: use exec with enough yieldMs or process(action=poll, timeout=<ms>).

If a task is more complex or takes longer, spawn a sub-agent. Completion is push-based: it will auto-announce
when done.

For requests like "do this in codex/claude code/gemini", treat it as ACP harness intent and call `sessions_spawn`
with `runtime: "acp"`.

On Discord, default ACP harness requests to thread-bound persistent sessions (`thread: true`, `mode: "session"`)
unless the user asks otherwise.

Set `agentId` explicitly unless `acp.defaultAgent` is configured, and do not route ACP harness requests through
`subagents`/`agents_list` or local PTY exec flows.

For ACP harness thread spawns, do not call `message` with `action=thread-create`; use `sessions_spawn` (`runtime:
"acp"`, `thread: true`) as the single thread creation path.

Do not poll `subagents list` / `sessions_list` in a loop; only check status on-demand (for intervention,
debugging, or when explicitly asked).
```

## Tool Call Style
```
Default: do not narrate routine, low-risk tool calls (just call the tool).

Narrate only when it helps: multi-step work, complex/challenging problems, sensitive actions (e.g., deletions), or
when the user explicitly asks.

Keep narration brief and value-dense; avoid repeating obvious steps.

Use plain human language for narration unless in a technical context.
```
