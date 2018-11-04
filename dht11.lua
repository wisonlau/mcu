function task()
    local _,temp11,humi11=dht.read11(4)
    local str = string.format("温度:%.1f 湿度:%.1f", temp11, humi11)
    print(str)
end
tmr.create():alarm(8000, tmr.ALARM_AUTO, task)
