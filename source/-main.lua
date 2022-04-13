-- Name this file `main.lua`. Your game can use multiple source files if you wish
-- (use the `import "myFilename"` command), but the simplest games can be written
-- with just `main.lua`.

-- You'll want to import these in just about every project you'll work on.
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

-- Declaring this "gfx" shorthand will make your life easier. Instead of having
-- to preface all graphics calls with "playdate.graphics", just use "gfx."
-- Performance will be slightly enhanced, too.
-- NOTE: Because it's local, you'll have to do it in every .lua source file.

local gfx <const> = playdate.graphics

-- Here's our player sprite declaration. We'll scope it to this file because
-- several functions need to access it.

local playerSprite = nil

-- A function to set up our game environment.

local playerImageFile
local playerFrames = {}
local activePlayerFrame
local currentPlayerFrame = 1

function myGameSetUp()
	-- Set up the player sprite.
    -- The :setCenter() call specifies that the sprite will be anchored at its center.
    -- The :moveTo() call moves our sprite to the center of the display.
	playerImageFile = gfx.image.new("images/playerSpriteSheet")
    playerFrames[1] = gfx.newQuad(0,0,22,22, playerImageFile:getDimensions())
    playerFrames[2] = gfx.newQuad(22,0,22,22, playerImageFile:getDimensions())

    activePlayerFrame = playerFrames[currentPlayerFrame]
   -- playerImage2 = gfx.image.new("images/outline")
    --imageIndex = 1;
    --assert(playerImage)-- make sure the image was where we thought

    playerSprite = gfx.sprite.new(playerImage1)
    -- playerSprite:moveTo(191,120)-- this is where the center of the sprite is placed; (200,120) is the center of the Playdate screen
    playerSprite:moveTo(10,10)
    playerSprite:add() -- This is critical!


    -- We want an environment displayed behind our sprite.
    -- There are generally two ways to do this:
    -- 1) Use setBackgroundDrawingCallback() to draw a background image. (This is what we're doing below.)
    -- 2) Use a tilemap, assign it to a sprite with sprite:setTilemap(tilemap),
    --       and call :setZIndex() with some low number so the background stays behind
    --       your other sprites.

    local backgroudImage = gfx.image.new("images/background")
    -- assert(backgroudImage)

    gfx.sprite.setBackgroundDrawingCallback(
        function(x, y, width, height)
            gfx.setClipRect(x,y,width,height) -- let's only draw the part of the screen that's dirty
            backgroudImage:draw(0,0)
            gfx.clearClipRect() -- clear so we don't interfere with drawing that comes after this
        end
    )
end

-- Now we'll call the function above to configure our game.
-- After this runs (it just runs once), nearly everything will be
-- controlled by the OS calling `playdate.update()` 30 times a second.

myGameSetUp()

-- `playdate.update()` is the heart of every Playdate game.
-- This function is called right before every frame is drawn onscreen.
-- Use this function to poll input, run game logic, and move sprites.

function playdate.update()

    -- Poll the d-pad and move our player accordingly.
    -- (There are multiple ways to read the d-pad; this is the simplest.)
    -- Note that it is possible for more than one of these directions
    -- to be pressed at once, if the user is pressing diagonally.


    if playdate.buttonIsPressed (playdate.kButtonUp)then
        playerSprite:moveBy(0,-20)
    end
    if playdate.buttonIsPressed(playdate.kButtonRight)then
        playerSprite:moveBy(20,0)
    end
    if playdate.buttonIsPressed(playdate.kButtonDown)then
        playerSprite:moveBy(0,20)
    end
    if playdate.buttonIsPressed(playdate.kButtonLeft)then
        playerSprite:moveBy(-20,0)
    end

    -- Call the functions below in playdate.update() to draw sprites and keep
    -- timers updated. (We aren't using timers in this example, but in most
    -- average-complexity games, you will.)

    gfx.sprite.update()
    playdate.timer.updateTimers()
end