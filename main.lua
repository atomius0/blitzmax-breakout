-- blitzmax_breakout
-- a port of the BlitzMax Breakout sample game to LÖVE 2D


-- DONE: test list (see note below)
-- DONE: test oop
-- DONE: test drawanimimage counterpart separately first!



-- NOTE: tiles are never removed from TileList, even in the original code!

-- main loop in original source is at lines 198 - 226


require "strict" -- temporary
require('mobdebug').start()

--[[
require "_tests.test_image"
--]]
---[[
createclass = require "createclass"
TList       = require "linkedlist"


WIDTH, HEIGHT = nil, nil -- we set these in love.load()
SHADOW_ON = true
SHADOW_SIZE = 10

gtime = nil
pipes_img = nil
tiles_img = nil
logo_img = nil
paddle = nil
ballvis = nil

--setup the level
tilelist = nil
balllist = nil
playerX, playerY = 0, 0
score = 0

-- Private
ballcount = 0

minf = math.min

maxf = math.max
-- Public

do Ball = createclass()
	-- TODO: check how to concatenate two tables.
	-- (keeping the identity of the first table?)
	-- so, add content of table 2 to table 1...
	Ball.x, Ball.y = 0, 0
	Ball.dx, Ball.dy, ball.spd
end

function love.load()
	-- width and height are set in conf.lua
	WIDTH, HEIGHT = love.graphics.getDimensions()
	
	
end





--]]

