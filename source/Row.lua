import "CoreLibs/object"
import "Cell"
local gfx = playdate.graphics
class('Row').extends()
function Row:init(number)
    self.number = number
    self.column = createRow(number)
   -- print(self.column[1].isOccupied)
end
function createRow(rowNumber)
	local temp = {}
	for i = 1,25,1 do
		temp[i] = Cell(rowNumber,i,0)
	end
	return temp
end