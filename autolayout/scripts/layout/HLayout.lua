--
-- Author: justbilt
-- Date: 2015-02-14 00:35:57
--


local HLayout = class("HLayout", require("layout.BaseLayout"))

function HLayout:init(_container, _padding)
	HLayout.super.init(self, _container, _padding)
	self:setDirection(kCCScrollViewDirectionHorizontal)
end

function HLayout:gotoBegin(_ani)
	self:setContentOffset(ccp(0,0),_ani)
end

function HLayout:gotoEnd(_ani)
	self:setContentOffset(ccp(- self:getContentSize().width + self:getViewSize().width ,0),_ani)
end

function HLayout:layout()
	-- 求最大宽高
	local w,h = self:measure().w, self:getViewSize().height
	self:setContentSize(CCSize(w,h))
	self.bk:setContentSize(CCSize(w,h))

	-- 布局
	local config = nil
	local anchor = nil
	local x,y = 0,0
	local count = #self.items
	for i,v in ipairs(self.items) do
		config = v.config
		if i == 1 then
			anchor = ccp(0, config.anchor.y)
		else
			anchor = ccp(0.5, config.anchor.y)
		end

		x = x + config.size.w * v:getAnchorPoint().x
		y = config.size.h * (v:getAnchorPoint().y - anchor.y) + anchor.y * h

		v:setPosition(x,y)

		x = x + config.size.w * (1 - v:getAnchorPoint().x)

		config.size = nil
	end
end


return HLayout