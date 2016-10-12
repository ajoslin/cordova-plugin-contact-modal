# cordova-plugin-contact-modal

> Open the phone's "create contact" modal with some pre-filled values


## Install

```
$ cordova plugin add https://github.com/ajoslin/cordova-plugin-contact-modal --save
```

## Usage

```js
// The plugin expects a contact in the format provided by vcards-js module
var VCard = require('vcards-js')

var vcard = VCard()

document.addEventListener('deviceready', function () {
  var contactModal = window.cordova.plugins.contactModal
  contactModal.createContact(vcard, onComplete)
})

function onComplete () {
  // Will be called once the modal is successfully closed.
}
```

## API

#### `window.cordova.plugins.contactModal.createContact(vcard, [callback])`

##### vcard

*Required*
Type: `object`

Matches the format of a [vcards-js](https://github.com/enesser/vCards-js) object.

Only the following subset of vcard properties are supported. Pull requests are welcome for more properties!

- `firstName`
- `lastName`
- `workPhone`
- `cellPhone`
- `workEmail`
- `organization`
- `title`
- `socialUrls`
  - `facebook`
  - `instagram`
  - `twitter`
  - `linkedIn`

##### callback

Type: `function([error])`

Called once the native modal is closed.

Takes an error parameter, which will be given in if the modal failed to open.

## License

MIT © [Andrew Joslin](http://ajoslin.com)
