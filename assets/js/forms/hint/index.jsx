import React from 'react'
import './hint.css'

const Hint = ({message, children}) => {
  return (
    (message || children) ? <div className="form-input__hint">{message}. {children}</div> : null
  )
}

export default Hint