import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

-- Libraries
import "scripts/libraries/AnimatedSprite"
import "scripts/libraries/LDtk"

import "scripts/gameScene"
import "scripts/player"
import "scripts/bullet"
import "scripts/enemy"
GameScene()

-- Spawn a test enemy at position (200, 120)
-- Note: This is spawned here for testing. In production, enemies should be managed by GameScene
Enemy(200, 120)

local pd <const> = playdate
local gfx <const> = playdate.graphics

function pd.update()
    gfx.sprite.update()
    pd.timer.updateTimers()
end