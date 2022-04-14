import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "Cell"
import "Row"

local gfx = playdate.graphics
local grid = gfx.image.new(400,240)
local ROW_HEIGHT = 16
local CELL_INSET = 2
local SELECTION_WIDTH = 2
rows = {}
selectedColumn = 1
selectedRow = 1
isRunning = false
playdate.display.setInverted(true)


function populateRows()
	for i = 1,15,1 do
		rows[i] = Row(i)
	end
	local cell
	for i = 1,15,1 do
		for j = 1,25,1 do
			cell = rows[i].column[j]
			if i == 1 then
				if j == 1 then
					cell:addNeighbor(rows[i].column[j + 1],1)
					cell:addNeighbor(rows[i + 1].column[j +1],2)
					cell:addNeighbor(rows[i+1].column[j],3)
				elseif j == 25 then
					cell:addNeighbor(rows[i].column[j - 1],1)
					cell:addNeighbor(rows[i + 1].column[j -1],2)
					cell:addNeighbor(rows[i+1].column[j],3)
				else
					cell:addNeighbor(rows[i].column[j + 1],1)
					cell:addNeighbor(rows[i + 1].column[j +1],2)
					cell:addNeighbor(rows[i+1].column[j],3)
					cell:addNeighbor(rows[i + 1].column[j - 1],4)
					cell:addNeighbor(rows[i].column[j -1],5)
				end
			elseif i == 15 then
				if j == 1 then
					cell:addNeighbor(rows[i-1].column[j],1)
					cell:addNeighbor(rows[i -1].column[j +1],2)
					cell:addNeighbor(rows[i].column[j + 1],3)
				elseif j == 25 then
					cell:addNeighbor(rows[i].column[j - 1],1)
					cell:addNeighbor(rows[i - 1].column[j -1],2)
					cell:addNeighbor(rows[i-1].column[j],3)
				else
					cell:addNeighbor(rows[i].column[j - 1],1)
					cell:addNeighbor(rows[i - 1].column[j -1],2)
					cell:addNeighbor(rows[i-1].column[j],3)
					cell:addNeighbor(rows[i - 1].column[j + 1],4)
					cell:addNeighbor(rows[i].column[j +1],5)
				end
			elseif j == 1 then
				cell:addNeighbor(rows[i-1].column[j],1)
				cell:addNeighbor(rows[i - 1].column[j +1],2)
				cell:addNeighbor(rows[i].column[j + 1],3)
				cell:addNeighbor(rows[i - 1].column[j + 1],4)
				cell:addNeighbor(rows[i+1 ].column[j],5)
			elseif j == 25 then
				cell:addNeighbor(rows[i+1].column[j],1)
				cell:addNeighbor(rows[i + 1].column[j -1],2)
				cell:addNeighbor(rows[i].column[j - 1],3)
				cell:addNeighbor(rows[i - 1].column[j - 1],4)
				cell:addNeighbor(rows[i-1 ].column[j],5)
			else
				cell:addNeighbor(rows[i+1].column[j],1)
				cell:addNeighbor(rows[i + 1].column[j -1],2)
				cell:addNeighbor(rows[i].column[j - 1],3)
				cell:addNeighbor(rows[i - 1].column[j - 1],4)
				cell:addNeighbor(rows[i-1 ].column[j],5)
				cell:addNeighbor(rows[i-1].column[j +1], 6)
				cell:addNeighbor(rows[i].column[j +1],7)
				cell:addNeighbor(rows[i +1].column[j + 1],8)
			end
		end
	end
end


local function drawCell(col,row)
	local width = 1
	
	if col == selectedColumn and row == selectedRow then width = SELECTION_WIDTH end
	
	local x = (col-1)*ROW_HEIGHT + CELL_INSET
	local y = (row-1) *ROW_HEIGHT + CELL_INSET
	local s = ROW_HEIGHT - 2*CELL_INSET
	
	gfx.setColor(gfx.kColorBlack)
	gfx.drawRect(x, y, s, s, width)

	local val = rows[row].column[col].isOccupied
	if val == 1 then
		gfx.fillRect(x+2, y+2, s-4, s-4)
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
	populateRows()
end

function updateCells()
	
	for i = 1,15,1 do
		for j = 1,25,1 do
			rows[i].column[j]:growOrDecay()
		end
	end
	for i = 1,15,1 do
		for j = 1,25,1 do
			rows[i].column[j]:update()
		end
	end
end
initialize()
drawGrid()
function playdate.update()
	if isRunning then
		isRunning = false
		updateCells()
		drawGrid()		
		isRunning = true
	end
	grid:draw(0,0)
end
local function select(column,row)
	selectedRow = row
	selectedColumn = column
	drawGrid()
end

local function toggleCell(cell)
	cell:toggleIsOccupied()
	drawGrid()
end
function playdate.AButtonDown() -- not updateing the display
	local cell = rows[selectedRow].column[selectedColumn]
	toggleCell(cell)
	cell:countOcuupiedNeighbors()
	print(cell.occupiedNeighbors)	
end
function playdate.BButtonDown()
	isRunning = not isRunning
	print("isRunning",isRunning)
end

function playdate.leftButtonDown()
	if selectedColumn > 1 then select(selectedColumn-1, selectedRow) end
end

function playdate.rightButtonDown()
	if selectedColumn < 25 then select(selectedColumn+1, selectedRow) end
end
function playdate.upButtonDown()
	if selectedRow > 1 then select(selectedColumn, selectedRow-1) end
end

function playdate.downButtonDown()
	if selectedRow < 15 then select(selectedColumn, selectedRow+1) end
end