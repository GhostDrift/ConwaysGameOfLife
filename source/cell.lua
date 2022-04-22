import "CoreLibs/object"
local gfx = playdate.graphics
class('Cell').extends()
function Cell:init(row,column,isOccupied)
self.column = column
self.row = row
self.isOccupied = isOccupied
self.neighbors = {}
self.nextState = "empty"
end

function Cell:addNeighbor(cell,index)
    self.neighbors[index] = cell
end

function Cell:update()
    if(self.isOccupied ~= self.nextState) then
        
        self.isOccupied = self.nextState
    end
end

function Cell:countOcuupiedNeighbors()
    local neighbor 
    self.occupiedNeighbors = 0
    for i = 1,#self.neighbors,1
    do
        neighbor = self.neighbors[i]
        if(neighbor.isOccupied == 1) then
            -- print("Neigbor#",i,neighbor.row,neighbor.column)
            self.occupiedNeighbors = self.occupiedNeighbors +1
        end  
    end

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
    if (self.isOccupied == 1 )then
        if (self:checkForDecay())then
            self.nextState = 0
        else 
            self.nextState = 1
        end 
    else
        if (self:checkForGrowth()) then
           self.nextState = 1
        else
            self.nextState = 0
        end
    end
end

function Cell:toggleIsOccupied()
    if(self.isOccupied == 1) then
        --print (self.isOccupied)
        self.isOccupied = 0
    else 
        self.isOccupied = 1
    end
end