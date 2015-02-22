--
-- Author: justbilt
-- Date: 2015-01-24 10:42:37
--


local label_img = class("label_img", function(_params)
	return display.newSprite(_params.content)
end)

function label_img:ctor(_params)
end

function label_img:getSize()
	local size = self:getContentSize()
	return CCSize(size.width*self:getScaleX(), size.height*self:getScaleY())
end

function label_img:factory(_params)
	local items = {}
	table.insert(items,label_img.new(_params))
	return items
end

return label_img