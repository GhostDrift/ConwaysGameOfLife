import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "cell"
import "Row"

local gfx = playdate.graphics
local grid = gfx.image.new(400,240)
local ROW_HEIGHT = 16
local CELL_INSET = 2
local SELECTION_WIDTH = 2
selectedColumn = 1
selectedRow = 1
isRunning = false
playdate.display.setInverted(true)


cells = {
	Row(1),
	Row(2),
	Row(3),
	Row(4),
	Row(5),
	Row(6),
	Row(7),
	Row(8),
	Row(9),
	Row(10),
	Row(11),
	Row(12),
	Row(13),
	Row(14),
	Row(15)
}

local function drawCell(col,row)
	local width = 1
	
	if col == selectedColumn and row == selectedRow then width = SELECTION_WIDTH end
	
	local x = (col-1)*ROW_HEIGHT + CELL_INSET
	local y = (row-1) * ROW_HEIGHT + CELL_INSET
	local s = ROW_HEIGHT - 2*CELL_INSET
	
	gfx.setColor(gfx.kColorBlack)
	gfx.drawRect(x, y, s, s, width)

	-- local val = tracks[row].notes[col]
	local val = cells[row].cells[col].isOccupied
	
	if val ~= nil and val then
		gfx.setDitherPattern(1-val/LEVEL_INCREMENTS, gfx.image.kDitherTypeBayer4x4)
		gfx.fillRect(x+1, y+1, s-2, s-2)
	end
end
local function drawGrid()
	gfx.lockFocus(grid)
	gfx.clear(gfx.kColorWhite)
	for row = 1,15 do
		for col = 1,25 do
			drawCell(col,row)
		end
	end
end

function initialize()
	populateCells()
end
drawGrid()
function playdate.update()
	grid:draw(0,0)
end
