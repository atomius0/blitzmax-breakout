
require "image"
dbg = require "debugger"

tiles_img = nil

rotation = 0

function love.load()
	
	autoMidHandle(true)
	tiles_img = loadAnimImage("media/tiles.png", 32, 20, 1, 5)
	assert(tiles_img)
	
	--[[
	for i, v in ipairs(tiles_img.quads) do
		--print(i, v:getTextureDimensions())
		print(i, v:getViewport())
	end
	--]]
end


function love.update(dt)
	rotation = rotation + dt*60
	setRotation(rotation)
	--print(1*60*dt)
end


function love.draw()
	--dbg()
	
	for i = 1, 5 do
		drawImage(tiles_img, 100, 50 + 32 * (i-1), i)
	end
end

