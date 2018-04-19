const _express = require('express'),
      _request = require('request'),
      _rp = require('request-promise'),
      _fs = require('fs'),
      _app = _express()

const RESOURCE = {
  PORT: process.env.PORT || 3397,
  TOKEN: process.env.ACCESS_TOKEN,
  OPTIONS: JSON.parse(_fs.readFileSync('./options.json'))
}

const verifyRequest = (req, res, next) => {
  let token = req.headers[RESOURCE.OPTIONS['TOKEN-HEADER']]
  if ((RESOURCE.TOKEN && token === RESOURCE.TOKEN) || (token === RESOURCE.OPTIONS['FALLBACK-TOKEN'])) {
    next()
  } else {
    res.status(401).json({
      status: 'ERROR',
      message: `Invalid ${RESOURCE.OPTIONS['TOKEN-HEADER']} header (currently: ${token})`
    })
  }
}

_app.post('*', verifyRequest, (req, res) => {
  let method = req.headers[RESOURCE.OPTIONS['OVERRIDE-HEADER']] || req.method

  _rp({
    url: req.originalUrl,
    baseUrl: RESOURCE.OPTIONS['BASE-URL'],
    method: method,
    json: true,
    body: req.body
  }).then(data => {
    res.status(200).json(data)
  }).catch(err => {
    res.status(401).json({
      status: 'ERROR',
      message: err.message
    })
  })
})

_app.all('*', (req, res) => {
  res.status(200).json({
    status: 'OK',
    message: 'Server is online!'
  })
})

_app.listen(RESOURCE.PORT, () => {
  console.log('Server is now running on port', RESOURCE.PORT)
})
