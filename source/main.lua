import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/crank"
import "CoreLibs/ui"
import "Cell"
import "Row"

local gfx = playdate.graphics
local grid = gfx.image.new(400,240)
local ROW_HEIGHT = 16
local CELL_INSET = 2
local SELECTION_WIDTH = 2
numberOfRows = 15
local sounds = {}
rows = {}
selectedColumn = 13
selectedRow = 8
playdate.display.setInverted(true)


function populateRows()
	for i = 1,numberOfRows,1 do
		rows[i] = Row(i)
	end
	local cell
	for i = 1,numberOfRows,1 do
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
			elseif i == numberOfRows then
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
local function initializeSounds()
	sounds[1] = playdate.sound.fileplayer.new("sounds/CongaHi")
	sounds[2] = playdate.sound.fileplayer.new("sounds/Rimshot")
	sounds[3] = playdate.sound.fileplayer.new("sounds/CongaLow")
	sounds[4] = playdate.sound.fileplayer.new("sounds/CongaMid")
	sounds[5] = playdate.sound.fileplayer.new("sounds/Maraca")
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
	for row = 1,numberOfRows,1 do
		for col = 1,25 do
			drawCell(col,row)
		end
	end
end

function initialize()
	populateRows()
	initializeSounds()
	playdate.ui.crankIndicator:start()
end
local function clearCells()
	for i = 1, numberOfRows, 1 do
		for j = 1,25,1 do
			rows[i].column[j].isOccupied = 0
		end
	end
	drawGrid()
	sounds[5]:play()
end

function updateCells()
	--print("updating cells")
	for i = 1,numberOfRows,1 do
		for j = 1,25,1 do
			rows[i].column[j]:growOrDecay()
		end
	end
	for i = 1,numberOfRows,1 do
		for j = 1,25,1 do
			rows[i].column[j]:update()
		end
	end
	--print("done updating")
end
local menu = playdate.getSystemMenu()
local menuItem, error = menu:addMenuItem("How To Play", function()
    toggleMenu()
end)
initialize()
drawGrid()
local reverseCount = 0
local xOffset = 1;
increment = 1;
local playingGame = true;
-- function to display the instructions 
local function howTo()
	grid:draw(0,0)
	gfx.fillRect(6, 6, 388, 228)
end

function playdate.update()
	if(playingGame)then
		local crankChange = playdate.getCrankTicks(4)
		-- local crankChange = playdate.getCrankChange()
		if(crankChange ~= 0) then
			if(crankChange >0)then
				updateCells()
				sounds[2]:play()
				drawGrid()
			elseif (crankChange < 0) then
				if(reverseCount == -4) then
					clearCells()
					reverseCount = 0
				else
					reverseCount = reverseCount + crankChange
				end	
			end
		end
		grid:draw(0,0)
		if(playdate.isCrankDocked())then
			playdate.ui.crankIndicator:update(xOffset)
			if(xOffset == 4	 or xOffset == -8) then
				increment = ~increment
			end
				xOffset += increment
		end
	else 
		howTo()
	end
	--gfx.drawRect(12, 12, 50, 50, 1)
	print("upated")
end
-- function to select a cell
local function select(column,row)
	selectedRow = row
	selectedColumn = column
	drawGrid()
end
--function to toggle the instructions
function toggleMenu()
	if(playingGame) then
		playingGame = false
	else
		playingGame = true
	end
end

local function toggleCell(cell)
	cell:toggleIsOccupied()
	if(cell.isOccupied == 1) then
		sounds[2]:play()
	end
	drawGrid()
end
function playdate.AButtonDown() 
	local cell = rows[selectedRow].column[selectedColumn]
	toggleCell(cell)
	--cell:countOcuupiedNeighbors()
	--print(cell.occupiedNeighbors)	
end

function playdate.BButtonDown()
	if(playingGame)then
		clearCells()
	else
		toggleMenu()
	end
end

function playdate.leftButtonDown()
	if selectedColumn > 1 then
		 select(selectedColumn-1, selectedRow) 
		 sounds[4]:play()
	end
end

function playdate.rightButtonDown()
	if selectedColumn < 25 then 
		select(selectedColumn+1, selectedRow) 
		sounds[4]:play()
	end
end
function playdate.upButtonDown()
	if selectedRow > 1 then 
		select(selectedColumn, selectedRow-1)
		sounds[1]:play()
	end
end

function playdate.downButtonDown()
	if selectedRow < numberOfRows then
		 select(selectedColumn, selectedRow+1)
		 sounds[3]:play()
	end
end