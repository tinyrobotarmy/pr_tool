import React from 'react'
import './counter.css'

const Counter = ({count = 0, max}) => {
  const remaining = max - (count || 0)
  const ordinal = (Math.abs(remaining) === 1) ? 'character' : 'characters'
  const isOver = remaining < 0

  return (
    <div className="form-wrapper__counter">
      {
        isOver ? 
          `${Math.abs(remaining)} ${ordinal} too many!`:
          (remaining === 0) ? 
            'No characters remaining':
            `${remaining} ${ordinal} remaining`
      }
    </div>
  )
}

export default Counter