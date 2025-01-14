import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/crank"
import "CoreLibs/ui"
import "Cell"
import "Row"
import "Note"
import "ScreenShake"

local gfx = playdate.graphics
local grid = gfx.image.new(400,240)
local ROW_HEIGHT = 16
local CELL_INSET = 2
local SELECTION_WIDTH = 2
numberOfRows = 15
local sounds = {}
local snd = playdate.sound
rows = {}
selectedColumn = 13
selectedRow = 8
playdate.display.setInverted(true)
local screenShakeSprite = ScreenShake()
local menuId = 0

--function to set the shake ammount for the screen shake
function setShakeAmount(amount)
	screenShakeSprite:setShakeAmount(amount)
end

-- function to populate the rows table
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
				cell:addNeighbor(rows[i + 1].column[j + 1],4)
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
--function to initialize the sounds table
local function initializeSounds()
	sounds[1] = playdate.sound.fileplayer.new("sounds/CongaHi")
	sounds[2] = playdate.sound.fileplayer.new("sounds/Rimshot")
	sounds[3] = playdate.sound.fileplayer.new("sounds/CongaLow")
	sounds[4] = playdate.sound.fileplayer.new("sounds/CongaMid")
	sounds[5] = playdate.sound.fileplayer.new("sounds/Maraca")
	sounds[6] = Note(0.01,0.01,0.01,0,750,0.02,0.5,snd.kWaveSine)
	sounds[7] = Note(0.01,0.01,0.01,0,700,0.02,0.5,snd.kWaveSine)
	sounds[8] = Note(0.01,0.01,0.01,0,800,0.02,0.5,snd.kWaveSine)
	sounds[9] = Note(0,0.2,0.2,0.43,1000,0.1,0.5,snd.kWaveNoise)
	sounds[10] = Note(0,0.1,0.07,0.2,700,0.1,0.5,snd.kWaveSine)
	sounds[11] = Note(0,0.1,0.04,0,232,0.1,1,snd.kWavePOVosim)
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
--function to clear the cells
local function clearCells()
	for i = 1, numberOfRows, 1 do
		for j = 1,25,1 do
			rows[i].column[j].isOccupied = 0
		end
	end
	drawGrid()
	
end
-- function to reset the board, clears cells, plays sound, and shakes screen
local function resetCells()
	clearCells()
	sounds[9]:play()
	setShakeAmount(10)
end
-- function to load an example shape into the grid - takes in a table of columbs and a table of rows
local function loadExample(x,y)
	clearCells()
	for i = 1, #x do
		print("y", y[i], "x", x[i])
		rows[y[i]].column[x[i]].isOccupied = 1
	end
end


function initialize()
	populateRows()
	initializeSounds()
	playdate.ui.crankIndicator:start()
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
-- adds how to play option to system menu
local menuItem, error = menu:addMenuItem("How To Play", function()
    toggleMenu(0)
end)
-- adds an example menu option to the system menu
    --menu:addMenuItem("Examples", function()
    --	toggleMenu(1)
    --end)
    -- adds theme option to system menu
menu:addOptionsMenuItem("Theme", {"Dark","Light"}, "Dark", 
function(value)  
	if value == "Dark" then playdate.display.setInverted(true) end
	if value == "Light" then playdate.display.setInverted(false) end
end)
initialize()
drawGrid()
local reverseCount = 0
local xOffset = 1;
local increment = 1;
local playingGame = true;
local instructionsPage = 1
local examplesPage = 1;
local instructionHeadderText = {"Controls:","How To Play:","Cell Rules:","About:","About cont:"}
local instructionText = {"Move the cursor with the D-Pad\n\nToggle cells with the A button\n\nClear the screen with the B button\n\n","Populate some of the cells\n\nTurn the crank clockwise to advance the\nsimulation and watch what happens\n\nTurn the crank counterclockwise one full\nrotation to clear the screen","Empty cells with three neighbors will become\npopulated\n\nPopulated cells with only three neighbors\nsurvive\n\nIf a populated cell has more or less then three\nneighbors, it dies","The Game of Life is not your typical computer\ngame. It is a cellular automaton, and was\ninvented by Cambridge mathematician John\nConway. This game became widely known when\nit was mentioned in an article published by\nScientific American in 1970. It consists of a grid\nof cells which, based on a few mathematical\nrules, can live, die or multiply. Depending on the","initial conditions, the cells form various\npatterns throughout the course of the game."}
local instructionPageLocationText = {"     1/5 >>","<< 2/5 >>", "<< 3/5 >>", "<< 4/5 >>", "<< 5/5"}
local exampleTypeText = {"Still Life", "Oscillator", "Spaceship"}
local exampleTypeMap = {1,1,1,1,1,2,2,2,2,2,3,3,3,3}
local exampleTitleText = {"Block","Beehive", "Loaf", "Boat", "Tub", "Blinker","Toad", "Beacon", "Pulsar", "Pentadecathalon", "Glider", "Lightweight\nSpaceship", "Middleweight\nSpaceship", "Heavyweight\nSpaceship"}
local examplePageLocationText = {"     1/14 >>","<< 2/14 >>", "<< 3/14 >>", "<< 4/14 >>", "<< 5/14 >>", "<< 6/14 >>", "<< 7/14 >>", "<< 8/14 >>","<< 9/14 >>", "<< 10/14 >>", "<< 11/14 >>", "<< 12/14 >>", "<< 13/14 >>", "<< 14/14 "}
-- function to display the instructions
local function howTo()
	grid:draw(0,0)
	gfx.setColor(gfx.kColorWhite)
	gfx.fillRect(6, 6, 388, 228)
	gfx.setColor(gfx.kColorBlack)
	gfx.drawRect(7,7,387,227,2)
	gfx.drawText(instructionHeadderText[instructionsPage],18,18)
	gfx.drawText(instructionText[instructionsPage],30,45)
	gfx.drawText(instructionPageLocationText[instructionsPage],18,210)
	gfx.drawText("Press B to close", 260,210)
end
--function to display examples
local function examples()
	grid:draw(0,0)
	gfx.setColor(gfx.kColorWhite)
	gfx.fillRect(6, 6, 194, 228)
	gfx.setColor(gfx.kColorBlack)
	gfx.drawRect(7,7,193,227,2)
	gfx.drawText("Example Shapes", 18,18)
	gfx.drawText("Type: "..exampleTypeText[exampleTypeMap[examplesPage]],20,88)
	gfx.drawText("Name: "..exampleTitleText[examplesPage], 20,45)
	gfx.drawText(examplePageLocationText[examplesPage], 18,210)
end
-- main game play function
local function mainGamePlay()
	local crankChange = playdate.getCrankTicks(4)
	-- local crankChange = playdate.getCrankChange()
	if(crankChange ~= 0) then
		if(crankChange >0)then
			updateCells()
			sounds[2]:play()
			drawGrid()
		elseif (crankChange < 0) then
			if(reverseCount == -4) then
				resetCells()
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
end


-- function to select a cell
local function select(column,row)
	selectedRow = row
	selectedColumn = column
	drawGrid()
end
--function to toggle the instructions
function toggleMenu(id)
	if(playingGame) then
		playingGame = false
		menuId = id
		--playdate.display.setInverted(false)
		--gfx.setImageDrawMode(gfx.kDrawModeFillWhite)

	else
		playingGame = true
		gfx.clear(gfx.kColorWhite)
		--playdate.display.setInverted(true)
		--gfx.setImageDrawMode(gfx.kColorBlack)
	end
end
-- function to toggle the occupiede value of a cell
local function toggleCell(cell)
	cell:toggleIsOccupied()
	if(cell.isOccupied == 1) then
		sounds[2]:play()
	end
	-- cell:countOcuupiedNeighbors()
	drawGrid()
end

-- function to shake screen and play error sound
local function bump()
	sounds[11]:play()
	setShakeAmount(5)
end

--button functions
function playdate.AButtonDown() 
	if(playingGame) then
		local cell = rows[selectedRow].column[selectedColumn]
		toggleCell(cell)
	else
		if(menuId == 1) then
			
		end
	end
end

function playdate.BButtonDown()
	if(playingGame)then
		resetCells()
	else
		toggleMenu()
		sounds[10]:play()
	end
end

function playdate.leftButtonDown()
	if(playingGame)then
		if selectedColumn > 1 then
			select(selectedColumn-1, selectedRow) 
			sounds[6]:play()
		else
			bump()
		end
	else
		if(menuId == 0) then
			if(instructionsPage >1) then
				instructionsPage -= 1
				sounds[6]:play()
			else
				bump()
			end
		else
			if(examplesPage >1) then
				examplesPage -= 1
				sounds[6]:play()
			else
				bump()
			end
		end
	end
end

function playdate.rightButtonDown()
	if(playingGame)then
		if selectedColumn < 25 then 
			select(selectedColumn+1, selectedRow) 
			sounds[6]:play()
		else
			bump()
		end
	else
		if(menuId == 0) then
			if(instructionsPage <5) then
				instructionsPage += 1
				sounds[6]:play()
			else
				bump()
			end
		else
			if(examplesPage <14) then
				examplesPage += 1
				sounds[6]:play()
			else
				bump()
			end
		end
	end
end
function playdate.upButtonDown()
	if (playingGame)then
		if selectedRow > 1 then 
			select(selectedColumn, selectedRow-1)
			sounds[8]:play()
		else
			bump()
		end
	end
end

function playdate.downButtonDown()
	if (playingGame) then
		if selectedRow < numberOfRows then
			select(selectedColumn, selectedRow+1)
			sounds[7]:play()
		else
			bump()
		end
	end
end
-- update method
function playdate.update()
	if(playingGame)then
		mainGamePlay()
	elseif (menuId == 0) then
		howTo()
	else
		examples()
	end
	screenShakeSprite:update()
end