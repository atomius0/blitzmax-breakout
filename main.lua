-- blitzmax_breakout
-- a port of the BlitzMax Breakout sample game to LÖVE 2D


-- DONE: test list (see note below)
-- DONE: test oop
-- DONE: test drawanimimage counterpart separately first!



-- NOTE: tiles are never removed from TileList, even in the original code!

-- main loop in original source is at lines 198 - 226


require "strict" -- temporary
--require('mobdebug').start()

--[[
require "_tests.test_image"
--]]
---[[
require "random"
createclass = require "createclass"
TList       = require "linkedlist"


WIDTH, HEIGHT = nil, nil -- we set these in love.load()
SHADOW_ON = true
SHADOW_SIZE = 10

gtime = nil
pipes_img = nil
tiles_img = nil
logo_img = nil
paddle = nil
ballvis = nil

--setup the level
tilelist = nil
balllist = nil
playerX, playerY = 0, 0
score = 0

-- Private
ballcount = 0

minf = math.min

maxf = math.max
-- Public

do Ball = createclass()
	Ball.x, Ball.y = 0, 0
	Ball.dx, Ball.dy, Ball.spd, Ball.rot = 0, 0, 0, 0
	-- Ball.visual = 0 -- unused variable in original code
	
	function Ball:Update()
		self.x = self.x + (self.dx * self.spd)
		self.y = self.y + (self.dy * self.spd)
		if self.x < 34 or self.x > 606 then
			self.dx = -self.dx
		end
		if self.y < 50 then
			self.dy = -self.dy
		end
		if self.y > HEIGHT-8 then
			ballcount = ballcount -1
			balllist:remove(self)
		else
			if self.dy > 0 then
				if self.y > playerY - 8 then
					if self.x > playerX-32 and self.x < playerX-32 then
						self.dy = self.dy*-1
					end
				end
			end
			self.rot = self.rot + 10
		end
	end
	
	function Ball:draw(offx, offy)
	--  	SetRotation rot
	--  	DrawImage ballvis,x+offx,y+offy
	--  	SetRotation 0
	end--  EndMethod
    --  
	function Ball.create(x, y)
		x = x or WIDTH / 2
		y = y or HEIGHT / 2
		local b = Ball()
		ballcount = ballcount + 1
		b.x = x
		b.y = y
		b.dx = rnd(-2, 2)
		b.dy = rnd(-2, 2)
		b.spd = 4 -- 0.1
		return b
	end
end


-- all tiles are a standard size so
do Tile = createclass() --Type Tile
--  Field x#,y#
--  Field typ = 0
--  Field state = 0
--  Field rot#=0,size#=1
--
--  Method Draw(offx,offy)
--    Select state
--      Case 0
--        SetRotation rot
--        If size>1
--          SetScale size,size
--          size=size*0.9
--        Else
--          size = 1
--          SetScale 0.95+(0.05*Cos(gTime)),0.95+(0.05*Sin(gTime))
--        EndIf
--      Case 1
--        SetRotation rot
--        SetScale size,size
--    EndSelect
--    Select typ
--      Case 0
--        DrawImage tiles_img,x+offx,y+offy+(2*Sin(gtime)),0
--      Case 1
--        DrawImage tiles_img,x+offx,y+offy+(2*Sin(gtime)),1
--      Case 2
--        DrawImage tiles_img,x+offx,y+offy+(2*Sin(gtime)),2
--      Case 3
--        DrawImage tiles_img,x+offx,y+offy+(2*Sin(gtime)),3
--      Case 4
--        DrawImage tiles_img,x+offx,y+offy+(2*Sin(gtime)),4
--    EndSelect
--
--    SetScale 1,1
--    SetRotation 0
--  EndMethod
--
--  Method Update()
--    Local c
--    Local b:Ball
--    If state = 0
--      'Check this tile for collision with all of the balls
--      For b=EachIn BallList
--        If b.x>x-4 And b.x<x+24
--          If b.y>y-4 And b.y<y+24
--            b.dy=-b.dy
--            Select typ
--              Case 1
--                If ballcount=1
--                  For c=0 Until 2
--                    BallList.AddLast(ball.Create(b.x,b.y))
--                  Next
--                EndIf
--                state = 1
--                size = 1
--              Case 2
--                typ = 3
--                size=1.5
--              Case 3
--                typ = 4
--                size=1.5
--              Default
--                Score:+((1+typ)*100)
--                state = 1
--            EndSelect
--            Return
--          EndIf
--        EndIf
--      Next
--    Else
--      y:+4
--      rot:+5
--      size:-.005
--      If y>HEIGHT
--        BallList.Remove(b)
--      EndIf
--    EndIf
--  EndMethod
--
--
--  Function Create:Tile(x=0,y=0,typ=0)
--    Local t:Tile = New Tile
--      t.x=x
--      t.y=y
--      t.typ = typ
--      Return t
--  EndFunction
end --EndType


-------------------------------------------------------------------------------

function love.load()
	-- width and height are set in conf.lua
	WIDTH, HEIGHT = love.graphics.getDimensions()
	
	
end





--]]




























