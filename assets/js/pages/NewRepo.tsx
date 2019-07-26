// assets/js/pages/index.tsx

import * as React from 'react'
import { Link } from 'react-router-dom'
import { RouteComponentProps } from 'react-router-dom'
import Main from '../components/Main'
import {FormInput, FormTextArea} from '../forms'

const initialState = {
  name: '',
  url: '',
  username: '',
  password: ''
}

export default class NewRepoPage extends React.Component<{}, RepoState> {
  constructor(props: {}) {
    super(props)
    this.handleChange = this.handleChange.bind(this);
    this.handleFormSubmit = this.handleFormSubmit.bind(this);
    this.state = initialState
  }

  componentDidMount() {
    fetch('http://localhost:4000/api/git_repos/', {
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
    }})
      .then((results) => {
        return results.json();
      })
      .then((result) => {
        this.setState({repos: result.data})
      })
  }

  handleChange(name, value) {
    this.setState({[name]: value})
  }

  handleFormSubmit(e) {
    e.preventDefault()
    fetch('http://localhost:4000/api/git_repos/',{
        method: "POST",
        body: JSON.stringify({
          git_repo: {
            name: this.state.name,
            url: this.state.url,
            username: this.state.username,
            password: this.state.password,
          },
        }),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
      }).then(response => {
        this.props.history.push('/');
        window.flash(`Your repo has been created, loading Pulll Requests.
                      This can take a few minutes or more
                      depending on how many PRs there are`, 'success')
      })
  }

  public render(): JSX.Element {
    return (
      <Main>
        <div className="row">
          <div className="col-sm-1"></div>
          <div className="col-sm-10">
            <h2>New Git Repo</h2>
            <p>Please fill in the details below to add a new git repo and retrieve it's pull request details</p>
          </div>
          <div className="col-sm-1"></div>
        </div>

        <div className="row">
        <div className="col-sm-1"></div>
          <div className="col-sm-10">
            <form onSubmit={this.handleFormSubmit} className="repo-form">
            <FormInput
              wrapperClass="form-group"
              onChange={this.handleChange}
              name="name"
              label="Name"
              value={this.state.name}
              required={true}
            />
            <FormInput
              wrapperClass="form-group"
              onChange={this.handleChange}
              name="url"
              label="URL"
              value={this.state.url}
              required={true}
              hint="Relative path of your repo <username|org>/<repo_name>"
            />
            <FormInput
              wrapperClass="form-group"
              onChange={this.handleChange}
              name="username"
              label="Github Username"
              value={this.state.username}
              required={true}
              hint="Username will not be saved"
            />
            <FormInput
              wrapperClass="form-group"
              onChange={this.handleChange}
              name="password"
              type="password"
              label="Github Password"
              value={this.state.password}
              required={true}
              hint="Password will not be saved"
            />
            <Link to="/" className="btn btn-light">Cancel</Link> &nbsp;
            <input type="submit" value="Submit" className="btn btn-primary" />
            </form>
          </div>
          <div className="col-sm-1"></div>
        </div>
      </Main>
    )
  }
}