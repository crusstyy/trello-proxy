# Trello Proxy for Roblox
Currently, Roblox's `HttpService` only allows for `GET` and `POST` HTTP request methods. This makes accessing other HTTP methods, such as `PUT`, `DELETE`, `HEAD`, etc. impossible without the use of a proxy. Trello Proxy for Roblox enables these HTTP methods, allowing full access to the Trello API.

## Getting Started
To get started setting up your own proxy, simple create an account at [Heroku](https://heroku.com), and click the button below to setup a new application, and deploy this repository to it.

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

You will also require your access token, which you can grab from your app's config vars. This is a randomly-generated token, which can be found under your app's `Settings > Reveal Config Vars > ACCESS_TOKEN`. This prevents unauthorised requests to your server.

> Note that if you change your ACCESS_TOKEN, you will need to update it in any scripts that make requests to your proxy server.

## Proxying Requests
Now that your server is up and running, you can start proxying requests. All proxy requests must be made using the `POST` method. Any `GET` requests will simply return a `HTTP/200` status code, and a `JSON` file confirming that the server is operational.

To make a request to Trello's API, simply substitute `api.trello.com` with `yourapp.herokuapp.com`. You will then need to set the `X-Auth-Token` header to your `ACCESS_TOKEN` and `X-HTTP-Method-Override` header to the method which you intend to request.

### Example
`POST` `https://yourapp.herokuapp.com/1/members/me/boards?key=your-trello-key&token=your-trello-token`
```
Headers {
  "X-Auth-Token": "ACCESS_TOKEN",
  "X-HTTP-Method-Override": "GET"
}
```

This is a direct substitute for `GET` `https://api.trello.com/1/members/me/boards?key=your-trello-key&token=your-trello-token`.

> See the [official Trello API documentation](https://developers.trello.com/v1.0/reference) for a full list of available methods.

## Roblox
The [ModuleScript provided](roblox) in the [`/roblox`](roblox) directory enables easy access to your server. It provides shorthand functions for `DELETE`, `GET`, `POST` and `PUT` via the `DeleteAsync`, `GetAsync`, `PostAsync` and `PutAsync` methods.

> The `options.module` and `util.module` modules should both be parented to the core `trello.proxy.module` module when inserting these to your game.

> Note that the `.lua` file extension is omitted from the file name.

Ensure you set your application's URL and access token in the [`options.module`](roblox/trello.proxy.module/options.module.lua) module.

```lua
{
  BaseUrl = 'https://yourapp.herokuapp.com',
  Token = 'YOUR_ACCESS_TOKEN',
  ...
}
```

### Example Usage
The following code excerpt will return a table containing the `id` and `name` of all open boards for the authenticated user:

```lua
local TrelloAPI = require(script.Parent['trello.proxy.module'])
local Trello = TrelloAPI.new('trello-api-key', 'trello-auth-token')

function GetMyOpenBoards()
  local Boards = Trello:GetAsync('/1/members/me/boards', {
    fields = 'id,name',
    filter = 'open'
  })

  return Boards
end
```

> You can retrieve your Trello app token directly from [this page](https://trello.com/app-key). You can also generate an auth token from here.

-----
`</>` with `<3` by [ClockworkSquirrel](https://roblox.com/users/3659905/profile)
