--
-- Author: justbilt
-- Date: 2015-01-24 10:46:28
--

local labelparser = import(".labelparser")

local config = {
	div = import(".items.label_div"),
	img = import(".items.label_img"),
	bmf = import(".items.label_bmf"),
}

local RichLabel = class("RichLabel", function()
	local node = display.newNode()
	node:setAnchorPoint(ccp(0.5,0.5))
	node.old_setAnchorPoint = node.setAnchorPoint
	return node
end)

function RichLabel.createWithText(_text, _dimensions)
	return RichLabel.new():init(_text, _dimensions)
end

function RichLabel.createWithConfig(_config, _dimensions)
	return RichLabel.new():initWithConfig(_config, _dimensions)
end

function RichLabel:init(_text, _dimensions)
	return self:initWithConfig(labelparser.parse(_text), _dimensions)
end

function RichLabel:initWithConfig(_config, _dimensions)
	self:initItems(_config)
	self:layout(_dimensions)
	return self
end

function RichLabel:getItem(_id)
	return self.items[_id]
end

function RichLabel:initItems(_content)
	self.items = {}
	self.content = display.newNode()
		:addTo(self)
	for i,v in ipairs(_content) do
		for ii,vv in ipairs(config[v.labelname]:factory(v)) do
			self.content:addChild(vv)
			table.insert(self.items, vv)
		end
	end
end

function RichLabel:layout(_dimensions)
	if self.dimensions then
		if _dimensions and _dimensions:equals(self.dimensions) then
			return
		end
	else
		self.dimensions = _dimensions or CCSize(2^52, 0)
	end

	local size = nil
	local line_pos = ccp(0,0)
	local line_height = 0
	local line_config = {}
	local content_size = CCSize(0,0)
	for i,item in ipairs(self.items) do
		size = item:getSize()
		if line_pos.x + size.width > self.dimensions.width or item.newline then
			content_size.width = math.max(content_size.width, line_pos.x)
			content_size.height = content_size.height + line_height
			table.insert(line_config,{id = i, height = line_height})
			line_pos.x = 0
			line_height = 0
		end
		line_pos.x = line_pos.x + size.width
		line_height = math.max(line_height, size.height)		
	end
	content_size.width = math.max(content_size.width, line_pos.x)
	table.insert(line_config,{id = 0, height = line_height})
	content_size.height = content_size.height + line_height

	local line_id = 1
	local start_pos = ccp(-content_size.width/2,content_size.height/2)
	local line_pos = ccp(0,line_config[line_id].height)
	for i,item in ipairs(self.items) do
		if i == line_config[line_id].id then
			line_pos.x = 0
			line_id = line_id + 1
			line_pos.y = line_pos.y + line_config[line_id].height
		end
		item:setAnchorPoint(ccp(0,0))
		item:setPosition(start_pos.x + line_pos.x, start_pos.y - line_pos.y)
		size = item:getSize()
		line_pos.x = line_pos.x + size.width
	end

	self.size = content_size
	self:setAnchorPoint(ccp(self:getAnchorPoint()))
end

function RichLabel:getContentSize()
	return self.size
end

function RichLabel:setDimensions(_dimensions)
	self:layout(_dimensions)
end

function RichLabel:setAnchorPoint(_anchor)
	self:old_setAnchorPoint(_anchor)
	if self.content then 
		self.content:setPosition(ccp((-_anchor.x+0.5)*self.size.width, (-_anchor.y+0.5)*self.size.height))
	end

	-- if DEBUG >= 2 then
	-- 	if self.debug then
	-- 		self.debug:removeFromParent()
	-- 	end
	-- 	self.debug = display.newRect(self.size.width, self.size.height, {color = ccc4f(1,0,0,1)})
	-- 		:addTo(self)
	-- 	self.debug:setPosition(self.content:getPosition())
	-- end
end

-----------------------------------------------------------------------------
function RichLabel:HexToRGB(hex,a)
	local r = tonumber(string.sub(hex, 2, 3),16)
	local g = tonumber(string.sub(hex, 4, 5),16)
	local b = tonumber(string.sub(hex, 6, 7),16)

	if a then
		return r, g, b, a
	end

	return r, g, b
end

function RichLabel:StrToChar(str)
    local list = {}
    local len = string.len(str)
    local i = 1 
    while i <= len do
        local c = string.byte(str, i)
        local shift = 1
        if c > 0 and c <= 127 then
            shift = 1
        elseif (c >= 192 and c <= 223) then
            shift = 2
        elseif (c >= 224 and c <= 239) then
            shift = 3
        elseif (c >= 240 and c <= 247) then
            shift = 4
        end
        local char = string.sub(str, i, i+shift-1)
        i = i + shift
        table.insert(list, char)
    end
	return list, len
end

-----------------------------------------------------------------------------

return RichLabel