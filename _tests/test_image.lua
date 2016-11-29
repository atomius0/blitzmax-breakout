
require "image"


tiles_img = nil

function love.load()
	
	autoMidHandle(true)
	tiles_img = loadAnimImage("media/tiles.png", 32, 20, 1, 5)
	assert(tiles_img)
end


function love.update()
	--[[
	assert(tiles_img)
	assert(tiles_img.img)
	print("ok")
	--]]
	for i = 1, 5 do
		--TODO: this doesn't draw anything... why?
		drawImage(tiles_img, 100, 50 + 32 * (i-1))
		print(tiles_img, 100, 50 + 32 * (i-1))
	end
end

