CCBNodeExtend = {}

function CCBNodeExtend.newEditBox(_params)
    local pos = ccp(_params.scale9:getPosition())
    local anchor = ccp(_params.scale9:getAnchorPoint().x,_params.scale9:getAnchorPoint().y)

    local editbox = CCEditBox:create(_params.scale9:getPreferredSize(), _params.scale9,nil,nil)

    if editbox then
        -- CCNodeExtend.extend(editbox)
        if _params.listener then editbox:registerScriptEditBoxHandler(_params.listener) end
        print("newEditBox:", _params.scale9:getPosition())
        editbox:setPosition(pos)
        editbox:setFontColor(ccc3(0,0,0))
        editbox:setAnchorPoint(anchor)
    end
    return editbox
end

function CCBNodeExtend.newEditBox2(_text, _callfunc)
    -- 创建输入框
    local editbox = CCScale9Sprite:create("item.png")
    editbox:setAnchorPoint(ccp(1,0.5))
    editbox:setPreferredSize(CCSize(100,50))

    editbox = CCBNodeExtend.newEditBox({
        scale9 = editbox,
        listener = function(event, editbox)
            _callfunc(editbox:getText())
        end,
    })

    local ttf = ui.newTTFLabel({size = 40, text = _text, color = ccc3(255,0,0)})
        :pos(-5,0)
        :addTo(editbox)
    ttf:setAnchorPoint(ccp(1,0))

    return editbox
end


local BoxLayoutScene = class("BoxLayoutScene", function()
    return display.newScene("BoxLayoutScene")
end)

DEBUG_BOX_LAYOUT = true

function BoxLayoutScene:ctor()
    CCFileUtils:sharedFileUtils():addSearchPath("res/../../")

    display.newColorLayer(ccc4(50,50,50,255))
        :addTo(self)

    local size = CCSize(display.cx, display.cy)

    local bg = display.newColorLayer(ccc4(128,128,128,255))
        :pos(display.cx, display.cy)
        :align(display.CENTER)
        :addTo(self)

    bg:setContentSize(size)
    bg:ignoreAnchorPointForPosition(false)

    display.newPolygon({{0, display.cy}, {display.width, display.cy}})
        :addTo(self)

    display.newPolygon({{display.cx, 0}, {display.cx, display.height}})
        :addTo(self)

    local box = require("BoxLayout").new()
        :pos(display.cx, display.cy)
        :addTo(self)

    local size = CCSize(80+20,50+10)
    box:push(display.newScale9Sprite("item.png",nil,nil,size):add(ui.newTTFLabel({text=1,color=ccc3(255,0,0)}):pos(size.width/2, size.height/2)))
    local size = CCSize(80+20,50+30)
    box:push(display.newScale9Sprite("item.png",nil,nil,size):add(ui.newTTFLabel({text=2,color=ccc3(255,0,0)}):pos(size.width/2, size.height/2)))
    local size = CCSize(20+20,50+50)
    box:push(display.newScale9Sprite("item.png",nil,nil,size):add(ui.newTTFLabel({text=3,color=ccc3(255,0,0)}):pos(size.width/2, size.height/2)))


    self.padding = 10
    self.align = display.CENTER
    self.width = 0
    self.direction = kCCScrollViewDirectionHorizontal

    local f = function()
        box:layout(self.direction, {padding = self.padding, align = self.align, h = self.width})
    end

    f()

    local names = {
        CENTER        = display.CENTER,
        LEFT_TOP      = display.LEFT_TOP,
        CENTER_TOP    = display.CENTER_TOP,
        RIGHT_TOP     = display.RIGHT_TOP,
        CENTER_RIGHT  = display.CENTER_RIGHT,
        BOTTOM_RIGHT  = display.BOTTOM_RIGHT,
        BOTTOM_CENTER = display.BOTTOM_CENTER,
        BOTTOM_LEFT   = display.BOTTOM_LEFT,
        CENTER_LEFT   = display.CENTER_LEFT,
    }
    local items = {}
    for k,v in pairs(names) do
        table.insert(items,ui.newTTFLabelMenuItem({size = 20,text=k,listener = handler(self,function()
            self.align = v
            f()
        end)}):align(display.CENTER_LEFT))
    end
    ui.newMenu(items):addTo(self):pos(10, display.cy):alignItemsVerticallyWithPadding(20)

    local names = {
        Horizontal = kCCScrollViewDirectionHorizontal,
        Vertical = kCCScrollViewDirectionVertical,
    }
    local items = {}
    for k,v in pairs(names) do
        table.insert(items,ui.newTTFLabelMenuItem({size = 20,text=k,listener = handler(self,function()
            self.direction = v
            f()
        end)}):align(display.CENTER_LEFT))
    end
    ui.newMenu(items):addTo(self):pos(display.width - 200, display.cy):alignItemsVerticallyWithPadding(20)



    CCBNodeExtend.newEditBox2("padding:",function(_text)
        self.padding = tonumber(_text)
        f()
    end):pos(display.cx-100,100):addTo(self)

    CCBNodeExtend.newEditBox2("width:", function(_text)
        self.width = tonumber(_text)
        f()
    end):pos(display.cx+300,100):addTo(self)

end

return BoxLayoutScene
