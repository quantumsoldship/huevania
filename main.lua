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

local pd <const> = playdate
local gfx <const> = playdate.graphics

function pd.update()
    gfx.sprite.update()
    pd.timer.updateTimers()
end