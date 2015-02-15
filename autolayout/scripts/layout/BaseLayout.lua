--
-- Author: justbilt
-- Date: 2015-02-14 00:35:57
--


local BaseLayout = class("BaseLayout", function(...)
	local node = CCNodeExtend.extend(CCScrollView:create(...))
	node.old_setViewSize = node.setViewSize
	return node
end)

function BaseLayout:init(_container, _padding)
	self.container = _container or display.newNode()
	self.items     = {}
	self.weight    = 0
	self.padding   = _padding or {w=2,h=2}

	self:setContainer(self.container)

	self.bk = display.newColorLayer(ccc4(128,128,128,255))
		:addTo(self,-1)
end

function BaseLayout:insert(_node, _config)
	local config = {}

	_config        = _config or {}
	config.padding = _config.padding or {w=0,h=0}
	config.weight  = _config.weight or self.weight
	config.anchor  = _config.anchor or ccp(0.5,0.5)
	_node.config   = config

	table.insert(self.items, _node)
	self.container:addChild(_node)

	self.weight = self.weight + 1
end

function BaseLayout:setViewSize(_size)
	self:old_setViewSize(_size)
	self:layout()
end

function BaseLayout:gotoBegin(_ani)
	self:setContentOffset(ccp(0, - self:getContentSize().height + self:getViewSize().height),_ani)
end

function BaseLayout:gotoEnd(_ani)
	self:setContentOffset(ccp(0,0),_ani)
end

function BaseLayout:measure()
	-- 按照权重排序
	table.sort(self.items, function(v1,v2) return v1.config.weight < v2.config.weight end)

	-- 求最大宽高
	local config = nil
	local w,h = 0,0
	for i,v in ipairs(self.items) do
		config = v.config
		config.size = {
			w = v:getContentSize().width + config.padding.w + self.padding.w,
			h = v:getContentSize().height + config.padding.h + self.padding.h,
		}
		w = w + config.size.w
		h = h + config.size.h
	end

	return {w=w,h=h}
end

function BaseLayout:layout()
	assert(false, "You should overwrite this function !")
end


return BaseLayout