--
-- Author: justbilt
-- Date: 2015-01-24 13:13:13
--


local TestRichLabel = class("TestRichLabel", function()
    return display.newScene("TestAttributeScene")
end)

function TestRichLabel:ctor()
    CCFileUtils:sharedFileUtils():addSearchPath("res/../../")
    
    RichLabel     = require("RichLabel")

    local text = "<div font=DFYuanW7-GBK size=18 color=#ffffff ox=1.5 oy=1.5 oc=#000000 >使己方全体攻击力提高<div><div font=DFYuanW7-GBK size=18 color=#93fe7f ox=1.5 oy=1.5 oc=#000000 >%buff1att0<div><div font=DFYuanW7-GBK size=18 color=#ffffff ox=1.5 oy=1.5 oc=#000000 >，持续<div><div font=DFYuanW7-GBK size=18 color=#ffff00 ox=1.5 oy=1.5 oc=#000000 >%buff1tm<div><div font=DFYuanW7-GBK size=18 color=#ffffff ox=1.5 oy=1.5 oc=#000000 >秒。能量消耗<div><div font=DFYuanW7-GBK size=18 color=#ff5c42 ox=1.5 oy=1.5 oc=#000000 >40下一级：<div><div font=DFYuanW7-GBK size=18 color=#ffffff ox=1.5 oy=1.5 oc=#000000 >使己方全体攻击力提高<div><div font=DFYuanW7-GBK size=18 color=#93fe7f ox=1.5 oy=1.5 oc=#000000 >%buff1att1<div><div font=DFYuanW7-GBK size=18 color=#ffffff ox=1.5 oy=1.5 oc=#000000 >。<div>"
    local text2 = "<img>img.png</img><bmf font='fonts/crit.fnt'>暴击x1</bmf><div size=50 oc=#FF00FF>hello，world</div>"
    local config = {
        [1] = {
            ["content"]   = "img.png",
            ["labelname"] = "img",
        },
        [2] = {
            ["content"]   = "hello，world",
            ["labelname"] = "div",
            ["size"]      = 50,
            ["oc"]      = "#FF00FF"
        },
        [3] = {
            ["color"]     = "#FF00FF",
            ["content"]   = "hello，world",
            ["font"]      = "nihao",
            ["labelname"] = "div",
            ["size"]      = 30
        }       
    }
    
    RichLabel.createWithText(text,CCSize(200,0))
        :pos(display.cx,display.cy)
        :addTo(self)

    local label = RichLabel.createWithConfig(config,CCSize(200,0))
        :pos(0,display.cy)
        :align(display.LEFT_CENTER)
        :addTo(self)

    label:setDimensions(CCSize(300,0))


    RichLabel.createWithText(text2, CCSize(99999,0))
        :align(display.LEFT_TOP)
        :pos(0,display.height)
        :addTo(self)

    RichLabel.createWithText(text2, CCSize(99999,0))
        :align(display.LEFT_BOTTOM)
        :pos(0,0)
        :addTo(self)

    RichLabel.createWithText(text2, CCSize(99999,0))
        :align(display.RIGHT_BOTTOM)
        :pos(display.width,0)
        :addTo(self)

    RichLabel.createWithText(text2, CCSize(99999,0))
        :align(display.RIGHT_TOP)
        :pos(display.width,display.height)
        :addTo(self)
end

return TestRichLabel