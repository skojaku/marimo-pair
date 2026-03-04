# Worked Example: "I want to plot this data"

This walks through the full turn-based workflow from SKILL.md.

## Step 1 — Show up first

Create and focus the cell before any investigation:

```python
# [Agent work]
# Investigating your data — checking variables, shapes, and imports...
```

## Step 2 — Investigate via scratchpad

Run `execute_code` to inspect variables. **Immediately** update the cell:

```python
# [Agent work]
#
# task: inspect notebook variables
#
# ```py
# for name, val in kernel.globals.items():
#     print(name, type(val).__name__, getattr(val, 'shape', ''))
# ```
#
# summary: found `sales` DataFrame (1200, 4)
# ---
```

Run `execute_code` to check schema. Update the cell again right away:

```python
# [Agent work]
#
# task: inspect notebook variables
#
# ```py
# for name, val in kernel.globals.items():
#     print(name, type(val).__name__, getattr(val, 'shape', ''))
# ```
#
# summary: found `sales` DataFrame (1200, 4)
# ---
#
# task: check data schema
#
# ```py
# print(kernel.globals['sales'].dtypes)
# ```
#
# summary: columns — date (datetime), region (str), revenue (float), units (int)
# ---
```

Run `execute_code` to check imports. Update again:

```python
# [Agent work]
#
# task: inspect notebook variables
# ...
# ---
#
# task: check data schema
# ...
# ---
#
# task: check available plotting libraries
#
# ```py
# import sys; [m for m in sys.modules if 'plot' in m or 'altair' in m]
# ```
#
# summary: altair already imported
# ---
```

The user sees the cell growing probe by probe — never a long pause then a dump.

## Step 3 — Ask in terminal chat

> "Your `sales` data has date, region, revenue, and units. You already have
> altair. What kind of plot — line chart of revenue over time? Bar chart by
> region? Something else?"

## Step 4 — Add draft code to the cell

```python
# [Agent work]
#
# task: inspect notebook variables
# ...
# ---
#
# task: check data schema
# ...
# ---
#
# task: check available plotting libraries
# ...
# ---

# Draft code:

import altair as alt

chart = alt.Chart(sales).mark_line().encode(
    x="date:T",
    y="revenue:Q",
    color="region:N",
)
chart
```

## Step 5 — Execute

The log stays as comments above the code. The user can see the full
investigation trail and the final result together.
