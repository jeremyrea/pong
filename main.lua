function love.load()
    world = love.physics.newWorld(0, 0, true)
        world:setCallbacks(beginContact, endContact, preSolve, postSolve)

    ball = {}
        ball.b = love.physics.newBody(world, 400,300, "dynamic")
        ball.b:setMass(1)
        ball.s = love.physics.newCircleShape(10)
        ball.f = love.physics.newFixture(ball.b, ball.s)
        ball.f:setRestitution(1)    -- make it bouncy
        ball.f:setUserData("Ball")

    panel1 = {}
        panel1.b = love.physics.newBody(world, 20,300, "dynamic")
        panel1.s = love.physics.newRectangleShape(10,75)
        panel1.f = love.physics.newFixture(panel1.b, panel1.s, 100000)
        panel1.f:setUserData("Block")

    panel2 = {}
        panel2.b = love.physics.newBody(world, 780,300, "dynamic")
        panel2.s = love.physics.newRectangleShape(10,75)
        panel2.f = love.physics.newFixture(panel2.b, panel2.s, 100000)
        panel2.f:setUserData("Block")

    topLimit = {}
        topLimit.b = love.physics.newBody(world, 400,-1, "static")
        topLimit.s = love.physics.newRectangleShape(800,1)
        topLimit.f = love.physics.newFixture(topLimit.b, topLimit.s)
        topLimit.f:setUserData("Block") 

    bottomLimit = {}
        bottomLimit.b = love.physics.newBody(world, 400,601, "static")
        bottomLimit.s = love.physics.newRectangleShape(800,1)
        bottomLimit.f = love.physics.newFixture(bottomLimit.b, bottomLimit.s)
        bottomLimit.f:setUserData("Block") 

    firstLaunch = true
    pts1        = 0
    pts2        = 0
    x           = 0
    y           = 0
    text        = ""   -- we'll use this to put info text on the screen later
    persisting  = 0    -- we'll use this to store the state of repeated callback calls
end

function love.update(dt)
    world:update(dt)

    if love.keyboard.isDown("w") then
        panel1.b:applyForce(0, -50000000)
    elseif love.keyboard.isDown("s") then
        panel1.b:applyForce(0, 50000000)
    end
    if love.keyboard.isDown("up") then
        panel2.b:applyForce(0, -50000000)
    elseif love.keyboard.isDown("down") then
        panel2.b:applyForce(0, 50000000)
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
        --ball.b:applyForce(-10000, 0)
    elseif (x < 0) then
        pts2 = pts2 + 1
        newRound()
        firstLaunch = true
        --ball.b:applyForce(10000, 0)
    end

    if (firstLaunch == true) then
        --love.timer.sleep(2)
        ball.b:applyForce(10000, 0)
        firstLaunch = false
    end
    text = pts1.."                    "..pts2
end

function love.draw()
    love.graphics.circle("fill", ball.b:getX(),ball.b:getY(), ball.s:getRadius(), 20)
    love.graphics.polygon("fill", panel1.b:getWorldPoints(panel1.s:getPoints()))
    love.graphics.polygon("fill", panel2.b:getWorldPoints(panel2.s:getPoints()))
    love.graphics.polygon("line", topLimit.b:getWorldPoints(topLimit.s:getPoints()))
    love.graphics.polygon("line", bottomLimit.b:getWorldPoints(bottomLimit.s:getPoints()))
    love.graphics.print(text, 350, 10)

end

function newRound()
    ball.b:setLinearVelocity(0, 0)
    panel1.b:setLinearVelocity(0, 0)
    panel2.b:setLinearVelocity(0, 0)
    ball.b:setX(400)
    ball.b:setY(300)
    panel1.b:setX(20)
    panel1.b:setY(300)
    panel2.b:setX(780)
    panel2.b:setY(300)
    firstLaunch = true
end
