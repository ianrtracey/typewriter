import React from 'react';

class Login extends React.Component {

  constructor(props) {
    super(props)
  }

  render() {
    return (
      <div className="column col-8 centered">
      <div className="card">
      <div className="card-header">
      <h4 className="card-title">Login</h4>
      <h6 className="card-meta">New to Typeformer? <a href="/signup">Sign up </a></h6>
      </div>
      <div className="card-body">
      <form method="POST" action="http:">
      <div className="form-group">
      <label className="form-label">Email</label>
      <input className="form-input" name="username" type="text" id="input-example-1" placeholder="your@email.com" />
      <label className="form-label">Password</label>
      <input className="form-input" name="password" type="password" placeholder="" />

      </div>
      <div className="card-footer">
      <button type="submit" className="btn btn-primary">Do</button>
      </div>

      </form>
      </div>
      </div>
      </div>
    );
  }
}
export default Login;
