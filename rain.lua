connect_state = true

-- wifi
wifi.setmode(wifi.STATION)
wifi.sta.sethostname("WLW")
station_cfg={}
station_cfg.ssid=""
station_cfg.pwd=""
wifi.sta.config(station_cfg)
wifi.sta.autoconnect(1)

-- m = mqtt.Client("Node-Rain", 60, "mqtt用户名", "mqtt密码")

tmr.alarm(0, 1000, 1, function()
    if wifi.sta.getip() == nil then
        print("Wifi Connecting...")
    else
        -- init_mqtt()
        tmr.stop(0)
        print("Wifi Connected, IP is "..wifi.sta.getip())
    end
end)

-- mqtt
function init_mqtt()
    m:connect("mqtt服务地址",1883,0, 
               function(client)
                   print("connect success")   
                   connect_state = true
                   m:publish("RainAvailability","online",0,1)   
               end,
               function(client, reason)
                   print("connect failed: "..reason)
                   node.restart()
               end)
end

-- 雨水感应
tmr.alarm(1, 900000, 1, function()
    -- A0接A0
    if connect_state == true then
        --  此处可根据雨量进行判断，在传感器干燥的情况下，电压比较器将输出值限定在了1024
        --  当有水分滴入时，输出值会降低
        if adc.read(0) == 1024 then --  也可以使用GPIO:gpio.read(0) DO接GPIO 18
            print("{\"rainfall\": \"No Rain\"}",adc.read(0))
            -- m:publish("Rain", "{\"rainfall\": \"No Rain\"}", 0, 0)
        elseif adc.read(0) < 800 and adc.read(0) > 600 then
            print("{\"rainfall\": \"Small Rain\"}",adc.read(0))
            -- m:publish("Rain", "{\"rainfall\": \"Small Rain\"}", 0, 0)
        else
            print("{\"rainfall\": \"Big Rain\"}",adc.read(0))
            -- m:publish("Rain", "{\"rainfall\": \"Big Rain\"}", 0, 0)
        end
    end
end)

-- tmr.alarm(2, 5000, 1, function()
--     if connect_state == true then
--         m:publish("RainAvailability","online",2,0)
--     end
-- end)

-- m:on("offline", function(client)
--     init_mqtt()
-- end)

-- m:lwt("RainAvailability", "offline", 0, 0)
