# scrollz

Viewport control for micro. Position the view around your cursor without
moving the cursor, and move half a screen at a time without losing your place.

## Commands

| Command             | Effect                                                   |
|---------------------|----------------------------------------------------------|
| `scrollz top`       | Scroll the cursor's line to the top of the view           |
| `scrollz bottom`    | Scroll the cursor's line to the bottom of the view        |
| `scrollz center`    | Scroll the cursor's line to the center of the view        |
| `scrollz halfdown`  | Move down half a screen, cursor comes along, recentered   |
| `scrollz halfup`    | Move up half a screen, cursor comes along, recentered     |

`top`, `bottom` and `center` move only the view. The cursor stays on exactly
the character it was on.

`halfdown` and `halfup` move both. They are the equivalent of vim's `Ctrl-D`
and `Ctrl-U`: the cursor travels half a screen and the view follows so the
cursor ends up centered.

## Keybindings

scrollz binds nothing on its own. Add what you want to `bindings.json`:

```json
{
    "Alt-d": "lua:scrollz.halfDown",
    "Alt-u": "lua:scrollz.halfUp",
    "<Alt-z><t>": "lua:scrollz.top",
    "<Alt-z><b>": "lua:scrollz.bottom",
    "<Alt-z><z>": "Center"
}
```

None of these collide with a micro default. `Ctrl-D` and `Ctrl-U` are taken by
`Duplicate` and `ToggleMacro`, which is why the half-page pair uses `Alt`.

The `Alt-z` prefix mirrors vim's `z` command namespace and leaves room for more
view commands later without spending another top-level key.

## Notes on behaviour

**scrollmargin is respected.** `top` leaves `scrollmargin` rows above the
cursor rather than putting it flush against the first row. If it did not, the
next cursor movement would trigger micro's own relocation logic and shift the
view anyway, so "top" would not stay put. Set `scrollmargin` to `0` if you want
the cursor flush against the edge. `bottom` is symmetric.

**Softwrap is handled.** All of these count display rows, not buffer lines, so
with `softwrap` on, half a screen means half of what you can actually see —
not half as many buffer lines, which may be far more text than fits.

**End of file.** Scrolling is clamped so the view never runs past the last
line, matching micro's built-in `Center`.

## Relationship to micro's built-ins

micro already has `Center`, exposed here as `scrollz center` for symmetry.

micro also has `HalfPageUp` and `HalfPageDown`, but they scroll the view and
leave the cursor behind. The moment you press an arrow key, micro relocates the
view back to the cursor and undoes the scroll. `scrollz halfup` and
`scrollz halfdown` move the cursor too, so the new position sticks.

`CursorToViewTop` and `CursorToViewBottom` are the inverse of `scrollz top` and
`scrollz bottom`: they move the cursor to a fixed spot in the view, rather than
moving the view to a fixed spot around the cursor.
