-- blitzmax_breakout
-- a port of the BlitzMax Breakout sample game to LÖVE 2D


-- DONE: test list (see note below)
-- DONE: test oop
-- DONE: test drawanimimage counterpart separately first!



-- NOTE: tiles are never removed from TileList, even in the original code!

-- main loop in original source is at lines 198 - 226


require "strict" -- temporary
require('mobdebug').start()

---[[
require "_tests.test_image"
--]]
--[[
createclass = require "createclass"
TList       = require "linkedlist"


function love.load()
	WIDTH, HEIGHT = 640, 480
	
	SHADOW_ON = true
	SHADOW_SIZE = 10
	
	gtime = nil
	--pipes = love.graphics.newImage()
	
end





--]]

