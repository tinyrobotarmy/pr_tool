import React, { Component } from 'react'
import {handleChange, idFromName} from '../actions'
import Wrapper from '../wrapper'

class Select extends Component {
  constructor(props) {
    super(props)
    this.onChangeCallback = this.onChangeCallback.bind(this)
    this.state = {
      value: 0
    }
  }

  render() {
    const {
      name, 
      required, 
      label, 
      autoFocus = false, 
      onChange, 
      hint, 
      wrapperClass,
      labelClass,
      value,
      options,
      optionLabelFunction,
      optionValueFunction,
      prompt,
    } = this.props
    const id = idFromName(name)

    return (
      <Wrapper 
        id={id} 
        name={name} 
        wrapperClass={wrapperClass}
        labelClass={labelClass}
        label={label} 
        hint={hint} 
        required={required}
        value={this.state.value}
      >
        <select 
          name={name}
          id={id}
          className="form-control"
          onChange={handleChange(onChange, (event) => {
            this.onChangeCallback(event)
          })}
          required={required}
          autoFocus={autoFocus}
          value={value}
          prompt={prompt}
        >
        <option disabled hidden>{prompt}</option>
        {
          options.map((option, index) => {
            return (<option key={index} value={optionValueFunction(option)}>{optionLabelFunction(option)}</option>)})
        }
        </select>
      </Wrapper>
    )
  }

  onChangeCallback(event) {
    this.setState({value: event.target.value})
  }
}

export default Select