local pd <const> = playdate
local gfx <const> = playdate.graphics

class('Player').extends(AnimatedSprite)

function Player:init(x,y,gameManager)
    self.gameManager = gameManager


    local playerImageTable = gfx.imagetable.new("images/player-table-16-16")
    Player.super.init(self, playerImageTable)

    self:addState("idle",1,1)
    self:addState("run",2,4,{tickStep = 5})
    self:addState("jump",6,6)
    self:addState("moveJump",4,4)
    self:playAnimation()

    self:moveTo(x,y)
    self:setZIndex(Z_INDEXES.Player)
    self:setTag(TAGS.Player)
    self:setCollideRect(6,4,5,13)

    -- Physics
    self.xVelocity = 0
    self.yVelocity = 0
    self.gravity = 0.7
    self.maxSpeed = 2

    self.drag = 0.05
    self.minimumAirSpeed = 0.1


    self.jumpVelocity = -6



    self.touchingGround = false
    self.touchingCeiling = false
    self.touchingWall = false

end

function Player:collisionResponse()
    return gfx.sprite.kCollisionTypeSlide
end

function Player:update()
    self:updateAnimation()

    self:handleState()
    self:handleMovementAndCollisions()

end

function Player:handleState()
    if self.currentState == "idle" then
        self:applyGravity()
        self:handleGroundInput()
    elseif self.currentState == "run" then
        self:applyGravity()
        self:handleGroundInput()
    elseif self.currentState == "jump" or self.currentState == "moveJump" then
        if self.touchingGround then
            self:changeToIdleState()
        end
        self:applyGravity()
        self:applyDrag(self.drag)
    end
end

function Player:handleAirInput()
    if pd.buttonIsPressed(pd.kButtonLeft) then
        self.xVelocity  = -self.maxSpeed
    elseif pd.buttonIsPressed(pd.kButtonRight) then
        self.xVelocity = self.maxSpeed
    end
end

function Player:handleMovementAndCollisions()
    local _, _, collisions, length = self:moveWithCollisions(self.x + self.xVelocity, self.y + self.yVelocity)
    self.touchingGround = false
    self.touchingCeiling = false
    self.touchingWall = false
    for i=1, length do
        local collision = collisions[i]
        if collision.normal.y == -1 then
            self.touchingGround = true
        elseif collision.normal.y == 1 then
            self.touchingCeiling = true
        
        
        end
        if collision.normal.x ~= 0 then
            self.touchingWall = true
        end
    end
    if self.xVelocity < 0 then
        self.globalFlip = 1
    elseif self.xVelocity > 0 then
        self.globalFlip = 0
    end

    if self.x < 0 then
		self.gameManager:enterRoom("west")
    elseif self.x > 400  then
        self.gameManager:enterRoom("east")
    elseif self.y < 0 then
        self.gameManager:enterRoom("north")
    elseif self.y > 240 then
        self.gameManager:enterRoom("south")
	end

end

function Player:handleGroundInput()
    if pd.buttonJustPressed(pd.kButtonA) then
        self:changeToJumpState()
    elseif pd.buttonIsPressed(pd.kButtonLeft) then
        self.globalFlip = 1
        self:changeToRunState("left")
    elseif pd.buttonIsPressed(pd.kButtonRight) then
        self.globalFlip = 0
        self:changeToRunState("right")
    else
        self:changeToIdleState()
    
    end
end

function Player:changeToIdleState()
    self.xVelocity = 0
    self:changeState("idle")

end

function Player:changeToRunState(direction)
    if direction == "left" then
        self.xVelocity = -self.maxSpeed
    elseif direction == "right" then
        self.xVelocity = self.maxSpeed
    end
    self:changeState("run")

end

function Player:changeToJumpState()
    self.yVelocity = self.jumpVelocity
    if pd.buttonIsPressed(pd.kButtonLeft) then
        self.globalFlip = 1
        self:changeState("moveJump")
    elseif pd.buttonIsPressed(pd.kButtonRight) then
        self.globalFlip = 0
        self:changeState("moveJump")
    else
        self:changeState("jump")
    end
end

function Player:applyGravity()
    self.yVelocity += self.gravity
    if self.touchingGround or self.touchingCeiling then
        self.yVelocity = 0
    end
end

function Player:applyDrag(amount)
    if self.xVelocity > 0 then
        self.xVelocity -= amount
    elseif self.xVelocity < 0 then
        self.xVelocity = self.xVelocity + amount

    end

    if math.abs(self.xVelocity) < self.minimumAirSpeed then
        self.xVelocity = 0


    end
end