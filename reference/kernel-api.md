# marimo Kernel API Reference

Entry point for API details. Recipes are split into focused files:

- [scratchpad.md](scratchpad.md) — scratchpad inspection recipes
- [cell-operations.md](cell-operations.md) — cell mutation recipes

Each reference file includes its own preamble with the imports you need.
Use the minimal preamble for scratchpad work; only pull in the full
cell-mutation imports when you need to create, update, or delete cells.

## Discovering the API

If an import fails or you need something not listed in the reference files,
explore from within `marimo session exec -c`:

```python
import marimo
print(marimo.__file__)       # browse the source with your file tools
print(marimo.__version__)    # import paths change across releases

# List all kernel commands
import marimo._runtime.commands as commands
print([c for c in dir(commands) if c.endswith("Command")])

# List all frontend notifications
import marimo._messaging.notification as notification
print([n for n in dir(notification) if n.endswith("Notification")])
```

Use this to verify import paths and discover new APIs rather than guessing.
