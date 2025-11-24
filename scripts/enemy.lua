local pd <const> = playdate
local gfx <const> = playdate.graphics

class('Enemy').extends(gfx.sprite)

function Enemy:init(x, y)
    Enemy.super.init(self)
    
    -- Set position
    self:moveTo(x, y)
    
    -- Create enemy image (placeholder box with "E")
    local enemySize = 32
    local enemyImage = gfx.image.new(enemySize, enemySize)
    gfx.pushContext(enemyImage)
        -- Draw box
        gfx.drawRect(0, 0, enemySize, enemySize)
        -- Draw "E" in the center
        gfx.drawText("E", enemySize / 2 - 4, enemySize / 2 - 8)
    gfx.popContext()
    
    self:setImage(enemyImage)
    self:setCollideRect(0, 0, enemySize, enemySize)
    self:add()
    
    -- Initialize spiral pattern variables
    self.currentAngle = 0
    self.angleIncrement = 15  -- degrees to increase per shot
    
    -- Set up a timer to fire bullets in a spiral pattern
    self.fireTimer = pd.timer.new(500, function()
        self:fireBullet()
    end)
    self.fireTimer.repeats = true
end

function Enemy:fireBullet()
    -- Create a bullet at the enemy's position with current angle
    local x, y = self:getPosition()
    Bullet(x, y, self.currentAngle, 2)
    
    -- Increment angle for spiral effect
    self.currentAngle = (self.currentAngle + self.angleIncrement) % 360
end

function Enemy:update()
    -- Enemy doesn't move, just exists and fires bullets via timer
end
