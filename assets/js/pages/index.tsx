// assets/js/pages/index.tsx

import * as React from 'react'
import { Link } from 'react-router-dom'
import { RouteComponentProps } from 'react-router-dom'
import Main from '../components/Main'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import ReactTooltip from 'react-tooltip'

const initialState = {
  repos: [],
}

interface Repo {
  id: number;
  name: string;
  url: string;
}

// Interface for the Counter component state
interface HomeState {
  pulls: Array<Repo>
}

export default class HomePage extends React.Component<{}, HomeState> {
  constructor(props: {}) {
    super(props)
    this.handleDelete = this.handleDelete.bind(this);
    // Set the initial state of the component in a constructor.
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

  handleDelete(e) {
    e.preventDefault()
    if (window.confirm('Are you sure you wish to delete this repo?')) {
      fetch(e.target,
        {
          method: 'DELETE',
          headers: {'Content-Type': 'application/json'},
          body: null,
      }).then((results) => {
        this.componentDidMount()
        return null
      })
    }
  }
  public render(): JSX.Element {
    return (
      <Main>
        <div className="row">
          <div className="col-sm-1"></div>
          <div className="col-sm-10">
            <h2>Welcome to the Pull Request Analysis Tool</h2>
            <p>Please choose a repository from the list below</p>
          </div>
          <div className="col-sm-1"></div>
        </div>

        <div className="row">
        <div className="col-sm-1"></div>
          <div className="col-sm-10">
            <table className="table">
              <thead>
                <tr>
                  <th>Repository Name</th>
                  <th>URL</th>
                  <th className="actions">Actions</th>
                </tr>
              </thead>
              <tbody>
                {
                  this.state.repos.map((repo, index) => {
                    return (
                      <tr key={repo.id}>
                        <td>
                          <Link to={`repos/${repo.id}`}>{ repo.name }</Link>
                        </td>
                        <td>{ repo.url }</td>
                        <td className="actions">
                          <a
                            href={`http://localhost:4000/api/git_repos/${repo.id}`}
                            className="a-link"
                            data-tip="Delete Repo"
                            onClick={this.handleDelete}>
                            <FontAwesomeIcon icon="trash" title="delete repo"/>
                          </a>
                          <ReactTooltip place="top" type="dark" effect="float"/>
                          <a
                            href={`/repos/${repo.id}/reload`}
                            data-tip="Reload PRs"
                            className="a-link">
                            <FontAwesomeIcon icon="sync" title="reload PRs" />
                            <ReactTooltip place="top" type="dark" effect="float"/>
                          </a>
                        </td>
                      </tr>
                    )
                  })
                }
              </tbody>
            </table>
            <div>
              <Link to="/repos/new" className="btn btn-primary">Add Repo</Link>
            </div>
          </div>
          <div className="col-sm-1"></div>
        </div>
      </Main>
    )
  }
}