--
-- Author: justbilt
-- Date: 2015-02-14 00:35:57
--


local VLayout = class("VLayout", require("layout.BaseLayout"))

function VLayout:init(_container, _padding)
	VLayout.super.init(self, _container, _padding)
	self:setDirection(kCCScrollViewDirectionVertical)
end

function VLayout:layout()
	-- 求最大宽高
	local w,h = self:getViewSize().width, self:measure().h
	self:setContentSize(CCSize(w,h))
	self.bk:setContentSize(CCSize(w,h))

	-- 布局
	local config = nil
	local anchor = nil
	local x,y = 0,h
	local count = #self.items
	for i,v in ipairs(self.items) do
		config = v.config
		if i == 1 then
			anchor = ccp(config.anchor.x,0)
		else
			anchor = ccp(config.anchor.x,0.5)
		end

		x = config.size.w * (v:getAnchorPoint().x - anchor.x) + anchor.x * w
		y = y - config.size.h * v:getAnchorPoint().y

		v:setPosition(x,y)

		y = y - config.size.h * (1 - v:getAnchorPoint().y)

		config.size = nil
	end
end


return VLayout