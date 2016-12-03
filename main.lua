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
require "image"
require "random"
createclass = require "createclass"
TList       = require "linkedlist"


WIDTH, HEIGHT = nil, nil -- we set these in love.load()
SHADOW_ON = true
SHADOW_SIZE = 10

gtime = nil
back = nil -- added because strict.lua complains otherwise
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
		setRotation(self.rot)
		drawImage(ballvis, self.x + offx, self.y + offy)
		setRotation(0)
	end
    
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
do Tile = createclass()
	Tile.x, Tile.y = 0, 0
	Tile.typ = 0
	Tile.state = 0
	Tile.rot, Tile.size = 0, 1
	
	function Tile:draw(offx, offy)
		if self.state == 0 then
			setRotation(self.rot)
			if self.size > 1 then
				setScale(self.size, self.size)
				self.size = self.size * 0.9
			else
				self.size = 1
				setScale(0.95 + (0.05 * math.cos(gtime)), 0.95 + (0.05 * math.sin(gtime)))
			end
		elseif self.state == 1 then
			setRotation(self.rot)
			setScale(self.size, self.size)
		end
		
		if self.typ == 0 then
			drawImage(tiles_img, self.x + offx, self.y + offy + (2 * math.sin(gtime)), 0)
		elseif self.typ == 1 then
			drawImage(tiles_img, self.x + offx, self.y + offy + (2 * math.sin(gtime)), 1)
		elseif self.typ == 2 then
			drawImage(tiles_img, self.x + offx, self.y + offy + (2 * math.sin(gtime)), 2)
		elseif self.typ == 3 then
			drawImage(tiles_img, self.x + offx, self.y + offy + (2 * math.sin(gtime)), 3)
		elseif self.typ == 4 then
			drawImage(tiles_img, self.x + offx, self.y + offy + (2 * math.sin(gtime)), 4)
		end
		
		setScale(1, 1)
		setRotation(0)
	end
	
	function Tile:update()--  Method Update()
		local c = 0--    Local c
		-- local b = nil -- not needed, is local variable in for-loop below
		if self.state == 0 then--    If state = 0
			-- Check this tile for collision with all of the balls
			for b in balllist:eachin() do--      For b=EachIn BallList
				if b.x > self.x-4 and b.x < self.x+24 then--        If b.x>x-4 And b.x<x+24
					if b.y > self.y-4 and b.y < self.y+24 then--          If b.y>y-4 And b.y<y+24
						b.dy = -b.dy--            b.dy=-b.dy
						if self.typ == 1 then--            Select typ
							--##--              Case 1
							if ballcount == 1 then--                If ballcount=1
								for c = 0, 1 do -- or 2? --                  For c=0 Until 2
									balllist:addLast(Ball.create(b.x, b.y))--                    BallList.AddLast(ball.Create(b.x,b.y))
								end--                  Next
							end--                EndIf
							self.state = 1
							self.size = 1
						elseif self.typ == 2 then--              Case 2
							self.typ = 3--                typ = 3
							self.size = 1.5--                size=1.5
						elseif self.typ == 3 then--              Case 3
							self.typ = 4--                typ = 4
							self.size = 1.5--                size=1.5
						else--              Default
							score = score + ((1 + self.typ) * 100)--                Score:+((1+typ)*100)
							self.state = 1--                state = 1
						end--            EndSelect
						return--            Return
					end--          EndIf
				end--        EndIf
			end--      Next
		else--    Else
			self.y = self.y + 4--      y:+4
			self.rot = self.rot + 5--      rot:+5
			self.size = self.size - .005--      size:-.005
			if self.y > HEIGHT then--      If y>HEIGHT
				balllist:remove(b)--        BallList.Remove(b)
			end--      EndIf
		end--    EndIf
	end--  EndMethod
	
	
	function Tile.create(x, y, typ)--  Function Create:Tile(x=0,y=0,typ=0)
		x = x or 0
		y = y or 0
		typ = typ or 0
		
		local t = Tile()--    Local t:Tile = New Tile
		t.x = x--      t.x=x
		t.y = y--      t.y=y
		t.typ = typ--      t.typ = typ
		return t--      Return t
	end--  EndFunction
end --EndType


-------------------------------------------------------------------------------

function love.load()
	-- width and height are set in conf.lua
	WIDTH, HEIGHT = love.graphics.getDimensions() --Graphics WIDTH,HEIGHT,DEPTH
	
	autoMidHandle(true) --AutoMidHandle True
	
	-- Media
	back = {} --Global back:TImage[2]
	back[1] = loadImage("media/back1.png") --back[0] = LoadImage("media\back1.png")
	back[2] = loadImage("media/back2.png") --back[1] = LoadImage("media\back2.png")
	pipes_img = loadAnimImage("media/pipes.png", 32, 32, 0, 4) --Pipes_img=LoadAnimImage("media\pipes.png",32,32,0,4)
	tiles_img = loadAnimImage("media/tiles.png", 32, 20, 0, 5) --Tiles_img=LoadAnimImage("media\tiles.png",32,20,0,5)
	paddle = loadImage("media/paddle.png") --paddle = LoadImage("media\paddle.png")
	ballvis = loadImage("media/ball.png") --ballvis = LoadImage("media\ball.png")
	logo_img = loadImage("media/B-Max.png")--logo_img=LoadImage("media\B-Max.png")
	
	
	tilelist = TList() --Tilelist:TList = New TList
	balllist = TList() --Balllist:TList = New TList
	playerX = WIDTH / 2 --playerX# = Width/2
	playerY = HEIGHT - 40--PlayerY# = Height-40
	score = 0 --Score=0
	
	resetGame() --ResetGame()
	
	love.mouse.setVisible(false) --HideMouse
end


function love.keypressed(key) --While Not KeyDown(KEY_ESCAPE)
	if key == "escape" then
		love.event.push('quit') --End
	end
end


function love.update(dt)
	-- Update Players Position
	playerX = minf(574,maxf(64,love.mouse.getX())) -- playerx = minf(574,maxf(64,MouseX()))
	-- Update Balls
	updateBalls() -- UpdateBalls()
	-- Update Tiles
	updateTiles() -- UpdateTiles()
	
	gtime = gtime + 10 -- gTime:+10
end


function love.draw()
	-- Draw Level
	drawLevel()-- DrawLevel()

	setAlpha(.75)-- SetAlpha .75
	setColor(0, 0, 255)-- SetColor 0,0,255
	drawRect(0, 0, WIDTH, 20)-- DrawRect 0,0,Width,20
	
	setBlend("ALPHABLEND") -- SetBlend ALPHABLEND
	
	setAlpha(0,5) -- SetAlpha 0.5
	setColor(0, 0, 0) -- SetColor 0,0,0
	love.graphics.print("Score:" .. tostring(score), 4, 4) -- DrawText "Score:"+Score,4,4
	
	setAlpha(1)-- SetAlpha 1
	setColor(255, 255, 255) -- SetColor 255,255,255
	love.graphics.print("Score:" .. tostring(score) .. " " .. tostring(ballcount), 2, 2) -- DrawText "Score:"+Score+" "+ballcount,2,2
	
	-- Flip
end



function drawLevel() --Function DrawLevel()
	local w, aa = 0, 0 --  Local w,aa#
	tileImage(back[2], 0, gtime / 20) --  TileImage back[1],0,gTime/20
	setBlend("ALPHABLEND") --  SetBlend ALPHABLEND
	drawImage(logo_img, width / 2, height / 2) --  DrawImage logo_img,width/2,height/2
	aa = 0.5 + (0.5 * math.cos(gtime / 50)) --  aa#=0.5+(0.5*Cos(gtime/50))
	setBlend("ALPHABLEND") --  SetBlend AlphaBLEND
	setAlpha(aa) --  SetAlpha aa
	tileImage(back[1], 0, gtime / 10) --  TileImage back[0],0,gTime/10
	
	if SHADOW_ON then --  If ShadowOn
		setColor(0, 0, 0) --    SetColor 0,0,0
		setBlend("ALPHABLEND") --    SetBlend AlphaBLEND
		setAlpha(0.5) --    SetAlpha 0.5
		drawPipes(SHADOW_SIZE + 16, SHADOW_SIZE + 16) --    DrawPipes ShadowSize+16,ShadowSize+16
		
		drawTiles(SHADOW_SIZE + 16, SHADOW_SIZE + 10) --    DrawTiles ShadowSize+16,ShadowSize+10
		drawPlayer(SHADOW_SIZE, SHADOW_SIZE) --    DrawPlayer ShadowSize,ShadowSize
		drawBalls(SHADOW_SIZE, SHADOW_SIZE) --    DrawBalls ShadowSize,ShadowSize
	end --  EndIf
	
	setColor(255, 255, 255) --  SetColor 255,255,255
	setBlend("MASKBLEND") --  SetBlend MASKBLEND
	setAlpha(1) --  SetAlpha 1
	drawPipes() --  DrawPipes()
	drawTiles() --  DrawTiles()
	drawPlayer() --  DrawPlayer()
	drawBalls() --  DrawBalls()
end --EndFunction


function resetGame() --Function ResetGame()
	tilelist = TList() --  TileList = New TList
	balllist = TList() --  BallList = New TList
	-- local x, y --  Local x,y -- not needed
	for y = 0, 4 do --  For y=0 Until 5
		for x = 0, 17 do --    For x=0 Until 18
			tilelist:addLast(Tile.create(38 + x * 32, (y * 24) + 66, 4 - y)) --        Tilelist.AddLast(Tile.Create(38+x*32,(y*24)+66,4-Y))
		end --    Next
	end--  Next
	
	balllist:addLast(Ball.create()) --  BallList.AddLast(Ball.Create())
end --EndFunction


function drawPipes(x, y) --Function DrawPipes(x=16,y=16)
	x = x or 16
	y = y or 16
	--  Local tmp -- not needed
	
	-- top
	for tmp = 0, 17 do --  For tmp=0 Until 18
		drawImage(pipes_img, x + 32 + (tmp * 32), y + 16, 3) --    DrawImage Pipes_img,x+32+(tmp*32),y+16,3
	end --  Next
	
	-- sides
	for tmp = 0, 13 do --  For tmp=0 Until 14
		drawImage(pipes_img, x, y + 48 + (tmp * 32), 2) --    DrawImage Pipes_img,x,y+48+(tmp*32),2
		drawImage(pipes_img, x + WIDTH - 32, y + 48 + (tmp * 32), 2) --    DrawImage Pipes_img,x+Width-32,y+48+(tmp*32),2
	end --  Next
	
	-- Corners
	drawImage(pipes_img, x, y + 16, 0) --  DrawImage Pipes_img,x,y+16 ,0
	drawImage(pipes_img, x + WIDTH - 32, y + 16, 1) --  DrawImage Pipes_img,x+Width-32,y+16,1
	
end --EndFunction


function drawTiles(x_off, y_off) --Function DrawTiles(x_off=10, y_off=10)
	x_off = x_off or 10
	y_off = y_off or 10
	-- Local tl:Tile -- not needed
	local any = false -- Local any=0
	for tl in tilelist:eachin() do --  For tl=EachIn TileList
		tl:draw(x_off, y_off) --  tl.Draw(x_off, y_off)
		any = true --  any=1
	end -- Next
	if not any then --	If Not any 
		resetGame() --  ResetGame()
		score = score + 10000 --  score:+10000
	end -- EndIf
end --EndFunction


function drawBalls(x_off, y_off) --Function DrawBalls(x_off=0, y_off=0)
	x_off = x_off or 0
	y_off = y_off or 0
	
	--	Local bl:Ball -- not needed
	for bl in balllist:eachin() do --  For bl=EachIn balllist
		bl:draw(x_off, y_off) --  bl.Draw(x_off, y_off)
	end --  Next
end --EndFunction


function updateBalls() --Function UpdateBalls()
	if ballcount == 0 then --  If ballcount=0
		balllist:addLast(Ball.create(WIDTH / 2, HEIGHT / 2)) --    BallList.AddLast(Ball.Create(Width/2,Height/2))
	else --  Else
		--  	Local bl:Ball -- not needed
		for bl in balllist:eachin() do --  	For bl = EachIn BallList
			bl:update() --  		bl.Update()
		end --  	Next
	end --  EndIf
end --EndFunction


function updateTiles() --Function UpdateTiles()
	--	Local tl:Tile -- not needed
	for tl in tilelist:eachin() --	For tl=EachIn tilelist
		tl:update() --		tl.Update()
	end --	Next
end --EndFunction


function drawPlayer(x_off, y_off) --Function DrawPlayer(x_off=0,y_off=0)
	x_off = x_off or 0
	y_off = y_off or 0
	
	drawImage(paddle, playerX + x_off, playerY + y_off) --  DrawImage paddle, playerx+x_off, playery+y_off
end --End Function

--]]

