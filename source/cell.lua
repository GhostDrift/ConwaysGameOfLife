import "CoreLibs/object"
local gfx = playdate.graphics
class('Cell').extends(gfx.sprite)
function Cell:init(row,column,isOccupied)
self.column = column
self.row = row
self.isOccupied = isOccupied
self.neighbors = {}
self.nextState = "empty"
end
function Cell:init()
    self.column = 0
    self.row = 0
    self.occupied = true
    self.neighbors = {}
    self.occupiedNeighbors = 0
    self.nextState = "empty"
end

function Cell:addNeighbor(cell,index)
    self.neightbors[index] = cell
end

function Cell:update()
    if(self.nextState == "empty") then
        self.isOccupied = false
    else
        self.isOccupied = true
    end
end

function Cell:countOcuupiedNeighbors()
    local neighbor = nil
    self.occupiedNeighbors = 0
    for i = 1,9,1
    do
        neighbor = neighbors[i]
        if(neighbor.occupied) then
            self.occupiedNeighbors = self.occupiedNeighbors +1
        end  
    end
    print(self.occupiedNeighbors)
end

function Cell:checkForDecay()
    local decay = true
    if(self.occupiedNeighbors == 2) then
        decay = false
    elseif (self.occupiedNeighbors == 3) then
        decay = false
    end
    return decay
end

function Cell:checkForGrowth()
    local growth = false
    if(self.occupiedNeighbors == 3) then
        growth = true
    end
    return growth
end

function Cell:growOrDecay()
    self:countOcuupiedNeighbors()
    if(self.isOccupiped) then
        if(self:checkForDecay())then
            self.nextState = "empty"
        else 
            self.nextState = "occupied"
        end 
    else
        if(self:checkForGrowth()) then
           self.nextState = "occupied" 
        else
            self.nextState = "empty"
        end
    end
end