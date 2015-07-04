--
-- Author: justbilt
-- Date: 2015-02-14 00:35:57
--


local Layout = class("Layout", function(...)
	local node = display.newNode()
	node:setAnchorPoint(ccp(0.5,0.5))
	return node
end)

function Layout:ctor()
	self.layout_config         = {}
	self.items          = {}
	self.layout_config.padding = {w=0,h=0}
	self.layout_config.anchor  = ccp(0.5,0.5)
end

function Layout:setPadding(_padding)
	self.padding = _padding
end

function Layout:push(_node, _config)
	local config = {}

	_config        = _config or {}
	config.padding = _config.padding or {w=0,h=0}
	config.anchor  = _config.anchor or ccp(0.5,0.5)
	_node.layout_config   = config

	if AUTOLAYOUT_DEBUG_ENABLE then
		display.newColorLayer(ccc4(128,128,0,255))
			:addTo(_node, -1)
			:size(_node:getContentSize().width, _node:getContentSize().height)
	end

	self:addChild(_node)
	table.insert(self.items, _node)
end

function Layout:vlayout(_items, _padding, _width)
	local info = self:measure(_items, _padding)
	-- 求最大宽高
	local w,h = _width or info.maxw , info.h

	-- 布局
	local config = nil
	local anchor = nil
	local x,y = 0,h
	for i,v in ipairs(_items) do
		config = v.layout_config
		anchor = config.anchor.x

		x = config.size.w * (v:getAnchorPoint().x - anchor) + anchor * w
		y = y - config.size.h * (1-v:getAnchorPoint().y)

		v:setPosition(x,y)

		y = y - config.size.h * v:getAnchorPoint().y

		config.size = nil
	end

	return info
end

function Layout:hlayout(_items, _padding, _height)
	local info = self:measure(_items, _padding)
	-- 求最大宽高
	local w,h = info.w, _height or info.maxh

	-- 布局
	local config = nil
	local anchor = nil
	local x,y = 0,0
	for i,v in ipairs(_items) do
		config = v.layout_config
		anchor = config.anchor.y

		x = x + config.size.w * v:getAnchorPoint().x
		y = config.size.h * (v:getAnchorPoint().y - anchor) + anchor * h

		v:setPosition(x,y)

		x = x + config.size.w * (1 - v:getAnchorPoint().x)

		config.size = nil
	end

	return info
end

-- 求每个元素的布局宽高	
function Layout:measure(_items, _padding)
	_padding = _padding or {w=0,h=0}
	local w,h,maxw,maxh = 0,0,0,0
	local config = nil
	local size = nil

	for i,v in ipairs(_items) do
		config = v.layout_config
		assert(config.size==nil, "Aleady call!")
		config.size = {
			w = v:getContentSize().width + config.padding.w + _padding.w,
			h = v:getContentSize().height + config.padding.h + _padding.h,
		}
		size = v.layout_config.size
		w = w + size.w
		h = h + size.h
		maxw = math.max(maxw, size.w)
		maxh = math.max(maxh, size.h)
	end

	return {w=w,h=h,maxw=maxw,maxh=maxh}
end

function Layout:hhlayout()
	local info = self:hlayout(self.items, self.padding)
	self:setContentSize(CCSize(info.w, info.maxh))
end

function Layout:vvlayout()
	local info = self:vlayout(self.items, self.padding)
	self:setContentSize(CCSize(info.maxw, info.h))
end


return Layout