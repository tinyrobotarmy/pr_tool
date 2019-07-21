import React from 'react'
import Hint from '../hint'
import Counter from './counter'
import './form-wrapper.css'

const Wrapper = ({id, name, required = false,wrapperClass,labelClass, label, hint, errors, children, value, maxLength, loading = false}) => {

  return (
    <div className={wrapperClass}>
      <label 
        htmlFor={id}
        className={labelClass}
        title={required ? `${label || name} is required` : ''}
      >
        {label || name}
      </label>
      {children}
      <Hint message={hint}>
        {maxLength ? <Counter count={value.length} max={maxLength} /> : null}
      </Hint>

    </div>
  )
}

export default Wrapper