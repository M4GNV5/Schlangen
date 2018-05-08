--self: {id: "own id", r: "radius", colors: {"list of colours to use"}}
--food item: {d: "direction from me", dist: "distance", v: "food value"}
--enemy item: {d: "direction from me", dist: "distance", bot: "player id", r: "radius of the snake"}

-- initialize your data here, and maybe set colors for your snake
function init()
    self.colors = {
        0xFF0000, 0xFF0000, 0xFF0000, 
        0x00FF00, 0x00FF00, 0x00FF00, 
        0x0000FF, 0x0000FF, 0x0000FF}
end

function step()
    local direction_count = 16
    local food_range = 1000
    local food_close = math.sqrt(self.r) * 100
    local emergency_distance = 50 + self.r
    local super_emergency_distance = 10 + self.r
    
    --try not to die
    local emergency = nil
	local emergencyDist = emergency_distance + 1
	for i, enemy in findSegments(emergency_distance + 4 * self.r, false):pairs() do
	    local minDistance = enemy.dist - enemy.r - self.r
	    if minDistance < emergency_distance and minDistance < emergencyDist then
	        emergency = enemy
	        emergencyDist = minDistance
	    end
	end
	
	if emergency then
	    return emergency.d + 5 * math.pi / 8, false
	end
    
    

    --make sure we don't process too many food items and time out
    local nearbyFood = findFood(food_range, 0)
    if #nearbyFood > 100 then
        nearbyFood = findFood(food_range / 10, 0)
    end

    --calculate direction with most food
    local directions = {}
    for i, food in nearbyFood:pairs() do
        local index = math.floor(food.d * direction_count)
        local score = math.max(1, food_close / food.dist) * food.v
        
        if not directions[index] then
            directions[index] = {}
            directions[index].nearest = food
            directions[index].sum = score
            directions[index].count = 1
        else
            if directions[index].nearest.dist > food.dist then
                directions[index].nearest = food
            end
            
            directions[index].sum = directions[index].sum + score
            directions[index].count = directions[index].count + 1
        end
	end
	
	local best = {sum = -1, nearest = {d = 0}}
	for i, direction in pairs(directions) do
	    direction.sum = direction.sum * math.sqrt(direction.count)
	    if direction.sum > best.sum then
	        best = direction
	    end
	end

    return best.nearest.d, false
end
