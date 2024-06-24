local utf8 = require("utf8")

-- Default configuration
fontSize = 18
margin = 50
maxWidth = 700
scrollSensitivity = 100
scrollVelocity = 5

-- Internal editor state
yPos = 0
yVel = 0

function love.load(args)
    -- Load file from args
    if args[1] then
        filename = args[1]
    else
        print("Please supply a filename as the first argument.")
        os.exit()
    end
    text = love.filesystem.read(filename)

    -- Window setup
    love.window.setTitle(filename  .. " - TypeWriter")
    love.window.setMode(600, 700, {resizable=true, vsync=0, minwidth=400, minheight=300})
    love.graphics.setColor(0, 0, 0)
    love.graphics.setBackgroundColor(255, 255, 255)
    love.graphics.setNewFont(fontSize)

    -- Keybaord setup
    love.keyboard.setKeyRepeat(true)
end

function love.textinput(t)
    -- Ignore keypress if ctrl is held
    if love.keyboard.isDown("lctrl", "rctrl") then
        return
    end

    -- Append keypress to buffer
    text = text .. t
end

function love.keypressed(key)
    -- Quit the program
    if key == "escape" then
        love.event.quit()

    -- Toggle fullscreen
    elseif key == "f11" then
        love.window.setFullscreen(not love.window.getFullscreen())

    -- Zoom
    elseif (key == "=" or key == "+") and love.keyboard.isDown("lctrl", "rctrl") then
        fontSize = fontSize + 2
        love.graphics.setNewFont(fontSize)
    elseif key == "-" and love.keyboard.isDown("lctrl", "rctrl") then
        fontSize = fontSize - 2
        love.graphics.setNewFont(fontSize)

    -- Delete the previous character
    elseif key == "backspace" then
        -- get the byte offset to the last UTF-8 character in the string.
        local byteoffset = utf8.offset(text, -1)

        if byteoffset then
            -- remove the last UTF-8 character.
            -- string.sub operates on bytes rather than UTF-8 characters,
            -- so we couldn't do string.sub(text, 1, -2).
            text = string.sub(text, 1, byteoffset - 1)
        end

    -- Newline
    elseif key == "return" then
        text = text .. "\n"

    end
end

function love.wheelmoved(dx, dy)
    -- If ctrl held, zoom
    if love.keyboard.isDown("lctrl", "rctrl") then
        fontSize = fontSize - dy
        love.graphics.setNewFont(fontSize)
        return
    end

    -- Update smooth scrolling velocity
    yVel = yVel + dy * scrollSensitivity
end

function love.update(dt)
    -- Gradually reduce velocity to create a smooth scrolling effect.
    yPos = math.min(0, yPos + yVel * dt)
    yVel = yVel - yVel * math.min(dt * scrollVelocity, 1)
end

function love.draw()
    -- Draw the text body
    width = love.graphics.getWidth()
    sideMargin = math.max(margin, (width - maxWidth) / 2)
    love.graphics.printf(text, sideMargin, margin + yPos, width - sideMargin * 2)
end

function love.quit()
    -- Save the file and close the window
    love.filesystem.write(filename, text)
    love.event.quit()
end

-- Load user config
love.filesystem.load("config.lua")()

