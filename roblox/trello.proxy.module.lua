local Http, Options, Trello = game:GetService'HttpService', require(script['options.module']), {}
Trello.Util = require(script['util.module'])

Trello.__index = Trello
function Trello.new(key, token)
  local self = setmetatable({}, Trello)
  self.__key, self.__token = key, token
  return self
end

function Trello:RequestAsync(Method, Path, QueryString)
  local RequestUrl = ('%s%s?%s'):format(Options.BaseUrl, Path, QueryString)
  return ({pcall(Http.PostAsync, Http, RequestUrl, '', Enum.HttpContentType.ApplicationJson, false, {
	[Options.Headers.Method] = Method,
	[Options.Headers.Token] = Options.Token
  })})[2]
end

function Trello:RequestJsonWithParamTableAsync(Method, Route, ParamTable)
  local QueryString = Trello.Util.Query:Stringify(Trello.Util.Table:Join(ParamTable, {
      key = self.__key, token = self.__token
  }))

  return Trello.Util.Json:Parse(self:RequestAsync(Method, Route, QueryString))
end

function Trello:GetAsync(Route, ParamTable)
  return self:RequestJsonWithParamTableAsync('GET', Route, ParamTable)
end

function Trello:PostAsync(Route, ParamTable)
  return self:RequestJsonWithParamTableAsync('POST', Route, ParamTable)
end

function Trello:PutAsync(Route, ParamTable)
  return self:RequestJsonWithParamTableAsync('PUT', Route, ParamTable)
end

function Trello:DeleteAsync(Route, ParamTable)
  return self:RequestJsonWithParamTableAsync('DELETE', Route, ParamTable)
end

return Trello
