-- -----------------------------------------------------------------------------------
-- Create class and variables
-- -----------------------------------------------------------------------------------

local GGData = require("GGData")



-- -----------------------------------------------------------------------------------
-- Create class and variables
-- -----------------------------------------------------------------------------------

local utilities = {}
local db = GGData:new("db")



-- -----------------------------------------------------------------------------------
-- Init db
-- -----------------------------------------------------------------------------------

if not db.highscore then
  db:set("highscore", 0)
  db:save()
end

if not db.previousScore then
    db:set("previousScore", 0)
    db:save()
end



-- -----------------------------------------------------------------------------------
-- Highscore
-- -----------------------------------------------------------------------------------

function utilities:getHighscore()
    return db.highscore
end

function utilities:getPreviousScore()
    return db.previousScore
end

function utilities:setHighScore(score)
    if score > db.highscore then
        print("New highscore")

        db:set("highscore", score)
        db:save()

        return true
    else
        return false
    end
end

function utilities:setPreviousScore(score)
    db:set("previousScore", score)
    db:save()
end




-- -----------------------------------------------------------------------------------
-- Return
-- -----------------------------------------------------------------------------------

return utilities
