Powerup = Class{}

function Powerup:init(x, y, type)
    self.x = x
    self.y = y
    self.type = type
    self.falling = false
end

function Powerup:update(dt)
    if self.x > 0 and self.y > 0 then
        self.falling = true
    end

    if self.falling == true then
        self.y = self.y + 1
    end
end

function Powerup:render()  
    if self.falling == true then   
        love.graphics.draw(gTextures['main'], gFrames['powerups'][self.type], self.x + 8, self.y)
    end

end

function Powerup:collides(target)
    if self.y + 16 < target.y 
    or self.y > target.y + target.height 
    or self.x + 16 < target.x or 
    self.x > target.x + target.width then
        return false
    else
        return true
    end
end