var AppDispatcher = require('./AppDispatcher');
var constants = require('./constants');

var ActionTypes = constants.ActionTypes;

module.exports = {
  receiveLogin: function(json, errors) {
    AppDispatcher.handleServerAction({
      type: ActionTypes.LOGIN_RESPONSE,
      json: json,
      errors: errors
     });
  }
}
