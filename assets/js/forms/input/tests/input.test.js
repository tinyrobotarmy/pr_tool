import React from 'react'
import FormInput from '../index'
import { mount, configure } from 'enzyme'
import Adapter from 'enzyme-adapter-react-16'

configure({adapter: new Adapter()});

describe('Form Input', () => {
  const wrappedInput = mount(<FormInput
    name="first_name"
    label="First name"
  />)

  it('should have a input with name of "first_name"', () => {
    expect(wrappedInput.find('input').getDOMNode().name).toEqual('first_name')
  })

  it('should have a input with expected id', () => {
    expect(wrappedInput.find('input').getDOMNode().id).toEqual('form-input-first_name')
  })

})

describe('Form Input with counter', () => {
  const wrappedInput = mount(<FormInput
    name="first_name"
    label="First name"
    maxLength={12}
  />)

  it('should render a counter', () => {
    expect(wrappedInput.find('Counter').length).toEqual(1)
  })

  it('should render a hint', () => {
    expect(wrappedInput.find('Hint').length).toEqual(1)
  })
})