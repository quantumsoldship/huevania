local pd <const> = playdate
local gfx <const> = playdate.graphics

class('Bullet').extends(gfx.sprite)

function Bullet:init(x, y, angle, speed)
    Bullet.super.init(self)
    
    -- Create a small circular sprite for the bullet
    local radius = 3
    local image = gfx.image.new(radius * 2, radius * 2)
    gfx.pushContext(image)
        gfx.fillCircleAtPoint(radius, radius, radius)
    gfx.popContext()
    self:setImage(image)
    
    self:moveTo(x, y)
    self:setCollideRect(0, 0, radius * 2, radius * 2)
    
    -- Calculate velocity vector based on angle
    self.dx = math.cos(angle)
    self.dy = math.sin(angle)
    self.speed = speed or 4
    
    self:add() -- Add to global sprite list
end

function Bullet:update()
    -- Move the bullet
    self:moveBy(self.dx * self.speed, self.dy * self.speed)
    
    -- Remove bullet if it goes off-screen to improve performance
    local x, y = self:getPosition()
    if x < -20 or x > 420 or y < -20 or y > 260 then
        self:remove()
    end
end
