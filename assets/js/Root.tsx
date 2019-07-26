// assets/js/Root.tsx

import * as React from 'react'
import { BrowserRouter, Route, Switch } from 'react-router-dom'

import Header from './components/Header'
import Flash from './components/Flash'
import HomePage from './pages'
import RepoPage from './pages/Repo';
import NewRepoPage from './pages/NewRepo';

export default class Root extends React.Component {
  public render(): JSX.Element {
    return (
      <>
        <Flash/>
        <BrowserRouter>
          <Header />
          <Switch>
            <Route exact path="/repos/new" component={ NewRepoPage } />
            <Route exact path="/repos/:id" component={ RepoPage } />
            <Route exact path="/" component={HomePage} />
          </Switch>
        </BrowserRouter>
      </>
    )
  }
}