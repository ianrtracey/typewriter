var React = require('react');
var Router = require('react-router');
var Route = Router.Route;
var DefaultRoute = Router.DefaultRoute;

var App = require('./index.jsx');
var Login = require('./Login.jsx');
var Signup = require('./Signup.jsx');
var Home = require('./Home.jsx');

module.exports = {
  <Route name="app" path="/" handler={App}>
    <DefaultRoute handler={Login} />
    <Route name="login" path="/login" handler={Login} />
    <Route name="signup" path="/signup" handler={Signup} />
    <Route name="home" path="/home" handler={Home} />
  </Route>
}
