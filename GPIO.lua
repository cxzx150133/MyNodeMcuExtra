-- GPIO.lua
local GPIO = {}
-- Example: GPIO:Mode(gpio.OUTPUT,1,2,3),set pin 1,2,3 to OUTPUT mode.
function GPIO:Mode(mode,...)
    local args = { ... }
    for k,v in pairs(args) do
        gpio.mode(v,mode)
    end
end
function GPIO:Read(...)
    local args = { ... }
    for k,v in pairs(args) do
        gpio.read(v)
    end
end
-- Example: GPIO:Write(gpio.HIGH,1,2,3),write pin 1,2,3 to HIGH LEVEL.
function GPIO:Write(write,...)
    local args = { ... }
    for k,v in pairs(args) do
        gpio.write(v,write)
    end
end

function GPIO:Example(play_num,time_ms)
    play_num = play_num and nil or 10
    time_ms  = time_ms  and nil or 100
    local time = time_ms * 1000 -- us
    local p = 1
    GPIO:Mode(gpio.OUTPUT,1,2,3)
    for i=1,play_num do
        if p > 3 then p = 1 end
        GPIO:Write(gpio.HIGH,p)
        tmr.delay(time)
        GPIO:Write(gpio.LOW,p)
        tmr.delay(time)
        p = p + 1
    end
    GPIO:Write(gpio.HIGH,1,2,3)
    tmr.delay(time)
    GPIO:Write(gpio.LOW,1,2,3)
end

return GPIO
