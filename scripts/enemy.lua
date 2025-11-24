local pd <const> = playdate
local gfx <const> = playdate.graphics

class('Enemy').extends(gfx.sprite)

-- Enemy firing patterns
FIRING_PATTERNS = {
    SPIRAL = "spiral",
    BURST = "burst",
    WAVE = "wave",
    RANDOM = "random"
}

function Enemy:init(x, y, pattern)
    Enemy.super.init(self)
    
    self.pattern = pattern or FIRING_PATTERNS.SPIRAL
    
    -- Create a simple enemy image (larger circle)
    local img = gfx.image.new(16, 16)
    gfx.pushContext(img)
    gfx.fillCircleAtPoint(8, 8, 8)
    gfx.popContext()
    
    self:setImage(img)
    self:moveTo(x, y)
    self:setCollideRect(2, 2, 12, 12)
    
    -- Pattern state variables
    self.spiralAngle = 0
    self.burstCount = 0
    self.wavePhase = 0
    
    -- Set up firing timer based on pattern
    if self.pattern == FIRING_PATTERNS.SPIRAL then
        self.fireTimer = pd.timer.new(500, function()
            self:fireSpiralPattern()
        end)
    elseif self.pattern == FIRING_PATTERNS.BURST then
        self.fireTimer = pd.timer.new(1500, function()
            self:fireCircularBurst()
        end)
    elseif self.pattern == FIRING_PATTERNS.WAVE then
        self.fireTimer = pd.timer.new(800, function()
            self:fireWavePattern()
        end)
    elseif self.pattern == FIRING_PATTERNS.RANDOM then
        self.fireTimer = pd.timer.new(600, function()
            self:fireRandomPattern()
        end)
    end
    
    self.fireTimer.repeats = true
    
    self:add()
end

-- PATTERN: Spiral - bullets fired in a rotating spiral
function Enemy:fireSpiralPattern()
    local numBullets = 3
    local angleStep = 120
    
    for i = 1, numBullets do
        local angle = self.spiralAngle + (i - 1) * angleStep
        -- Mix of bullet types for variety
        local bulletType = BULLET_TYPES.NORMAL
        if i == 2 then
            bulletType = BULLET_TYPES.PHASING
        end
        Bullet(self.x, self.y, angle, 2.5, bulletType)
    end
    
    self.spiralAngle += 15  -- Rotate the spiral
end

-- PATTERN: Circular burst - fire bullets in all directions at once
function Enemy:fireCircularBurst()
    local numBullets = 8
    local angleStep = 360 / numBullets
    
    for i = 1, numBullets do
        local angle = (i - 1) * angleStep
        -- Alternate between normal and bouncing bullets
        local bulletType = (i % 2 == 0) and BULLET_TYPES.BOUNCING or BULLET_TYPES.NORMAL
        Bullet(self.x, self.y, angle, 2, bulletType)
    end
    
    self.burstCount += 1
end

-- PATTERN: Wave - fire bullets in a sweeping wave motion
function Enemy:fireWavePattern()
    local numBullets = 5
    local baseAngle = 45  -- Wave sweeps from 45 to 135 degrees
    local waveWidth = 90
    
    for i = 1, numBullets do
        local offset = (i - 1) / (numBullets - 1)  -- 0 to 1
        local angle = baseAngle + (waveWidth * offset) + math.sin(self.wavePhase) * 20
        
        -- Use phasing bullets for wave pattern
        Bullet(self.x, self.y, angle, 2.2, BULLET_TYPES.PHASING)
    end
    
    self.wavePhase += 0.5
end

-- PATTERN: Random - fire bullets in random directions with mixed types
function Enemy:fireRandomPattern()
    local numBullets = math.random(2, 4)
    
    for i = 1, numBullets do
        local angle = math.random(0, 359)
        local speed = math.random(15, 30) / 10  -- 1.5 to 3.0
        
        -- Random bullet type selection
        local rand = math.random(1, 3)
        local bulletType
        if rand == 1 then
            bulletType = BULLET_TYPES.NORMAL
        elseif rand == 2 then
            bulletType = BULLET_TYPES.PHASING
        else
            bulletType = BULLET_TYPES.BOUNCING
        end
        
        Bullet(self.x, self.y, angle, speed, bulletType)
    end
end

-- Extension point: Add new patterns here
-- Example pattern template:
-- function Enemy:fireCustomPattern()
--     -- Define your pattern logic here
--     -- Create bullets with desired angles, speeds, and types
--     -- Update any pattern state variables
-- end

function Enemy:collisionResponse()
    return gfx.sprite.kCollisionTypeOverlap
end

function Enemy:update()
    -- Enemy could have movement logic here
    -- For now, it's stationary
end

-- Clean up timer when enemy is removed
function Enemy:remove()
    if self.fireTimer then
        self.fireTimer:remove()
    end
    Enemy.super.remove(self)
end
