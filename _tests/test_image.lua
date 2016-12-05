
require "image"
dbg = require "debugger"

tiles_img = nil
full_img  = nil

rotation = 0
scroll = 0

function love.load()
	
	autoMidHandle(true)
	tiles_img = loadAnimImage("media/tiles.png", 32, 20, 1, 5)
	assert(tiles_img)
	full_img = loadImage("media/tiles.png")
	assert(full_img)
	
	--[[
	for i, v in ipairs(tiles_img.quads) do
		--print(i, v:getTextureDimensions())
		print(i, v:getViewport())
	end
	--]]
end


function love.update(dt)
	--rotation = rotation + dt*60
	--rotation = rotation % 360
	rotation = (rotation + dt*60) % 360
	setRotation(rotation)
	scroll = scroll + dt*60
	--print(1*60*dt)
end


function love.draw()
	tileImage(full_img, -scroll, scroll * .25)
	
	love.graphics.print("rotation: " .. tostring(rotation), 10, 10)
	
	--dbg()
	
	for i = 1, 5 do
		drawImage(tiles_img, 100, 50 + 32 * (i-1), i)
	end
	
	setRotation(90)
	
	--local scale = math.sin(rotation / 360 * 2)
	--local scale = math.sin(math.rad(rotation)) * 2
	local scale = (math.sin(math.rad(rotation)) + 1.25) * 1
	setScale(scale, scale)
	
	drawImage(full_img, 150, 300)
	love.graphics.circle("fill", 150, 300, 4)
	
	setRotation(rotation)
	setScale(scale, scale*2)
	setAlpha(.5)
	drawImage(tiles_img, 400, 300)
	
	setScale(1, 2)
	
	setColor(255, 0, 0)
	drawImage(full_img, 450, 300)
	setColor(0, 255, 0)
	drawImage(full_img, 450, 350)
	setColor(0, 0, 255)
	drawImage(full_img, 450, 400)
	
	
	setColor(255, 255, 255)
	setAlpha(1)
	
	setScale(1, 1)
end

