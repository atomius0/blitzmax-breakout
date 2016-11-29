
require "image"

tiles_img = nil

function love.load()
	autoMidHandle(true)
	tiles_img = loadAnimImage("media/tiles.png", 32, 20, 1, 5)
	assert(tiles_img)
end


function love.run()
	for i = 1, 5 do
		drawImage(tiles_img, 100, 50 + 32 * (i-1))
	end
end

