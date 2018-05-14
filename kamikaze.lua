local MAX_INT = 16777215
local MIN_TARGET_R = 5
local MAX_DISTANCE = 20
local DANGER_DISTANCE = 10
local ATTACK_ANGLE_DIFF = math.pi / 6
local avoidDirection = 0

local ignore = "M4GNV5"

function init()
    math.randomseed(self.id)
    if math.random(0, 1) == 0 then
        avoidDirection = math.pi / 2
    else
        avoidDirection = -math.pi / 2
    end

    self.colors = {0xFF0000, 0x000000, 0x000000, 0x000000, 0x000000}
end

local target = nil
local lastDist = 100
function step()
    local findRange = MAX_INT
    if target then
        findRange = 70
    end
    local enemies = findSegments(MAX_INT, false)
    
    --avoid dangers and find a target if we have none yet
    local closest = nil
    local closestDistance = nil
    for i, enemy in pairs(enemies) do
        local distance = enemy.dist - enemy.r - self.r
        if target and enemy.bot == target then
            --nothing
        elseif enemy.r > MIN_TARGET_R and (not target or enemy.bot == target) and enemy.bot_name ~= ignore then
            log("got a new target: " .. tostring(enemy.bot))
            target = enemy.bot
        elseif distance < DANGER_DISTANCE then
            closest = enemy
            closestDistance = distance
        end
    end
    
    --if we are in danger avoid it
    if closest then
        lastD = closest.d + avoidDirection
        return lastD, true
    end
    
    --iterate over all near segments to check if we see the head
    --
    --when the snake is sideways to us it looks like this:
    -- OOOOOOOOO
    -- \      /
    --    us
    --when we are at the head of the snake it looks like this:
    -- OOOOOOOOOOOOO > us
    --
    --so in order to detect if we are at the head of the snake we just have to look at difference of
    --  the leftmost and the rightmost angle. When it's below a certain threshhold we attack!
    local targetInRange = false
    local closestNode = {dist = MAX_INT, d = 0}
    local minAngle = 2 * math.pi
    local maxAngle = 0
    for i, node in pairs(enemies) do
        if node.bot == target then
            targetInRange = true
            
            if minAngle > node.d then
                minAngle = node.d
            end
            if maxAngle < node.d then
                maxAngle = node.d
            end
            
            if node.dist < closestNode.dist then
                closestNode = node
            end
        end
    end
    
    if not targetInRange or closestNode.r < MIN_TARGET_R then
        target = nil
        
        local closest = {dist = 101, d = 0}
        for i, food in pairs(findFood(100, 1)) do
            if math.abs(food.d) < 1 and closest.dist > food.dist then
                closest = food
            end
        end
        
        return closest.d, (self.r > MIN_TARGET_R - 1)
    elseif maxAngle - minAngle <= ATTACK_ANGLE_DIFF or closestNode.dist - self.r - closestNode.r >= MAX_DISTANCE then
        return closestNode.d, true
    else
        return closestNode.d + avoidDirection, true
    end
end
