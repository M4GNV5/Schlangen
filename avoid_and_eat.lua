--food item: {d: "direction from me", dist: "distance", v: "food value"}
--enemy item: {d: "direction from me", dist: "distance", bot: "player id", r: "radius of the snake"}

function init()
    self.colors = {
        0xFF0000, 0xFF0000, 0xFF0000, 
        0x00FF00, 0x00FF00, 0x00FF00, 
        0x0000FF, 0x0000FF, 0x0000FF
    }
end

function step()
    local viewDist = 100 + self.r
    local dangerDist = 20 + self.r
    
    local enemy = findSegments(viewDist, false)[1]
    local food = findFood(viewDist, 1)

    if enemy == nil then
        local minDist = math.huge
        local targetD = 0
        
        for i, item in pairs(food) do
            if item.dist < minDist then
                minDist = item.dist
                targetD = item.d
            end
        end
        
        return targetD, false
    elseif enemy.dist - enemy.r - self.r < dangerDist then
        return enemy.d + math.pi, false
    else
        local closestD = 0
        local closestDdiff = math.huge
        
        for i, item in pairs(food) do
            local dDiff = math.abs(enemy.d + math.pi - item.d)
            if dDiff < closestDdiff and dDiff < math.pi / 2 then
                closestD = item.d
                closestDDiff = dDiff
            end
        end
        
        return closestD, false
    end
end
