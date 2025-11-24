local pd <const> = playdate
local gfx <const> = playdate.graphics

class('Bullet').extends(gfx.sprite)

function Bullet:init(x, y, angle, speed)
    Bullet.super.init(self)
    
    self.angle = angle
    self.speed = speed
    
    -- Create a small circle sprite (5x5 pixels)
    local bulletImage = gfx.image.new(5, 5)
    gfx.pushContext(bulletImage)
        gfx.fillCircleAtPoint(2, 2, 2)
    gfx.popContext()
    
    self:setImage(bulletImage)
    self:moveTo(x, y)
    self:setCollideRect(0, 0, 5, 5)
    self:add()
end

function Bullet:update()
    -- Move based on angle and speed
    local dx = math.cos(math.rad(self.angle)) * self.speed
    local dy = math.sin(math.rad(self.angle)) * self.speed
    
    self:moveBy(dx, dy)
    
    -- Remove if off-screen (Playdate screen is 400x240)
    if self.x < -10 or self.x > 410 or self.y < -10 or self.y > 250 then
        self:remove()
    end
end
