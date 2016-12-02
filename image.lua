-- image handling functions
-- replicates some functionality of BlitzMax's Max2D module

--[[
--TODO: implement tileImage function! how?
use image:setWrap() and then draw the image with a large quad. see:
https://love2d.org/wiki/(Image):setWrap
https://love2d.org/wiki/WrapMode
--]]

local _autoMidHandle = false
local _rotation = 0
local _scale_x, _scale_y = 1, 1


function setRotation(r)
	_rotation = math.rad(r)
end


function setScale(sx, sy)
	_scale_x = sx
	_scale_y = sy
end


function setAlpha(alpha) -- range: 0.0 - 1.0
	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(r, g, b, 255 * alpha)
end


function setColor(red, green, blue) -- range: 0 - 255
	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(red, green, blue, a)
end


--[[
blend should be one of:

Blend mode   | Effect
---------------------
- MASKBLEND  | Pixels are drawn only if their alpha component is greater than .5
- SOLIDBLEND | Pixels overwrite existing backbuffer pixels
- ALPHABLEND | Pixels are alpha blended with existing backbuffer pixels
- LIGHTBLEND | Pixel colors are added to backbuffer pixel colors, giving a 'lighting' effect
- SHADEBLEND | Pixel colors are multiplied with backbuffer pixel colors, giving a 'shading' effect
--]]
function setBlend(blend)
	assert(type(blend) == "string")
	--NOTE: do nothing, bmx-breakout only uses ALPHABLEND, which is the default mode in love2d.
	-- bmx-breakout also uses MASKBLEND, but it has no real effect
	-- (except for making the hiscore's background bar opaque instead of transparent.
	-- but we can turn it opaque easily, even without MASKBLEND)
end


function autoMidHandle(b)
	assert(type(b) == "boolean", "boolean required")
	_autoMidHandle = b
end


function midHandleImage(image)
	local t = image
	assert(type(t) == "table")
	assert(type(t.quads) == "table" and t.quads[1]) -- make sure there is at least 1 quad
	
	local _, w, h
	_, _, w, h = t.quads[1]:getViewport()
	t.handle_x = w * .5
	t.handle_y = h * .5
end


-- generates quads, similar to how LoadAnimImage from the BlitzMax Max2D module works.
-- parameters:
-- 'first' is one-based instead of zero based
-- 'sw' and 'sh' are the reference width and height (total size of the image in pixels)
-- see:  https://love2d.org/wiki/love.graphics.newQuad
function generateQuads(cell_w, cell_h, first, count, sw, sh)
	local quads = {}
	
	local x_cells = sw / cell_w
	local y_cells = sh / cell_h
	assert(first-1+count <= x_cells * y_cells, "too many cells")
	
	for cell = first-1, first-1+count-1 do
		local x = cell % x_cells * cell_w
		local y = math.floor(cell / x_cells) * cell_h
		--print(x_cells,y_cells,cell,x,y)
		quads[cell+1-first+1] = love.graphics.newQuad(x, y, cell_w, cell_h, sw, sh)
	end
	
	return quads
end


function _loadImage(is_anim, url, cell_w, cell_h, first, count)
	local t = {}
	
	t.img = love.graphics.newImage(url)
	if not t.img then return end
	
	if is_anim then
		t.quads = generateQuads(cell_w, cell_h, first, count, t.img:getDimensions())
	else
		-- if it is not an animated image,
		-- generate a single quad spanning the whole image.
		local x, y = t.img:getDimensions()
		t.quads = generateQuads(x, y, 1, 1, x, y)
	end
	
	t.handle_x, t.handle_y = 0, 0
	if _autoMidHandle then midHandleImage(t) end
	return t
end


-- the flags parameter from the blitzmax LoadImage function was left out on purpose
-- since it isn't used in this project
-- returns: table containing image and quad data. to be used with function drawImage.
function loadImage(url)
	return _loadImage(false, url)
end


-- flags parameter was left out here, too (see function above)
-- returns: table containing image and quad data. to be used with function drawImage.
function loadAnimImage(url, cell_w, cell_h, first, count)
	return _loadImage(true, url, cell_w, cell_h, first, count)
end


-- parameters:
-- image - the table returned by loadImage or loadAnimImage
function drawImage(image, x, y, frame)
	local t = image
	frame = frame or 1 -- set default value for frame
	love.graphics.draw(t.img, t.quads[frame], x, y, _rotation, _scale_x, _scale_y, t.handle_x, t.handle_y)
	-- TODO: handle rotation and scaling
end


function tileImage(image, x, y, frame)
	x = x or 0
	y = y or 0
	frame = frame or 0
	
	assert(false, "not implemented")
	--TODO: this
end


function drawRect(x, y, width, height)
	love.graphics.rectangle("fill", x, y, width, height)
end

