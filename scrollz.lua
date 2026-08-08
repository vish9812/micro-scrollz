VERSION = "1.0.0"

local micro = import("micro")
local config = import("micro/config")

-- micro stores numeric settings as float64, but Scroll() and friends want an
-- int, so anything read out of Settings has to be floored on the way through.
local function intOpt(bp, name)
	return math.floor(bp.Buf.Settings[name])
end

-- Move the view so the cursor's display line lands `row` rows below the top of
-- the view. This works in SLocs rather than buffer line numbers so it stays
-- correct when softwrap splits one buffer line across several display rows.
--
-- `row` is offset by scrollmargin by the callers: parking the cursor on the
-- literal first row would leave Relocate() unsatisfied, and it would shove the
-- view by scrollmargin on the next cursor movement, so "top" would quietly
-- drift a few lines the moment you pressed an arrow key.
local function placeCursorAtRow(bp, row)
	-- `-bp.Cursor.Loc` dereferences: luar hands back an addressable struct
	-- field as a pointer, and SLocFromLoc wants the value.
	local v = bp:GetView()
	v.StartLine = bp:Scroll(bp:SLocFromLoc(-bp.Cursor.Loc), -row)
	bp:SetView(v)
	bp:ScrollAdjust()
end

-- Move the cursor half a screen and bring the view along, leaving the cursor
-- centered. micro's built-in HalfPageUp/HalfPageDown only scroll the view; the
-- cursor stays where it was, so the next cursor movement triggers Relocate()
-- and snaps you straight back to where you started.
--
-- MoveCursorUp/MoveCursorDown count display lines and carry the visual column,
-- so this behaves the same with softwrap on or off.
local function halfPage(bp, dir)
	local rows = math.floor(bp:BufView().Height / 2)
	if rows < 1 then
		rows = 1
	end

	if dir < 0 then
		bp.Cursor:Deselect(true)
		bp:MoveCursorUp(rows)
	else
		bp.Cursor:Deselect(false)
		bp:MoveCursorDown(rows)
	end

	bp:Center()
	return true
end

-- Scroll the cursor's line to the top of the view (vim's zt).
function top(bp)
	placeCursorAtRow(bp, intOpt(bp, "scrollmargin"))
	return true
end

-- Scroll the cursor's line to the bottom of the view (vim's zb).
function bottom(bp)
	local row = bp:BufView().Height - 1 - intOpt(bp, "scrollmargin")
	if row < 0 then
		row = 0
	end
	placeCursorAtRow(bp, row)
	return true
end

-- Scroll the cursor's line to the center of the view (vim's zz). This is just
-- micro's built-in Center, wrapped so the command set is complete.
function center(bp)
	return bp:Center()
end

function halfDown(bp)
	return halfPage(bp, 1)
end

function halfUp(bp)
	return halfPage(bp, -1)
end

local subcommands = {
	top = top,
	bottom = bottom,
	center = center,
	halfdown = halfDown,
	halfup = halfUp,
}

local function command(bp, args)
	local name = ""
	if #args > 0 then
		name = args[1]:lower()
	end

	local fn = subcommands[name]
	if fn == nil then
		micro.InfoBar():Error("scrollz: expected top, bottom, center, halfdown or halfup")
		return
	end

	fn(bp)
end

function init()
	config.MakeCommand("scrollz", command, config.NoComplete)
	config.AddRuntimeFile("scrollz", config.RTHelp, "help/scrollz.md")
end
