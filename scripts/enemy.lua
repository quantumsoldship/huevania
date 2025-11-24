local pd <const> = playdate
local gfx <const> = playdate.graphics

class('Enemy').extends(gfx.sprite)

function Enemy:init(x, y)
    Enemy.super.init(self)
    
    -- Create a simple placeholder sprite (20x20 square with 'E')
    local enemyImage = gfx.image.new(20, 20)
    gfx.pushContext(enemyImage)
        gfx.setColor(gfx.kColorWhite)
        gfx.fillRect(0, 0, 20, 20)
        gfx.setColor(gfx.kColorBlack)
        gfx.drawRect(0, 0, 20, 20)
        gfx.drawTextAligned("E", 10, 6, kTextAlignment.center)
    gfx.popContext()
    
    self:setImage(enemyImage)
    self:moveTo(x, y)
    self:setCollideRect(0, 0, 20, 20)
    self:add()
    
    -- Initialize firing pattern variables
    self.currentAngle = 0
    
    -- Set up timer to fire bullets repeatedly
    self.fireTimer = pd.timer.new(500, function()
        self:firePattern()
    end)
    self.fireTimer.repeats = true
end

function Enemy:firePattern()
    -- Fire bullets in a spiral pattern
    -- Fire multiple bullets at once, incrementing angle
    for i = 1, 3 do
        local bulletAngle = self.currentAngle + (i - 1) * 120
        Bullet(self.x, self.y, bulletAngle, 2)
    end
    
    -- Increment angle for spiral effect
    self.currentAngle = self.currentAngle + 15
    if self.currentAngle >= 360 then
        self.currentAngle = self.currentAngle - 360
    end
end

function Enemy:update()
    Enemy.super.update(self)
end
