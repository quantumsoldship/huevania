local pd <const> = playdate
local gfx <const> = playdate.graphics

-- Cache screen dimensions
local SCREEN_WIDTH <const> = pd.display.getWidth()
local SCREEN_HEIGHT <const> = pd.display.getHeight()
local OFF_SCREEN_BUFFER <const> = 10

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
    self:setZIndex(Z_INDEXES.Bullet)
    self:setTag(TAGS.Bullet)
    self:add()
end

function Bullet:update()
    -- Move based on angle and speed
    local dx = math.cos(math.rad(self.angle)) * self.speed
    local dy = math.sin(math.rad(self.angle)) * self.speed
    
    self:moveBy(dx, dy)
    
    -- Remove if off-screen
    if self.x < -OFF_SCREEN_BUFFER or self.x > SCREEN_WIDTH + OFF_SCREEN_BUFFER or 
       self.y < -OFF_SCREEN_BUFFER or self.y > SCREEN_HEIGHT + OFF_SCREEN_BUFFER then
        self:remove()
    end
end
