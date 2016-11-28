-- blitzmax_breakout
-- a port of the BlitzMax Breakout sample game to LÖVE 2D

-- TODO: everything
-- TODO: put function generateQuads into a module of its own.
--       from: D:\Dateien\Programming\lua\love\projects\tests\quad_test\main.lua

-- TODO: find main loop in original source


-- DONE: test list (see note below)
-- DONE: test oop
-- DONE: test drawanimimage counterpart separately first!

-- DONE: replicate LoadAnimImage as a function that returns an array of quads!
--       see:  https://love2d.org/wiki/love.graphics.newQuad

-- NOTE: for animated sprites / bmx DrawAnimImage counterpart:
--       see wiki example for love.graphics.newQuad



-- NOTE: tiles are never removed from TileList, even in the original code!

require "strict" -- temporary

createclass = require "createclass"
TList       = require "linkedlist"


function love.load()
	WIDTH, HEIGHT = 640, 480
	
	SHADOW_ON = true
	SHADOW_SIZE = 10
	
	gtime = nil
	--pipes = love.graphics.newImage()
	
end

