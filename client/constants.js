var keyMirror = require('keymirror');

var APIRoot = 'http://localhost:9292';

module.exports = {

  APIEndpoints: {
    LOGIN:        APIRoot + "/v1/login",
    REGISTRATION: APIRoot + "/v1/signup"
  },

  PayloadSources: keyMirror({
    SERVER_ACTION: null,
    VIEW_ACTION: null
  }),

  ActionTypes: keyMirror({
    LOGIN_REQUEST: null,
    LOGIN_RESPONSE: null,

    REDIRECT: null,

    LOAD_FORMS: null,
    RECIEVE_FORMS: null,
    LOAD_FORM: null,
    RECEIVE_FORM: null,
    CREATE_FORM: null
  })
};
