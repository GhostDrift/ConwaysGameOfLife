import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local gfx = playdate.graphics
local grid = gfx.image.new(400,240)
local ROW_HEIGHT = 16
local CELL_INSET = 2
local SELECTION_WIDTH = 2
selectedColumn = 1
selectedRow = 1
isRunning = false

local function drawCell(col,row)
	local width = 1
	
	if col == selectedColumn and row == selectedRow then width = SELECTION_WIDTH end
	
	local x = (col-1)*ROW_HEIGHT + CELL_INSET
	local y = (row-1) * ROW_HEIGHT + CELL_INSET
	local s = ROW_HEIGHT - 2*CELL_INSET
	
	gfx.setColor(gfx.kColorBlack)
	gfx.drawRect(x, y, s, s, width)

	-- local val = tracks[row].notes[col]
	
	if val ~= nil and val > 0 then
		gfx.setDitherPattern(1-val/LEVEL_INCREMENTS, gfx.image.kDitherTypeBayer4x4)
		-- gfx.fillRect(x+1, y+1, s-2, s-2)
	end
end
