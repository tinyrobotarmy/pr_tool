// assets/js/pages/index.tsx

import * as React from 'react'
import { Link } from 'react-router-dom'
import { RouteComponentProps } from 'react-router-dom'
import Main from '../components/Main'

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
                      </tr>
                    )
                  })
                }
              </tbody>
            </table>
          </div>
          <div className="col-sm-1"></div>
        </div>
      </Main>
    )
  }
}