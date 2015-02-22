--
-- Author: justbilt
-- Date: 2015-01-24 10:35:20
--

local label_div = class("label_div", function(_params)
	local label = ui.newTTFLabel(_params)
	
	if _params.oc and FontCreator then
    	FontCreator.createOutline(label, _params.ox, _params.oy, _params.oc, _params.oo)
	end

	return label
end)

function label_div:getSize()
	return self:getContentSize()
end

function label_div:factory(_params)
	-- 字体颜色
	if type(_params.color) == "string" then
		_params.color = ccc3(RichLabel:HexToRGB(_params.color))
	end
	-- 描边颜色
	if type(_params.oc) == "string" then
		_params.oc = ccc3(RichLabel:HexToRGB(_params.oc))
	end
	if _params.oc then
		_params.ox = _params.ox or 1
		_params.oy = _params.oy or 1
		_params.oo = _params.oo or 255		
	end

	local items = {}
	local label = nil
	for i,v in ipairs(RichLabel:StrToChar(_params.content)) do
		if v == "\n" then
			_params.text = ""
			label = label_div.new(_params)
			label.newline = true
		else
			_params.text = v
			label = label_div.new(_params)
		end
		table.insert(items,label)
	end
	_params.text = nil
	return items
end


return label_div