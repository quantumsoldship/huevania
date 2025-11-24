local pd <const> = playdate
local gfx <const> = playdate.graphics

class('Bullet').extends(gfx.sprite)

function Bullet:init(x, y, angle, speed)
    Bullet.super.init(self)
    
    -- Set position
    self:moveTo(x, y)
    
    -- Movement properties
    self.angle = angle
    self.speed = speed
    
    -- Calculate velocity components
    self.vx = math.cos(math.rad(angle)) * speed
    self.vy = math.sin(math.rad(angle)) * speed
    
    -- Create bullet image (small circle)
    local bulletSize = 4
    local bulletImage = gfx.image.new(bulletSize, bulletSize)
    gfx.pushContext(bulletImage)
        gfx.fillCircleAtPoint(bulletSize / 2, bulletSize / 2, bulletSize / 2)
    gfx.popContext()
    
    self:setImage(bulletImage)
    self:setCollideRect(0, 0, bulletSize, bulletSize)
    self:add()
end

function Bullet:update()
    -- Move the bullet
    self:moveBy(self.vx, self.vy)
    
    -- Remove bullet if off-screen
    local x, y = self:getPosition()
    if x < -10 or x > 410 or y < -10 or y > 250 then
        self:remove()
    end
end
