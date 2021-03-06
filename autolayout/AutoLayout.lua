--
-- Author: justbilt
-- Date: 2015-02-25 14:41:30
--


local Layout    = import(".Layout")
local BoxLayout = import(".BoxLayout")

local AutoLayout = class("AutoLayout", function(...)
	local node = CCScrollView:create(...)
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
	self.index = 0
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
	self.index = self.index + 1

	if _direction == kCCScrollViewDirectionVertical then
		_layout:vvlayout()
	else
		_layout:hhlayout()
	end
	self.layouts[self.index] = _layout
	self:getContainer():addChild(_layout)

	return self
end

function AutoLayout:push(_item, _config)
	local layout = self:newLayout()
	layout:push(_item, _config)
	self:pushLayout(layout, self:getDirection())
	return layout
end

function AutoLayout:pop()
	self:remove(self.index)
end

function AutoLayout:remove(_id)
	if self.index <= 0 then
		return
	end
	local layout = self.layouts[_id]
	table.remove(self.layouts, _id)
	self:getContainer():removeChild(layout)	

	self.index = self.index - 1
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


function AutoLayout:pushGrid(_item_list, _stripe, _direction, _params, _padding)
	_params = _params or {}
	
	local box = nil
	local len = #(_item_list)
	local size = nil
	for i,v in ipairs(_item_list) do
		if not box then
			box = BoxLayout.new()
		end
		box:push(v, _padding)
		if i%_stripe == 0 or i == len then
			if _direction == kCCScrollViewDirectionHorizontal and not _params.w then
				_params.w = box:measure(_direction, _params.padding or 0).w
			elseif _direction == kCCScrollViewDirectionVertical and not _params.h then
				_params.h = box:measure(_direction, _params.padding or 0).h				
			end
			box:layout(_direction, _params)
			self:push(box)
			box = nil
		end
	end
end

function AutoLayout:layout(_movetoend, _ani)
	local length = 0
	local offset = 0

	if self:getDirection() == kCCScrollViewDirectionVertical then
		length = self:getContentSize().height
		offset = self:getContentOffset().y
		local info = Layout:vlayout(self.layouts, nil, self:getViewSize().width)
		self:setContentSize(CCSize(math.max(self:getViewSize().width, info.maxw), info.h))
	else
		-- length = self:getContentSize().width
		-- offset = self:getContentOffset().x
		local info = Layout:hlayout(self.layouts, nil, self:getViewSize().height)
		self:setContentSize(CCSize(info.w, math.max(self:getViewSize().height, info.maxh)))
	end

	if _movetoend == true then
		self:gotoEnd(_ani)
	elseif _movetoend == false then
		self:gotoBegin(_ani)
	else
		if not self.layouted then
			self:gotoBegin(_ani)
		else
			if self:getDirection() == kCCScrollViewDirectionVertical then
				self:setContentOffset(ccp(0, -(self:getContentSize().height-length)+offset),_ani)
			else
				-- self:setContentOffset(ccp((self:getContentSize().width-length)+offset, 0),_ani)
			end	
		end
	end

	if self.sizeSuitEnbale then
		if self:getDirection() == kCCScrollViewDirectionVertical then
			self:setTouchEnabled(self:getContentSize().height>self:getViewSize().height)
		else
			self:setTouchEnabled(self:getContentSize().width>self:getViewSize().width)
		end
	end

	self.layouted = true
end


return AutoLayout