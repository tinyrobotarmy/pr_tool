// assets/js/pages/index.tsx

import * as React from 'react'
import { Link } from 'react-router-dom'
import { RouteComponentProps } from 'react-router-dom'
import Main from '../components/Main'
import {FormInput, FormTextArea} from '../forms'

const initialState = {
  id: null,
  username: '',
  password: ''
}

export default class ReloadRepoPage extends React.Component<{}, RepoState> {
  constructor(props: {}) {
    super(props)
    this.handleChange = this.handleChange.bind(this);
    this.handleFormSubmit = this.handleFormSubmit.bind(this);
    this.state = initialState
  }

  componentDidMount() {
    console.log("mounting")
    let id = this.props.match.params.id
    this.setState({id: id})
  }

  handleChange(name, value) {
    this.setState({[name]: value})
  }

  handleFormSubmit(e) {
    e.preventDefault()
    fetch(`http://localhost:4000/api/git_repos/${this.state.id}/reload` ,{
        method: "POST",
        body: JSON.stringify({
          git_repo: {
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
        window.flash(`We are refreshing your PRs. This can take a few minutes or more
                      depending on how many PRs there are`, 'success')
      })
  }

  public render(): JSX.Element {
    return (
      <Main>
        <div className="row">
          <div className="col-sm-1"></div>
          <div className="col-sm-10">
            <h2>Reload Pull Requests for Git Repo</h2>
            <p>Please fill in your username and password as we don't store credentials</p>
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
            <input type="submit" value="Reload PRs" className="btn btn-primary" />
            </form>
          </div>
          <div className="col-sm-1"></div>
        </div>
      </Main>
    )
  }
}