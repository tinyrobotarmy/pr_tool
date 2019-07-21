import {mount} from 'enzyme'
import React from 'react'
import {MemoryRouter as Router} from 'react-router-dom'
import SubmitOrCancel from '../index'
import { configure } from 'enzyme'
import Adapter from 'enzyme-adapter-react-16'

configure({adapter: new Adapter()});

describe('Submit', () => {
  it('should be disabled (if true in props)', () => {
    expect(mount(
      <Router>
        <SubmitOrCancel disabled={true}>
        Save changes
        </SubmitOrCancel>
      </Router>
    ).find('button').instance().disabled).toEqual(true)
  })

  it('should not be disabled by default', () => {
    expect(mount(
      <Router>
        <SubmitOrCancel>
        Save changes
        </SubmitOrCancel>
      </Router>
    ).find('button').instance().disabled).toEqual(false)
  })

})