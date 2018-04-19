local Http, Util = game:GetService'HttpService', {
  Table = {}, Query = {}, Json = {}
}

Util.__index = Util
function Util.Table:Join(...)
	local metatable = {}

	for _,tab in pairs({...}) do
		if (typeof(tab) == 'table') then
			for key, value in pairs(tab) do
				metatable[key] = value
			end
		end
	end

	return metatable
end

function Util.Query:Stringify(paramTable)
	local queryString = ''

	if (typeof(paramTable) == 'table') then
		local queryTable = {}

		for key, value in pairs(paramTable) do
			queryTable[#queryTable+1] = Http:UrlEncode(key) .. '=' .. Http:UrlEncode(value)
		end

		queryString = table.concat(queryTable, '&')
	end

	return queryString
end

function Util.Json:Parse(JsonString)
	return ({pcall(Http.JSONDecode, Http, JsonString)})[2]
end

function Util.Json:Stringify(Array)
	return ({pcall(Http.JSONEncode, Http, Array)})[2]
end

return Util
