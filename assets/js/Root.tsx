// assets/js/Root.tsx

import * as React from 'react'
import { BrowserRouter, Route, Switch } from 'react-router-dom'

import Header from './components/Header'
import HomePage from './pages'
import PullsPage from './pages/pulls';

export default class Root extends React.Component {
  public render(): JSX.Element {
    return (
      <>
        <Header />
        <BrowserRouter>
          <Switch>
            <Route exact path="/" component={HomePage} />
            <Route path="/pulls" component={ PullsPage } />
          </Switch>
        </BrowserRouter>
      </>
    )
  }
}