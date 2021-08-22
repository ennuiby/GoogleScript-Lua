local leffil, effil 	= pcall(require, 'effil') assert(leffil, 'Library \'effil\' not found')
local encoding          = require 'encoding'
local lsampev, sampev 	= pcall(require, 'lib.samp.events') assert(lsampev, 'Library \'lib.samp.events\' not found.')

encoding.default            = 'CP1251'
u8 = encoding.UTF8


function ptext(text)
    sampAddChatMessage(('%s | {ffffff}%s'):format(script.this.name, text), 0xA52A2A)
end

function main()
    while not isSampAvailable() do wait(0) end
	wait(-1)
end


function sampev.onServerMessage(color, text)
    if text then
		sendGoogleMessage('chatlog', {text = text})
	end
end

function sendGoogleMessage(method, data)
	local url = ''
	local date = os.date("*t", os.time())
	date = ("%d.%d.%d"):format(date.day, date.month, date.year)
	local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
    local mynick = sampGetPlayerNickname(myid)
	if method then
		url = url..("?method=%s&data=%s&date=%s&nick=%s"):format(method, encodeURI(u8:encode(encodeJson(data))), os.date('%d.%m.%Y'), mynick)
	else return end
	local complete = false
	lua_thread.create(function()
		local dlstatus = require('moonloader').download_status
		local downloadpath = getWorkingDirectory() .. '\\urlRequests.json'
		wait(50)
		downloadUrlToFile('https://script.google.com/macros/s/AKfycbzf7lMvfGy8fm6CPQ/exec'..url, downloadpath, function(id, status, p1, p2) -- remove
		if status == dlstatus.STATUS_ENDDOWNLOADDATA then
			--print("Скачан файл '"..downloadpath.."'")
			complete = true
		end
	end)
	while complete ~= true do wait(50) end
	--print("Обработка ответа...")
	local file = io.open("moonloader/urlRequests.json", "r+")
    if file then
        local cfg = file:read('*a')
        if cfg ~= nil then 
            print("Входящий запрос от Google Script. "..cfg)
        else 
            print("Входящий запрос от Google Script. Содержимое: Неверный формат объекта")
        end
        file:close()
    end
	wait(50)
	--print("Удаляем файл '"..downloadpath.."'")
	os.remove(downloadpath)
	return
	end)
end

function encodeURI(str)
	if (str) then
		str = string.gsub (str, "\n", "\r\n")
		str = string.gsub (str, "([^%w ])",
		function (c) return string.format ("%%%02X", string.byte(c)) end)
		str = string.gsub (str, " ", "+")
        str = string.gsub (str, "%{......%}", "")
	end
	return str
end