--
-- Author: wangbilt<wangbilt@gmail.com>
-- Date: 2015-05-12 14:30:09
--

local BoxLayout = class("BoxLayout", function()
	return CCNode:create()
end)

function BoxLayout:ctor()
	self:setAnchorPoint(ccp(0.5,0.5))
	self.item = {}
	
	if DEBUG_BOX_LAYOUT then
	    self.bg = display.newColorLayer(ccc4(100,100,100,255))
	        :addTo(self,-1)
    end
end

function BoxLayout:push(_item, _padding)
	_padding = _padding or {l=0,t=0,r=0,b=0}
	_item:setAnchorPoint(ccp(0.5, 0.5))
	table.insert(self.item, {item=_item, padding = _padding})
	self:addChild(_item)

	return #(self.item)
end

function BoxLayout:getItem(_id)
	return assert(self.item[_id])
end

function BoxLayout:measure(_direction, _padding)
	local w,h = 0,0
	for i,v in ipairs(self.item) do
		if _direction == kCCScrollViewDirectionVertical then
			w = math.max(w, v.item:getContentSize().width+v.padding.l+v.padding.r) 
			h = h + v.item:getContentSize().height+v.padding.t+v.padding.b
		elseif _direction == kCCScrollViewDirectionHorizontal then
			h = math.max(h, v.item:getContentSize().height+v.padding.t+v.padding.b) 
			w = w + v.item:getContentSize().width+v.padding.l+v.padding.r
		end
	end
	if _direction == kCCScrollViewDirectionVertical then
		h = h + (#(self.item) - 1) * _padding
	elseif _direction == kCCScrollViewDirectionHorizontal then
		w = w + (#(self.item) - 1) * _padding
	end

	return {w=w,h=h}
end

function BoxLayout:layout(_direction, _params)
	_params.padding = _params.padding or 0
	_params.align   = _params.align or display.CENTER
	
	local src_size = self:measure(_direction, _params.padding)

	if _params.w then
		_params.w = math.max(_params.w, src_size.w)
	else
		_params.w = src_size.w
	end

	if _params.h then
		_params.h = math.max(_params.h, src_size.h)
	else
		_params.h = src_size.h
	end

	self:setContentSize(CCSize(_params.w, _params.h))
	
	if DEBUG_BOX_LAYOUT then
	    self.bg:setContentSize(CCSize(_params.w, _params.h))
    end

    if _direction == kCCScrollViewDirectionHorizontal then
    	self:hlayout(_params, src_size.w, display.ANCHOR_POINTS[_params.align])
	elseif _direction == kCCScrollViewDirectionVertical then
    	self:vlayout(_params, src_size.h, display.ANCHOR_POINTS[_params.align])
    end
end

function BoxLayout:hlayout(_params, _w, _anchor)
	local x = _anchor.x*(_params.w - _w)
	local y = 0
	local size = nil
	for i,v in ipairs(self.item) do
		size = v.item:getContentSize()
		y = _anchor.y * _params.h + (1 - v.item:getAnchorPoint().y - _anchor.y) * size.height
		x = x + v.padding.l + size.width/2
		v.item:setPosition(x,y)
		x = x + size.width/2 + v.padding.r + _params.padding
	end
end

function BoxLayout:vlayout(_params, _h, _anchor)
	local x = 0
	local y = _anchor.y * (_params.h - _h)
	local size = nil
	for i,v in ipairs(self.item) do
		size = v.item:getContentSize()
		x = _anchor.x * _params.w + (1 - v.item:getAnchorPoint().x - _anchor.x) * size.width
		y = y + v.padding.t + size.height/2
		v.item:setPosition(x,y)
		y = y + size.height/2 + v.padding.b + _params.padding
	end
end

return BoxLayout