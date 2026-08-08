# scrollz

Viewport control for the [micro](https://micro-editor.github.io) editor. Put
the line you are reading where you want it on screen, and move half a screen at
a time without losing your cursor.

The companion to [navz](https://github.com/vish9812/navz), which does the same
job for VS Code.

## What it does

| Command             | Effect                                                   |
|---------------------|----------------------------------------------------------|
| `scrollz top`       | Scroll the cursor's line to the top of the view           |
| `scrollz bottom`    | Scroll the cursor's line to the bottom of the view        |
| `scrollz center`    | Scroll the cursor's line to the center of the view        |
| `scrollz halfdown`  | Move down half a screen, cursor comes along, recentered   |
| `scrollz halfup`    | Move up half a screen, cursor comes along, recentered     |

The first three move the view only — your cursor does not budge. The last two
are vim's `Ctrl-D` / `Ctrl-U`: cursor and view move together, cursor lands
centered.

## Why not just use micro's built-ins

micro ships `Center` (which `scrollz center` simply wraps) but has no
equivalent of vim's `zt` or `zb` — its `CursorToViewTop` / `CursorToViewBottom`
do the opposite, moving the cursor rather than the view.

It also ships `HalfPageUp` / `HalfPageDown`, but those scroll the view and
leave the cursor where it was. As soon as you move the cursor, micro relocates
the view back and the scroll is undone. `scrollz halfup` / `halfdown` move the
cursor as well, so the jump actually sticks.

## Install

Clone into micro's plugin directory:

```sh
git clone https://github.com/vish9812/scrollz ~/.config/micro/plug/scrollz
```

Then restart micro. Verify with `> help scrollz`.

## Keybindings

scrollz binds nothing by default. Add to `~/.config/micro/bindings.json`:

```json
{
    "Alt-d": "lua:scrollz.halfDown",
    "Alt-u": "lua:scrollz.halfUp",
    "<Alt-z><t>": "lua:scrollz.top",
    "<Alt-z><b>": "lua:scrollz.bottom",
    "<Alt-z><z>": "Center"
}
```

None of these overwrite a micro default. `Ctrl-D` and `Ctrl-U` are already
`Duplicate` and `ToggleMacro`, so the half-page pair lives on `Alt`. The
`Alt-z` prefix mirrors vim's `z` namespace and keeps room for more view
commands later.

## Softwrap

All movement counts display rows rather than buffer lines, so with `softwrap`
enabled half a screen means half of what you can actually see. `scrollmargin`
is respected by `top` and `bottom`; set it to `0` if you want the cursor flush
against the edge of the view.

## Requirements

micro 2.0.0 or newer.

## License

MIT
