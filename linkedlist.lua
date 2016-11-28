-- incomplete minimal clone of BlitzMax TList type
-- based on an array.
-- written by atomius, 2016

local createClass = require "createclass"

--[[
required functions (already implemented):
	new
	addLast
	eachIn
	remove

not yet implemented:
	clear
	isEmpty
	contains
	addFirst
	first
	last
	removeFirst
	removeLast
	insertBeforeLink
	insertAfterLink
	count
	copy
	reverse  -- Reverse the order of the list.
	reversed -- Creates a new list that is the reversed version of this list.
	sort
	toArray
--]]


local TList = createClass()

function TList:_init()
	--self._length = 0
	return self
end


function TList:addLast(obj)
	self[#self+1] = obj
end


function TList:eachin()
	local pos = 0
	
	return function()
		pos = pos + 1
		--if pos <= self._length then
		if pos <= #self then
			return self[pos]
		end
	end
end


function TList:remove(obj)
	-- search obj in list
	for i, v in ipairs(self) do
		if v == obj then -- found obj
			table.remove(self, i)
			return true
		end
	end
	return false
end


return TList

