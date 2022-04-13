import "CoreLibs/object"
class(cell,{x,y,neighborsX,neighborsY,occupied}).extends()
function cell:init(x,y,occupied)
    cell.super()
    self.x = x
    self.y = y
    self.neighborsX = {-1,-1,-1,-1,-1,-1,-1,-1}
    self.neighborsY = {-1,-1,-1,-1,-1,-1,-1,-1}
    self.occupied = occupied
end

function cell:setNeighbor(index,x,y)
    self.neighborsX[index] = x
    self.neightborsY[index] = y
    print(self.neighborsX[index])
    print(self.neightborsY[index])
end