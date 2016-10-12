var exec = require('cordova/exec')

function noop () {}

module.exports = {
  createContact: function (data, callback) {
    callback = callback || noop

    cordova.exec(successCallback, errorCallback, 'ContactModal', 'openCreateContact', [data])

    function successCallback (data) {
      callback(null, data)
    }

    function errorCallback (error) {
      callback(error)
    }
  }
}
