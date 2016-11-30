
require "image"
dbg = require "debugger"

tiles_img = nil

rotation = 0

function love.load()
	
	autoMidHandle(true)
	tiles_img = loadAnimImage("media/tiles.png", 32, 20, 1, 5)
	assert(tiles_img)
	
	-- fixes rotation around wrong origin,
	--TODO: fix it in image.lua (midHandleImage uses the whole size of the image...)
	tiles_img.handle_x = 32 * .5
	tiles_img.handle_y = 20 * .5
end


function love.update(dt)
	rotation = rotation + dt*60
	setRotation(rotation)
	print(1*60*dt)
end

-- you can't draw in love.update,
-- because the mainloop clears the screen between love.update and love.draw!
--function love.update()
function love.draw()
	--[[
	assert(tiles_img)
	assert(tiles_img.img)
	print("ok")
	--]]
	
	--dbg()
	
	for i = 1, 5 do
		--BUG: this draws the same tile 5 times (the green one)
		-- fixed: forgot the image index parameter.
		drawImage(tiles_img, 100, 50 + 32 * (i-1), i)
	end
end

