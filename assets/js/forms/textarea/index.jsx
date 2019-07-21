import React, { Component } from 'react'
import {handleChange, idFromName} from '../actions'
import Wrapper from '../wrapper'
import '../forms.css'

class TextArea extends Component {
  constructor(props) {
    super(props)
    this.onChangeCallback = this.onChangeCallback.bind(this)
    this.state = {
      value: 0
    }
  }

  render() {
    const {name,
      required,
      label,
      onChange,
      value,
      hint,
      maxLength,
      wrapperClass,
      labelClass
    } = this.props
    const id = idFromName(name)

    return (
      <Wrapper 
        id={id} 
        name={name} 
        label={label} 
        hint={hint} 
        required={required}
        maxLength={maxLength}
        labelClass={labelClass}
        wrapperClass={wrapperClass}
        value={this.state.value}
      >
        <textarea 
          name={name}
          id={id}
          className="form-control"
          onChange={handleChange(onChange, (event) => {
            this.onChangeCallback(event)
          })}
          required={required}
          rows={10}
          value={value}
        ></textarea>
      </Wrapper>
    )
  }

  onChangeCallback(event) {
    this.setState({value: event.target.value})
  }
}

export default TextArea