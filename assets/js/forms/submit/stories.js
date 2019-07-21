import React from 'react'
import {storiesOf} from '@storybook/react'
import {MemoryRouter as Router} from 'react-router-dom'

import {Card, FormSubmit} from '../../'

storiesOf('Form submit', module)
  .add('default (with cancel link)', () => (
    <Router>
      <Card>
        <form>
          <FormSubmit>
          Save my changes
          </FormSubmit>
        </form>
      </Card>
    </Router>
  ))
  .add('disabled', () => (
    <Router>
      <Card>
        <form>
          <FormSubmit disabled={true}>
          Save my changes
          </FormSubmit>
        </form>
      </Card>
    </Router>
  ))
  .add('without cancel link', () => (
    <Router>
      <Card>
        <form>
          <FormSubmit showCancel={false}>
          Save my changes
          </FormSubmit>
        </form>
      </Card>
    </Router>
  ))
  .add('while loading', () => (
    <Router>
      <Card>
        <form>
          <FormSubmit showCancel={false} loading={true}>
          Save my changes
          </FormSubmit>
        </form>
      </Card>
    </Router>
  ))
  .add('while loading, with custom "loadingTitle"', () => (
    <Router>
      <Card>
        <form>
          <FormSubmit showCancel={false} loading={true} loadingTitle="Hacking the mainframe">
          Save my changes
          </FormSubmit>
        </form>
      </Card>
    </Router>
  ))
