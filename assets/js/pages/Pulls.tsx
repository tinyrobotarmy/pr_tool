import * as React from 'react'
import { Link } from 'react-router-dom'

import Main from '../components/Main'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

interface PullRequest {
  id: number;
  title: string;
  author: string;
}

// Interface for the Counter component state
interface PullsState {
  pulls: Array<PullRequest>
}

const initialState = { pulls: [] }

export default class PullsPage extends React.Component<{}, PullsState> {
  constructor(props: {}) {
    super(props)

    // Set the initial state of the component in a constructor.
    this.state = initialState
  }

  componentDidMount() {
    fetch('http://localhost:4000/api/pull_requests/', {
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json',
        'Accept': 'application/json',                  
    }})
      .then((results) => {
        return results.json();
      })
      .then((result) => {
        this.setState({pulls: result.data})
      })
  }

  handleDelete(e) {
    e.preventDefault()
    if (window.confirm('Are you sure you wish to delete this item?')) {
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
          <table className="table">
            <thead>
              <tr>
                <th>Title</th>
                <th>Author</th>
                <th className="actions">Actions</th>
              </tr>
            </thead>
            <tbody>
            {
              this.state.pulls.map((pull, index) => {
                return (
                  <tr key={pull.id}>
                    <td>
                      <Link to={`pulls/${pull.id}`}>{ pull.title }</Link>
                    </td>
                    <td>{ pull.author }</td>
                    <td className="actions">
                      <Link to={`pulls/${pull.id}/edit`}>
                        <FontAwesomeIcon icon="edit" />
                      </Link>
                      <a 
                        href={`http://localhost:4000/api/pull_requests/${pull.id}`} 
                        className="a-link"
                        onClick={this.handleDelete}>
                        <FontAwesomeIcon icon="trash" />
                      </a>
                    </td>
                  </tr>
                )
              })
            }
          </tbody>
          </table>
          <div>
            <Link to="/books/new" className="btn btn-primary">Create Book</Link>
          </div>
        </div>
        <div className="col-sm-1"></div>
      </div>
      </Main>
    )
  }
}