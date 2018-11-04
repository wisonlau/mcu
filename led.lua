wifi.sta.sethostname("mcu")
wifi.setmode(wifi.STATION)
station_cfg={}
station_cfg.ssid=""
station_cfg.pwd=""
station_cfg.save=true
wifi.sta.config(station_cfg)
wifi.sta.autoconnect(1)

-- led
function led_control()
    -- 3v,D1
    -- 配置GPIO5为输出模式
    gpio.mode(1, gpio.OUTPUT)
    print(gpio.read(0),"\n")
    -- 可以设置电平,设置成gpio.LOW板子灯亮起
    gpio.write(1, gpio.LOW)
    -- 可以得到pin状态
    print(gpio.read(1),"\n")
    -- 延时微妙
    tmr.delay(1000000)
    -- 设置成gpio.HIGH板子灯熄灭
    gpio.write(1, gpio.HIGH)
    print(gpio.read(1,"\n"))
end

led_control()
