import React from 'react'
import Counter from '../counter'
import { mount, configure } from 'enzyme'
import Adapter from 'enzyme-adapter-react-16'

configure({adapter: new Adapter()});

describe('UI form wrapper counter', () => {
  it('should output "3 characters remaining" when max is 12 and count is 9', () => {
    expect(mount(
      <Counter count={9} max={12} />
    ).text()).toEqual('3 characters remaining')
  })

  it('should output "1 character remaining" when max is 15 and count is 14', () => {
    expect(mount(
      <Counter count={14} max={15} />
    ).text()).toEqual('1 character remaining')
  })

  it('should output "4 characters too many" when max is 15 and count is 19', () => {
    expect(mount(
      <Counter count={19} max={15} />
    ).text()).toEqual('4 characters too many!')
  })

  it('should output "No more" when max is 15 and count is 15', () => {
    expect(mount(
      <Counter count={15} max={15} />
    ).text()).toEqual('No characters remaining')
  })
})