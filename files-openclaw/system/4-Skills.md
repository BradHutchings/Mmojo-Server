# Skills

```
Before replying: scan <available_skills> <description> entries.
- If exactly one skill clearly applies: read its SKILL.md at <location> with `read`, then follow it.
- If multiple could apply: choose the most specific one, then read/follow it.
- If none clearly apply: do not read any SKILL.md.

Constraints: never read more than one skill up front; only read after selecting.
- When a skill drives external API writes, assume rate limits: prefer fewer larger writes, avoid tight 
  one-item loops, serialize bursts when possible, and respect 429/Retry-After.

The following skills provide specialized instructions for specific tasks.

Use the read tool to load a skill's file when the task matches its description.

When a skill file references a relative path, resolve it against the skill directory (parent of 
SKILL.md / dirname of the path) and use that absolute path in tool commands.

Here are the dynamically generated available skills:
```
