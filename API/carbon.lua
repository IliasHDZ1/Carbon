--[[

			Carbon API By IliasHDZ
		This API is the Framework for all
		MarsOS Applications
]]

local draw = {
	clear = function( color )
		term.setBackgroundColor( color )
		term.clear()
	end,
	setCursor = function( pos )
		term.setCursorPos(pos.x, pos.y)
	end,
	setColor = function( tc, bgc )
		term.setBackgroundColor(bgc)
		term.setTextColor(tc)
	end
}

local function print_error( str )
	term.setTextColor( colors.red )
	term.setBackgroundColor( colors.black )
	error(str)
end

local temp = {}
temp["button"] = {type="button",id=nil,parent=nil,pos={x=0,y=0},w=0,text="",bgc=colors.white,tc=colors.black,click=nil}
temp["label"] = {type="label",id=nil,parent=nil,pos={x=0,y=0},text="",bgc=colors.white,tc=colors.black}
temp["panel"] = {type="panel",id=nil,parent=nil,pos={x=0,y=0},w=0,h=0,bgc=colors.white,contents={}}

main = {pos={x=0,y=0},contents={}}

function new(_type)
	if temp[_type] ~= nil then return temp[_type] else
		print_error("Instance type \"" .. _type .."\" doesn't exist.")
	end
end

function insert( insert, pack )
	if insert == nil or pack == nil then
		print_error("parameter object expected, got nil.")
		return
	end
	insert.id = #pack.contents
	insert.parent = pack
	table.insert(pack.contents, insert)
end

local function renderObj(obj)
	if obj.type == "button" then
		draw.setCursor(obj.pos)
		draw.setColor(obj.tc, obj.bgc)
		term.write(string.rep(" ", obj.w))
		draw.setCursor(obj.pos)
		if #obj.text > obj.w then
			term.write(string.sub(obj.text, 0, obj.w-2) .. "..")
		else term.write(obj.text) end
	elseif obj.type == "label" then
		draw.setCursor(obj.pos)
		draw.setColor(obj.tc, obj.bgc)
		term.write(obj.text)
	elseif obj.type == "panel" then
		paintutils.drawFilledBox(obj.pos.x, obj.pos.y, obj.pos.x+obj.w, obj.pos.y+obj.h, obj.bgc)
	end
end

local function clickObjs( pack, x, y )
	for i,obj in ipairs(pack.contents) do
		if obj.type == "button" then
			if y == obj.pos.y then
				if x >= obj.pos.x and x < obj.pos.x+obj.w then
					if obj.click then obj.click() end
				end
			end
		end
	end
end

local function renderObjs( pack )
	for i,obj in ipairs(pack.contents) do
		local object = obj

		object.x = obj.pos.x + pack.pos.x
		object.y = obj.pos.y + pack.pos.y

		renderObj(obj) 
		if obj.type == "panel" then renderObjs(obj) end
	end
end

local function update( event )
	if event[1] == "mouse_click" then
		clickObjs(main, event[3], event[4])
	end
end

local function render()
	--draw.clear(colors.black)
	renderObjs(main)
end

function caller( event )
	update(event)
	render()
end