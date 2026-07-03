PlayState = Class{__includes = BaseState}

noPowerup = 30
lockedBrick = false

function PlayState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.highScores = params.highScores
    self.ball = params.ball
    self.level = params.level
    self.keys = params.keys

    self.recoverPoints = params.recoverPoints
    self.paddlePoints = params.paddlePoints

    self.ball[1].dx = math.random(-100, 100)
    self.ball[1].dy = math.random(-70, -80)

    self.powerup = {[1] = Powerup(-5, -5, 4)}

    hitcount = math.floor(self.health/3 * noPowerup) 
end


function PlayState:update(dt)
    if self.health == 0 then
        gStateMachine:change('game-over', {
            score = self.score,
            highScores = self.highScores
        })
    end

    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            self.score = self.score + 10

            if UNMUTED then
                gSounds['pause']:play()
            end
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true

        if UNMUTED then
            gSounds['pause']:play()
        end

        return
    end

    self.paddle:update(dt)

    for k, b in pairs(self.ball) do
        b:update(dt)
    end
    for k, pp in pairs(self.powerup) do
        pp:update(dt)
    end
        
    for k, ball in pairs(self.ball) do
        if ball:collides(self.paddle) then
            ball.y = self.paddle.y - 8
            ball.dy = -ball.dy

            if ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
                ball.dx = -50 + -(8 *(self.paddle.x + self.paddle.width/2 - ball.x) * 2 / self.paddle.size)
            
            elseif ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
                ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width/2 - ball.x) * 2 / self.paddle.size)
            end

            if UNMUTED then
                gSounds['paddle-hit']:play()
            end
        end
    end

    for k, pp in pairs(self.powerup) do
        if pp:collides(self.paddle) then
            pp.y = self.paddle.y - 16
            table.remove(self.powerup, k)
            
            if UNMUTED then
                gSounds['paddle-hit']:play()
                gSounds['victory']:play()
            end

            if pp.type == 9 then
                for i = 1, 4 do
                    b = Ball()
                    b.skin = math.random(7)
                    b.x = self.ball[1].x
                    b.y = self.ball[1].y
                    b.dy = self.ball[1].dy + math.random(-15, 15)
                    b.dx = self.ball[1].dx + math.random(-10, 10)
                    table.insert(self.ball, b)
                end
            elseif pp.type == 5 and self.paddle.size < 4 then
                self.paddle.size = self.paddle.size + 1
                self.paddle.width = self.paddle.size * 32
                io.write("size increment" .. "\n")
            elseif pp.type == 6 and self.paddle.size > 1 then
                self.paddle.size = self.paddle.size - 1
                self.paddle.width = self.paddle.size * 32
            elseif pp.type == 10 then
                self.keys = self.keys + 1
            elseif pp.type == 3 and self.health < 3 then
                self.health = self.health + 1
            elseif pp.type == 4 then
                self.health = self.health - 1
            elseif pp.type == 1 then
                self.health = self.health - 3
            elseif pp.type == 2 then
                self.health = 3
            end
        end

        if pp.y > VIRTUAL_HEIGHT then
            table.remove(self.powerup, k)
        end
    
    end

        for i, ball in pairs(self.ball) do
            for k, brick in pairs(self.bricks) do
                if brick.isLocked == true then
                    lockedBrick = true
                end

            
            if brick.inPlay and ball:collides(brick) then
                if brick.isLocked == true and self.keys >= 1 then
                    brick.inPlay = false
                    self.keys = self.keys - 1

                    if UNMUTED then
                        gSounds['brick-hit-1']:play()
                    end

                    self.score = self.score + 200
                end
                
                hitcount = hitcount - 1

                if math.random(hitcount) == hitcount then
                    if math.random(1, 9) == 9 then
                        table.insert(self.powerup, Powerup(brick.x, brick.y, 9))
                        hitcount = math.floor(self.health/3 * noPowerup)
                    elseif math.random(1, 9) == 5 then
                        table.insert(self.powerup, Powerup(brick.x, brick.y, 5))
                        hitcount = math.floor(self.health/3 * noPowerup)
                    elseif math.random(1, 9) == 6 then
                        table.insert(self.powerup, Powerup(brick.x, brick.y, 6))
                        hitcount = math.floor(self.health/3 * noPowerup)
                    elseif math.random(1, 9) == 3 then
                        table.insert(self.powerup, Powerup(brick.x, brick.y, 3))
                        hitcount = math.floor(self.health/3 * noPowerup)
                    elseif math.random(1, 9) == 4 then
                        table.insert(self.powerup, Powerup(brick.x, brick.y, 4))
                        hitcount = math.floor(self.health/3 * noPowerup)
                    elseif math.random(1, 9) == 1 then
                        table.insert(self.powerup, Powerup(brick.x, brick.y, 1))
                        hitcount = math.floor(self.health/3 * noPowerup)
                    elseif math.random(1, 9) == 1 then
                        table.insert(self.powerup, Powerup(brick.x, brick.y, 2))
                        hitcount = math.floor(self.health/3 * noPowerup)
                    end
                elseif lockedBrick == true and math.random(math.floor(hitcount/2)) == math.floor(hitcount/2) then
                    table.insert(self.powerup, Powerup(brick.x, brick.y, 10))
                    hitcount = math.floor(self.health/3 * noPowerup) 
                end 
                if brick.isLocked == false then
                    self.score = self.score + (brick.tier * 200 + brick.color * 25)
                    brick:hit()
                else
                    hitcount = hitcount - 1

                    if UNMUTED then
                        gSounds['no-select']:play()
                    end
                end
                
                if self.score > self.recoverPoints then
                    self.health = math.min(3, self.health + 1)
                    self.recoverPoints = math.min(100000, self.recoverPoints * 2)

                    if UNMUTED then
                        gSounds['recover']:play()
                    end
                end

                if self.score > self.paddlePoints then
                    if self.paddle.size < 3 then
                        self.paddle.size = self.paddle.size + 1
                        self.paddle.width = self.paddle.size * 32
                    end
                    self.paddlePoints = math.min(120000, self.paddlePoints + 7000)

                    if UNMUTED then
                        gSounds['recover']:play()
                    end
                end

                if self:checkVictory() then
                    if UNMUTED then
                        gSounds['victory']:play()
                    end

                    gStateMachine:change('victory', {
                        level = self.level,
                        paddle = self.paddle,
                        health = self.health,
                        score = self.score,
                        highScores = self.highScores,
                        ball = self.ball,
                        recoverPoints = self.recoverPoints,
                        paddlePoints = self.paddlePoints,
                        keys = self.keys
                    })
                end

                if ball.x + 2 < brick.x and ball.dx > 0 then
                    ball.dx = -ball.dx
                    ball.x = brick.x - 8
                elseif ball.x + 6 > brick.x + brick.width and ball.dx < 0 then
                    ball.dx = -ball.dx
                    ball.x = brick.x + 32
                elseif ball.y < brick.y then
                    ball.dy = -ball.dy
                    ball.y = brick.y - 8
                else
                    ball.dy = -ball.dy
                    ball.y = brick.y + 16
                end

                if math.abs(ball.dy) < 150 then
                    ball.dy = ball.dy * 1.02
                end
                break
            end
        end

        for j, ball in pairs(self.ball) do
            if ball.y > VIRTUAL_HEIGHT then
                table.remove(self.ball, j)
            end
        end

        if #self.ball == 0 then
            self.health = self.health - 1

            if UNMUTED then
                gSounds['hurt']:play()
            end
        
            if self.health == 0 then
                gStateMachine:change('game-over', {
                    score = self.score,
                    highScores = self.highScores
                })
            else
                gStateMachine:change('serve', {
                    paddle = self.paddle,
                    bricks = self.bricks,
                    health = self.health,
                    score = self.score,
                    highScores = self.highScores,
                    level = self.level,
                    recoverPoints = self.recoverPoints,
                    paddlePoints = self.paddlePoints,
                    keys = self.keys
                })
            end
        end

        for k, brick in pairs(self.bricks) do
            brick:update(dt)
        end

        if love.keyboard.wasPressed('escape') then
            love.event.quit()
        end
    end
end

function PlayState:render()
    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end

    self.paddle:render()

    for k, b in pairs(self.ball) do
        b:render()
    end
    
    for k, pp in pairs(self.powerup) do 
        pp:render()
    end

    renderScore(self.score)
    renderHealth(self.health)
    renderKeys(self.keys)

    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end

function PlayState:checkVictory()
    for k, brick in pairs(self.bricks) do
        if brick.inPlay then
            return false
        end 
    end

    return true
end