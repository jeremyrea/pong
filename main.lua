function love.load()
    world = love.physics.newWorld(0, 0, true)

    ball = {}
        ball.b = love.physics.newBody(world, 400, 300, "dynamic")
        ball.b:setMass(1)
        ball.s = love.physics.newCircleShape(10)
        ball.f = love.physics.newFixture(ball.b, ball.s)
        ball.f:setRestitution(1)    -- make it bouncy
        ball.f:setUserData("Ball")

    panel1 = {}
        panel1.b = love.physics.newBody(world, 40, 300, "dynamic")
        panel1.s = love.physics.newRectangleShape(20, 75)
        panel1.f = love.physics.newFixture(panel1.b, panel1.s, 100000)
        panel1.f:setUserData("Block")

    panel2 = {}
        panel2.b = love.physics.newBody(world, 760, 300, "dynamic")
        panel2.s = love.physics.newRectangleShape(20, 75)
        panel2.f = love.physics.newFixture(panel2.b, panel2.s, 100000)
        panel2.f:setUserData("Block")

    topLimit = {}
        topLimit.b = love.physics.newBody(world, 400, 0, "static")
        topLimit.s = love.physics.newRectangleShape(800, 20)
        topLimit.f = love.physics.newFixture(topLimit.b, topLimit.s)
        topLimit.f:setUserData("Block") 

    bottomLimit = {}
        bottomLimit.b = love.physics.newBody(world, 400, 600, "static")
        bottomLimit.s = love.physics.newRectangleShape(800, 20)
        bottomLimit.f = love.physics.newFixture(bottomLimit.b, bottomLimit.s)
        bottomLimit.f:setUserData("Block") 

    scoreFont = love.graphics.newFont(90)
    centerFont = love.graphics.newFont(20)

    firstLaunch = true
    gameEnd1    = false
    gameEnd2    = false
    pts1        = 0
    pts2        = 0
    x           = 0
    y           = 0
    score       = ""
    endGame     = "" 
    message     = "Game will restart in 5 seconds"
end

function love.update(dt)
    world:update(dt)

    if love.keyboard.isDown("w") then
       -- panel1.b:applyForce(0, -250000000) --50000000
       panel1.b:setLinearVelocity(0, -400)
    elseif love.keyboard.isDown("s") then
        --panel1.b:applyForce(0, 250000000)
        panel1.b:setLinearVelocity(0, 400)
    end
    if love.keyboard.isDown("up") then
        --panel2.b:applyForce(0, -250000000)
        panel2.b:setLinearVelocity(0, -400)
    elseif love.keyboard.isDown("down") then
        --panel2.b:applyForce(0, 250000000)
        panel2.b:setLinearVelocity(0, 400)
    end

    if love.keyboard.isDown("r") then
        ball.velocity = {x = 0, y = 0}
        newRound()
        firstLaunch = true
    end

    x = ball.b:getX()
    if (x > 800) then
        pts1 = pts1 + 1
        newRound()
        firstLaunch = true
    elseif (x < 0) then
        pts2 = pts2 + 1
        newRound()
        firstLaunch = true
    end

    if (pts1 == 10) then
    	endGame = "Player 1 wins!"
    	gameEnd1 = true
	elseif (pts2 == 10) then
		endGame = "Player 2 wins!"
		gameEnd1 = true
	end

	if (gameEnd1 ~= true and gameEnd2 ~= true) then
    	if (firstLaunch == true) then
        	ball.b:setLinearVelocity(500, 0)
        	firstLaunch = false
    	end
    end

    score = pts1.." "..pts2
end

function love.draw()
    love.graphics.circle("fill", ball.b:getX(),ball.b:getY(), ball.s:getRadius(), 20)
    love.graphics.polygon("fill", panel1.b:getWorldPoints(panel1.s:getPoints()))
    love.graphics.polygon("fill", panel2.b:getWorldPoints(panel2.s:getPoints()))
    love.graphics.polygon("fill", topLimit.b:getWorldPoints(topLimit.s:getPoints()))
    love.graphics.polygon("fill", bottomLimit.b:getWorldPoints(bottomLimit.s:getPoints()))
    love.graphics.setFont(scoreFont)
    if (pts1 ~= 10 or pts2 ~= 10) then
    	love.graphics.printf(score, 0, 30, 800, 'center')
    elseif (pts1 == 10) then
    	--love.graphics.print(score, 350, 30)
	elseif (pts2 == 10) then
		--love.graphics.print(score, 350, 30)
	end
    love.graphics.setFont(centerFont)
	love.graphics.printf("|\n\n|\n\n|\n\n|\n\n|\n\n|\n\n|\n\n|\n\n|\n\n|\n\n|\n\n|\n\n|\n\n|\n\n|\n\n|\n\n|\n\n|", 0, 12, 800, 'center')

	if (gameEnd2 == true) then
		love.timer.sleep(5)
		gameEnd2 = false
	end

	if (gameEnd1 == true) then
    	love.graphics.printf(endGame, 0, 10, 800, 'left')
    	love.graphics.printf(message, 0, 10, 800, 'right')
    	pts1 = 0
    	pts2 = 0
    	gameEnd1 = false
    	gameEnd2 = true
    end 

end

function love.keyreleased(key)
    if (key == "w") or (key == "s") then
        panel1.b:setLinearVelocity(0,0)
    end

    if (key == "up") or (key == "down") then
        panel2.b:setLinearVelocity(0,0)
    end
end

function newRound()
    ball.b:setLinearVelocity(0, 0)
    panel1.b:setLinearVelocity(0, 0)
    panel2.b:setLinearVelocity(0, 0)
    ball.b:setX(400)
    ball.b:setY(300)
    panel1.b:setX(40)
    panel1.b:setY(300)
    panel2.b:setX(760)
    panel2.b:setY(300)
    firstLaunch = true
end