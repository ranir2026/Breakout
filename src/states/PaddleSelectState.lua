PaddleSelectState = Class{__includes = BaseState}

function PaddleSelectState:enter(params)
    self.highScores = params.highScores
end

function PaddleSelectState:init()
    self.curPaddle = 1
end

function PaddleSelectState:update(dt)
    if love.keyboard.wasPressed('left') then
        if self.curPaddle == 1 then
            if UNMUTED then
               gSounds['no-select']:play()
            end
        else
            if UNMUTED then
                gSounds['select']:play()
            end
            self.curPaddle = self.curPaddle - 1
        end
    elseif love.keyboard.wasPressed('right') then
        if self.curPaddle == 4 then
            if UNMUTED then
                gSounds['no-select']:play()
            end
        else
            if UNMUTED then
              gSounds['select']:play()
            end
            self.curPaddle = self.curPaddle + 1
        end
    end

    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
        if UNMUTED then
            gSounds['confirm']:play()
        end

        gStateMachine:change('serve', {
            paddle = Paddle(self.curPaddle, 2),
            bricks = LevelMaker.createMap(1),
            health = 3,
            score = 0,
            highScores = self.highScores,
            level = 1,
            recoverPoints = 5000,
            paddlePoints = 7000,
            keys = 3
        })
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PaddleSelectState:render()
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf("Select your paddle with left and right!", 0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf("Press Enter to continue!", 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')

    if self.curPaddle == 1 then
        love.graphics.setColor(40/255, 40/255, 40/255, 0.5)
    end
    
    love.graphics.draw(gTextures['arrows'], gFrames['arrows'][1], VIRTUAL_WIDTH / 4 - 24, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3)

    love.graphics.setColor(1, 1, 1, 1)

    if self.curPaddle == 4 then
        love.graphics.setColor(40/255, 40/255, 40/255, 0.5)
    end

    love.graphics.draw(gTextures['arrows'], gFrames['arrows'][2], VIRTUAL_WIDTH - VIRTUAL_WIDTH / 4, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3)

    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.draw(gTextures['main'], gFrames['paddles'][2 + 4 * (self.curPaddle - 1)], VIRTUAL_WIDTH / 2 - 32, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3)
end