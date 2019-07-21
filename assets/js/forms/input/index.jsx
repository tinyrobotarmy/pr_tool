import React, { Component } from 'react'
import {handleChange, idFromName} from '../actions'
import Wrapper from '../wrapper'

class Input extends Component {
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
      type = 'text', 
      autoFocus = false, 
      onChange, 
      hint, 
      minLength, 
      maxLength,
      wrapperClass,
      labelClass,
      value
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
        maxLength={maxLength}
        value={this.state.value}
      >
        <input 
          type={type}
          name={name}
          id={id}
          className="form-control"
          onChange={handleChange(onChange, (event) => {
            this.onChangeCallback(event)
          })}
          required={required}
          autoFocus={autoFocus}
          minLength={minLength}
          value={value}
        />
      </Wrapper>
    )
  }

  onChangeCallback(event) {
    this.setState({value: event.target.value})
  }
}

export default Input