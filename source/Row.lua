import "CoreLibs/object"
import "Cell"
local gfx = playdate.graphics
class('Row').extends()
function Row:init(number)
    self.number = number
    self.cells = createRow(number)
end
function createRow(rowNumber)
	local temp = {}
	for i = 1,25,1 do
		temp[i] = Cell(rowNumber,i,false)
	end
	return temp
end