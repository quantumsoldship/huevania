local pd <const> = playdate
local gfx <const> = playdate.graphics
import "scripts/bullet"

class('Enemy').extends(gfx.sprite)

function Enemy:init(x, y)
    Enemy.super.init(self)
    
    -- Create a placeholder sprite for the enemy
    local size = 32
    local image = gfx.image.new(size, size)
    gfx.pushContext(image)
        gfx.setColor(gfx.kColorBlack)
        gfx.fillRect(0, 0, size, size)
        gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
        gfx.drawText("E", 10, 8)
    gfx.popContext()
    self:setImage(image)
    
    self:moveTo(x, y)
    self:setCollideRect(0, 0, size, size)
    self:add()
    
    -- "Bullet Hell" logic: Spin variable for spiral patterns
    self.spinAngle = 0
    
    -- Fire every 200ms
    self.fireTimer = pd.timer.performAfterDelay(200, function() self:firePattern() end)
    self.fireTimer.repeats = true
end

function Enemy:firePattern()
    -- Example Pattern: Spiral Shot
    local bulletsPerShot = 4
    local angleStep = (math.pi * 2) / bulletsPerShot
    
    for i = 1, bulletsPerShot do
        local angle = self.spinAngle + (i * angleStep)
        -- Spawn bullet at enemy position
        Bullet(self.x, self.y, angle, 3)
    end
    
    -- Rotate the pattern slightly for next time
    self.spinAngle += 0.2
end

function Enemy:update()
    -- Add movement logic here if needed
end
