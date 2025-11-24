local pd <const> = playdate
local gfx <const> = playdate.graphics

-- Screen bounds for off-screen cleanup
local SCREEN_WIDTH <const> = 400
local SCREEN_HEIGHT <const> = 240
local CLEANUP_MARGIN <const> = 10

class('Bullet').extends(gfx.sprite)

-- Bullet types determine collision behavior
BULLET_TYPES = {
    NORMAL = "normal",     -- Collides with walls and disappears
    PHASING = "phasing",   -- Ignores walls completely
    BOUNCING = "bouncing"  -- Bounces off walls
}

function Bullet:init(x, y, angle, speed, bulletType)
    Bullet.super.init(self)
    
    self.angle = angle
    self.speed = speed or 2
    self.bulletType = bulletType or BULLET_TYPES.NORMAL
    
    -- Calculate velocity from angle and speed
    self.vx = math.cos(math.rad(angle)) * self.speed
    self.vy = math.sin(math.rad(angle)) * self.speed
    
    -- Create a simple bullet image (small circle)
    local img = gfx.image.new(4, 4)
    gfx.pushContext(img)
    gfx.fillCircleAtPoint(2, 2, 2)
    gfx.popContext()
    
    self:setImage(img)
    self:moveTo(x, y)
    self:setCollideRect(0, 0, 4, 4)
    
    -- Bouncing bullets track bounce count
    if self.bulletType == BULLET_TYPES.BOUNCING then
        self.bounceCount = 0
        self.maxBounces = 3
    end
    
    self:add()
end

function Bullet:collisionResponse(other)
    if self.bulletType == BULLET_TYPES.PHASING then
        return gfx.sprite.kCollisionTypeOverlap
    elseif self.bulletType == BULLET_TYPES.BOUNCING then
        return gfx.sprite.kCollisionTypeBounce
    else
        return gfx.sprite.kCollisionTypeSlide
    end
end

function Bullet:update()
    local newX = self.x + self.vx
    local newY = self.y + self.vy
    
    if self.bulletType == BULLET_TYPES.PHASING then
        -- Phasing bullets ignore collisions
        self:moveTo(newX, newY)
    elseif self.bulletType == BULLET_TYPES.BOUNCING then
        -- Bouncing bullets respond to wall collisions
        local actualX, actualY, collisions, length = self:moveWithCollisions(newX, newY)
        
        if length > 0 then
            self.bounceCount += 1
            
            -- Remove bullet after max bounces
            if self.bounceCount >= self.maxBounces then
                self:remove()
                return
            end
            
            -- Reverse velocity based on collision normal
            for i = 1, length do
                local collision = collisions[i]
                if collision.normal.x ~= 0 then
                    self.vx = -self.vx
                end
                if collision.normal.y ~= 0 then
                    self.vy = -self.vy
                end
            end
        end
    else
        -- Normal bullets collide with walls and disappear
        local actualX, actualY, collisions, length = self:moveWithCollisions(newX, newY)
        
        if length > 0 then
            self:remove()
            return
        end
    end
    
    -- Remove bullet if off-screen
    if self.x < -CLEANUP_MARGIN or self.x > SCREEN_WIDTH + CLEANUP_MARGIN or 
       self.y < -CLEANUP_MARGIN or self.y > SCREEN_HEIGHT + CLEANUP_MARGIN then
        self:remove()
    end
end
