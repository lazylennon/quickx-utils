--
-- Author: justbilt
-- Date: 2015-02-25 14:41:30
--


local Layout = import(".Layout")

local AutoLayout = class("AutoLayout", function(...)
	local node = CCNodeExtend.extend(CCScrollView:create(...))
	node.old_setViewSize = node.setViewSize
	node.old_setContainer = node.setContainer
	return node
end)

function AutoLayout:ctor()
	self:init()
end

function AutoLayout:init()
	if AUTOLAYOUT_DEBUG_ENABLE then
		self.debug = display.newColorLayer(ccc4(128,0,0,255))
			:addTo(self, -1)
			:size(display.width*3,display.height*3)
	end
	
	self.layouts = {}
	self.index = 1
end

function AutoLayout:setSizeSuitEnable(_enbale)
	self.sizeSuitEnbale = _enbale
end

function AutoLayout:clear()
	self:getContainer():removeAllChildren()
	self:init()
end

function AutoLayout:newLayout()
	return Layout.new()
end

function AutoLayout:pushLayout(_layout, _direction)
	assert(_direction)
	if _direction == kCCScrollViewDirectionVertical then
		_layout:vvlayout()
	else
		_layout:hhlayout()
	end
	self.layouts[self.index] = _layout
	self:getContainer():addChild(_layout)
	self.index = self.index + 1

	return self
end

function AutoLayout:push(_item, _config)
	local layout = self:newLayout()
	layout:push(_item, _config)
	self:pushLayout(layout, self:getDirection())
	return layout
end

function AutoLayout:setContainer(_container)
	assert(false,"You should not call this function!")
end

function AutoLayout:setViewSize(_size, ...)
	self:old_setViewSize(_size)

	if #self.layouts <= 0 then
		return
	end

	self:layout(...)
end

function AutoLayout:gotoBegin(_ani)
	if self:getDirection() == kCCScrollViewDirectionVertical then
		self:setContentOffset(ccp(0, - self:getContentSize().height + self:getViewSize().height),_ani)
	else
		self:setContentOffset(ccp(0,0),_ani)
	end	
end

function AutoLayout:gotoEnd(_ani)
	if self:getDirection() == kCCScrollViewDirectionVertical then
		self:setContentOffset(ccp(0,math.max(0,- self:getContentSize().height + self:getViewSize().height)),_ani)
	else
		self:setContentOffset(ccp(math.min(0,- self:getContentSize().width + self:getViewSize().width) ,0),_ani)
	end
end

function AutoLayout:layout(_movetoend, _ani)
	if self:getDirection() == kCCScrollViewDirectionVertical then
		local info = Layout:vlayout(self.layouts, nil, self:getViewSize().width)
		self:setContentSize(CCSize(math.max(self:getViewSize().width, info.maxw), info.h))
	else
		local info = Layout:hlayout(self.layouts, nil, self:getViewSize().height)
		self:setContentSize(CCSize(info.w, math.max(self:getViewSize().height, info.maxh)))
	end

	if _movetoend == true then
		self:gotoEnd(_ani)
	elseif _movetoend == false then
		self:gotoBegin(_ani)
	end

	if self.sizeSuitEnbale then
		if self:getDirection() == kCCScrollViewDirectionVertical then
			self:setTouchEnabled(self:getContentSize().height>self:getViewSize().height)
		else
			self:setTouchEnabled(self:getContentSize().width>self:getViewSize().width)
		end
	end
end


return AutoLayout