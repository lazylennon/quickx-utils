

local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    CCFileUtils:sharedFileUtils():addSearchPath("res/../../")
    local AutoLayout = require("AutoLayout")

    local h_layout = AutoLayout.new()
        :pos(display.cx+200,display.cy)
        :addTo(self)
    do
        h_layout:setDirection(kCCScrollViewDirectionHorizontal)
        h_layout:setAnchorPoint(ccp(0.5,0.5))
        h_layout:ignoreAnchorPointForPosition(false)

        local h = AutoLayout:newLayout()
        h:push(display.newScale9Sprite("item.png",nil,nil,CCSize(40,40)):add(ui.newTTFLabel({text=1})),{padding={w=30,h=2}})
        h:push(display.newScale9Sprite("item.png",nil,nil,CCSize(40,40)):add(ui.newTTFLabel({text=2})),{padding={w=30,h=2}})
        h:push(display.newScale9Sprite("item.png",nil,nil,CCSize(40,40)):add(ui.newTTFLabel({text=3})),{padding={w=30,h=2}})
        h_layout:pushLayout(h, kCCScrollViewDirectionVertical)

        h_layout:push(display.newScale9Sprite("item.png",nil,nil,CCSize(80+20,50+10)):add(ui.newTTFLabel({text=1})),{anchor = ccp(0,0.5)})
        h_layout:push(display.newScale9Sprite("item.png",nil,nil,CCSize(80+10,50+20)):add(ui.newTTFLabel({text=2})),{padding = {w=30,h=10}})
        h_layout:push(display.newScale9Sprite("item.png",nil,nil,CCSize(80+0,50+30)):add(ui.newTTFLabel({text=3})),{anchor = ccp(1,0.5)})
        h_layout:push(display.newScale9Sprite("item.png",nil,nil,CCSize(80+-10,50+40)):add(ui.newTTFLabel({text=4})))
        h_layout:push(display.newScale9Sprite("item.png",nil,nil,CCSize(80+-20,50+50)):add(ui.newTTFLabel({text=5})))

        h_layout:layout(false,true)
    end

    local v_layout = AutoLayout.new()
        :pos(display.cx-200,display.cy)
        :addTo(self)
    do
        v_layout:setDirection(kCCScrollViewDirectionVertical)
        v_layout:setAnchorPoint(ccp(0.5,0.5))
        v_layout:ignoreAnchorPointForPosition(false)

        v_layout:push(display.newScale9Sprite("item.png",nil,nil,CCSize(80+20,50+10)):add(ui.newTTFLabel({text=1})),{anchor = ccp(0,0.5)})
        v_layout:push(display.newScale9Sprite("item.png",nil,nil,CCSize(80+10,50+20)):add(ui.newTTFLabel({text=2})),{padding = {w=30,h=10}})
        v_layout:push(display.newScale9Sprite("item.png",nil,nil,CCSize(80+0,50+30)):add(ui.newTTFLabel({text=3})),{anchor = ccp(1,0.5)})
        v_layout:push(display.newScale9Sprite("item.png",nil,nil,CCSize(80+-10,50+40)):add(ui.newTTFLabel({text=4})))
        v_layout:push(display.newScale9Sprite("item.png",nil,nil,CCSize(80+-20,50+50)):add(ui.newTTFLabel({text=5})))

        local h = AutoLayout:newLayout()
        h:push(display.newScale9Sprite("item.png",nil,nil,CCSize(40,40)):add(ui.newTTFLabel({text=1})),{padding={w=30,h=2}})
        h:push(display.newScale9Sprite("item.png",nil,nil,CCSize(40,40)):add(ui.newTTFLabel({text=2})),{padding={w=30,h=2}})
        h:push(display.newScale9Sprite("item.png",nil,nil,CCSize(40,40)):add(ui.newTTFLabel({text=3})),{padding={w=30,h=2}})
        v_layout:pushLayout(h, kCCScrollViewDirectionHorizontal)
        
        local h = AutoLayout:newLayout()
        h:push(display.newScale9Sprite("item.png",nil,nil,CCSize(40,40)):add(ui.newTTFLabel({text=1})),{padding={w=30,h=2}})
        h:push(display.newScale9Sprite("item.png",nil,nil,CCSize(40,40)):add(ui.newTTFLabel({text=2})),{padding={w=30,h=2}})
        h:push(display.newScale9Sprite("item.png",nil,nil,CCSize(40,40)):add(ui.newTTFLabel({text=3})),{padding={w=30,h=2}})
        v_layout:pushLayout(h, kCCScrollViewDirectionHorizontal)


        v_layout:push(display.newScale9Sprite("item.png",nil,nil,CCSize(40,40)):add(ui.newTTFLabel({text=9})))

        v_layout:layout(false, true)
    end


    ui.newMenu({
        ui.newTTFLabelMenuItem({text = "add1", size = 30, listener = function()
            v_layout:push(display.newScale9Sprite("item.png",nil,nil,CCSize(80+-20,50+50)):add(ui.newTTFLabel({text=v_layout.index+1})))
            v_layout:layout(true,true)
        end}),

        ui.newTTFLabelMenuItem({text = "add2", size = 30, listener = function()
            h_layout:push(display.newScale9Sprite("item.png",nil,nil,CCSize(math.random(50,100),50)):add(ui.newTTFLabel({text=h_layout.index+1})))
            h_layout:layout(true,true)
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
