import React from 'react'
import {Link} from 'react-router-dom'
import './submit.css'

const SubmitOrCancel = ({children, showCancel=true, cancelTo = '/', disabled= false, loading=false, loadingTitle='Saving changes...'}) => {
  return (
    <fieldset className="submit-btns">
      <div className="btns-with-reset">
        <button type="submit" disabled={disabled}>{children}</button>
        {showCancel ? 
          <div className="btns-with-reset__cancel">or <Link to={cancelTo}>cancel</Link></div>
          : null
        }
      </div>
    </fieldset>
  )
}

export default SubmitOrCancel