--
-- Author: justbilt
-- Date: 2015-01-24 17:13:02
--

local label_bmf = class("label_bmf", function(_params)
	return ui.newBMFontLabel(_params)
end)

function label_bmf:getSize()
	return self:getContentSize()
end

function label_bmf:factory(_params)
	-- 字体颜色
	if type(_params.color) == "string" then
		_params.color = ccc3(RichLabel:HexToRGB(_params.color))
	end

	local items = {}
	local label = nil
	for i,v in ipairs(RichLabel:StrToChar(_params.content)) do
		if v == "\n" then
			_params.text = ""
			label = label_bmf.new(_params)
			label.newline = true
		else
			_params.text = v
			label = label_bmf.new(_params)
		end
		table.insert(items,label_bmf.new(_params))
	end
	_params.text = nil
	return items
end


return label_bmf