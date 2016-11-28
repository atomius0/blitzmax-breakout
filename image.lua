-- image handling functions
-- replicates some functionality of BlitzMax's Max2D module


--[[ TODO:

- add private locals for rotation, scale_x and scale_y

- add functions: setRotation, setScale, setAlpha, setColor, setBlend

- note: setRotation in bmax uses degrees, love.graphics.draw uses radians:
  research how to convert degrees to radians!

- in func setBlend: handle blend modes for alphablend and maskblend

- use parameters of love.graphics.draw() for rotation and scaling.

- research how to do setAlpha, setColor, setBlend

--]]

local _autoMidHandle = false

function autoMidHandle(b)
	assert(type(b) == "boolean", "boolean required")
	_autoMidHandle = b
end


function midHandleImage(image)
	local t = image
	assert(type(t) == "table")
	local x, y = t.img:getDimensions()
	t.handle_x = x * .5
	t.handle_y = y * .5
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
		print(x_cells,y_cells,cell,x,y)
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
		r.quads = generateQuads(x, y, 1, 1, x, y)
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
	love.graphics.draw(t.img, t.quads[frame], x, y)
	-- TODO: handle rotation and scaling
end

