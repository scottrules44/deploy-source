--print table
local m = {}

m.run = function (  )
	local obj = display.newRect( display.contentCenterX, display.contentCenterY, 80, 50 )
	obj:setFillColor( 1,0,0 )
	return obj
end
return m