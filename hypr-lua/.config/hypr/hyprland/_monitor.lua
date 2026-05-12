-- # monitor=name,resolution,position,scale
--
-- # monitor=,preferred,auto,auto
-- monitor=,highrr,0x0,1
-- monitor=HDMI-A-1,2560x1440@74.96Hz,1920x-360,1.25 

hl.monitor({
    output = "eDP-1",
    mode = "highrr",
    position = "0x0",
    scale = 1,
})

hl.monitor({
    output = "HDMI-A-1",
    mode = "2560x1440@74.96Hz",
    position = "1920x-360",
    scale = 1.25,
})
