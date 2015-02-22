

local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    CCFileUtils:sharedFileUtils():addSearchPath("res/../../")
    local VLayout = require("VLayout")
    local HLayout = require("HLayout")

    local v_layout = VLayout.new()
        :pos(display.cx-200,display.cy)
        :addTo(self)

    local h_layout = HLayout.new()
        :pos(display.cx+200,display.cy)
        :addTo(self)

    do
        h_layout:setAnchorPoint(ccp(0.5,0.5))
        h_layout:ignoreAnchorPointForPosition(false)

        h_layout:init()
        h_layout:insert(display.newScale9Sprite("item.png",nil,nil,CCSize(80+20,50+10)):add(ui.newTTFLabel({text=1})),{anchor = ccp(0,0.5)})
        h_layout:insert(display.newScale9Sprite("item.png",nil,nil,CCSize(80+10,50+20)):add(ui.newTTFLabel({text=2})),{padding = {w=30,h=10}})
        h_layout:insert(display.newScale9Sprite("item.png",nil,nil,CCSize(80+0,50+30)):add(ui.newTTFLabel({text=3})),{anchor = ccp(1,0.5)})
        h_layout:insert(display.newScale9Sprite("item.png",nil,nil,CCSize(80+-10,50+40)):add(ui.newTTFLabel({text=4})))
        h_layout:insert(display.newScale9Sprite("item.png",nil,nil,CCSize(80+-20,50+50)):add(ui.newTTFLabel({text=5})))

        h_layout:layout()
        h_layout:gotoBegin(true)

    end

    do
        v_layout:setAnchorPoint(ccp(0.5,0.5))
        v_layout:ignoreAnchorPointForPosition(false)

        v_layout:init()
        v_layout:insert(display.newScale9Sprite("item.png",nil,nil,CCSize(80+20,50+10)):add(ui.newTTFLabel({text=1})),{anchor = ccp(0,0.5)})
        v_layout:insert(display.newScale9Sprite("item.png",nil,nil,CCSize(80+10,50+20)):add(ui.newTTFLabel({text=2})),{padding = {w=30,h=10}})
        v_layout:insert(display.newScale9Sprite("item.png",nil,nil,CCSize(80+0,50+30)):add(ui.newTTFLabel({text=3})),{anchor = ccp(1,0.5)})
        v_layout:insert(display.newScale9Sprite("item.png",nil,nil,CCSize(80+-10,50+40)):add(ui.newTTFLabel({text=4})))
        v_layout:insert(display.newScale9Sprite("item.png",nil,nil,CCSize(80+-20,50+50)):add(ui.newTTFLabel({text=5})))

        v_layout:layout()
        v_layout:gotoBegin(true)
    end


    ui.newMenu({
        ui.newTTFLabelMenuItem({text = "add1", size = 30, listener = function()
            v_layout:insert(display.newScale9Sprite("item.png",nil,nil,CCSize(80+-20,50+50)):add(ui.newTTFLabel({text=v_layout.weight+1})))
            v_layout:layout()
            v_layout:gotoEnd(true)
        end}),

        ui.newTTFLabelMenuItem({text = "add2", size = 30, listener = function()
            h_layout:insert(display.newScale9Sprite("item.png",nil,nil,CCSize(math.random(50,100),50)):add(ui.newTTFLabel({text=h_layout.weight+1})))
            h_layout:layout()
            h_layout:gotoEnd(true)
        end}),
        ui.newTTFLabelMenuItem({text = "resize", size = 30, listener = function()
            v_layout:setViewSize(CCSize(math.random(100,300),math.random(100,300)))
            h_layout:setViewSize(CCSize(math.random(100,300),math.random(100,300)))
            v_layout:gotoEnd(true)
            h_layout:gotoBegin(true)
        end}),     
    })
        :pos(display.cx, 100)
        :addTo(self)
        :alignItemsHorizontallyWithPadding(20)
end

return MainScene
