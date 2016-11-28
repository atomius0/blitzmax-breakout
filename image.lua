-- image handling functions
-- replicates some functionality of BlitzMax's Max2D module

-- TODO: LoadImage, LoadAnimImage, DrawImage


local _autoMidHandle = false

function autoMidHandle(v)
	assert(type(v) == "boolean", "boolean required")
	_autoMidHandle = v
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



